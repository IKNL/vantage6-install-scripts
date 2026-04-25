#!/bin/bash

# Fail when an error occurs
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

CLEAN_SCRIPT="$SCRIPT_DIR/clean-docker-images.sh"
ALLOWED_IMAGES_SCRIPT="$SCRIPT_DIR/update-allowed-images-gaurd.sh"

echo "This update will do the following:"
echo " - Clean docker images used by vantage6 (keeps the node image)"
echo " - Update the node config allowed_images to ^docker\\.io/s102099/*"
echo

read -r -p "Continue? [y/N] " confirm
if [[ "${confirm:-}" != "y" && "${confirm:-}" != "Y" ]]; then
  echo "Aborted."
  exit 0
fi

chmod +x $CLEAN_SCRIPT
chmod +x $ALLOWED_IMAGES_SCRIPT

read -r -p "Dry run (no changes)? [y/N] " dryrun
if [[ "${dryrun:-}" == "y" || "${dryrun:-}" == "Y" ]]; then
  echo
  echo "Dry run selected."
  echo "Running docker cleanup in dry-run mode only (allowed_images update is skipped)."
  echo
  DRY_RUN=1 "$CLEAN_SCRIPT"
  exit 0
fi

DRY_RUN=0 "$CLEAN_SCRIPT"
"$ALLOWED_IMAGES_SCRIPT"

echo "########################################################"
echo " Done! " 
echo " Please send the content of the log file  "
echo " (deleted-images.log) "
echo " to the support team: matteo.gabetta@biomeris.it"
echo "########################################################"
