import threading
import socket
import struct
from scipy.spatial.transform import Rotation

from musashi_msgs.msg import PlayerState

PLAYER_SERVER_IP = '127.0.0.1'
PLAYER_SERVER_PORT = 12536


class BaseStationClient(threading.Thread):
    def __init__(self):
        super(BaseStationClient, self).__init__()

        self._socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self._socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEPORT, 1)

        return

    def run(self,):
        return

    def send(self, _player_state):

        position_quat = Rotation.from_quat([
            _player_state.position.orientation.x,
            _player_state.position.orientation.y,
            _player_state.position.orientation.z,
            _player_state.position.orientation.w,
        ])
        position_rpy = position_quat.as_euler('xyz', degrees=False)

        moveto_quat = Rotation.from_quat([
            _player_state.position.orientation.x,
            _player_state.position.orientation.y,
            _player_state.position.orientation.z,
            _player_state.position.orientation.w,
        ])
        moveto_rpy = moveto_quat.as_euler('xyz', degrees=False)

        data = '{},{},{},{},'.format(
          _player_state.color,
          _player_state.id,
          _player_state.action,
          _player_state.state
        )
        
        data = data + '{},{},'.format(
          _player_state.ball.distance,
          _player_state.ball.angle,
        )
        
        data = data + '{},{},'.format(
          _player_state.goal.distance,
          _player_state.goal.angle,
        )
        
        data = data + '{},{},'.format(
          _player_state.my_goal.distance,
          _player_state.my_goal.angle,
        )
        
        data = data + '{},{},{},'.format(
          _player_state.position.position.x,
          _player_state.position.position.y,
          position_rpy[2],
        )
        
        data = data + '{},'.format(
          _player_state.role
        )
        
        data = data + '{},'.format(
          _player_state.haveball
        )
        
        data = data + '{},{},{},'.format(
          _player_state.moveto.position.x,
          _player_state.moveto.position.y,
          moveto_rpy[2],
        )
        
        data = data + '{},{}'.format(
          _player_state.obstacle.distance,
          _player_state.obstacle.angle,
        )

        # data = 'iiiidddddddddiiddddd'.format(
        #     _player_state.color,
        #     _player_state.id,
        #     _player_state.action,
        #     _player_state.state,
        #     _player_state.ball.distance,
        #     _player_state.ball.angle,
        #     _player_state.goal.distance,
        #     _player_state.goal.angle,
        #     _player_state.my_goal.distance,
        #     _player_state.my_goal.angle,
        #     _player_state.position.position.x,
        #     _player_state.position.position.y,
        #     position_rpy[2],
        #     _player_state.role,
        #     _player_state.haveball,
        #     _player_state.moveto.position.x,
        #     _player_state.moveto.position.y,
        #     moveto_rpy[2],
        #     _player_state.obstacle.distance,
        #     _player_state.obstacle.angle,
        # )

        self._socket.sendto(data.encode(),
                            (PLAYER_SERVER_IP, PLAYER_SERVER_PORT))

        return

    def recv(self,):
        return
