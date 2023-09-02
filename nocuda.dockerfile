ARG UBUNTU_VERSION=22.04

# This needs to generally match the container host's environment.
ARG ROCM_VERSION=5.6

# Target the CUDA build image
ARG BASE_ROCM_DEV_CONTAINER=rocm/dev-ubuntu-${UBUNTU_VERSION}:${ROCM_VERSION}-complete

# Unless otherwise specified, we make a fat build.
# List from https://github.com/ggerganov/llama.cpp/pull/1087#issuecomment-1682807878
# This is mostly tied to rocBLAS supported archs.
ARG ROCM_DOCKER_ARCH=\
  gfx803 \
  gfx900 \
  gfx906 \
  gfx908 \
  gfx90a \
  gfx1010 \
  gfx1030 \
  gfx1100 \
  gfx1101 \
  gfx1102


FROM ${BASE_ROCM_DEV_CONTAINER}
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl gnupg software-properties-common
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
  rocblas-dev \
  libclblast-dev \
  hipblas-dev \
  python3-pip \
  opencl-headers \
  libclc-dev \
  libopencl-clang-dev \
  ocl-icd-opencl-dev \
  opencl-clhpp-headers \
  opencl-c-headers \
  rocm-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN pip install psutil
RUN mkdir ./home/koboldcpp
COPY ./koboldcpp ./home/koboldcpp

WORKDIR /home/koboldcpp
RUN pip install -r requirements.txt

ENV LLAMA_OPENBLAS=1
ENV LLAMA_CLBLAST=0
ENV LLAMA_HIPBLAS=1
ENV CC=/opt/rocm/llvm/bin/clang
ENV CXX=/opt/rocm/llvm/bin/clang++

RUN make -j$(nproc)

WORKDIR /
COPY start_program.sh /home/koboldcpp

WORKDIR /home/koboldcpp
RUN chmod 555 start_program.sh

EXPOSE 5001
CMD "./start_program.sh"
