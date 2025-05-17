FROM uwrobosoccer/python:3.12.8 AS key

RUN apt update
RUN apt install -y curl
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /ros-archive-keyring.gpg

FROM uwrobosoccer/python:3.12.8

COPY --from=key /ros-archive-keyring.gpg /usr/share/keyrings/ros-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN apt update
RUN apt upgrade -y
RUN apt install -y \
    software-properties-common \
    equivs
RUN add-apt-repository universe

WORKDIR /ros2_ws
ADD https://github.com/ros2/ros2.git#release-humble-20241205 src/ros2

#todo: make equivs package fro 3.12, pip, setuptoolspossibly others, install colcon with pip and make equivs for that and missing parts (rosdep?) from ros-dev-tools (ros-build-essential?)

RUN colcon build \
--symlink-install \
--cmake-args \
  -DPYTHON_EXECUTABLE=/usr/local/bin/python3.12 \
  -DPYTHON_INCLUDE_DIR=/usr/local/include/python3.12 \
  -DPYTHON_LIBRARY=/usr/local/lib/libpython3.12.so

SHELL ["/bin/bash", "-c"]
# TODO: wrong path?
RUN cat > /entrypoint.sh <<'EOF' 
#!/usr/bin/env bash
set -e
source /opt/ros/humble/setup.bash
exec "$@"
EOF
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc