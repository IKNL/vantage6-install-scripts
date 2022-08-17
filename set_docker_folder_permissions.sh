#!/bin/bash

#######################################
# Bash script to set permissions for Docker folders required to update node
# files. This file should be run in your root crontab on reboot.
# Written by Frank, Anja and Bart from IKNL
#######################################

chmod 755 /var/lib/docker /var/lib/docker/volumes /var/lib/docker/volumes/vantage6-starter_head_and_neck-user-vol
chmod 777 -R /var/lib/docker/volumes/vantage6-starter_head_and_neck-user-vol/_data