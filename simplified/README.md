### Simplified version

- Root layer verision has a lot of assumes the IP address of devices and has multiple points of failure
- This folder gives users a second option with running the bridge

1. On host device running the bridge
```bash
./bridge_setup.sh # optionally add the host's device's ip address
```

2. On PX 2 device running ROS1 
```bash
./px2_setup.sh <HOST-IP>
```

### Assumptions for above
- Both devices are connected to the same network
- [ros-humble-ros1-bridge-builder](https://github.com/TommyChangUMD/ros-humble-ros1-bridge-builder/?tab=readme-ov-file) is set up 
- PX 2 is on and ready to run cameras
