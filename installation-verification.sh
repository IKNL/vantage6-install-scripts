#!/bin/bash

#######################################
# Bash script to verify that the installation script was successful.
# Run with 'bash installation-verification.sh'
# Written by Frank and Anja from IKNL
#######################################

REPORT=installation-verification-report.txt
touch $REPORT

## Installed packages ##
echo '## Check installed packages ##' >> $REPORT
# conda is not available by default in subshells
source ~/miniconda/etc/profile.d/conda.sh
conda activate vantage6
pip list >> $REPORT
docker info >> $REPORT

## Conda ##
echo '## Check that conda is functional ##' >> $REPORT
conda list >> $REPORT

## vantage6 ##
echo '## Check that vantage6 is functional ##' >> $REPORT
vnode list >> $REPORT
vnode files --name starter_head_and_neck --environment application >> $REPORT

## Docker ##
echo '## Check that docker is running ##' >> $REPORT
if [ "$(systemctl is-active docker)" = "active" ]
then echo '[OK] docker is running' >> $REPORT
else echo '[ERR] docker is not  running...' >> $REPORT
fi

echo '## Run docker hello-world (without sudo) ##' >> $REPORT
docker run hello-world >> $REPORT
