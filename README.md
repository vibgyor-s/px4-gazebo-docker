# px4-gz-docker
Docker files needed to build images for px4_sitl simulation in ROS2 and Gazebo

## Create a ./work directory in root of cloned repo
The `./work` directory setup 

run `./get_src.sh` to clone each repo
```
work/
┣ px4/
┣ ros2_ws/
┃ ┗ src/
┃   ┣ px4_msgs/
┃   ┣ px4-offboard/
┗ .gitignore
```
AVOID:HUGE OVERLOAD, binaries already installed in ENV: 
Please build ros_gz from source. [see ros-gz](https://github.com/gazebosim/ros_gz)


Currently, docker uses same network interface as the host (Configure in compose file)
QGC running in host environment will directly connect to PX4 SITL

### Build and run
To build the image

`docker compose build`

OR

Same image can be pulled prebuilt by 

`docker pull pixelinkler/px4-gazebo-docker:latest`

To run multiple drones

`./run_dev.sh`

To access the shell of each service, in two different terminals run

////Terminal 1: `docker exec -u user -it px4-gazebo-docker-px4_gazebo-1 terminator`

Terminal 1: `docker exec -u user -it {(NAME_OF_CONTAINER)} bash`

To start px4_sitl and ros2 offboard control, split each terminator into 3 panels and run

1. `cd px4 && make px4_sitl gazebo-classic` to build px4_sitl first. (This only need to be built once in one of the container shells)\

comment(`PX4_SYS_AUTOSTART=4001 PX4_GZ_MODEL=x500 ./build/px4_sitl_default/bin/px4 -i 1` to start px4_sitl instance 1 with x500 in gz-garden.)

2. `MicroXRCEAgent udp4 -p 8888` to start DDS agent for communication with ROS2

comment(
### Environment Variables
- `PX4_GZ_MODEL` Name of the px4 vehicle model to spawn in gz
- `PX4_GZ_MODEL_POSE` Spawn pose of the vehicle model, must used with `PX4_GZ_MODEL`
- `PX4_MICRODDS_NS` Namespace assigned to the sitl vehicle, normally associated with px4 instances, but can be set mannually
- `ROS_DOMAIN_ID` Separate each container into its own domain (Is it still necessary since each SITL instance has a unique namespace?)
)

## In case anyone tries to get docker to work with QGC (in host), here is what worked for me. 

    get the the docker host ip using

DOCKER_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINER_NAME)

    Modify the QGC (in host) config file under

.config/QGroundControl.org/QGroundControl.ini

    Add the following

[LinkConfigurations]  
Link0\auto=true  
Link0\high_latency=false  
Link0\host0=$DOCKER_IP  
Link0\hostCount=4  
Link0\name=gazebo  
Link0\port=14580  
Link0\port0=14580  
Link0\type=1  
