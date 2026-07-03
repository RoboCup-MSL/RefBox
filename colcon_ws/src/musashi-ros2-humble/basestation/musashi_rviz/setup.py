from setuptools import find_packages, setup

package_name = 'musashi_rviz'

setup(
    name=package_name,
    version='0.0.0',
    packages=find_packages(exclude=['test']),
    data_files=[
        ('share/ament_index/resource_index/packages',
            ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
        ('share/' + package_name + '/launch', ['launch/bringup_launch.py']),
        ('share/' + package_name + '/launch',
         ['launch/player_spawn_launch.py']),
        ('share/' + package_name + '/launch', ['launch/team_spawn_launch.py']),
        ('share/' + package_name + '/config',
         ['config/field_parameters.yaml', 'config/field_parameters_demo.yaml']),
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='ubuntu',
    maintainer_email='ubuntu@todo.todo',
    description='TODO: Package description',
    license='TODO: License declaration',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': [
            'node_field_publisher = musashi_rviz.node_field_publisher:main',
            'node_sample01_tf_publisher = musashi_rviz.node_sample01_tf_publisher:main',
        ],
    },
)
