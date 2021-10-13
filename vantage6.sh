#!/bin/bash

#######################################
# Bash script to setup a new system (Ubuntu 18.04) for vantage6.
# Key components: apt-get, miniconda, virtual environment, docker, vantage6.
# Run with 'sudo -E bash vantage6.sh'
# Written by Frank and Anja from IKNL
#######################################

VENV=vantage6
VANTAGE6_VERSION=2.1.1
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOGNAME="$(logname)"
REPORT=vantage6-installation-report.txt
touch $REPORT

## Update packages and Upgrade system
echo '(1/6) ###Update/upgrade system'
echo '###Update/upgrade system' >> $REPORT
apt-get update -y >> $REPORT
apt-get upgrade -y >> $REPORT
apt-get install systemd -y >> $REPORT

echo '(2/6) ###Installing miniconda'
echo '###Installing miniconda' >> $REPORT
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

echo '(3/6) ###Creating a virtual environment'
echo '###Creating a virtual environment' >> $REPORT
# create python virtual environment with python 3.7!
conda create -n $VENV python=3.7 -y >> $REPORT
# activate environment
conda activate $VENV


## vantage6 ## >> $REPORT
echo '(4/6) ###Installing vantage6 $VANTAGE6_VERSION ..'
echo '###Installing vantage6 $VANTAGE6_VERSION ..' >> $REPORT
pip install vantage6==$VANTAGE6_VERSION >> $REPORT


## Docker ## >> $REPORT
echo '(5/6) ###Installing Docker..'
echo '###Installing Docker..' >> $REPORT
# installer script downloaded from: https://get.docker.com/
chmod +x $SCRIPT_DIR/get-docker.sh
$SCRIPT_DIR/get-docker.sh >> $REPORT
# Manage Docker as a non-root user
echo '(6/6) ###Manage Docker as a non-root user..'
echo '###Manage Docker as a non-root user..' >> $REPORT
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
