FROM nvidia/cuda:12.2.0-devel-ubuntu20.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates curl gnupg software-properties-common 
RUN add-apt-repository -y ppa:cnugteren/clblast && apt-get update

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
  libclblast-dev \
  libcublas-dev \
  opencl-headers \
  python3-pip && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install -r requirements.txt
RUN pip install psutil
RUN mkdir ./home/koboldcpp
COPY ./koboldcpp ./home/koboldcpp

WORKDIR /home/koboldcpp
# You need this environment variable to make sure that the CUDA architecture works for all GPUs
ENV CUDA_DOCKER_ARCH=all
RUN make LLAMA_OPENBLAS=1 LLAMA_CUBLAS=1 LLAMA_CLBLAST=1 -j$(nproc)

WORKDIR /
COPY start_program.sh /home/koboldcpp

WORKDIR /home/koboldcpp
RUN chmod 555 start_program.sh

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
EXPOSE 5001
CMD "./start_program.sh"

