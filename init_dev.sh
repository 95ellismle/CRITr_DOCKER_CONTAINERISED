# Change debug to True
cd critr/critr
FILE_TO_CHANGE="settings.py"
DEBUG_STR=$(grep "DEBUG" $FILE_TO_CHANGE)
if ! [ -z "$DEBUG_STR" ]; then
    sed -i "s/$DEBUG_STR/DEBUG = True/" $FILE_TO_CHANGE
else
    echo "ERROR: No DEBUG setting found in settings.py"
    exit 1;
fi

# Change ports to 8000:80
cd -
FILE_TO_CHANGE="docker-compose.yml"
PORT_STR=$(grep " 80:80" $FILE_TO_CHANGE)
if ! [ -z "$PORT_STR" ]; then
    sed -i "s/$PORT_STR/      - 8000:80/" $FILE_TO_CHANGE
fi

