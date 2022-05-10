#!/bin/bash

#######################################
# Bash script to start the node, which will mean
# the node will be online and ready for communication with the server.
# Written by Frank, Anja and Bart from IKNL
#######################################

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOG_DIR="${SCRIPT_DIR}/log"
LAST_START="${LOG_DIR}/last_restart.v6"

## activate the vantage6 venv ##
# conda is not available by default in subshells
source ~/miniconda/etc/profile.d/conda.sh
conda activate vantage6

## starting the node ##
echo "Starting node..."
vnode start --config starter_head_and_neck.yaml

vnode list

echo "> Saving last start time"
date +"%Y-%m-%d %T" > $LAST_START