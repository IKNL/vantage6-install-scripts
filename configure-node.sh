SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OUTPUT_DIR="$HOME/.config/vantage6/node"
DATA_FILE="$HOME/empty-data.csv"

echo "> Creating directory to store configuration"
mkdir -p $OUTPUT_DIR

echo "> Creating empty data file"
touch $DATA_FILE

echo "> Please enter your API KEY:"
read API_KEY

echo "> Parsing & saving configuration file"
export API_KEY=$API_KEY
export DATA_FILE=$DATA_FILE
envsubst < $SCRIPT_DIR/config.tpl > $OUTPUT_DIR/starter_head_and_neck.yaml 
