SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Enter your API KEY:"
read API_KEY

export API_KEY=$API_KEY
envsubst < $SCRIPT_DIR/config.tpl > my_config.yaml
