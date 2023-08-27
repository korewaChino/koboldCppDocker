FROM ubuntu:20.04

# Initialize the image
# Modify to pre-install dev tools and ROCm packages
ARG ROCM_VERSION=5.3
ARG AMDGPU_VERSION=5.3

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates curl gnupg software-properties-common && \
  curl -sL http://repo.radeon.com/rocm/rocm.gpg.key | apt-key add - && \
  sh -c 'echo deb [arch=amd64] http://repo.radeon.com/rocm/apt/$ROCM_VERSION/ focal main > /etc/apt/sources.list.d/rocm.list' && \
  sh -c 'echo deb [arch=amd64] https://repo.radeon.com/amdgpu/$AMDGPU_VERSION/ubuntu focal main > /etc/apt/sources.list.d/amdgpu.list'
RUN add-apt-repository -y ppa:cnugteren/clblast -y && apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
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

COPY requirements.txt .
RUN pip install -r requirements.txt
RUN pip install psutil
RUN mkdir ./home/koboldcpp
COPY ./koboldcpp ./home/koboldcpp

WORKDIR /home/koboldcpp
RUN make LLAMA_OPENBLAS=1 LLAMA_CLBLAST=1 -j$(nproc)

WORKDIR /
COPY start_program.sh /home/koboldcpp

WORKDIR /home/koboldcpp
RUN chmod 555 start_program.sh

EXPOSE 5001
CMD "./start_program.sh"
