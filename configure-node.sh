SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OUTPUT_DIR="$HOME/.config/vantage6/node"
mkdir -p $OUTPUT_DIR

echo "Enter your API KEY:"
read API_KEY

export API_KEY=$API_KEY
envsubst < $SCRIPT_DIR/config.tpl > $OUTPUT_DIR/starter_head_and_neck.yaml 
