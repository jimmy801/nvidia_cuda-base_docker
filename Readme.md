# nvidia_cuda-base_docker

## Introduction
Dockerfile for nvidia cuda. You can use `--build-arg CUDA=<cuda_version>` to specify pyton version, and `--build-arg PYTHON_VERSION=<version_num>` to specify pyton version.
- Default `CUDA` is `10.0-cudnn7-runtime-ubuntu18.04`
- Default `PYTHON_VERSION` is `3`
- You can find docker cuda versions on: https://hub.docker.com/r/nvidia/cuda/tags


```
All arg set need to add prefix `--build-arg`. 
That is to say, if you want to specify both python version and cuda version, you have to write `--build-arg PYTHON_VERSION=<version_num> --build-arg CUDA=<cuda_version>` to do this.
```