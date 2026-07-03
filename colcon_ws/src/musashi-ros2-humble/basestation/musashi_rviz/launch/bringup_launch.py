
"""bringup_launch.py

初心者向け説明:
- これはRViz上にフィールドと複数プレイヤーの状態を表示するためのトップレベルのlaunchファイルです。
- 使用例: `ros2 launch musashi_rviz bringup_launch.py`
- このファイルは以下を行います:
    1. `musashi_rviz` パッケージの `node_field_publisher` ノードを起動してフィールド情報を配信します。
    2. `rviz2` を起動してパッケージ内のRViz設定 (`rviz/config.rviz`) をロードします。
    3. 同梱の `team_spawn_launch.py` を取り込んでプレイヤー用の名前空間と `robot_state_publisher` を起動します。

Launch の基本:
- `LaunchDescription()` に起動アクションを列挙します。
- `Node(...)` は ROS ノードを起動するアクションです。`parameters` や `arguments` を指定できます。
- `IncludeLaunchDescription(...)` は他の launch ファイルをネストして再利用します。
"""

from launch import LaunchDescription
from launch_ros.actions import Node
from launch.actions import IncludeLaunchDescription
from launch.launch_description_sources import PythonLaunchDescriptionSource
from ament_index_python.packages import get_package_share_directory
import os

FIELD_CONFIG_FILE_NAME = 'field_parameters_demo.yaml'

def generate_launch_description():

    team_spawn_launch_path = os.path.join(
        get_package_share_directory('musashi_rviz'),
        'launch',
        'team_spawn_launch.py'
    )
    
    field_parameter_path = os.path.join(
        get_package_share_directory('musashi_rviz'),
        'config',
        FIELD_CONFIG_FILE_NAME
    )

    rviz_config_path = os.path.join(
        get_package_share_directory('musashi_rviz'),
        'rviz',
        'config.rviz'
    )

    return LaunchDescription([
        # ノードの起動
        # 1. musashi_rvizパッケージのnode_field_publisherを起動
        # rviz上にフィールドを描画する
        Node(
            package='musashi_rviz',
            executable='node_field_publisher',
            name='field_publisher',
            parameters=[field_parameter_path]
        ),
        # 2. rviz2を起動
        # config.rvizを参照してレイアウトを読み込む
        # config.rvizは上書き保存して良い
        Node(
            package='rviz2',
            executable='rviz2',
            name='rviz2',
            output='screen',
            arguments=['-d', rviz_config_path]
        ),
        # 3. team_spawn_launchを起動
        IncludeLaunchDescription(
            PythonLaunchDescriptionSource(team_spawn_launch_path),
        )
    ])
