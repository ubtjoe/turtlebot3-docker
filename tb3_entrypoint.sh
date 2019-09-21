#!/bin/bash
set -e

# setup ros environment
source "/opt/ros/$ROS_DISTRO/setup.bash"
source "/home/turtlebot/catkin_ws/devel/setup.bash"
exec "$@"
