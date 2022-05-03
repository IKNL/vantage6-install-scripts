ACTIONS_LOG="${LOG_DIR}/actions_performed.v6"


command_exists() {
	command -v "$@" > /dev/null 2>&1
}

has_conda_env(){
    conda env list | grep "${@}" >/dev/null 2>/dev/null
}

add_action(){
    command=$1
    status=$2
    id=$3
    if [ $status -eq 0 ]; then
        datetime=`date +"%Y-%m-%d %T"`
        echo "${id}:${command} ${datetime}" >> $ACTIONS_LOG
    else
        echo "ERROR: Command \"${command}\" failed!"
    fi
}