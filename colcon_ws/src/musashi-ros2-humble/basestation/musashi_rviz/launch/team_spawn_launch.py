# player_spawn_launch.py
# team�S�������p�u���b�V�����邽�߂�launch�t�@�C��

"""team_spawn_launch.py

初心者向け説明:
- この launch は複数のプレイヤーを名前空間ごとに起動します。
- 以前はソース内で `PLAYER_NUM` をハードコーディングしていましたが、
  ここでは `player_num` を起動引数として受け取り、柔軟にプレイヤー数を指定できるようにしています。

使い方例:
```
ros2 launch musashi_rviz team_spawn_launch.py player_num:=3
```
これで `player1`, `player2`, `player3` が起動します。

実装のポイント（初心者向け）:
- `DeclareLaunchArgument` で引数を宣言します。
- `OpaqueFunction` を使うと、実際の起動コンテキスト（LaunchContext）から
  `LaunchConfiguration` の値を取得して Python ロジックを実行できます。
- ここでは `OpaqueFunction` 内で `player_num` を整数に変換し、必要な数だけ `GroupAction` を生成します。
"""

from launch import LaunchDescription
from launch.actions import GroupAction, IncludeLaunchDescription, DeclareLaunchArgument, OpaqueFunction
from launch.substitutions import LaunchConfiguration
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch_ros.actions import PushRosNamespace
from ament_index_python.packages import get_package_share_directory
import os


def _create_player_groups(context, *args, **kwargs):
    """OpaqueFunction から呼ばれる関数。

    LaunchContext を受け取って `player_num` を実際の値に解決し、
    その数だけ GroupAction を生成して返します。
    """
    # LaunchConfiguration の値を取得（文字列）
    player_num_str = LaunchConfiguration('player_num').perform(context)
    try:
        player_num = int(player_num_str)
    except Exception:
        # 取得できなかった場合は安全に 5 を使う
        player_num = 5

    player_spawn_launch_path = os.path.join(
        get_package_share_directory('musashi_rviz'),
        'launch',
        'player_spawn_launch.py'
    )

    groups = []
    for i in range(player_num):
        groups.append(
            GroupAction([
                PushRosNamespace('player' + str(i + 1)),
                IncludeLaunchDescription(
                    PythonLaunchDescriptionSource(player_spawn_launch_path),
                    launch_arguments=[
                        ('frame_prefix', 'player' + str(i + 1) + '/'),
                    ]
                ),
            ])
        )

    return groups


def generate_launch_description():
    # `player_num` を起動引数として宣言（デフォルトは 5）
    declare_player_num = DeclareLaunchArgument(
        'player_num', default_value='5', description='Number of player instances to spawn'
    )

    # OpaqueFunction を使って、起動時コンテキストから `player_num` を取得し動的にグループを生成
    create_groups = OpaqueFunction(function=_create_player_groups)

    return LaunchDescription([
        declare_player_num,
        create_groups,
    ])
