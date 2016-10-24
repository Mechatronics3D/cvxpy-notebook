FROM jupyter/datascience-notebook
MAINTAINER Behzad Samadi <behzad@mechatronics3d.com>

# Folders
ENV WS=$HOME/work
ENV ST=$HOME/.ipython/default_profile/startup

# Packages
ENV PKGS="wget unzip gcc g++ gfortran git cmake liblapack-dev pkg-config swig spyder time"
ENV PIP2="vpython CVXcanon cvxpy"
ENV PIP3="vpython CVXcanon"

USER root

# Install required packages
RUN apt-get update && \
    apt-get install -y --install-recommends $PKGS

RUN pip3 install --upgrade pip
RUN pip3 install $PIP3

# Create cvxpy and cvxflow folders
RUN cd $WS && mkdir cvxpy && mkdir cvxflow

# Clone cvxpy short course
RUN git clone https://github.com/cvxgrp/cvx_short_course.git $WS/cvxpy

# Install cvxpy 
RUN conda install -c https://conda.anaconda.org/omnia scs
RUN conda install -c cvxgrp cvxpy
RUN conda install nose
RUN source activate python2 && \
    conda install -c cvxgrp cvxpy && \
    conda install nose && \
    pip install --upgrade pip && \
    pip install $PIP2 && \
    source deactivate

# Clone cvxflow
RUN git clone https://github.com/mwytock/cvxflow.git $WS/cvxflow
  
# Giving the ownership of the folders to the NB_USER
RUN chown -R $NB_USER $WS

# Notebook startup script
COPY nb_startup.py $ST
COPY nb_startup.py $WS

USER $NB_USER
