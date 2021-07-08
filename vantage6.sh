#!/bin/bash

#######################################
# Bash script to install apps on a new system (Ubuntu)
# Run with 'bash install-apps.sh'
# Written by Frank and Anja from IKNL
#######################################

VENV=vantage6
VANTAGE6_VERSION=2.1.0
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


## Update packages and Upgrade system
echo '###Update/upgrade system'
apt-get update -y
apt-get upgrade -y
apt-get install curl -y
apt-get install wget -y
apt-get install systemd -y


echo '###Installing miniconda'
# download installer script
# curl -fsSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o ~/miniconda.sh
# add execution permissions
chmod +x $SCRIPT_DIR/get-miniconda.sh
# install miniconda
bash $SCRIPT_DIR/get-miniconda.sh -b -p $HOME/miniconda
# activate conda in this shell
eval "$($HOME/miniconda/bin/conda shell.bash hook)"
# initialize conda
conda init


echo '###Configuring conda'
# create python virtual environment with python 3.7!
conda create -n $VENV python=3.7 -y
# activate environment
conda activate $VENV


## vantage6 ##
echo '###Installing vantage6 $VANTAGE6_VERSION ..'
pip install vantage6==$VANTAGE6_VERSION


## Docker ##
echo '###Installing Docker..'
#sudo DRY_RUN=1 sh get-docker.sh
chmod +x $SCRIPT_DIR/get-docker.sh
bash $SCRIPT_DIR/get-docker.sh

# Manage Docker as a non-root user
echo '##Manage Docker as a non-root user..'
# Create the docker group
getent group docker || groupadd docker
# Add your user to the docker group
usermod -aG docker $USER
# Activate the changes to groups
newgrp docker

echo '###Rebooting system now.'
reboot
