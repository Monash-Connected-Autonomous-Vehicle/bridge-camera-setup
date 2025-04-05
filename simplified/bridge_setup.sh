#!/bin/bash

# Kill any running instances of roscore or rosmaster
pkill roscore
pkill rosmaster

# Check if an IP address is passed as a parameter, otherwise default to the local IP
if [ -z "$1" ]; then
    echo "No IP address provided. Using the local machine's IP address."
    ROS_IP=$(hostname -I | awk '{print $1}')
    if [ -z "$ROS_IP" ]; then
        echo "Error: Unable to determine the local machine's IP address."
        exit 1
    fi
else
    # Use the provided IP address
    ROS_IP=$1
fi

# Set the ROS master URI based on the ROS_IP
export ROS_IP
export ROS_MASTER_URI=http://$ROS_IP:11311
export CONTAINER_CMD="sudo apt update; sudo apt install -y tilix; export ROS_MASTER_URI=$ROS_MASTER_URI; export ROS_IP=$ROS_IP; roscore"
export FINAL_CONTAINER_CMD="\"$CONTAINER_CMD\""
    
rocker --x11 --user --privileged \
    --volume /dev/shm:/dev/shm --network=host -- osrf/ros:noetic-desktop \
    "bash -c  $FINAL_CONTAINER_CMD" &

    
# 2. Start ROS 1-ROS 2 bridge 
source /opt/ros/humble/setup.bash
source ~/ros-humble-ros1-bridge/install/local_setup.bash
ros2 run ros1_bridge dynamic_bridge --bridge-all-topics 