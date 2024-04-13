#!/bin/bash
if [ ! -d ./work/px4 ] ; then
    cd ./work
    git clone https://github.com/PX4/PX4-Autopilot px4
    cd px4
    git tag v1.14.0
    cd ../..
fi

if [ ! -d ./work/ros2_ws/src ] ; then
    mkdir -p ./work/ros2_ws/src
    cd work/ros2_ws/src
    git clone https://github.com/PX4/px4_msgs.git
    git clone https://github.com/Jaeyoung-Lim/px4-offboard.git
fi

