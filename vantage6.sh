#!/bin/bash

#######################################
# Bash script to install apps on a new system (Ubuntu)
# Run with 'bash vantage6.sh'
# Written by Frank and Anja from IKNL
#######################################

VENV=vantage6
VANTAGE6_VERSION=2.1.0
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOGNAME="$(logname)"
REPORT=installation-report.txt
touch $REPORT

## Update packages and Upgrade system
echo '###Update/upgrade system'
apt-get update -y >> $REPORT
apt-get upgrade -y >> $REPORT
apt-get install systemd -y >> $REPORT


echo '###Installing miniconda'
# installer script downloaded from:
# curl -fsSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o ~/miniconda.sh
# add execution permissions
chmod +x $SCRIPT_DIR/get-miniconda.sh
# install miniconda
bash $SCRIPT_DIR/get-miniconda.sh -b -p $HOME/miniconda >> $REPORT
# activate conda in this shell
eval "$($HOME/miniconda/bin/conda shell.bash hook)"
# initialize conda
conda init >> $REPORT


echo '###Configuring conda'
# create python virtual environment with python 3.7!
conda create -n $VENV python=3.7 -y >> $REPORT
# activate environment
conda activate $VENV


## vantage6 ##
echo '###Installing vantage6 $VANTAGE6_VERSION ..'
pip install vantage6==$VANTAGE6_VERSION >> $REPORT


## Docker ##
echo '###Installing Docker..'
# installer script downloaded from: https://get.docker.com/
chmod +x $SCRIPT_DIR/get-docker.sh
$SCRIPT_DIR/get-docker.sh >> $REPORT
# Manage Docker as a non-root user
echo '##Manage Docker as a non-root user..'
# Create the docker group
groupadd docker
# Add your user and root to the docker group
usermod -aG docker $USER
usermod -aG docker $LOGNAME

## Reboot ##
echo '###Rebooting system in 10 seconds.'
for i in {10..1..1}
    do
        echo -en "\rRebooting in $i seconds .. "
        if [ $i -eq 1 ]
        then
            echo -en "\rRebooting in $i second ..   "
        fi
        sleep 1
    done
echo -en "\rBye bye.                       "
reboot
