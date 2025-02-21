#!/bin/bash

#######################################
# Bash script to setup a new system (Ubuntu 22.04) for vantage6.
# Key components: apt-get, miniconda, virtual environment, docker, vantage6.
# Run with 'sudo -E bash vantage6.sh'
# Written by Frank, Anja and Bart from IKNL
#######################################

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

has_conda_env(){
    conda env list | awk '{print $1}' | grep "${@}" >/dev/null 2>/dev/null
}

VENV=vantage6
VANTAGE6_VERSION=2.3.4
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOGNAME="$(logname)"
REPORT=vantage6-installation-report.txt
touch $REPORT

## Update packages and Upgrade system
echo "" | tee -a $REPORT
echo '(1/6) ### Update/upgrade system' | tee -a $REPORT
echo "" | tee -a $REPORT
apt-get update -y 2>&1 | tee -a $REPORT
apt-get upgrade -y 2>&1 | tee -a $REPORT
apt-get install systemd -y 2>&1 | tee -a $REPORT

echo "" | tee -a $REPORT
if ! command_exists conda; then
    echo '(2/6) ### Installing miniconda' | tee -a $REPORT
    # installer script downloaded from:
    # curl -fsSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o ~/miniconda.sh
    # add execution permissions
    chmod +x $SCRIPT_DIR/get-miniconda.sh
    # install miniconda
    bash $SCRIPT_DIR/get-miniconda.sh -b -p $HOME/miniconda 2>&1 | tee -a $REPORT
else
    echo "(2/6) ### Skipping Miniconda installation (already installed)" | tee -a $REPORT
fi
echo "" | tee -a $REPORT

# activate conda in this shell
echo "Initializing conda..." | tee -a $REPORT
eval "$($HOME/miniconda/bin/conda shell.bash hook)"
# initialize conda
conda init 2>&1 | tee -a $REPORT
echo "" | tee -a $REPORT

if ! has_conda_env ".*$VENV.*"; then
    echo '(3/6) ### Creating a virtual environment' | tee -a $REPORT
    # create python virtual environment with python 3.7!
    conda create -n $VENV python=3.7 -y 2>&1 | tee -a $REPORT
else
    echo "(3/6) ### Using existing virtual environment $VENV" | tee -a $REPORT
fi
# activate environment
conda activate $VENV

## vantage6 ##
echo "(4/6) ### Installing vantage6 ${VANTAGE6_VERSION}.." | tee -a $REPORT
pip install vantage6==$VANTAGE6_VERSION 2>&1 | tee -a $REPORT

## Docker ##
if ! command_exists docker; then
    echo '(5/6) ### Installing Docker..' | tee -a $REPORT
    # installer script downloaded from: https://get.docker.com/
    chmod +x $SCRIPT_DIR/get-docker.sh
    $SCRIPT_DIR/get-docker.sh 2>&1 | tee -a $REPORT
else
    echo "Docker is already installed!" | tee -a $REPORT
fi

# Manage Docker as a non-root user
echo '(6/6) ### Manage Docker as a non-root user..' | tee -a $REPORT
# Create the docker group
if [ ! $(getent group docker) ]; then
    echo "Group docker added" | tee -a $REPORT
    groupadd docker 2>&1 | tee -a $REPORT
fi

# Add your user and root to the docker group, unless they are already in it
# This is done by first showing the groups user/logname belongs to, then check
# silently (-q) if whole word is present in those groups
if ! id -nG $USER | grep -qw docker; then
    echo "Adding user to docker group" | tee -a $REPORT
    usermod -aG docker $USER 2>&1 | tee -a $REPORT
fi
if ! id -nG $LOGNAME | grep -qw docker; then
    echo "Adding log to docker group" | tee -a $REPORT
    usermod -aG docker $LOGNAME 2>&1 | tee -a $REPORT
fi

#STOP & START evry night
mkdir -p $HOME/v6-restart-log
chown -R $SUDO_USER: $HOME/v6-restart-log
echo "" >> /etc/crontab
echo "" >> /etc/crontab
echo "0 1 * * * $SUDO_USER bash $HOME/vantage6-install-scripts/stop-node.sh && echo \"\$(date '+\%Y-\%m-\%d \%H:\%M:\%S') - V6 Node stopped\" >> $HOME/v6-restart-log/vantage_node_restart.log" >> /etc/crontab
echo "5 1 * * * $SUDO_USER bash $HOME/vantage6-install-scripts/start-node.sh && echo \"\$(date '+\%Y-\%m-\%d \%H:\%M:\%S') - V6 Node started\" >> $HOME/v6-restart-log/vantage_node_restart.log" >> /etc/crontab
service cron restart
cat /etc/crontab | tee -a $REPORT

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
