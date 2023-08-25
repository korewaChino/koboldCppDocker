FROM nvidia/cuda:12.2.0-devel-rockylinux9

RUN dnf makecache

RUN dnf install -y yum-utils sudo
RUN dnf config-manager --set-enabled crb
RUN dnf install -y epel-release

RUN dnf makecache -y -v

RUN dnf install -y gcc \
    gcc-c++ \
    python3 python3-devel \
    python3-pip \
    make \
    cmake \
    git \
    wget \
    unzip \
    openblas-devel \
    clblast-devel

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

EXPOSE 5001
CMD "./start_program.sh"

