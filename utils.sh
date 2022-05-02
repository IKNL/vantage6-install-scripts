command_exists() {
	command -v "$@" > /dev/null 2>&1
}

has_conda_env(){
    conda env list | grep "${@}" >/dev/null 2>/dev/null
}