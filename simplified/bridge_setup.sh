#!/bin/bash

# Kill any running instances of roscore or rosmaster
pkill roscore
pkill rosmaster

# Check if an IP address is passed as a parameter, otherwise, exit with an error
if [ -z "$1" ]; then
    echo "Error: No IP address provided. Usage: ./bridge_setup.sh <HOST_IP_ADDRESS>"
    exit 1
fi

# Set the ROS master URI and IP based on the parameter passed
ROS_IP=$1
export ROS_MASTER_URI=http://$ROS_IP:11311
export ROS_IP

# Start Docker with ROS Noetic and ROS master in the background
rocker --x11 --user --privileged \
    --volume /dev/shm:/dev/shm --network=host -- osrf/ros:noetic-desktop \
    'bash -c "sudo apt update; sudo apt install -y tilix; 
              export ROS_MASTER_URI=$ROS_MASTER_URI;
              export ROS_IP=$ROS_IP;
              roscore"'
