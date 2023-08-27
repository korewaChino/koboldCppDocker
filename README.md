<img alt="Docker Pulls" src="https://img.shields.io/docker/pulls/korewachino/koboldcpp?link=https%3A%2F%2Fhub.docker.com%2Fr%2Fkorewachino%2Fkoboldcpp">

## Full-featured Docker image for Kobold-C++ (KoboldCPP)

[Docker Hub](https://hub.docker.com/r/korewachino/koboldcpp) | [GitHub](https://github.com/korewaChino/koboldCppDocker)

This is a Docker image for Kobold-C++ (KoboldCPP) that includes all the tools needed to build and run KoboldCPP, with almost all BLAS backends supported.

The image is based on Ubuntu 20.04 LTS, and has both an NVIDIA CUDA and a generic/OpenCL/ROCm version.

## Usage

Simply run Docker to build and run KoboldCPP, refer to the [docker-compose.yml](docker-compose.yml) file for an example.

To use the non-NVIDIA version, use the `nocuda` tag.

## Building

To build the image, run:

```bash
docker compose build
```
