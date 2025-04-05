#!/bin/bash

pkill '^gmsl_n_cameras'

export LD_LIBRARY_PATH=/usr/lib

# Check if the ROS_MASTER_URI is passed as an argument
if [ -z "$1" ]; then
    echo "Error: ROS_MASTER_URI not provided. Usage: ./px2_setup.sh <HOST_IP> (i.e. twizy's IP)"
    exit 1
fi

# Set the ROS_MASTER_URI to the parameter passed
export ROS_MASTER_URI=$1

# Get the IP address of the current laptop (assuming it's on a local network)
export ROS_IP=$(hostname -I | awk '{print $1}')

# Check if we got a valid IP address
if [ -z "$ROS_IP" ]; then
    echo "Error: Unable to determine the IP address of the current laptop."
    exit 1
fi

echo "Setting ROS_IP to $ROS_IP and ROS_MASTER_URI to $ROS_MASTER_URI"

# Navigate to the workspace where the camera launch file is located
cd ~/Documents/ros_gmsl_ws

# Source the workspace environment
source devel/setup.bash

# Launch the cameras using roslaunch
roslaunch gmsl_n_cameras gmsl_n_cameras.launch
