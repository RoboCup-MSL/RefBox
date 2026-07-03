import launch
import launch_ros.actions

def generate_launch_description():
  return launch.LaunchDescription([
    launch_ros.actions.Node(
      package='musashi_camera',
      executable='node_musashi_camera',
      name='node_musashi_camera',
    ),
  ])

