#!/bin/bash

if [ $# -lt 3 ]; then
    echo "Error: parameters problem"
    exit 1
fi

PIPE_SERVER="server_pipe"
CLIENT_ID=$1
PIPE_CLIENT=$CLIENT_ID"_pipe"
OPTION=$2
ARGS_ARRAY=${@:3}
ARGS_STRING=""

if [ ! -e $PIPE_CLIENT ]; then
    mkfifo $PIPE_CLIENT
fi

for value in ${ARGS_ARRAY[@]}
do
    ARGS_STRING="$ARGS_STRING$value "
done

case "$OPTION" in
    init)
        echo "$CLIENT_ID $OPTION $ARGS_STRING" > $PIPE_SERVER
        ;;
    insert)
        if [ $# -ne 4 ]; then
            echo "Error, parameters problem"
            exit 1
        fi
        read -p "Please write login: " login
        read -p "Please write password: " password
        #echo "$CLIENT_ID $OPTION $ARGS_STRING $login\\n$password" > $PIPE_SERVER
        val="$CLIENT_ID $OPTION $ARGS_STRING $login"
        val=$val'\n'
        val=$val"$password"
        echo "$val" > $PIPE_SERVER
        ;;
    show)
        echo "$CLIENT_ID $OPTION $ARGS_STRING" > $PIPE_SERVER
        read exit_code < $PIPE_CLIENT
        ;;
    edit)
        echo "$CLIENT_ID show $ARGS_STRING" > $PIPE_SERVER
        read exit_code < $PIPE_CLIENT
        if [ $exit_code -eq 0 ]; then
            FILE_TEMP=`mktemp`
            cat $PIPE_CLIENT > $FILE_TEMP
            vim $FILE_TEMP
            echo "$CLIENT_ID update $ARGS_STRING `cat $FILE_TEMP`" > $PIPE_SERVER
            rm $FILE_TEMP
        fi
        ;;
    rm)
        echo "$CLIENT_ID $OPTION $ARGS_STRING" > $PIPE_SERVER
        ;;
    ls)
        echo "$CLIENT_ID $OPTION $ARGS_STRING" > $PIPE_SERVER
        ;;
    shutdown)
        echo "$CLIENT_ID $OPTION $ARGS_STRING" > $PIPE_SERVER
        ;;
    *)
        echo "$OPTION"
        echo "Error, bad request"
        exit 1
esac
cat $PIPE_CLIENT
rm $PIPE_CLIENT

