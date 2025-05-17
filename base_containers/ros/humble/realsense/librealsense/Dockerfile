FROM uwrobosoccer/interbotix_stack:1.0.0

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get dist-upgrade -y

RUN apt-get install -y --no-install-recommends \
    ca-certificates \
    libssl-dev \
    libusb-1.0.0-dev \
    libudev-dev \
    pkg-config \
    libgtk-3-dev \
    git \
    wget \ 
    cmake \
    build-essential \
    libglfw3-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    at

ADD https://github.com/IntelRealSense/librealsense.git#v2.56.3 /librealsense_src

WORKDIR /librealsense_src/build
RUN cmake ../ \
    -DCMAKE_BUILD_TYPE=release \
    -DBUILD_EXAMPLES=false \
    -DBUILD_GRAPHICAL_EXAMPLES=false \
    -DBUILD_GLSL_EXTENSIONS=false

RUN make -j$(($(nproc) - 1))
# it's possible to install some of the above (the real deps)
# and copy this as a stage build into ros, instead of building 
# it on top of ros
RUN make install
