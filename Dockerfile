FROM jupyter/datascience-notebook
MAINTAINER Behzad Samadi <behzad@mechatronics3d.com>

# Folders
ENV WS=$HOME/work
ENV ST=$HOME/.ipython/default_profile/startup
ENV DL=$HOME/Downloads

# Packages
ENV PKGS="wget unzip gcc g++ gfortran git cmake liblapack-dev pkg-config swig spyder time"
ENV PIP="cvxcanon"

USER root

# Update and install required packages
RUN apt-get update && \
    apt-get install -y --install-recommends $PKGS

# Update pip2
RUN pip2 install --upgrade pip
RUN pip2 install $PIP

# Update pip3
RUN pip3 install --upgrade pip
RUN pip3 install $PIP

# Update conda
RUN conda update conda

# Create cvxpy and cvxflow folders
RUN cd $WS && mkdir cvxpy && mkdir cvxflow

# Clone cvxpy short course
RUN git clone https://github.com/cvxgrp/cvx_short_course.git $WS/cvxpy

# Install scs
RUN git clone https://github.com/cvxgrp/scs.git $DL/scs && \
    cd $DL/scs/python && \
    python3 setup.py install && \
    $CONDA_DIR/envs/python2/bin/python setup.py install 

# Install cvxpy and nose 
RUN conda install -c cvxgrp cvxpy
RUN conda install nose
RUN conda install -f  numpy
RUN conda install -n python2 -c cvxgrp cvxpy
RUN conda install -n python2 nose
RUN conda install -n python2 -f  numpy

# Clone cvxflow
RUN git clone https://github.com/mwytock/cvxflow.git $WS/cvxflow
  
# Giving the ownership of the folders to the NB_USER
RUN chown -R $NB_USER $WS

USER $NB_USER
