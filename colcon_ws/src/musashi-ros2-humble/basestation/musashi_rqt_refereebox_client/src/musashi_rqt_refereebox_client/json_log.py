from datetime import datetime, timezone
import math
import numpy as np
from scipy.spatial.transform import Rotation
import json

# ------------------------------
# こいつにmusashi_msgsをimportするのは禁止！
# このモジュール単体でテストできなくなるので
# ------------------------------


def make_header(start_time):
    header = {}
    header['type'] = 'worldstate'  # これは決まっている
    header['teamName'] = 'Hibikino-Musashi'  # これは決まっている
    header['intention'] = ''  # 自由な記入形式（使わなくてもいい）チーム全体の意思決定のメモみたいな

    # 現在時間を取得
    current_time = datetime.now(timezone.utc)

    # 経過時間を計算
    elapsed_time = current_time - start_time

    # 経過時間msを計算
    ageMs = elapsed_time.total_seconds()*1000

    # headerに追加．キー名は"ageMs"
    header['ageMs'] = ageMs

    # 辞書型を返す
    return header


def transform_to_world(x, y, z, qx, qy, qz, qw):
    # 座標変換行列を作成
    M = np.array([
        [-1, 0, 0],
        [0, -1, 0],
        [0, 0, -1]
    ])

    # 現在の位置をnp.arrayに
    _p = np.array([x, y, z])

    # 座標変換
    p = np.dot(M, _p)  # M.p

    # 姿勢角の変換
    r = Rotation.from_quat([qx, qy, qz, qw])
    _r = r.as_euler('xyz', degrees=False)
    _th = _r[2]  # z軸周りの角度[rad]
    th = _th - 2.0*math.pi  # 変換

    return p[0], p[1], th


def make_player(id,
                _px, _py, _qx, _qy, _qz, _qw,
                _tpx, _tpy, _tqx, _tqy, _tqz, _tqw,
                haveball):
    player = {}

    player['id'] = int(id)  # プレイヤーIDを追加
    player['ballEngaged'] = int(haveball)  # ボール保持を追加
    player['velocity'] = [0.0, 0.0, 0.0]  # 速度を追加(プレイヤーからは来ていないはず)
    player['intention'] = ''
    player['batteryLevel'] = 98.0  # バッテリー残量を追加（プレイヤーから来ていない）

    # 現在の位置を追加する．ただし大会規定の座標系に変換する必要がある
    px, py, th = transform_to_world(_px, _py, 0.0, _qx, _qy, _qz, _qw)

    # 辞書型に追加
    player['pose'] = [px, py, th]

    # 目標姿勢を追加する．ただし大会規定の座標系に変換する必要がある
    tpx, tpy, tth = transform_to_world(_tpx, _tpy, 0.0, _tqx, _tqy, _tqz, _tqw)

    # 辞書型に追加
    player['targetPose'] = [tpx, tpy, tth]

    # 辞書型を返す
    return player


def make_players(_players):
    players = []

    for _player in _players:
        player = make_player(
            _player[0],  # id
            _player[1],  # x
            _player[2],  # y
            # _player[3],  # z （ない）
            _player[4],  # qx
            _player[5],  # qy
            _player[6],  # qz
            _player[7],  # qw
            _player[8],  # moveto x
            _player[9],  # moveto y
            # _player[10],  # moveto z （ない）
            _player[11],  # moveto qx
            _player[12],  # moveto qy
            _player[13],  # moveto qz
            _player[14],  # moveto qw
            _player[15],  # haveball
        )
        players.append(player)

    return players  # 辞書型のリストを返す

def make_ball(_px, _py, _qx, _qy, _qz, _qw,
              ball_dis, ball_angle):
    ball = {}

    # まずはプレイヤー姿勢を座標変換
    px, py, th = transform_to_world(_px, _py, 0.0, _qx, _qy, _qz, _qw)

    # ボールとの距離と角度からrobot座標系におけるボール座標を求める
    rx = ball_dis*math.cos(ball_angle)
    ry = ball_dis*math.sin(ball_angle)

    # プレイヤー姿勢に基づきworld座標系におけるボール座標を求める
    # 回転＋並行移動（同次変換）
    M = np.array([
        [math.cos(th), -math.sin(th), px],
        [math.sin(th), math.cos(th), py],
        [0, 0, 1]
    ])
    B = np.array([rx, ry, 1])
    X = np.dot(M, B)

    ball['position'] = [X[0], X[1], 0.0]  # z軸(高さ方向はもらってないので計算できない)
    ball['velocity'] = [0.0, 0.0, 0.0]  # ボールの運動速度はもらっていないのでわからない
    ball['confidence'] = 1.0  # 尤度はもらっていないのでわからない

    return ball

def make_balls(_balls):
    balls = []
    
    for _ball in _balls:
        ball = make_ball(
            _ball[0], # x
            _ball[1], # y
            # _ball[2], # z（ない）
            _ball[3], # qx
            _ball[4], # qy
            _ball[5], # qz
            _ball[6], # qw
            _ball[7], # ball distance
            _ball[8], # ball angle
        )
        balls.append(ball)
        
    return balls


if __name__ == '__main__':
    print('Verification of json format')

    # テスト用のプレイヤーデータ作成（id,x,y,z,qx,qy,qz,qw,haveball）
    players = [
        [1,
         2.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0,
         2.0, 3.0, 0.0, 0.0, 0.0, 0.0, 1.0,
         0],
        [2,
         2.5, 1.5, 0.0, 0.0, 0.0, 0.0, 1.0,
         2.5, 2.0, 0.0, 0.0, 0.0, 0.0, 1.0,
         1]
    ]

    # テスト用のボールデータ作成(x,y,z,qx,qy,qz,qw,ball_distance,ball_angle)
    balls = [
        [2.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0,
         2.5, math.pi/2.0],
        [2.5, 1.5, 0.0, 0.0, 0.0, 0.0, 1.0,
         2.5, math.pi/3.0]
    ]

    data = make_header(datetime.now(timezone.utc))
    data['robots'] = make_players(players)
    data['balls'] = make_balls(balls)

    print(json.dumps(data, indent=2))
