import launch
import launch.actions
import launch.substitutions
import launch_ros.actions


def generate_launch_description():

        temperature = launch_ros.actions.Node(
                package='mypkg',
                executable='temperature',
                output='screen'
                )

        return launch.LaunchDescription([talker, listener])     
