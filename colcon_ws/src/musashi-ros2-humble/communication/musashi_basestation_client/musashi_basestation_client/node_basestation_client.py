#!/usr/bin/env python3

import rclpy
from rclpy.node import Node
import math

from musashi_msgs.msg import PlayerState

from musashi_basestation_client.basestation_client import BaseStationClient

class BasestationClientNode(Node):
    
    # メンバ変数初期化
    _player_state = PlayerState()
    
    # テストデータ代入
    _player_state.color = 1
    _player_state.id = 1
    _player_state.action = 0
    _player_state.state = 0
    
    def __init__(self):
        super().__init__('node_basestation_client')
        
        # インスタンス作成
        self.basestation_client = BaseStationClient()
        
        # スレッドのスタート（いらないのでは）
        # basestation_client.start()
        
        # サブスクライバー作成
        self._sub_player_state = self.create_subscription(
            PlayerState,
            '/player_state',
            self.player_state_callback,
            10,
        )
        
        # タイマコールバック関数の開始
        self._t = 0.0
        self._timer = self.create_timer(0.03, self.timer_callback)
        
    def player_state_callback(self, player_state):
        self._player_state = player_state # メンバ変数に保存
        return
    
    def timer_callback(self):
        self.get_logger().info('timer callback')
        
        # テストデータ
        self._player_state.position.position.x = math.sin(self._t)
        self._player_state.position.position.y = math.cos(self._t)
        
        # 送信処理
        self.basestation_client.send(self._player_state)
        
        # 返信の受信処理
        self.basestation_client.recv()
        
        self._t = self._t + 0.03
        return

def main(args=None):
    rclpy.init(args=args)
    node = BasestationClientNode()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
