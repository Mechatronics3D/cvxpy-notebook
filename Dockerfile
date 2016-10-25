FROM jupyter/datascience-notebook
MAINTAINER Behzad Samadi <behzad@mechatronics3d.com>

# Folders
ENV WS=$HOME/work
ENV ST=$HOME/.ipython/default_profile/startup
ENV MKL_PATH=/opt/intel

# Install MKL dependency packages
RUN apt-get update && \
  apt-get install -y man

# Install MKL
RUN cd /tmp && \
  wget -q http://registrationcenter-download.intel.com/akdlm/irc_nas/8374/l_mkl_11.3.1.150.tgz && \
  tar -xzf l_mkl_11.3.1.150.tgz && cd l_mkl_11.3.1.150 && \
  sed -i 's/ACCEPT_EULA=decline/ACCEPT_EULA=accept/g' silent.cfg && \
  sed -i 's/ACTIVATION_TYPE=exist_lic/ACTIVATION_TYPE=trial_lic/g' silent.cfg && \
  ./install.sh -s silent.cfg && \
  cd .. && rm -rf * # Clean up

# Configure dynamic link
RUN echo "${MKL_PATH}/mkl/lib/intel64" >> /etc/ld.so.conf.d/intel.conf && ldconfig && \
  echo ". /opt/intel/bin/compilervars.sh intel64" >> /etc/bash.bashrc
  
# Packages
ENV PKGS="wget unzip gcc g++ gfortran git cmake liblapack-dev pkg-config swig spyder time"
ENV PIP="vpython CVXcanon"

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

# Install cvxpy, scs and nose 
RUN git clone https://github.com/cvxgrp/scs.git $DL/scs && \
    cd $DL/scs/python && \
    python3 setup.py install
RUN conda install -c cvxgrp cvxpy
RUN conda install nose
# RUN source activate python2 && \
#    cd $DL/scs/python && \
#    python2 setup.py install
#    source deactivate
RUN conda install -n python2 -c cvxgrp cvxpy
RUN conda install -n python2 nose

# Clone cvxflow
RUN git clone https://github.com/mwytock/cvxflow.git $WS/cvxflow
  
# Giving the ownership of the folders to the NB_USER
RUN chown -R $NB_USER $WS

USER $NB_USER
