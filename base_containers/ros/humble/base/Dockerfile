FROM alpine AS gpg
RUN apk add curl
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /ros-archive-keyring.gpg

# this is ok with 36.4.3 per nvidia support
FROM nvcr.io/nvidia/l4t-jetpack:r36.4.0
COPY --from=gpg /ros-archive-keyring.gpg /usr/share/keyrings/ros-archive-keyring.gpg

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install locales && \
    locale-gen en_US en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 && \
    apt install -y software-properties-common && \
    add-apt-repository universe && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null && \
    apt update && \
    apt upgrade -y && \ 
    apt install -y \
    python3 \
    python3-pip \
    python3-rosdep \
    python3-colcon-common-extensions \
    ros-humble-ros-base && \
    rm -rf /var/lib/apt/lists/* # buildkit

COPY default_fastdds_profile.xml /
ENV FASTRTPS_DEFAULT_PROFILES_FILE=/default_fastdds_profile.xml
ENV RMW_FASTRTPS_USE_QOS_FROM_XML=1

RUN adduser --disabled-password --gecos "" ros
RUN mkdir -p /etc/ros/rosdep/sources.list.d && chown -R ros:ros /etc/ros

USER ros
WORKDIR /home/ros/ros_ws

RUN rosdep init

# install fastddsspy
#RUN apt install -y --no-install-recommends \
#cmake \
#    g++ \ 
#    wget \
#    git \
#    libasio-dev \
#    libtinyxml2-dev \
#    libssl-dev \
#    libyaml-cpp-dev 
#RUN pip3 install -U colcon-common-extensions vcstool
#RUN mkdir -p ~/fastdds-spy/src && \
#cd ~/fastdds-spy && \
#wget https://raw.githubusercontent.com/eProsima/Fast-DDS-Spy/main/fastddsspy.repos && \ 
#vcs import src < fastddsspy.repos 
#colcon build --packages-up-to-regex fastddsspy

SHELL ["/bin/bash", "-c"]
RUN cat > /home/ros/entrypoint.sh <<'EOF' 
#!/usr/bin/env bash
set -e
source /opt/ros/humble/setup.bash
exec "$@"
EOF
RUN chmod +x /home/ros/entrypoint.sh
ENTRYPOINT ["/home/ros/entrypoint.sh"]
RUN echo "source /opt/ros/humble/setup.bash" >> /home/ros/.bashrc