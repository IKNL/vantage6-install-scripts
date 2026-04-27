#!/bin/bash

#####################################################################
# Script to clean docker images used by vantage6. 
# usage: 
#   DRY_RUN=0 ./clean-docker-images.sh
#####################################################################

# Fail when an error occors
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Keep the node image 
KEEP="harbor2.vantage6.ai/infrastructure/node:harukas"
REGISTRY_PREFIX="harbor2.vantage6.ai/"

# Log which images have been deleted
LOG_FILE="$SCRIPT_DIR/deleted-images.log"
DRY_RUN="${DRY_RUN:-0}"   # set DRY_RUN=1 to not delete
KEEP_ID_RAW=""
KEEP_ID=""
if KEEP_ID_RAW="$(docker image inspect --format '{{.Id}}' "$KEEP" 2>/dev/null)"; then
  KEEP_ID="${KEEP_ID_RAW#sha256:}"
fi

: > "$LOG_FILE"
echo "Keeping: $KEEP sha=$KEEP_ID_RAW dry_run=$DRY_RUN" | tee -a "$LOG_FILE"
echo "Registry prefix: $REGISTRY_PREFIX" | tee -a "$LOG_FILE"

image_refs_for_id() {
  local image_id="$1"

  docker image ls --no-trunc --format '{{.ID}} {{.Repository}}:{{.Tag}}' \
    | awk -v id="$image_id" '$1==id {print $2}' \
    | paste -sd ',' -
}

image_refs_for_id_with_prefix() {
  local image_id="$1"
  local prefix="$2"

  docker image ls --no-trunc --format '{{.ID}} {{.Repository}}:{{.Tag}}' \
    | awk -v id="$image_id" -v pfx="$prefix" '$1==id && index($2, pfx) == 1 {print $2}' \
    | paste -sd ',' -
}

# Remove docker files
echo "Scanning local image IDs..." | tee -a "$LOG_FILE"
docker image ls --no-trunc --format '{{.ID}}' | sort -u | while read -r id; do
  refs_all="$(image_refs_for_id "$id")"
  if [[ "$refs_all" == *"$KEEP"* ]]; then
    echo "Keeping: sha=$id refs=$refs_all" | tee -a "$LOG_FILE"
    continue
  fi

  if [[ -n "${KEEP_ID:-}" && "$id" == "$KEEP_ID" ]]; then
    echo "Keeping: sha=$id (matched keep image id)" | tee -a "$LOG_FILE"
    continue
  fi

  refs_matching_prefix="$(image_refs_for_id_with_prefix "$id" "$REGISTRY_PREFIX")"
  if [[ -z "${refs_matching_prefix:-}" ]]; then
    if [[ -n "${refs_all:-}" ]]; then
      echo "Skipping: sha=$id refs=$refs_all" | tee -a "$LOG_FILE"
    fi
    continue
  fi

  echo "Deleting: sha=$id refs=$refs_matching_prefix" | tee -a "$LOG_FILE"

  if [[ "$DRY_RUN" == "0" ]]; then
    docker rmi -f "$id" >/dev/null || true
  fi
done

# Print all images to the logs
echo "" | tee -a "$LOG_FILE"
echo "## Image still on the system:" | tee -a "$LOG_FILE"
docker image ls --no-trunc --format '{{.Repository}}:{{.Tag}} {{.ID}}' | tee -a "$LOG_FILE"

