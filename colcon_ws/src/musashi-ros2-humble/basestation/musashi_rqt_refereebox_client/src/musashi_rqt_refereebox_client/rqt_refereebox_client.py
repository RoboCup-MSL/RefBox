import os
from ament_index_python.resources import get_resource
from python_qt_binding import loadUi
from qt_gui.plugin import Plugin
from python_qt_binding.QtWidgets import QWidget
from python_qt_binding.QtCore import QTimer, Slot
from python_qt_binding.QtWidgets import QErrorMessage

from musashi_rqt_refereebox_client.refbox_client import RefBoxClient

from musashi_msgs.msg import RefereeCmd, PlayerState, PlayerStates

PKG_NAME = 'musashi_rqt_refereebox_client'
UI_FILE_NAME = 'refereebox_client.ui'

GUI_UPDATE_PERIOD = 0.033  # GUIの更新周期[s]
PERIOD = 0.25  # タイマコールバックの実行周期[s]

class RqtRefereeBoxClient(Plugin):
    
    # メンバ変数定義は __init__ 内で行う（プラグインを複数立ち上げたときの副作用回避）
    
    def __init__(self, context):
        super(RqtRefereeBoxClient, self).__init__(
            context)  # 親クラス(Pluginクラス)のコンストラクタ呼び出し
        self.setObjectName('RqtRefereeBoxClient')  # 自分の名前を設定
        self._context = context  # コンテキストインスタンスをメンバ変数へ
        self._node = context.node  # ノードインスタンスをメンバ変数へ

        #
        # メンバ変数の作成
        #
        self.is_connected_refbox = False

        #
        #
        #
        self.create_ui()  # UIをロード，描画領域に追加

        # RefBoxClient は接続時に生成するためここでは None を設定
        self._refbox_client = None

        # player_states を初期化しておく（タイマーで未設定参照されるのを防ぐ）
        self.player_states = None

        # ホストIPを表示するために一時的に RefBoxClient を生成して取得（破棄してよい）
        try:
            host_ip = RefBoxClient().getHostIP()
        except Exception:
            host_ip = '127.0.0.1'
        self._widget.lblOwnIP.setText(host_ip)
        
        self.connect_signals_slots()  # GUIのシグナルスロット接続
        self.create_publishers()  # パブリッシャーの作成
        self.create_subscribers()  # サブスクライバーの作成

        # タイマコールバックのスタート
        self._node.timer = self._node.create_timer(PERIOD,
                                                   self.timer_callback)

        # GUIスレッドのスタート
        self.start_ui_thread()

    # ウィジェット作成
    def create_ui(self):
        # Qwidget型のメンバ変数作成
        self._widget = QWidget()

        # パッケージ名からパッケージのディレクトリパスを取得
        _, package_path = get_resource('packages', PKG_NAME)

        # .uiファイルへのパスを作成，取得
        ui_file = os.path.join(package_path, 'share',
                               PKG_NAME, 'resource', UI_FILE_NAME)

        # .uiファイルをQWidget型メンバ変数にロード
        loadUi(ui_file, self._widget)

        # 複数立ち上げた時の対策処理でウィンドウ名を変更している
        if self._context.serial_number() > 1:
            self._widget.setWindowTitle(
                self._widget.windowTitle() + (' (%d)' % self._context.serial_number()))

        # コンテキストに作成したウィジェットを追加．これをしないとGUI画面が表示されない
        self._context.add_widget(self._widget)

    def connect_signals_slots(self):
        # chckConnect
        # stateChangedシグナルをonStateChangedChckConnectスロットへ接続
        self._widget.chckConnect.stateChanged.connect(
            self.onStateChangedChckConnect)
        return

    def create_publishers(self,):
        # referee_cmdのパブリッシャ作成
        self._pub_refcmd = self._node.create_publisher(
            RefereeCmd,
            '/referee_cmd',
            5)
        #
        return

    def create_subscribers(self,):
        # player_statesのサブスクライバー
        self._sub_player_states = self._node.create_subscription(
            PlayerStates,
            '/player_states',
            self.player_states_callback,
            5
        )
        return

    def start_ui_thread(self):
        # QTimerのtimeoutシグナルが発行されるたびにQWidgetのupdateスロットが実行される
        # これをしないと各ウィジェットのシグナルが発行された時に認識されない

        # GUIイベント更新のためのタイマ割り込み
        self._timer = QTimer()
        # timeoutシグナルをupdateスロットに接続
        self._timer.timeout.connect(self._widget.update)
        # QTimerスタート
        self._timer.start(int(GUI_UPDATE_PERIOD*1000.0))

    # シャットダウン時処理
    def shutdown_plugin(self):
        # 終了時はタイマーを止める
        # タイマー停止
        self._timer.stop()

        # プラグイン終了時に RefBoxClient が動作中なら安全に切断する
        try:
            if getattr(self, '_refbox_client', None) is not None:
                self._refbox_client.disconnect()
                self._refbox_client = None
        except Exception:
            self._node.get_logger().error('Error disconnecting RefBoxClient during shutdown')

    # プラグインの設定保存処理
    def save_settings(self, plugin_settings, instance_settings):
        pass

    # プラグインの設定保存処理
    def restore_settings(self, plugin_settings, instance_settings):
        pass

    # ------------------------------
    # ノードのタイマコールバック関数
    # ------------------------------
    def timer_callback(self,):
        # self._node.get_logger().info('timer callback')

        # レフェリーボックスへログの送信を行う．周期的に送信する必要があるためタイマコールバックで実行することになる
        # 全てのプレイヤーの情報はメンバ変数 self.player_states(PlayerStatesメッセージ型) に入っている
        if self.is_connected_refbox == True:
            # player_states が受信済みか確認してから送信する
            if getattr(self, 'player_states', None) is not None:
                try:
                    self._refbox_client.send_jsonlog(self.player_states)
                except Exception as e:
                    self._node.get_logger().error(f'Failed to send json log: {e}')
            else:
                # まだ player_states が無い場合はスキップしてログ出力
                self._node.get_logger().info('player_states not available yet; skipping send_jsonlog')

        return

    # ------------------------------
    # 以下，スロット関数
    # ------------------------------
    # 接続チェックボックスの状態が変化した時に呼び出されるスロット
    def onStateChangedChckConnect(self, state):
        if state:  # チェックが入った → 接続処理

            # RefBoxClientの新規作成
            self._refbox_client = RefBoxClient()
            # IPアドレスとポートをGUIから取得
            refboxIP = self._widget.lnedtIP.text()
            refboxPort = int(self._widget.lnedtPort.text())

            # 接続のトライ
            self._node.get_logger().info(
                'Try to connect to RefereeBox [{}:{}] ...'.format(refboxIP, refboxPort))
            isConnect = self._refbox_client.connect(refboxIP, refboxPort)

            if isConnect:  # 接続成功時の処理
                self._node.get_logger().info('Successfully connected to RefereeBox')

                # レフェリーからコマンド受信時のシグナルスロット接続
                self._refbox_client.recievedCommand.connect(
                    self.onRecievedCommand)
                # RefereeBox client スレッドのスタート
                self._refbox_client.start()

                # 接続中フラグをTrueへ
                self.is_connected_refbox = True

            else:  # 接続失敗時の処理
                self._node.get_logger().error('Failed to connect to RefereeBox')
                self._node.get_logger().error('Please check network connection status')

                # エラーメッセージダイアログの表示
                dlg = QErrorMessage(self._widget)
                dlg.showMessage(
                    'Failed to connect to RefereeBox. Please check network connection status.')

                self._widget.chckConnect.setCheckState(False)
                # 接続に失敗したインスタンスがあれば切断処理
                try:
                    if self._refbox_client is not None:
                        self._refbox_client.disconnect()
                except Exception:
                    pass
                self._refbox_client = None

                # 接続中フラグをFalseへ
                self.is_connected_refbox = False

        else:  # チェックが外れた → 切断処理
            # 安全に切断する
            try:
                if self._refbox_client is not None:
                    self._refbox_client.disconnect()
            except Exception:
                self._node.get_logger().error('Error during disconnect of RefBoxClient')
            finally:
                self._refbox_client = None

            # 接続中フラグをFalseへ
            self.is_connected_refbox = False

    # refereebox_clientがrefereeboxから受信した際に呼び出されるスロット関数
    def onRecievedCommand(self, recv, command, targetTeam):
        self._node.get_logger().info(
            'Recieved: command={}, targetTeam={}'.format(command, targetTeam))

        # GUIに受信した生テキストを表示
        self._widget.txtRecv.setText(recv.decode('utf-8'))

        # RefereeCmdメッセージの作成
        refereeCmd = RefereeCmd()

        # 値の代入
        refereeCmd.command = command
        refereeCmd.target_team = targetTeam

        # refcmdメッセージをパブリッシュ．
        # player_serverに伝達することが目的
        self._pub_refcmd.publish(refereeCmd)

    # ------------------------------
    # スロット関数定義，ここまで
    # ------------------------------

    # ------------------------------
    # 以下，サブスクライバーのコールバック関数
    # ------------------------------

    def player_states_callback(self, player_states):
        self.player_states = player_states  # メンバ変数に保存

        # ここではレフェリーボックスへログのjsonを送信しないほうがいい
        # (理由)rqt_player_serverのplayer_statesパブリッシュの周期に依存して送信してしまうので
        return
