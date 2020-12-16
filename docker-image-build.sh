#!/bin/bash
daemon_path="."
path_to_dockfile="./Dockerfile"
image_repository="image_repository"
CUDA="10.0-cudnn7-runtime-ubuntu16.04"
PYTHON_VERSION="3.8"
TZ="America/New_York"
image_tag=cuda${CUDA}_py${PYTHON_VERSION}

docker build -t ${image_repository}:${image_tag} ${daemon_path} \
-f ${path_to_dockfile} \
--build-arg CUDA=${CUDA} \
--build-arg PYTHON_VERSION=${PYTHON_VERSION} \
--build-arg TZ=${TZ}
