#!/bin/bash

#######################################
# Bash script to stop the node, which will mean
# the node will be offline and cannot be reached for communication with the server.
# Written by Frank and Anja from IKNL
#######################################

## activate the vantage6 venv ##
# conda is not available by default in subshells
source ~/miniconda/etc/profile.d/conda.sh
conda activate vantage6

## stopping the node ##
echo "Stopping node..."
vnode stop --name starter_head_and_neck

vnode list