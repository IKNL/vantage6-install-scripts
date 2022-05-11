SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OUTPUT_DIR="$HOME/.config/vantage6/node"
TASK_DIR="$HOME/.local/share/vantage6/node/starter_head_and_neck"
DATA_DIR="$HOME/data"
DATA_FILE="$DATA_DIR/default.csv"

# create data directory and file if they don't exist
mkdir -p $DATA_DIR
if [ ! -f $DATA_FILE ]; then
    echo 'Sex,Age' > $DATA_FILE
    echo 'm,21' >> $DATA_FILE
    echo 'f,19' >> $DATA_FILE
fi

echo "> Creating directory to store configuration and task-data"
mkdir -p $OUTPUT_DIR
mkdir -p $TASK_DIR

echo "> Please enter your API KEY:"
read API_KEY

echo "> Parsing & saving configuration file"
export API_KEY=$API_KEY
export DATA_FILE=$DATA_FILE
export TASK_DIR=$TASK_DIR
envsubst < $SCRIPT_DIR/config.tpl > $OUTPUT_DIR/starter_head_and_neck.yaml
