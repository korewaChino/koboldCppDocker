ARG UBUNTU_VERSION=22.04
ARG CUDA_VERSION=12.2.0

FROM nvidia/cuda:${CUDA_VERSION}-devel-ubuntu${UBUNTU_VERSION}

# Unless otherwise specified, we make a fat build.
ARG CUDA_DOCKER_ARCH=all
ENV LLAMA_PORTABLE=1
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates curl gnupg software-properties-common 
RUN apt-get install -y --no-install-recommends \
  sudo \
  libelf1 \
  libnuma-dev \
  build-essential \
  git \
  vim-nox \
  cmake-curses-gui \
  kmod \
  file \
  python3 \
  libopenblas-dev \
  opencl-headers \
  libclc-dev \
  libopencl-clang-dev \
  ocl-icd-opencl-dev \
  opencl-clhpp-headers \
  opencl-c-headers \
  libclblast-dev \
  opencl-headers \
  python3-pip && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*


RUN pip install psutil


RUN mkdir ./home/koboldcpp
COPY ./koboldcpp ./home/koboldcpp

WORKDIR /home/koboldcpp

RUN pip install --upgrade pip setuptools wheel \
  && pip install -r requirements.txt

# You need this environment variable to make sure that the CUDA architecture works for all GPUs
ENV CUDA_DOCKER_ARCH=${CUDA_DOCKER_ARCH}
ENV LLAMA_CUBLAS=1
ENV LLAMA_OPENBLAS=1
ENV LLAMA_CUBLAS=1
ENV LLAMA_CLBLAST=0
RUN make -j$(nproc)

WORKDIR /
COPY start_program.sh /home/koboldcpp

WORKDIR /home/koboldcpp
RUN chmod 555 start_program.sh

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
EXPOSE 5001
CMD "./start_program.sh"

