# nvidia_cuda-base_docker

## Introduction
Dockerfile for nvidia cuda. You can use `--build-arg CUDA=<cuda_version>` to specify cuda version, `--build-arg PYTHON_VERSION=<version_num>` to specify python version, and `--build-arg TZ=<timezone>` to specify timezone.
- Default `CUDA` is `10.0-cudnn7-runtime-ubuntu18.04`
- Default `PYTHON_VERSION` is `3`
- Default `TZ` is `Asia/Taipei`
- You can find docker cuda versions on: https://hub.docker.com/r/nvidia/cuda/tags
- You can get more info of ppa on: https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa
- You can find timezone on: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones


## Usage
You can see example on [docker-image-build.sh](https://github.com/jimmy801/nvidia_cuda-base_docker/blob/master/docker-image-build.sh)

> Note:
>
>    All arg set need to add prefix flag `--build-arg`. 
>
>    That is to say, if you want to specify cuda version, python version, and timezone
>    you have to add `--build-arg CUDA=<cuda_version> --build-arg PYTHON_VERSION=<version_num> --build-arg TZ=<timezone>` tags
>    to do this.
>
>
>   Original `PS1` is <div><span style="background:black"><font color="#4e9a06">{user_name}@{host_name}</font><font color="white">:</font><font color="#32afff">{work_path}</font><font color="white">$</font>&nbsp;</span></div>
>   and modified `PS1` is <div><span style="background:black"><font color="#4e9a06">{user_name}</font><font color="white">@</font><font color="#ad7fa8">{host_name}</font><font color="white">:</font><font color="#32afff">{work_path}</font><font color="white">#</font>&nbsp;</span></div>


