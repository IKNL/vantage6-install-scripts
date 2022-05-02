#!/bin/bash

#######################################
# Bash script to run updates for vantage6.
# Ensure this script is in your root crontab # TODO instructions for that
# Written by Frank, Anja and Bart from IKNL
#######################################

# define constants
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ACTIONS_JSON="${SCRIPT_DIR}/actions.json"

LOG_DIR="${SCRIPT_DIR}/log"
ACTIONS_LOG="${LOG_DIR}/actions_performed.v6"
LAST_RESTART="${LOG_DIR}/last_restart.v6"
NODE_ID_FILE="${LOG_DIR}/node_id.v6"
REPORT="${LOG_DIR}/vantage6-update-report.txt"

# 'import' functions from other scripts
source "${SCRIPT_DIR}/utils.sh"

# create logging directory and ensure files exist
cd $SCRIPT_DIR
mkdir -p $LOG_DIR
touch $ACTIONS_LOG
touch $REPORT
touch $LAST_RESTART
touch $NODE_ID_FILE

# Pull git and check if there are differences in actions.json before and after
git checkout main 2>&1 | tee -a $REPORT
old_id=$(git rev-parse HEAD:actions.json)
git pull origin main 2>&1 | tee -a $REPORT
new_id=$(git rev-parse HEAD:actions.json)
if [ "$old_id" = "$new_id" ]; then
    echo "No new actions required. Exiting..." | tee -a $REPORT
    exit 0
fi

# install json reading tool if not installed yet
if ! command_exists jq; then
    echo '### Update/upgrade system' | tee -a $REPORT
    apt-get update -y 2>&1 | tee -a $REPORT
    apt-get upgrade -y 2>&1 | tee -a $REPORT
    apt-get install jq -y 2>&1 | tee -a $REPORT
fi

# Read json file
json_data=`cat "$ACTIONS_JSON" | jq '.'`

# Execute actions
echo "Extracting actions to perform..." | tee -a $REPORT
actions=`echo "$json_data" | jq '.actions'`
for action in `echo "$actions" | jq -r '.[] | @base64'`; do
    # notes:
    # encoding/decoding base64 is to prevent issues with spaces in the variables
    # sed is used to delete double quotes around script names
    descr=`echo "$action" | base64 --decode | jq '.description'`
    command=`echo "$action" | base64 --decode | jq '.command' |
             sed -e 's/^"//' -e 's/"$//'`
    # TODO maybe include a timestamp here? That would make it easier to do
    # certain actions a number of times
    if `grep -q "$command" $ACTIONS_LOG`; then
        echo "Skipping action that has already been executed: ${descr}" | tee -a $REPORT
        continue
    fi

    echo "Executing action: ${descr}" | tee -a $REPORT
    bash "${SCRIPT_DIR}/$command"  #TODO test with arguments to the script

    # Add command to completed actions if it succeeded
    status=$?
    if [ $status -eq 0 ]; then
        echo "$command" >> $ACTIONS_LOG
    else
        echo "ERROR: Command \"$command\" failed!"
    fi
done

# Execute restarts
restarts=`echo "$json_data" | jq '.restart'`
for restart in `echo $restarts | jq -c '.[]'`; do
    for node_id in `echo $restart | jq -c '[]'`; do
        if `grep -q $node_id $NODE_ID_FILE`; then
            timestamp=`echo $restart | jq '.timestamp'`
            last_restart=`head -n 1 $LAST_RESTART`
            # check if node has already restarted since requested restart
            if [ ! -z "$last_restart" ] && [ "$timestamp" \> "$last_restart" ]; then
                echo "Restarting node..." | tee -a $REPORT
                # restart node
                ./restart_node.sh

                # update last_restart
                date +"%Y-%m-%d %T" > $LAST_RESTART
                break
            fi
        fi
    done
done