#!/bin/bash

#######################################
# Bash script to install apps on a new system (Ubuntu)
# Run with 'bash install-apps.sh'
# Written by Frank and Anja from IKNL
#######################################

VENV=vantage6
VANTAGE6_VERSION=2.1.0


## Update packages and Upgrade system
echo '###Update/upgrade system'
apt-get update -y
apt-get upgrade -y
apt-get install curl -y
apt-get install wget -y
apt-get install systemd -y


echo '###Installing miniconda'
# download installer script
curl -fsSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o ~/miniconda.sh
# add execution permissions
chmod +x ~/miniconda.sh
# install miniconda
bash ~/miniconda.sh -b -p $HOME/miniconda
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
curl -fsSL https://get.docker.com -o ~/get-docker.sh
#sudo DRY_RUN=1 sh get-docker.sh
chmod +x ~/get-docker.sh
sh ~/get-docker.sh

#check that docker is running
if [ "$(systemctl is-active docker)" = "active" ]
then echo '[OK] docker is running'
else echo '[ERR] docker is not  running...'
fi

# Manage Docker as a non-root user
echo '##Manage Docker as a non-root user..'
# Create the docker group
getent group docker|| groupadd docker
# Add your user to the docker group
usermod -aG docker $USER
# Activate the changes to groups
newgrp docker

# Verify that you can run docker commands without sudo
echo '##Run hello-world (without sudo)..'
docker run hello-world
