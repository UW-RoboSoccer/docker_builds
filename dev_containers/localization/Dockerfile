FROM ros:humble-ros-base AS base

RUN useradd -m -s /bin/bash dev

RUN mkdir -p /home/dev/ros2_ws/src

WORKDIR /home/dev/ros2_ws

RUN chown -R dev:dev /home/dev/ros2_ws

RUN echo "source /opt/ros/humble/setup.bash" >> /home/dev/.bashrc

USER dev

CMD ["bash"]