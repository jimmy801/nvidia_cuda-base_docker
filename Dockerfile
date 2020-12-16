# you can use `--build-arg CUDA=<cuda_version>` to specify pyton version
# use `--build-arg CUDA=10.0-cudnn7-runtime-ubuntu18.04` to set cuda10 w/ cudnn7 as docker cuda
# you can find cuda versions on: https://hub.docker.com/r/nvidia/cuda/tags
# NOTE: default `CUDA` is `10.0-cudnn7-runtime-ubuntu18.04`

# you can use `--build-arg PYTHON_VERSION=<version_num>` to specify pyton version
# use `--build-arg PYTHON_VERSION=3.5` to set python3.5 as docker default python version
# NOTE: default `PYTHON_VERSION` is `3`

# you can use `--build-arg TZ=<timezone>` to specify timezone
# use `--build-arg TZ=Asia/Taipei` to set Asia/Taipei as docker default timezone
# you can find timezones on: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
# NOTE: default `TZ` is `Asia/Taipei`

# NOTE: all arg set need to add prefix `--build-arg`
#       that is to say, if you want to specify cuda version, python version, and timezone
#       you have to write 
#       `--build-arg CUDA=<cuda_version> --build-arg PYTHON_VERSION=<version_num> --build-arg TZ=<timezone>`
#       to do this

ARG CUDA=10.0-cudnn7-runtime-ubuntu18.04
FROM nvidia/cuda:$CUDA
ARG PYTHON_VERSION=3
ARG TZ=Asia/Taipei

WORKDIR home

# set timezone
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install packages
RUN apt-get update && \
    apt-get install -y \
        cmake \
        wget \
        curl \
        git \
        vim \
        software-properties-common \
        libgl1-mesa-glx libsm6 libxrender1 libxext-dev

# register python dependency(ppa)
# NOTE: Register ppa may take more time
# More info: https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa
# Note: Python2.7 (all), 
#       Python 3.5 (16.04, xenial), Python 3.6 (18.04, bionic), Python 3.8 (20.04, focal) 
#       are not provided by deadsnakes as upstream ubuntu provides those packages
#       (it means they don't need to register ppa)
RUN ubuntu=$(lsb_release -r | grep "Release:") && ubuntu=${ubuntu##*:} && \
    if [ "$PYTHON_VERSION" != "2.7" ] && [ "$PYTHON_VERSION" != "3" ] && \
       [ \( ${ubuntu} = "16.04" -a "$PYTHON_VERSION" != "3.5" \) -o \
       \( ${ubuntu} = "18.04" -a "$PYTHON_VERSION" != "3.6" \) -o \
       \( ${ubuntu} = "20.04" -a "$PYTHON_VERSION" != "3.8" \) ]; then \
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
RUN if [ $PYTHON_VERSION \> 3 ]; then \
        apt-get install -y python3-distutils-extra && \
        ln -sf /usr/bin/python$PYTHON_VERSION /usr/bin/python3; \
    fi && \
    curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py


# uncomment it to not use default color prompt,
# replace PS1 2nd occurence line (PS1 color setting line)
# RUN sed -i '0,/PS1.*/! {0,/PS1.*/ s/PS1.*/'"\    PS1=\'\$\{debian_chroot:\+\(\$debian_chroot\)\}\\\[\\\033\[01;32m\\\]\\\u\\\[\\\033\[00;37m\\\]@\\\[\\\033\[01;35m\\\]\\\h\\\[\\\033\[00m\\\]:\\\[\\\033\[01;34m\\\]\\\w\\\[\\\033\[00m\\\]# \'"'/}' ~/.bashrc

# set ~/.bashrc
RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' ~/.bashrc && \
    # above enable color prompt of docker in terminal
    # set alias
    echo "alias nv='nvidia-smi'" >> ~/.bash_aliases && \
    echo "alias wnv='watch -n 1 nvidia-smi'" >> ~/.bash_aliases && \
    echo "alias wwnv='watch -n 0.1 nvidia-smi'" >> ~/.bash_aliases
