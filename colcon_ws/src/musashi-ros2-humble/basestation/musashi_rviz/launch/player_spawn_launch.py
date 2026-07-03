# player_spawn_launch.py
# player��robot_state���p�u���b�V�����邽�߂�launch�t�@�C��

"""player_spawn_launch.py

初心者向け説明:
- この launch は 1 台分のプレイヤーロボットの `robot_state_publisher` を起動します。
- `frame_prefix` 引数を受け取り、TF フレーム名のプレフィックス（名前空間）を付けられます。

ポイント:
- `DeclareLaunchArgument` を使うと、起動時に外部から値を渡せるようになります。
- `LaunchConfiguration('frame_prefix')` はその引数の値を参照するためのプレースホルダです。
- `robot_state_publisher` ノードには `robot_description`（URDF の文字列）を渡します。
"""

from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument
from launch.substitutions import LaunchConfiguration
from launch_ros.actions import Node
from ament_index_python.packages import get_package_share_directory
import os


def generate_launch_description():
    # URDF ファイルへのパスをパッケージ共有ディレクトリから取得
    urdf_file = os.path.join(
        get_package_share_directory('musashi_description'),
        'urdf',
        'musashi_player.urdf'
    )

    return LaunchDescription([

        # `frame_prefix` を宣言します。起動時に `frame_prefix:=player1/` のように渡せます。
        DeclareLaunchArgument('frame_prefix', default_value=''),

        # 1. robot_state_publisher���N��
        # `robot_state_publisher` は URDF を読み込み、TF を公開します。
        # `robot_description` に URDF ファイルの内容を渡しています。
        Node(
            package='robot_state_publisher',
            executable='robot_state_publisher',
            output='screen',
            parameters=[{
                'robot_description': open(urdf_file).read(),
                'frame_prefix': LaunchConfiguration('frame_prefix'),
            }]
        ),
    ])
