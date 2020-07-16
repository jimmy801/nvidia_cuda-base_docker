# you can use `--build-arg CUDA=<cuda_version>` to specify pyton version
# use `--build-arg CUDA=10.0-cudnn7-runtime-ubuntu18.04` to set cuda10 w/ cudnn7 as docker cuda
# you can find cuda versions on: https://hub.docker.com/r/nvidia/cuda/tags
# NOTE: default `CUDA` is `10.0-cudnn7-runtime-ubuntu18.04`

# you can use `--build-arg PYTHON_VERSION=<version_num>` to specify pyton version
# use `--build-arg PYTHON_VERSION=3.5` to set python3.5 as docker default python version
# NOTE: default `PYTHON_VERSION` is `3`

# NOTE: all arg set need to add prefix `--build-arg`
#       that is to say, if you want to specify both python version and cuda version,
#       you have to write `--build-arg PYTHON_VERSION=<version_num> --build-arg CUDA=<cuda_version>`
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


# python2.7 and python3(python3.6) don't need to register dependency(ppa)
# NOTE: register ppa may take more time
RUN if [ "$PYTHON_VERSION" != "2.7" ] && [ "$PYTHON_VERSION" != "3" ] && [ "$PYTHON_VERSION" != "3.6" ]; then \
		add-apt-repository ppa:deadsnakes/ppa; \
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
