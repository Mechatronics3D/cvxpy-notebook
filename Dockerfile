FROM jupyter/datascience-notebook
MAINTAINER Behzad Samadi <behzad@mechatronics3d.com>

# Folders
ENV WS=$HOME/work
ENV ST=$HOME/.ipython/default_profile/startup

# Packages
ENV PKGS="wget unzip gcc g++ gfortran git cmake liblapack-dev pkg-config swig spyder time"
ENV PIP="Cython"

USER root

# Install required packages
RUN apt-get update && \
    apt-get install -y --install-recommends $PKGS

RUN pip2 install --upgrade pip
RUN pip2 install $PIP
RUN pip3 install --upgrade pip
RUN pip3 install $PIP
 
# Create cvxpy and cvxflow folders
RUN cd $WS && mkdir cvxpy && mkdir cvxflow

# Clone cvxpy short course
RUN git clone https://github.com/cvxgrp/cvx_short_course.git $WS/cvxpy

# Install cvxpy and nose 
RUN conda install mkl
RUN conda install -c cvxgrp cvxpy
RUN conda install nose
RUN conda install -n python2 mkl
RUN conda install -n python2 -c cvxgrp cvxpy
RUN conda install -n python2 nose

# Clone cvxflow
RUN git clone https://github.com/mwytock/cvxflow.git $WS/cvxflow
  
# Giving the ownership of the folders to the NB_USER
RUN chown -R $NB_USER $WS

USER $NB_USER
