#!/bin/bash

#####################################################################
# Script to update the allowed images on this node to the new 
# repository.
# usage: 
#   ./update-allowed-images-gaurd.sh
#####################################################################

CONFIG_FILE="$HOME/.config/vantage6/node/starter_head_and_neck.yaml"

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Config file not found: $CONFIG_FILE" >&2
  exit 1
fi

# Update the allowed images to ^docker\.io/s102099/*
sed -i \
  -e 's@\^harbor2\\\.vantage6\\\.ai/starter/[*]@^docker\\\.io/s102099/*@' \
  -e 's@\^harbor2\.vantage6\.ai/starter/[*]@^docker\\\.io/s102099/*@' \
  "$CONFIG_FILE"