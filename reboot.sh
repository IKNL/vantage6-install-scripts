#!/bin/bash

id=$1
# *Before* doing the job, add the reboot job to the performed jobs
source "${SCRIPT_DIR}/utils.sh"
add_action "reboot.sh" 0 $id

## Reboot ##
echo '### Rebooting system in 10 seconds to finalize changes...'
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