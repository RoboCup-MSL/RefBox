import os
import struct
from ament_index_python.resources import get_resource
from python_qt_binding import loadUi
from python_qt_binding.QtWidgets import QWidget
from qt_gui.plugin import Plugin
from python_qt_binding.QtCore import QTimer, Slot

from musashi_rqt_player_server.player_server import PlayerServer

from geometry_msgs.msg import TransformStamped
from musashi_msgs.msg import RefereeCmd
from musashi_msgs.msg import PlayerState
from musashi_msgs.msg import PlayerStates

import tf2_ros

PKG_NAME = 'musashi_rqt_player_server'
UI_FILE_NAME = 'player_server.ui'

RATE_PLAYER_STATES_PUBLISH = 0.1  # player_statsのパブリッシュ周期[s]
RATE_TF_BROADCAST = 0.1  # 各プレイヤーのtfのブロードキャスト周期[s]
RATE_SEND_TO_PLAYERS = 0.1  # 各playerへのコマンド送信周期[s]

MAGENTA = 0
CYAN = 1

TEAM_COLOR = CYAN  # チームのカラーを設定する

ALPHA = 1
BETA = 2
GAMMA = 3
DELTA = 4
GOALIE = 5

ROLE_ASSIGN_METHOD = 0  # 0:static, 1:by distance between ball

TEAM_IP = '224.16.32.44'

# hibikino-musashiのチーム内コマンド
WELCOME = 00
START = 10
STOP = 11
FIRST = 20
SECOND = 21
KICKOFF_M = 30
KICKOFF_C = 40
THROWIN_M = 31
THROWIN_C = 41
CORNER_KICK_M = 32
CORNER_KICK_C = 42
GOAL_KICK_M = 33
GOAL_KICK_C = 43
FREE_KICK_M = 34
FREE_KICK_C = 44
PENALTY_M = 35
PENALTY_C = 45
GOAL_M = 36
GOAL_C = 46
DROP_BALL = 55
CALIB_COMPASS = 66
NUM_PLAYERS = 5

# コマンドマッピング（単純変換）
COMMAND_MAP_SIMPLE = {
    'START': START,
    'STOP': STOP,
    'DROP_BALL': DROP_BALL,
    'FIRST_HALF': FIRST,
    'SECOND_HALF': SECOND,
    'WELCOME': WELCOME,
}

