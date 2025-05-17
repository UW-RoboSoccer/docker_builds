FROM uwrobosoccer/librealsense_moveit:2.56.3

# set up realsense-ros, this container already contains ros

WORKDIR /root/interbotix_ws
ADD https://github.com/IntelRealSense/realsense-ros.git#4.56.3 src/realsense-ros

RUN apt update

RUN rosdep update
RUN rosdep install -i -r --from-path src --rosdistro humble --skip-keys=librealsense2 --skip-keys gazebo_ros \
    --skip-keys gazebo_ros2_control -y
RUN rm -rf /var/lib/apt/lists/* # buildkit
RUN apt-get clean

RUN . /opt/ros/humble/setup.sh && colcon build
