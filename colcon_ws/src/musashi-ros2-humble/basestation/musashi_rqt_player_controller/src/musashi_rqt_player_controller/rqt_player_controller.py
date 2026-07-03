from ament_index_python.resources import get_resource
from qt_gui.plugin import Plugin
from python_qt_binding import loadUi
from python_qt_binding.QtWidgets import QWidget, QHBoxLayout
from python_qt_binding.QtCore import QTimer, Slot
import os

from musashi_msgs.msg import PlayerStates

PKG_NAME = 'musashi_rqt_player_controller'
UI_FILE_NAME = 'player_controller.ui'

PLAYER_NUM = 5

MAGENTA = 0
CYAN = 1

ALPHA = 1
BETA = 2
GAMMA = 3
DELTA = 4
GOALIE = 5

class RqtPlayerController(Plugin):
    def __init__(self, context):
        super(RqtPlayerController, self).__init__(context)

        self.setObjectName('RqtPlayerController')
        self._context = context
        self._node = context.node

        # ウィジェットインスタンスを作成
        # メンバ変数_widgetに.uiファイルが書き込まれる
        self.create_ui()

        # コンテキストに作成したウィジェットを追加
        # これをしないとGUI画面が表示されない
        self._context.add_widget(self._widget)
        
        # サブスクライバーの作成
        self._sub_player_states = self._node.create_subscription(
            PlayerStates,
            '/player_states',
            self.player_states_callback,
            3
        )

        # GUIスレッドのスタート
        self.start_ui_thread()

    def create_ui(self,):
        # Qwidget型のメンバ変数作成
        self._widget = QWidget()
        # パッケージ名からパッケージのディレクトリパスを取得
        _, package_path = get_resource('packages', PKG_NAME)
        # .uiファイルへのパスを作成，取得
        ui_file = os.path.join(package_path, 'share',
                               PKG_NAME, 'resource', UI_FILE_NAME)

        self._layout = QHBoxLayout()

        self._pwidgets = []

        for i in range(PLAYER_NUM):
            self._pwidgets.append(QWidget())
            loadUi(ui_file, self._pwidgets[-1])  # 末尾のQWidgetインスタンスにuiファイルをロード

            self._layout.addWidget(self._pwidgets[-1])

        self._widget.setLayout(self._layout)

        # 複数出してしまった時に個別のインスタンスが作成されるように一工夫
        if self._context.serial_number() > 1:
            self._widget.setWindowTitle(
                self._widget.windowTitle() + (' (%d)' % self._context.serial_number()))

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

    def save_settings(self, plugin_settings, instance_settings):
        pass

    def restore_settings(self, plugin_settings, instance_settings):
        pass

    def player_states_callback(self, player_states):
        for i, player_state in enumerate(player_states.players):
            timestamp = str(player_state.header.stamp.sec) + '.' + \
                '{:.1g}'.format(player_state.header.stamp.nanosec)

            id = player_state.id
            color = player_state.color
            action = player_state.action
            state = player_state.state
            role = player_state.role

            self._pwidgets[i].lblTimeStamp.setText(
                timestamp)  # timestampラベルに書き込み
            self._pwidgets[i].lblID.setText(str(id))
            self._pwidgets[i].lblAction.setText(str(action))
            self._pwidgets[i].lblState.setText(str(state))

            # if color == MAGENTA:
            #     self._pwidgets[i].ledtDispColorAndRole.setStyleSheet(
            #         'color: magenta;')
            # elif color == CYAN:
            #     self._pwidgets[i].ledtDispColorAndRole.setStyleSheet(
            #         'color: cyan;')

            if role == ALPHA:
                self._pwidgets[i].ledtDispColorAndRole.setText('Alpha')
            if role == BETA:
                self._pwidgets[i].ledtDispColorAndRole.setText('Beta')
            if role == GAMMA:
                self._pwidgets[i].ledtDispColorAndRole.setText('Gamma')
            if role == DELTA:
                self._pwidgets[i].ledtDispColorAndRole.setText('Delta')
            if role == GOALIE:
                self._pwidgets[i].ledtDispColorAndRole.setText('Goalie')

        return
