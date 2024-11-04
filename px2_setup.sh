#!/bin/bash
pkill '^gmsl_n_cameras'

export LD_LIBRARY_PATH=/usr/lib

# Set the ROS master URI to the ROS 1 master running on the Docker container
export ROS_MASTER_URI=http://192.168.1.2:11311

# Set the ROS IP address for the PX2
export ROS_IP=192.168.1.181

# Navigate to the workspace where the camera launch file is located
cd ~/Documents/ros_gmsl_ws

# Source the workspace environment
source devel/setup.bash

# Launch the cameras using roslaunch
roslaunch gmsl_n_cameras gmsl_n_cameras.launch
