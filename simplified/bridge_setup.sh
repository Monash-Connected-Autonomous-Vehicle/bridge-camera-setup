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
export ROS_MASTER_URI=http://$ROS_IP:11311
export ROS_IP

# Start Docker with ROS Noetic and ROS master in the background
rocker --x11 --user --privileged \
    --volume /dev/shm:/dev/shm --network=host --osrf/ros:noetic-desktop \
    -e ROS_MASTER_URI=$ROS_MASTER_URI \
    -e ROS_IP=$ROS_IP \
    bash -c "sudo apt update; sudo apt install -y tilix; roscore"