class RqtPlayerServer(Plugin):
    def __init__(self, context):
        super(RqtPlayerServer, self).__init__(context)
        self.setObjectName('RqtPlayerServer')
        self._context = context  # 親クラスからコンテキストをもらう
        self._node = context.node  # 親クラスからノードの実態をもらう

        # レフェリーからのコマンド（musashi_msgs.msgのRefereeCmd型）
        self._refcmd = RefereeCmd()

        # チームの情報（プレイヤー情報の配列）
        # PlayerStates を NUM_PLAYERS 要素の PlayerState で初期化しておく
        self._player_states = PlayerStates()
        for i in range(NUM_PLAYERS):
            self._player_states.players.append(PlayerState())

        # チームカラー
        self._team_color = TEAM_COLOR

        # チームコマンドの初期化
        self.teamcmd = STOP

        # ウィジェットインスタンスを作成
        self.create_ui()

        # サブスクライバー作成
        self._sub_refcmd = self._node.create_subscription(
            RefereeCmd,
            '/referee_cmd',
            self.refcmd_callback,
            10
        )

        # パブリッシャー作成
        self._pub_player_stats = self._node.create_publisher(
            PlayerStates,
            '/player_states',
            10
        )

        # tfブロードキャスター作成（NUM_PLAYERS に合わせて動的生成）
        self.brs = [tf2_ros.TransformBroadcaster(self._node) for _ in range(NUM_PLAYERS)]

        # PlayerServer は Start/Stop ボタンで制御する（自動起動しない）
        self._player_server = None
        self._player_server_running = False

        # Start/Stop ボタンのシグナル接続
        try:
            self._widget.btnStartServer.clicked.connect(self.on_start_player_server)
        except Exception:
            pass
        try:
            self._widget.btnStopServer.clicked.connect(self.on_stop_player_server)
        except Exception:
            pass

        # GUIスレッドのスタート
        self.start_ui_thread()

        # PlayerStatesをパブリッシュするタイマコールバックのスタート
        self._node.timer_player_states_publish = self._node.create_timer(
            RATE_PLAYER_STATES_PUBLISH, self.timer_callback_player_states_publish)

        # tfをブロードキャストするタイマコールバックのスタート
        self._node.timer_tf_broadcast = self._node.create_timer(
            RATE_TF_BROADCAST, self.timer_callback_tf_broadcast)

        # 各プレイヤーへコマンドを送信するタイマコールバックのスタート
        self._node.timer_send_to_players = self._node.create_timer(
            RATE_SEND_TO_PLAYERS, self.timer_callback_send_to_players)

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

        # コンテキストに作成したウィジェットを追加
        # これをしないとGUI画面が表示されない
        self._context.add_widget(self._widget)

    def start_ui_thread(self):
        # QTimerのtimeoutシグナルが発行されるたびにQWidgetのupdateスロットが実行される
        # これをしないと各ウィジェットのシグナルが発行された時に認識されない

        # GUIイベント更新のためのタイマ割り込み
        self._timer = QTimer()
        # timeoutシグナルをupdateスロットに接続
        self._timer.timeout.connect(self._widget.update)
        # 16msec周期（33Hz）で画面更新
        self._timer.start(16)

    def shutdown_plugin(self):
        # 終了時はタイマーを止める
        self._timer.stop()
        # プラグイン終了時に PlayerServer が動作中なら安全に切断
        try:
            if getattr(self, '_player_server', None) is not None:
                self._player_server.close()
        except Exception:
            self._node.get_logger().error('Error closing PlayerServer during shutdown')

    def save_settings(self, plugin_settings, instance_settings):
        pass

    def restore_settings(self, plugin_settings, instance_settings):
        pass

    # ------------------------------
    # PlayerServer start/stop handlers
    # ------------------------------
    def on_start_player_server(self):
        # Start ボタンが押されたときに PlayerServer を生成して起動する
        if self._player_server_running:
            self._node.get_logger().info('PlayerServer already running')
            return

        try:
            bind_ip = self._widget.lnedtOwnIP.text().strip()
        except Exception:
            bind_ip = None
        try:
            bind_port = int(self._widget.lnedtPort.text())
        except Exception:
            bind_port = None

        self._player_server = PlayerServer(own_ip=bind_ip, port=bind_port)
        self._player_server.recievedPlayerData.connect(self.onRecievedPlayerData)
        try:
            self._player_server.open()
        except Exception as e:
            self._node.get_logger().warning('Failed to open PlayerServer: {}'.format(e))
            return

        self._player_server.start()
        self._player_server_running = True
        self._node.get_logger().info(f'PlayerServer started on {bind_ip}:{bind_port}')

    def on_stop_player_server(self):
        # Stop ボタンで PlayerServer を停止する
        if not self._player_server_running or self._player_server is None:
            self._node.get_logger().info('PlayerServer not running')
            return

        try:
            self._player_server.close()
        except Exception as e:
            self._node.get_logger().error('Error stopping PlayerServer: {}'.format(e))
        finally:
            self._player_server = None
            self._player_server_running = False
            self._node.get_logger().info('PlayerServer stopped')

    # レフェリーボックスコマンドのサブスクライバ-コールバック関数
    def refcmd_callback(self, msg):
        """RefereeCmd を受信したときのコールバック。
        単純変換は COMMAND_MAP_SIMPLE を使い、それ以外は
        _map_targeted_command() で追加処理を行う。
        """
        self._node.get_logger().info(
            'command={}, targetTeam={}'.format(msg.command, msg.target_team))

        self._refcmd = msg  # メンバ変数に格納
        cmd = msg.command

        # 単純マッピング
        if cmd in COMMAND_MAP_SIMPLE:
            self.teamcmd = COMMAND_MAP_SIMPLE[cmd]
        # ターゲット付きコマンド
        elif cmd in ('KICKOFF', 'GOALKICK', 'THROWIN', 'CORNER',
                     'PENALTY', 'FREEKICK', 'GOAL'):
            self.teamcmd = self._map_targeted_command(cmd, msg.target_team)
        # その他は現状維持（必要なら拡張）
        else:
            pass

        # UI上に表示
        self._widget.lblTeamCmd.setText(str(self.teamcmd))
        return

    def _map_targeted_command(self, cmd, target_team):
        """target_team およびチームカラーに応じて定数を返す。"""
        # 自チームか相手かを判定
        is_own = (target_team == TEAM_IP)
        mag = (self._team_color == MAGENTA)

        if cmd == 'KICKOFF':
            return KICKOFF_M if is_own and mag else (
                KICKOFF_C if is_own and not mag else (
                    KICKOFF_C if mag else KICKOFF_M))
        if cmd == 'GOALKICK':
            return GOAL_KICK_M if is_own and mag else (
                GOAL_KICK_C if is_own and not mag else (
                    GOAL_KICK_C if mag else GOAL_KICK_M))
        if cmd == 'THROWIN':
            return THROWIN_M if is_own and mag else (
                THROWIN_C if is_own and not mag else (
                    THROWIN_C if mag else THROWIN_M))
        if cmd == 'CORNER':
            return CORNER_KICK_M if is_own and mag else (
                CORNER_KICK_C if is_own and not mag else (
                    CORNER_KICK_C if mag else CORNER_KICK_M))
        if cmd == 'PENALTY':
            return PENALTY_M if is_own and mag else (
                PENALTY_C if is_own and not mag else (
                    PENALTY_C if mag else PENALTY_M))
        if cmd == 'FREEKICK':
            return FREE_KICK_M if is_own and mag else (
                FREE_KICK_C if is_own and not mag else (
                    FREE_KICK_C if mag else FREE_KICK_M))
        if cmd == 'GOAL':
            return GOAL_M if is_own and mag else (
                GOAL_C if is_own and not mag else (
                    GOAL_C if mag else GOAL_M))
        # デフォルト
        return self.teamcmd

    # PlayerStatesをパブリッシュするタイマコールバック関数
    def timer_callback_player_states_publish(self,):
        # player_statesメッセージをパブリッシュ
        self._pub_player_stats.publish(self._player_states)
        return
    
    def timer_callback_tf_broadcast(self,):

        # 各プレイヤーのtfをブロードキャスト
        now = self._node.get_clock().now().to_msg()

        for i, player_state in enumerate(self._player_states.players):
            if i >= len(self.brs):
                break

            t = TransformStamped()

            t.header.stamp = now
            t.header.frame_id = 'world'
            t.child_frame_id = 'player' + str(player_state.id) + '/base_link'

            t.transform.translation.x = player_state.position.position.x
            t.transform.translation.y = player_state.position.position.y
            t.transform.translation.z = player_state.position.position.z
            t.transform.rotation.x = player_state.position.orientation.x
            t.transform.rotation.y = player_state.position.orientation.y
            t.transform.rotation.z = player_state.position.orientation.z
            t.transform.rotation.w = player_state.position.orientation.w

            # self.br.sendTransform(t)
            self.brs[i].sendTransform(t)
        return

    # def timer_callback_tf_broadcast(self,):

    #     # 各プレイヤーのtfをブロードキャスト
    #     now = self._node.get_clock().now().to_msg()

    #     trs = [
    #         TransformStamped(),
    #         TransformStamped(),
    #         TransformStamped(),
    #         TransformStamped(),
    #         TransformStamped()
    #     ]

    #     for i, player in enumerate(self._player_states.players):
    #         trs[i].header.stamp = now
    #         trs[i].header.frame_id = 'world'
    #         trs[i].child_frame_id = 'player' + str(i + 1) + '/base_link'
    #         trs[i].transform.translation.x = player.position.position.x
    #         trs[i].transform.translation.y = player.position.position.y
    #         trs[i].transform.translation.z = player.position.position.z
    #         trs[i].transform.rotation.x = player.position.orientation.x
    #         trs[i].transform.rotation.y = player.position.orientation.y
    #         trs[i].transform.rotation.z = player.position.orientation.z
    #         trs[i].transform.rotation.w = player.position.orientation.w
    #         self.brs[i].sendTransform(trs[i])
            

    #     # for player_state in self._player_states.players:
    #     #     now = self._node.get_clock().now().to_msg()
    #     #     t = TransformStamped()

    #     #     t.header.stamp = now
    #     #     t.header.frame_id = 'world'
    #     #     t.child_frame_id = 'player' + str(player_state.id) + '/base_link'

    #     #     t.transform.translation.x = player_state.position.position.x
    #     #     t.transform.translation.y = player_state.position.position.y
    #     #     t.transform.translation.z = player_state.position.position.z
    #     #     t.transform.rotation.x = player_state.position.orientation.x
    #     #     t.transform.rotation.y = player_state.position.orientation.y
    #     #     t.transform.rotation.z = player_state.position.orientation.z
    #     #     t.transform.rotation.w = player_state.position.orientation.w

    #     #     # self.br.sendTransform(t)
    #     #     self.brs[player_state.id - 1].sendTransform(t)
    #     return

    def timer_callback_send_to_players(self,):

        players = self._player_states.players

        def get_float(pl, path, default=0.0):
            try:
                val = pl
                for p in path.split('.'):
                    val = getattr(val, p)
                return float(val)
            except Exception:
                return default

        def get_int(pl, path, default=0):
            try:
                val = pl
                for p in path.split('.'):
                    val = getattr(val, p)
                return int(val)
            except Exception:
                return default

        # header
        send_data = struct.pack('ii', NUM_PLAYERS, self._team_color)

        # commands
        cmds = [self.teamcmd for _ in range(NUM_PLAYERS)]
        send_data += struct.pack(''.join(['i' for _ in range(NUM_PLAYERS)]), *cmds)

        # states
        states = [get_int(players[i], 'state') if i < len(players) else 0 for i in range(NUM_PLAYERS)]
        send_data += struct.pack(''.join(['i' for _ in range(NUM_PLAYERS)]), *states)

        # float fields helper list
        float_fields = [
            'ball.distance',
            'ball.angle',
            'goal.distance',
            'goal.angle',
            'my_goal.distance',
            'my_goal.angle',
            'position.position.x',
            'position.position.y',
        ]

        for field in float_fields:
            vals = [get_float(players[i], field) if i < len(players) else 0.0 for i in range(NUM_PLAYERS)]
            send_data += struct.pack(''.join(['d' for _ in range(NUM_PLAYERS)]), *vals)

        # position.angle placeholder (RPY conversion required)
        send_data += struct.pack(''.join(['d' for _ in range(NUM_PLAYERS)]), *([0.0] * NUM_PLAYERS))

        # roles
        roles = self.roles_decision()
        send_data += struct.pack(''.join(['i' for _ in range(NUM_PLAYERS)]), *roles)

        # haveball
        haveballs = [get_int(players[i], 'haveball') if i < len(players) else 0 for i in range(NUM_PLAYERS)]
        send_data += struct.pack(''.join(['i' for _ in range(NUM_PLAYERS)]), *haveballs)

        # moveto x/y
        moveto_x = [get_float(players[i], 'moveto.position.x') if i < len(players) else 0.0 for i in range(NUM_PLAYERS)]
        moveto_y = [get_float(players[i], 'moveto.position.y') if i < len(players) else 0.0 for i in range(NUM_PLAYERS)]
        send_data += struct.pack(''.join(['d' for _ in range(NUM_PLAYERS)]), *moveto_x)
        send_data += struct.pack(''.join(['d' for _ in range(NUM_PLAYERS)]), *moveto_y)

        # moveto.angle placeholder
        send_data += struct.pack(''.join(['d' for _ in range(NUM_PLAYERS)]), *([0.0] * NUM_PLAYERS))

        # obstacle distance / angle
        obstacles_d = [get_float(players[i], 'obstacle.distance') if i < len(players) else 0.0 for i in range(NUM_PLAYERS)]
        obstacles_a = [get_float(players[i], 'obstacle.angle') if i < len(players) else 0.0 for i in range(NUM_PLAYERS)]
        send_data += struct.pack(''.join(['d' for _ in range(NUM_PLAYERS)]), *obstacles_d)
        send_data += struct.pack(''.join(['d' for _ in range(NUM_PLAYERS)]), *obstacles_a)

        # state_vector: position.x, position.y, position.angle placeholder
        pos_x = [get_float(players[i], 'position.position.x') if i < len(players) else 0.0 for i in range(NUM_PLAYERS)]
        pos_y = [get_float(players[i], 'position.position.y') if i < len(players) else 0.0 for i in range(NUM_PLAYERS)]
        send_data += struct.pack(''.join(['d' for _ in range(NUM_PLAYERS)]), *pos_x)
        send_data += struct.pack(''.join(['d' for _ in range(NUM_PLAYERS)]), *pos_y)
        send_data += struct.pack(''.join(['d' for _ in range(NUM_PLAYERS)]), *([0.0] * NUM_PLAYERS))

        # send
        try:
            self._player_server.broadcast(send_data)
        except Exception as e:
            self._node.get_logger().error(f'{e}: Please confirm Player IP address in player_server.py')

        return

    # PlayerServerクラスからシグナルが発行された時に実行されるスロット
    # プレイヤーからデータを受信した際のスロット関数
    # id: 受信したプレイヤーのid
    # player_state: プレイヤーのデータ
    @Slot(int, PlayerState)
    def onRecievedPlayerData(self, id, player_state):
        self._node.get_logger().debug('Player No:{}, states={}'.format(id, player_state))
        player_state.header.stamp = self._node.get_clock().now().to_msg()
        self._player_states.players[id - 1] = player_state  # 配列に代入
        return

    def roles_decision(self,):
        # 静的ロール割り振り
        # デフォルトは ALPHA を割り当て，最後のプレイヤーを GOALIE にする
        roles = [ALPHA for _ in range(NUM_PLAYERS)]
        if NUM_PLAYERS >= 1:
            roles[-1] = GOALIE

        # -----
        # ここから頑張って各プレイヤーのロールを決定する処理
        # -----
        # （案１）ボールとの距離の近さ順にAlpha, Beta,...
        if ROLE_ASSIGN_METHOD == 1:
            # 各プレイヤーの (index, ball.distance) をリスト化
            ball_distances = []
            for player in self._player_states.players:
                try:
                    pid = int(player.id)
                    dist = float(player.ball.distance)
                except Exception:
                    continue
                # ゴーリーは除外
                if pid == GOALIE:
                    continue
                ball_distances.append((pid - 1, dist))

            # 昇順（近い順）ソート
            ball_distances.sort(key=lambda x: x[1])

            # 近い順に役割を割り当てる（存在する範囲で）
            role_order = [ALPHA, BETA, GAMMA, DELTA]
            for i, (idx, _) in enumerate(ball_distances[:len(role_order)]):
                if 0 <= idx < NUM_PLAYERS:
                    roles[idx] = role_order[i]

        # ロール決定処理ここまで
        return roles  # 結果
