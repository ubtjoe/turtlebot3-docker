# MODIFY BELOW (NOTE(jwd) - you may need to change the network id `wlp3s0` below)
export ROS_MASTER_URI=192.168.1.100:11311
export ROS_HOSTNAME=$(ifconfig l4tbr0 | awk '/inet / {print $2}')
export ROS_HOSTNAME_CONTAINER=tb3-xavier
# END MODIFY

docker run -it --rm \
    -v /etc/localtime:/etc/localtime:ro \
    --name $ROS_HOSTNAME_CONTAINER \
    --privileged \
    --network=host \
    --env "ROS_MASTER_URI=http://$ROS_MASTER_URI" \
    --env "ROS_HOSTNAME=$ROS_HOSTNAME" \
    turtlebot3-xavier
