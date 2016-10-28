FROM jupyter/datascience-notebook
MAINTAINER Behzad Samadi <behzad@mechatronics3d.com>

# Folders
ENV WS=$HOME/work
ENV ST=$HOME/.ipython/default_profile/startup
ENV DL=$HOME/Downloads

# Packages
ENV PKGS="wget unzip gcc g++ gfortran git cmake liblapack-dev pkg-config swig spyder time"

USER root

# Update and install required packages
RUN apt-get update && \
    apt-get install -y --install-recommends $PKGS

# Update pip2
RUN pip2 install --upgrade pip

# Update pip3
RUN pip3 install --upgrade pip

# Update conda
RUN conda update conda

# Install cvxpy and nose 
RUN conda install -c cvxgrp cvxpy
RUN conda install nose
RUN conda install -n python2 -c cvxgrp cvxpy
RUN conda install -n python2 nose

# Reinstall numpy
RUN conda remove nomkl
RUN conda install mkl
RUN conda install -f  numpy
RUN conda remove -n python2 nomkl
RUN conda install -n python2 mkl
RUN conda install -n python2 -f  numpy

# Create cvxpy and cvxflow folders
RUN cd $WS && mkdir cvxpy && mkdir cvxflow

# Clone cvxpy short course
RUN git clone https://github.com/cvxgrp/cvx_short_course.git $WS/cvxpy

# Clone cvxflow
RUN git clone https://github.com/mwytock/cvxflow.git $WS/cvxflow

# Giving the ownership of the folders to the NB_USER
RUN chown -R $NB_USER $WS

USER $NB_USER
