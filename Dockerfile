ARG SOURCE_IMAGE=ubuntu:20.04
FROM $SOURCE_IMAGE

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      build-essential \
      ca-certificates \
      cmake \
      cron \
      curl \
      ffmpeg \
      g++-10 \
      gcc-10 \
      gdb \
      gfortran \
      git \
      gnupg2 \
      htop \
      iputils-ping \
      less \
      libgtk-3-dev \
      libpcl-dev \
      libstdc++6 \
      libtool \
      libopencv-dev \
      lsb-release \
      make \
      python3-pip \
      python3-dbg \
      python3-matplotlib \
      python3-numpy \
      python3-opencv \
      python3-pandas \
      python3-scipy \
      rsync \
      software-properties-common \
      unzip \
      wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp/cuda
ENV CUDA_VERSION 11.3
ARG DEB_FILE_NAME=cuda-repo-ubuntu2004-11-3-local_11.3.1-465.19.01-1_amd64.deb
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin \
    && mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600 \
    && wget https://developer.download.nvidia.com/compute/cuda/11.3.1/local_installers/${DEB_FILE_NAME} \
    && dpkg -i ${DEB_FILE_NAME} \
    && apt-key add /var/cuda-repo-ubuntu2004-11-3-local/7fa2af80.pub \
    && apt-get update \
    && apt-get -y install cuda \
    && rm ${DEB_FILE_NAME}

RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-11-3 \
    cuda-compat-11-3 \
    && rm -rf /var/lib/apt/lists/*

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf \
    && echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=11.3 brand=ampere,driver>=460,driver<470"
ENV NCCL_VERSION 2.8.4

RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-libraries-11-3 \
    libnpp-11-3 \
    cuda-nvtx-11-3 \
    libcublas-11-3 \
    libcusparse-11-3 \
    && rm -rf /var/lib/apt/lists/*

# apt from auto upgrading the cublas package. See https://gitlab.com/nvidia/container-images/cuda/-/issues/88
RUN apt-mark hold libcublas-11-3

RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-command-line-tools-11-3 \
    cuda-cudart-dev-11-3 \
    cuda-libraries-dev-11-3 \
    cuda-minimal-build-11-3 \
    cuda-nvml-dev-11-3 \
    libavcodec58 \
    libavformat58 \
    libavutil56 \
    libcublas-dev-11-3 \
    libcusparse-dev-11-3 \
    libnpp-dev-11-3 \
    libswresample3 \
    libswscale5 \
    libtinfo5 \
    libncursesw5 \
    libusb-1.0-0-dev \
    && rm -rf /var/lib/apt/lists/*

ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs
ENV CUDA_BIN_PATH /usr/local/cuda-11.3

COPY requirements.txt .
RUN pip install -r requirements.txt
