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
ARGS_STRING=${ARGS_STRING/%?/}

case "$OPTION" in
    init)
        echo "$CLIENT_ID $OPTION $ARGS_STRING" > $PIPE_SERVER
        cat $PIPE_CLIENT
        ;;
    insert)
        if [ $# -ne 4 ]; then
            echo "Error, parameters problem"
            exit 1
        fi
        read -p "Please write login: " login
        read -p "Please write password: " password
        user_id=$3
        service_file=$4
        echo "$CLIENT_ID $OPTION $user_id $service_file $login $password" > $PIPE_SERVER
        #val="$CLIENT_ID $OPTION $ARGS_STRING $login"
        #val=$val'\n'
        #val=$val"$password"
        #echo "$val" > $PIPE_SERVER
        cat $PIPE_CLIENT
        ;;
    show)
        if [ $# -ne 4 ]; then
            echo "Error, parameters problem"
            exit 1
        fi
        user_id=$3
        service_file=$4
        echo "$CLIENT_ID $OPTION $ARGS_STRING" > $PIPE_SERVER
        read exit_code < $PIPE_CLIENT
        if [ $exit_code -eq 0 ]; then
            FILE_TEMP=`mktemp`
            cat $PIPE_CLIENT > $FILE_TEMP
            login=`grep "login: " $FILE_TEMP | head -n 1 | sed 's/login: //'`
            password=`grep "password: " $FILE_TEMP | head -n 1 | sed 's/password: //'`
            echo "$user_id's login for $service_file is $login"
            echo "$user_id's password for $service_file is $password"
            rm $FILE_TEMP
        else
            cat $PIPE_CLIENT
        fi
        ;;
    edit)
        if [ $# -ne 4 ]; then
            echo "Error, parameters problem"
            exit 1
        fi
        #echo "Edit Mode: send -> $CLIENT_ID show $ARGS_STRING"
        echo "$CLIENT_ID show $ARGS_STRING" > $PIPE_SERVER
        read exit_code < $PIPE_CLIENT
        if [ $exit_code -eq 0 ]; then
            FILE_TEMP=`mktemp`
            cat $PIPE_CLIENT > $FILE_TEMP
            vim $FILE_TEMP
            login=`grep "login: " $FILE_TEMP | head -n 1 | sed 's/login: //'`
            password=`grep "password: " $FILE_TEMP | head -n 1 | sed 's/password: //'`
            echo "$CLIENT_ID update $ARGS_STRING $login $password" > $PIPE_SERVER
            rm $FILE_TEMP
        fi
        cat $PIPE_CLIENT
        ;;
    rm)
        echo "$CLIENT_ID $OPTION $ARGS_STRING" > $PIPE_SERVER
        cat $PIPE_CLIENT
        ;;
    ls)
        echo "$CLIENT_ID $OPTION $ARGS_STRING" > $PIPE_SERVER
        cat $PIPE_CLIENT
        ;;
    shutdown)
        echo "$CLIENT_ID $OPTION $ARGS_STRING" > $PIPE_SERVER
        cat $PIPE_CLIENT
        ;;
    *)
        echo "$OPTION"
        echo "Error, bad request"
        exit 1
esac
rm $PIPE_CLIENT

