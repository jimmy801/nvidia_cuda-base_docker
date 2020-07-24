# you can use `--build-arg CUDA=<cuda_version>` to specify pyton version
# use `--build-arg CUDA=10.0-cudnn7-runtime-ubuntu18.04` to set cuda10 w/ cudnn7 as docker cuda
# you can find cuda versions on: https://hub.docker.com/r/nvidia/cuda/tags
# NOTE: default `CUDA` is `10.0-cudnn7-runtime-ubuntu18.04`

# you can use `--build-arg PYTHON_VERSION=<version_num>` to specify pyton version
# use `--build-arg PYTHON_VERSION=3.5` to set python3.5 as docker default python version
# NOTE: default `PYTHON_VERSION` is `3`

# NOTE: all arg set need to add prefix `--build-arg`
#       that is to say, if you want to specify both python version and cuda version,
#       you have to write 
#       `--build-arg PYTHON_VERSION=<version_num> --build-arg CUDA=<cuda_version>`
#       to do this

ARG CUDA=10.0-cudnn7-runtime-ubuntu18.04
FROM nvidia/cuda:$CUDA
ARG PYTHON_VERSION=3

WORKDIR home

# install packages
RUN apt-get update && \
    apt-get install -y \
        cmake \
        wget \
        curl \
        git \
        vim \
        software-properties-common


# register python dependency(ppa)
# NOTE: Register ppa may take more time
# More info: https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa
# Note: Python2.7 (all), 
#       Python 3.5 (16.04, xenial), Python 3.6 (18.04, bionic), Python 3.8 (20.04, focal) 
#       are not provided by deadsnakes as upstream ubuntu provides those packages
#       (it means they don't need to register ppa)
RUN if [ "$PYTHON_VERSION" != "2.7" ] && [ "$PYTHON_VERSION" != "3" ] && \
       [ "$CUDA" = *"ubuntu16.04" -a "$PYTHON_VERSION" != "3.5" ] || \
       [ "$CUDA" = *"ubuntu18.04" -a "$PYTHON_VERSION" != "3.6" ] || \
       [ "$CUDA" = *"ubuntu20.04" -a "$PYTHON_VERSION" != "3.8" ]; then \
         add-apt-repository ppa:deadsnakes/ppa && \
         apt-get update; \
    fi

# install specific python version
RUN apt-get install -y \
        python$PYTHON_VERSION \
        python$PYTHON_VERSION-dev && \
    # set default `python` to `python$PYTHON_VERSION`
    ln -sf /usr/bin/python$PYTHON_VERSION /usr/bin/python

# install pip
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py


# set ~/.bashrc
RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' ~/.bashrc && \
    # above enable color prompt of docker in terminal
    # set alias
    echo "alias nv='nvidia-smi'" >> ~/.bashrc && \
    echo "alias wnv='watch -n 1 nvidia-smi'" >> ~/.bashrc && \
    echo "alias wwnv='watch -n 0.1 nvidia-smi'" >> ~/.bashrc
