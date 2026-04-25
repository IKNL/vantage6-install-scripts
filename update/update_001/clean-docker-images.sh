#!/bin/bash

#####################################################################
# Script to clean docker images used by vantage6. 
# usage: 
#   DRY_RUN=0 ./clean-docker-images.sh
#####################################################################

# Fail when an error occors
set -euo pipefail

# Keep the node image 
KEEP="harbor2.vantage6.ai/infrastructure/node:harukas"

# Log which images have been deleted
LOG_FILE="deleted-images.log"
DRY_RUN="${DRY_RUN:-0}"   # set DRY_RUN=1 to not delete
KEEP_ID="$(docker image inspect --format '{{.Id}}' "$KEEP")"

: > "$LOG_FILE"
echo "Keeping: $KEEP sha=$KEEP_ID dry_run=$DRY_RUN" | tee -a "$LOG_FILE"

image_refs_for_id() {
  local image_id="$1"

  docker image ls --no-trunc --format '{{.Repository}}:{{.Tag}} {{.ID}}' \
    | awk -v id="$image_id" '$2==id {print $1}' \
    | paste -sd ',' -
}

# Remove docker files
docker image ls -aq | sort -u | while read -r id; do
  if [[ "$id" == "$KEEP_ID" ]]; then
    continue
  fi

  refs="$(image_refs_for_id "$id")"
  if [[ -z "${refs:-}" ]]; then
    refs="<none>"
  fi

  echo "Deleting: sha=$id refs=$refs" | tee -a "$LOG_FILE"

  if [[ "$DRY_RUN" == "0" ]]; then
    docker rmi -f "$id" >/dev/null || true
  fi
done

# Print all images to the logs
echo "" | tee -a "$LOG_FILE"
echo "## Image still on the system:" | tee -a "$LOG_FILE"
docker image ls --no-trunc --format '{{.Repository}}:{{.Tag}} {{.ID}}' | tee -a "$LOG_FILE"

