from python_qt_binding.QtCore import QThread, Signal

import socket
from datetime import datetime, timezone
import json
import logging
import traceback

from musashi_msgs.msg import PlayerState
from musashi_msgs.msg import PlayerStates

from musashi_rqt_refereebox_client import json_log

MAX_RECV_SIZE = 1024 * 4  # byte


class RefBoxClient(QThread):

    # シグナル定義 (既存コードとの互換性維持のため綴りは変更しない)
    recievedCommand = Signal(bytes, str, str)

    def __init__(self, verbose=False):
        """TCP 接続を扱うスレッド。

        Args:
            verbose (bool): True の場合は標準出力へ詳細を出す（デバッグ用）。
        """
        super(RefBoxClient, self).__init__()

        # ログ
        self._logger = logging.getLogger(__name__)
        self._verbose = verbose

        # ソケットの作成 (IPv4, TCP)
        self._socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

        # 実行フラグ
        self._isRun = True

        # 受信バッファ (部分受信対応)
        self._recv_buffer = b''

        # 互換性のために受信シグナルの別名を用意（将来のリファクタ用）
        self.receivedCommand = self.recievedCommand

    def __del__(self,):
        # 明示的なクリーンアップは `disconnect()` を使うこと
        pass

    def _log(self, level, *args):
        # verbose モードなら print、そうでなければ logger
        msg = ' '.join(str(a) for a in args)
        if self._verbose:
            print(msg)
        else:
            if level == 'info':
                self._logger.info(msg)
            elif level == 'error':
                self._logger.error(msg)
            else:
                self._logger.debug(msg)

    # ホストIPアドレス取得
    def getHostIP(self):
        try:
            return socket.gethostbyname(socket.gethostname())
        except Exception:
            return '127.0.0.1'

    # 接続（サーバへのログイン）処理メソッド
    def connect(self, address, port):
        # 接続処理
        try:
            self._socket.settimeout(3)  # timeout [sec]
            self._socket.connect((address, port))
        except Exception as e:
            self._log('error', 'Failed to connect:', e)
            return False

        # 接続完了した時刻を記録する（UTC）
        self.connected_time = datetime.now(timezone.utc)

        # 無事にサーバ（RefereeBox）へ接続ができれば，RefereeBox側で反応がある
        return True  # 接続完了を表す

    # 切断処理メソッド
    def disconnect(self,):
        # 安全にスレッドを停止してソケットを閉じる
        self._isRun = False
        try:
            # 送信・受信を停止させる
            try:
                self._socket.shutdown(socket.SHUT_RDWR)
            except Exception:
                pass
            self._socket.close()
        finally:
            # スレッドが終了するのを待つ (タイムアウト付き)
            try:
                self.join(timeout=2.0)
            except Exception:
                pass

    # レフェリーボックスへログデータ（json）を送信する関数
    # player_statesメッセージのデータを読み取ってレフェリーボックスに送信するjsonデータを作成する
    # 一度辞書型を作ってjsonモジュールを使って変換する方法をとる
    def send_jsonlog(self, player_states):
        # まずはヘッダーを作成する
        data = json_log.make_header(self.connected_time)  # dataは辞書型

        # ------------------------------
        # 以下，各プレイヤーの状態を読み取りながらリストを作っていく
        # ------------------------------

        # ロボットの状態についてリストを作成する．
        _players = []
        for player_state in player_states.players:
            _player = [
                player_state.id,
                player_state.position.position.x,
                player_state.position.position.y,
                player_state.position.position.z,
                player_state.position.orientation.x,
                player_state.position.orientation.y,
                player_state.position.orientation.z,
                player_state.position.orientation.w,
                player_state.moveto.position.x,
                player_state.moveto.position.y,
                player_state.moveto.position.z,
                player_state.moveto.orientation.x,
                player_state.moveto.orientation.y,
                player_state.moveto.orientation.z,
                player_state.moveto.orientation.w,
                player_state.haveball,
            ]
            _players.append(_player)

        # data辞書にリストを追加．キー名は'robots'
        data['robots'] = json_log.make_players(_players)

        # ボールについてリストを作成する．
        balls = []
        for player_state in player_states.players:
            _ball = [
                player_state.position.position.x,
                player_state.position.position.y,
                player_state.position.position.z,
                player_state.position.orientation.x,
                player_state.position.orientation.y,
                player_state.position.orientation.z,
                player_state.position.orientation.w,
                player_state.ball.distance,
                player_state.ball.angle
            ]
            balls.append(_ball)
        # data辞書にリストを追加．キー名は'balls'
        data['balls'] = json_log.make_balls(balls)

        # 障害物についてリストを作成する．ただし大会規定のワールド座標系に合わせないといけないので座標変換が必要
        # チーム内xy軸の定義と大会ルールの定義は異なっている
        data_obstacles = []
        for i, player_state in enumerate(player_states.players):  # ロボット台数分の繰り返し
            _obstacle_data = {
                'position': [0.0, 0.0, 0.0],
                'velocity': [0.0, 0.0, 0.0],
                'radius': 0.25,
                'confidence': 1.0
            }
            data_obstacles.append(_obstacle_data)  # リストに追加
        # リストを追加．キー名は'obstacles'
        data['obstacles'] = data_obstacles

        # 辞書型からjsonデータへ変換（パラメータはテキトウ）
        json_data = json.dumps(data, ensure_ascii=False, indent=4)

        # プロトコル互換性: サーバが NULL 終端でメッセージを期待している場合があるため '\0' を付与
        payload = (json_data + '\0').encode('utf-8')

        try:
            # 送信は sendall を使って全データを保証
            self._socket.sendall(payload)
        except Exception as e:
            self._log('error', 'Failed to send json log:', e)
            # 送信失敗時は接続状況を見てスレッド停止
            self._isRun = False

        return

    # 主となる処理（スレッド処理実態）
    def run(self,):
        # ブロッキングモード設定
        self._socket.settimeout(None)
        # 受信は NULL ('\0') 終端で区切られる想定なので、バッファに蓄積しつつ
        # 完成したメッセージを切り出して処理する
        while self._isRun:
            try:
                chunk = self._socket.recv(MAX_RECV_SIZE)
                if not chunk:
                    # 空バイト列は接続切断を意味する
                    self._log('info', 'Connection closed by peer')
                    break

                # バッファに追加
                self._recv_buffer += chunk

                # NULL 終端で分割してメッセージを取り出す
                while b'\0' in self._recv_buffer:
                    msg, sep, rest = self._recv_buffer.partition(b'\0')
                    self._recv_buffer = rest

                    try:
                        # デコードして JSON をパース
                        text = msg.decode('utf-8')
                        recv_json = json.loads(text)
                    except Exception as e:
                        # パース失敗はログに記録して次へ
                        self._log('error', 'Failed to parse incoming message:', e)
                        if self._verbose:
                            self._log('error', 'Raw message:', msg)
                        continue

                    # 受信した辞書から値を取り出す
                    command = recv_json.get('command', '')
                    targetTeam = recv_json.get('targetTeam', '')

                    # シグナルの発行 (生データと抽出したフィールドを送る)
                    try:
                        self.recievedCommand.emit(msg + b'\0', command, targetTeam)
                    except Exception:
                        # シグナル送出時の例外はログに残す
                        self._log('error', 'Failed to emit recievedCommand signal')
                        self._log('error', traceback.format_exc())

            except Exception as e:
                # 受信ループでエラー発生 -> ログに残して終了
                self._log('error', 'Exception in receive loop:', e)
                if self._verbose:
                    self._log('error', traceback.format_exc())
                break

        # ループ終了時はソケットを閉じ、実行フラグを下ろす
        try:
            try:
                self._socket.shutdown(socket.SHUT_RDWR)
            except Exception:
                pass
            self._socket.close()
        except Exception:
            pass

        self._isRun = False
