## Full-featured Docker image for Kobold-C++ (KoboldCPP)

This is a Docker image for Kobold-C++ (KoboldCPP) that includes all the tools needed to build and run KoboldCPP, with almost all BLAS backends supported.

The image is based on Rocky Linux 9 with CUDA 12.2.0.

## Usage

Simply run Docker to build and run KoboldCPP, refer to the [docker-compose.yml](docker-compose.yml) file for an example.

## Building

To build the image, run:

```bash
docker compose build
```
