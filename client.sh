#!/bin/bash

if [ $# -lt 3 ]; then
    echo "Error: parameters problem"
    exit 1
fi

CLIENT_ID=$1
OPTION=$2
ARGS_ARRAY=${@:3}
ARGS_STRING=""

for value in ${ARGS_ARRAY[@]}
do
    ARGS_STRING="$ARGS_STRING$value "
done

case "$OPTION" in
    init)
        echo "$CLIENT_ID $OPTION $ARGS_STRING"
        ;;
    insert)
        if [ $# -ne 4 ]; then
            echo "Error, parameters problem"
            exit 1
        fi
        read -p "Please write login: " login
        read -p "Please write password: " password
        echo "$CLIENT_ID $OPTION $ARGS_STRING $login\n$password"
        ;;
    show)
        echo "$CLIENT_ID $OPTION $ARGS_STRING"
        ;;
    edit)
        echo "$CLIENT_ID $OPTION $ARGS_STRING"
        FILE_TEMP=`mktemp`
        echo "login" > $FILE_TEMP
        vim $FILE_TEMP
        cat $FILE_TEMP
        ;;
    rm)
        echo "$CLIENT_ID $OPTION $ARGS_STRING"
        ;;
    shutdown)
        echo "$CLIENT_ID $OPTION $ARGS_STRING"
        ;;
    *)
        echo "Error, bad request"
        exit 1
esac
