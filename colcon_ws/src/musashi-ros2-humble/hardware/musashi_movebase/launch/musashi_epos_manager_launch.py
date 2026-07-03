import launch
import launch_ros.actions
from launch_ros.actions import Node
from ament_index_python.packages import get_package_share_directory
import os

def generate_launch_description():
  
  param_files = '/home/musashi/ros2_ws/src/musashi-ros2-humble/hardware/musashi_movebase/config/musashi_movebase_config.yaml'
  
  config = os.path.join(
    get_package_share_directory('musashi_movebase'),
    'config',
    'musashi_movebase_config.yaml'
  )
  
  return launch.LaunchDescription([
    Node(
      package='musashi_movebase',
      executable='node_musashi_epos_manager',
      name='node_musashi_epos_manager',
      parameters=[param_files]
    ),
  ])

