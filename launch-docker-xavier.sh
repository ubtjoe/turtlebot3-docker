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
export ROS_MASTER_URI=192.168.1.124:11311
export ROS_HOSTNAME=$(ifconfig wlan0 | awk '/inet / {print $2}')
#export ROS_MASTER_URI=localhost:11311
#export ROS_HOSTNAME=localhost
export ROS_HOSTNAME_CONTAINER=dreslam-xavier
# END MODIFY

docker run -i -t --rm \
    --env DISPLAY=$DISPLAY \
    --env "QT_X11_NO_MITSHM=1" \
    -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --env "XAUTHORITY=$XAUTH" \
    -v "$XAUTH:$XAUTH" \
    -v /etc/localtime:/etc/localtime:ro \
    -v /dev:/dev \
    --name $ROS_HOSTNAME_CONTAINER \
    --privileged \
    --network=host \
    --env "ROS_MASTER_URI=http://$ROS_MASTER_URI" \
    --env "ROS_HOSTNAME=$ROS_HOSTNAME" \
    dreslam-host \
    ./launch-xavier-nodes.sh
