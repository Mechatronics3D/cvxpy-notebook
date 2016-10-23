FROM jupyter/datascience-notebook
MAINTAINER Behzad Samadi <behzad@mechatronics3d.com>

# Folders
ENV DL=$HOME/Downloads
ENV WS=$HOME/work
ENV ST=$HOME/.ipython/default_profile/startup

# Packages
ENV PKGS="wget unzip gcc g++ gfortran git cmake liblapack-dev pkg-config swig spyder time"
ENV Py2_PKGS="python-pip python-numpy python-scipy python-matplotlib"
ENV Py3_PKGS="python3-pip python3-numpy python3-scipy python3-matplotlib"
ENV PIP2="vpython CVXcanon cvxpy"
ENV PIP3="vpython CVXcanon"

USER root

# Install required packages
RUN apt-get update && \
    apt-get install -y --install-recommends $PKGS && \
    apt-get install -y --install-recommends $Py2_PKGS && \
    apt-get install -y --install-recommends $Py3_PKGS

RUN pip install --upgrade pip
RUN pip install $PIP2
RUN pip3 install --upgrade pip
RUN pip3 install $PIP3

# Create cvxpy and cvxflow folders
RUN cd $WS && mkdir cvxpy && mkdir cvxflow

# Clone cvxpy
RUN git clone https://github.com/cvxgrp/cvx_short_course.git $WS/cvxpy

# Install cvxpy 
RUN conda install -c cvxgrp cvxpy
RUN conda install nose

# Clone cvxflow
RUN git clone https://github.com/mwytock/cvxflow.git $WS/cvxflow
  
# Giving the ownership of the folders to the NB_USER
RUN chown -R $NB_USER $DL
RUN chown -R $NB_USER $WS

# Notebook startup script
COPY nb_startup.py $ST
COPY nb_startup.py $WS

USER $NB_USER
