#To build this file:
#sudo docker build . -t nbutter/mmcv:ubuntu1604

#To run this, mounting your current host directory in the container directory,
# at /project, and excute the check_installtion script which is in your current
# working direcotry run:
#sudo docker run --gpus all -v `pwd`:/project nbutter/mmcv /bin/bash -c "cd /project && python check_installation.py"

#To push to docker hub:
#sudo docker push nbutter/mmcv

#To build a singularity container
#sudo singularity build mmcv.img docker://nbutter/mmcv

#To the singularity image (noting singularity mounts the current folder by default)
#singularity run --nv mmcv.img python check_installation.py

# Pull base image.
#FROM nvidia/cuda:10.2-devel-ubuntu16.04
FROM nvidia/cuda:10.2-cudnn8-devel-ubuntu16.04
MAINTAINER Nathaniel Butterworth USYD SIH

#Create some directories to work with on Artmeis
RUN mkdir /project && mkdir /scratch

#Install ubuntu libraires and packages
RUN apt-get update -y && \
	apt-get install git curl libgl1 libglib2.0-0 libsm6 libxrender1 libxext6 -y && \
	rm -rf /var/lib/apt/lists/*

#Set some environemnt variables we will need
ENV PATH="/build/miniconda3/bin:${PATH}"
ARG PATH="/build/miniconda3/bin:${PATH}"
ENV PYTHONPATH $PYTHONPATH:/build/mmdetection/

WORKDIR /build

#Install Python3.8 we can use
RUN curl -o miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh &&\
	mkdir /build/.conda && \
	bash miniconda.sh -b -p /build/miniconda3 &&\
	rm -rf miniconda.sh

WORKDIR /build

#Install packages
RUN conda install pip pandas matplotlib scikit-image
RUN pip install --upgrade pip
RUN conda install pytorch==1.8.0 torchvision==0.9.0 torchaudio==0.8.0 cudatoolkit=10.2 -c pytorch
#RUN pip install torch==1.8.2 torchvision==0.9.2 torchaudio==0.8.2 --extra-index-url https://download.pytorch.org/whl/lts/1.8/cu102
#RUN pip install mmcv-full -f https://download.openmmlab.com/mmcv/dist/1.8.0/10.2/index.html
RUN git clone https://github.com/open-mmlab/mmcv.git && cd mmcv && \
	pip install -r requirements/optional.txt && \
	MMCV_WITH_OPS=1 pip install -e .
RUN git clone https://github.com/open-mmlab/mmdetection.git && \
  cd mmdetection && pip install -v -e .

#Run the container
CMD /bin/bash
