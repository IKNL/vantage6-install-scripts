#!/bin/bash

#######################################
# Bash script to verify that the installation script (vantage6.sh) was successful.
# Run with 'bash installation-verification.sh'
# Written by Frank, Anja and Bart from IKNL
#######################################

REPORT=vantage6-installation-verification-report.txt
touch $REPORT

## Installed packages ##
echo '## Check installed packages ##' > $REPORT
# conda is not available by default in subshells
source ~/miniconda/etc/profile.d/conda.sh
conda activate vantage6
pip list 2>&1 | tee -a $REPORT
docker info 2>&1 | tee -a $REPORT

## Conda ##
echo '## Check that conda is functional ##' 2>&1 | tee -a $REPORT
conda list 2>&1 | tee -a $REPORT

## vantage6 ##
echo '## Check that vantage6 is functional ##' | tee -a $REPORT
vnode list 2>&1 | tee -a $REPORT
vnode files --name starter_head_and_neck --environment application 2>&1 | tee -a $REPORT

## Docker ##
echo '## Check that docker is running ##' | tee -a $REPORT
if [ "$(systemctl is-active docker)" = "active" ]
then echo '[OK] docker is running' | tee -a $REPORT
else echo '[ERR] docker is not  running...' | tee -a $REPORT
fi

echo '## Run docker hello-world (without sudo) ##' | tee -a $REPORT
docker run hello-world 2>&1 | tee -a $REPORT
