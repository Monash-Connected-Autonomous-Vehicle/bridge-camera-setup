#!/bin/bash

# Function to wait for Docker to start
function wait_for_docker() {
  echo "Waiting for Docker to start..."
  while ! docker info > /dev/null 2>&1; do
    sleep 1
  done
  echo "Docker is up and running."
}

# Function to wait for roscore to start (port 11311 is ROS master default port)
function wait_for_roscore() {
  echo "Waiting for ROS master (roscore) to start..."
  while ! nc -z localhost 11311; do
    sleep 1
  done
  echo "ROS master is running."
}

# since only one instance of roscore can run at a time
pkill roscore
pkill rosmaster

# 1. Start Docker with ROS Noetic and ROS master in the background
rocker --x11 --user --privileged \
    --volume /dev/shm /dev/shm --network=host -- osrf/ros:noetic-desktop \
    'bash -c "sudo apt update; sudo apt install -y tilix; 
              export ROS_MASTER_URI=http://192.168.1.2:11311;
              export ROS_IP=192.168.1.2;
              roscore"' &

# Wait until Docker is up and running
wait_for_docker

# Wait for roscore to be ready
wait_for_roscore

# 2. Start ROS 1-ROS 2 bridge in the background
source /opt/ros/humble/setup.bash
source ~/ros-humble-ros1-bridge/install/local_setup.bash
ros2 run ros1_bridge dynamic_bridge --bridge-all-topics &

# 3. SSH into the NVIDIA device
echo "Connecting to NVIDIA device at 192.168.1.181..."
ssh nvidia@192.168.1.181 << 'EOF'
    # Run the PX2 setup script
    echo "Running PX2 setup script..."
    ./px2_setup.sh
EOF

echo "All processes have been started in the background."
