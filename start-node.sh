#!/bin/bash

#######################################
# Bash script to start the node, which will mean
# the node will be online and ready for communication with the server.
# Written by Frank and Anja from IKNL
#######################################

## activate the vantage6 venv ##
# conda is not available by default in subshells
source ~/miniconda/etc/profile.d/conda.sh
conda activate vantage6

## starting the node ##
vnode start --config starter_head_and_neck.yaml

vnode list