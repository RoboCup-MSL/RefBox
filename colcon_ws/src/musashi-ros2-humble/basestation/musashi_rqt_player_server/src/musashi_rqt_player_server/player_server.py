from python_qt_binding.QtCore import QThread, Signal

import socket
import math
import logging
from musashi_msgs.msg import PlayerState


# basestation自身のIPアドレスを設定してください
# 例：OWN_IP='172.16.44.10'
OWN_IP = '0.0.0.0'  # デフォルトは全インターフェース

PORT = 12536  # ポート

# 各プレイヤーのIPアドレスを設定してください（必要なら上書き）
PLAYER1_IP = '172.16.44.1'
PLAYER2_IP = '172.16.44.2'
PLAYER3_IP = '172.16.44.3'
PLAYER4_IP = '172.16.44.4'
PLAYER5_IP = '172.16.44.5'

MAX_RECV_SIZE = 1024 * 4


class PlayerServer(QThread):

    # シグナル定義
    recievedPlayerData = Signal(int, PlayerState)

    # コンストラクタ
    def __init__(self, own_ip=None, port=None, player_ips=None, verbose=False):
        super(PlayerServer, self).__init__()

        self._logger = logging.getLogger(__name__)
        self._verbose = verbose

        # 設定の反映（外部からも指定可能）
        self._own_ip = own_ip if own_ip is not None else OWN_IP
        self._port = port if port is not None else PORT
        # プレイヤー IP のマッピング list or dict
        if player_ips is None:
            self._player_ips = [PLAYER1_IP, PLAYER2_IP, PLAYER3_IP, PLAYER4_IP, PLAYER5_IP]
        else:
            self._player_ips = player_ips

        # ソケットの作成 (IPv4, UDP)
        self._socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        # SO_REUSEPORT は環境によっては利用不可なので安全に設定
        try:
            self._socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEPORT, 1)
        except Exception:
            try:
                self._socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            except Exception:
                pass

        # プレイヤーデータリスト（ローカル管理用）
        self._players = [{}, {}, {}, {}, {}]

        # 実行フラグ
        self._isRun = True

        # 受信バッファなど
        self._logger.debug('PlayerServer initialized: own_ip=%s port=%s', self._own_ip, self._port)

    # デストラクタ
    def __del__(self,):
        pass

    def open(self,):
        # バインド（紐付け）
        try:
            bind_addr = (self._own_ip, self._port)
            self._socket.bind(bind_addr)
            self._logger.info('PlayerServer bound to %s:%s', bind_addr[0], bind_addr[1])
        except Exception as e:
            self._logger.warning('Failed to bind PlayerServer socket: %s', e)
            raise

    def close(self,):
        # 安全にスレッドを停止してソケットを閉じる
        self._isRun = False
        try:
            try:
                self._socket.shutdown(socket.SHUT_RDWR)
            except Exception:
                pass
            self._socket.close()
        finally:
            try:
                self.join(timeout=2.0)
            except Exception:
                pass

    def run(self,):
        # プレイヤーからの受信スレッド
        self._socket.settimeout(None)

        while self._isRun:
            try:
                recv, addr = self._socket.recvfrom(MAX_RECV_SIZE)
            except Exception as e:
                # 受信エラーが発生してもスレッドを継続させる
                self._logger.error('Socket recvfrom error: %s', e)
                continue

            try:
                # recvには受信したデータ（bytes）
                # addrには送信元のアドレス（文字列）が入っている
                recv_str = recv.decode(errors='replace')
                if not recv_str:
                    continue

                # 先頭が 'R' または 'P' の制御メッセージは無視
                if recv_str[0] in ('R', 'P'):
                    continue

                values = recv_str.split(',')

                # 期待するフィールド数の簡易チェック（最低20項目を期待）
                # if len(values) < 20:
                #     self._logger.warning('Malformed player message from %s: insufficient fields (%d)', addr, len(values))
                #     continue
                if len(values) < 19:
                    self._logger.warning('Malformed player message from %s: insufficient fields (%d)', addr, len(values))
                    continue

                # プレイヤーIDの推定: 送信元IPの末尾か、事前マッピングを利用
                player_ip = addr[0]
                player_no = None
                try:
                    # try map via configured IPs
                    if player_ip in self._player_ips:
                        player_no = self._player_ips.index(player_ip) + 1
                    else:
                        # fallback: IP の末尾を利用
                        player_no = int(player_ip.split('.')[-1])
                except Exception:
                    self._logger.warning('Failed to determine player number from addr %s', addr)
                    continue

                # PlayerState型に値を代入（変換は例外を捕捉してスキップ）
                try:
                    player_state = PlayerState()
                    player_state.color = int(values[0])
                    player_state.id = int(values[1])
                    player_state.action = int(values[2])
                    player_state.state = int(values[3])
                    player_state.ball.distance = float(values[4]) * 0.01
                    player_state.ball.angle = float(values[5]) * 0.01
                    player_state.goal.distance = float(values[6]) * 0.01
                    player_state.goal.angle = float(values[7]) * 0.01
                    player_state.my_goal.distance = float(values[8]) * 0.01
                    player_state.my_goal.angle = float(values[9]) * 0.01

                    player_state.position.position.x = float(values[10]) * 0.01
                    player_state.position.position.y = float(values[11]) * 0.01
                    angle = float(values[12]) * 0.01
                    [qx, qy, qz, qw] = self.euler_to_quaternion(0, 0, angle)
                    player_state.position.orientation.x = qx
                    player_state.position.orientation.y = qy
                    player_state.position.orientation.z = qz
                    player_state.position.orientation.w = qw

                    player_state.role = int(values[13])
                    player_state.haveball = int(values[14])

                    player_state.moveto.position.x = float(values[15]) * 0.01
                    player_state.moveto.position.y = float(values[16]) * 0.01
                    angle = float(values[17]) * 0.01
                    [qx, qy, qz, qw] = self.euler_to_quaternion(0, 0, angle)
                    player_state.moveto.orientation.x = qx
                    player_state.moveto.orientation.y = qy
                    player_state.moveto.orientation.z = qz
                    player_state.moveto.orientation.w = qw

                    player_state.obstacle.distance = float(values[18]) * 0.01
                    # player_state.obstacle.angle = float(values[19])

                except Exception as e:
                    self._logger.error('Failed to parse player message from %s: %s', addr, e)
                    continue

                # シグナル発行（ID ベースで送る）
                try:
                    self.recievedPlayerData.emit(player_state.id, player_state)
                except Exception as e:
                    self._logger.error('Failed to emit recievedPlayerData: %s', e)

            except Exception as e:
                # 受信処理で予期しないエラーが出た場合はログ残して継続
                self._logger.error('Unexpected error in receive loop: %s', e)
                continue

    def send_to_player(self, binary_data, player_addr):
        try:
            self._socket.sendto(binary_data, player_addr)
        except socket.error as e:
            raise Exception('socket error [{}] in sending to {}'.format(e, player_addr[0]))

    def broadcast(self, binary_data):
        try:
            for ip in self._player_ips:
                self.send_to_player(binary_data, (ip, self._port))
        except Exception as e:
            raise Exception(e)

    def euler_to_quaternion(self, roll, pitch, yaw):
        qx = math.sin(roll/2) * math.cos(pitch/2) * math.cos(yaw/2) - \
            math.cos(roll/2) * math.sin(pitch/2) * math.sin(yaw/2)
        qy = math.cos(roll/2) * math.sin(pitch/2) * math.cos(yaw/2) + \
            math.sin(roll/2) * math.cos(pitch/2) * math.sin(yaw/2)
        qz = math.cos(roll/2) * math.cos(pitch/2) * math.sin(yaw/2) - \
            math.sin(roll/2) * math.sin(pitch/2) * math.cos(yaw/2)
        qw = math.cos(roll/2) * math.cos(pitch/2) * math.cos(yaw/2) + \
            math.sin(roll/2) * math.sin(pitch/2) * math.sin(yaw/2)
        return [qx, qy, qz, qw]
