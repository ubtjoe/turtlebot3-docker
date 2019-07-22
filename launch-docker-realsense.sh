XAUTH=/tmp/.docker.xauth
if [ ! -f $XAUTH ]
then
    xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
    if [ ! -z "$xauth_list" ]
    then
        echo $xauth_list | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi

# MODIFY BELOW (NOTE(jwd) - you may need to change the network id `wlp3s0` below)
export ROS_REMOTE_PC=$(ifconfig wlp5s0 | awk '/inet / {print $2}')
export ROS_PORT=11311
export ROS_MASTER_CONTAINER=rosmaster
# END MODIFY

docker run -i -t --rm \
    --env DISPLAY=$DISPLAY \
    --env "QT_X11_NO_MITSHM=1" \
    -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --env "XAUTHORITY=$XAUTH" \
    -v "$XAUTH:$XAUTH" \
    -v /etc/localtime:/etc/localtime:ro \
    --name $ROS_MASTER_CONTAINER \
    --runtime=nvidia \
    --privileged \
    --network=host \
    --env "ROS_MASTER_URI=http://$ROS_REMOTE_PC:$ROS_PORT" \
    --env "ROS_HOSTNAME=$ROS_REMOTE_PC" \
    realsense-ros-kinetic \
    /bin/bash 
