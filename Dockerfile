#To build this file:
#sudo docker build . -t nbutter/mmcv:ubuntu1604

#To run this, mounting your current host directory in the container directory,
# at /project, and excute the check_installtion script which is in your current
# working direcotry run:
#sudo docker run --gpus all -it -v `pwd`:/project nbutter/mmcv:ubuntu1604 /bin/bash -c "cd /project && python check_installation.py"

#To push to docker hub:
#sudo docker push nbutter/mmcv:ubuntu1604

#To build a singularity container
#sudo singularity build mmcv.img docker://nbutter/mmcv:ubuntu1604

#To run the singularity image (noting singularity mounts the current folder by default)
#singularity run --nv mmcv.img python check_installation.py

# Pull base image.
#FROM nvidia/cuda:10.2-devel-ubuntu16.04
FROM nvidia/cuda:10.2-cudnn8-devel-ubuntu16.04
MAINTAINER Nathaniel Butterworth USYD SIH

#Create some directories to work with on Artmeis
RUN mkdir /project && mkdir /scratch && touch /usr/bin/nvidia-smi

#Install ubuntu libraires and packages
RUN apt-get update -y && \
	apt-get install git curl libgl1 libglib2.0-0 libsm6 libxrender1 libxext6 -y && \
	rm -rf /var/lib/apt/lists/*

#Set some environemnt variables we will need
ENV PATH="/build/miniconda3/bin:${PATH}"
ARG PATH="/build/miniconda3/bin:${PATH}"

WORKDIR /build

#Install Python3.8 we can use
RUN curl -o miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh &&\
	mkdir /build/.conda && \
	bash miniconda.sh -b -p /build/miniconda3 &&\
	rm -rf miniconda.sh

WORKDIR /build

#Install packages
RUN conda install pip==22.2.2 pandas==1.4.2 matplotlib==3.5.1 scikit-image==0.19.2

#Install torch
RUN conda install pytorch==1.11.0 torchvision==0.12.0 torchaudio==0.11.0 cudatoolkit=10.2 -c pytorch

#install mim > mmcv, mmdetection
RUN git clone https://github.com/open-mmlab/mim.git && cd mim && pip install -e .
RUN mim install mmcv-full
RUN mim install mmdet

#Install TF. This requires specific versions of tf, cudnn, and cuda. So link approiately
RUN export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/:/usr/local/cuda-10.2/targets/x86_64-linux/lib/ && \
	ln -s /usr/lib/x86_64-linux-gnu/libcudnn.so /usr/lib/x86_64-linux-gnu/libcudnn.so.7 && \
	ln -s /usr/local/cuda-10.2/targets/x86_64-linux/lib/libcudart.so.10.2 /usr/lib/x86_64-linux-gnu/libcudart.so.10.1
RUN python -m pip install tensorflow==2.3.0

#Run the container
CMD /bin/bash
