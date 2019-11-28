#!/bin/bash

user_id=$1
service_path=$2
pipe_client=$3
encrypt_password="password"
#login_id=$4
#password=$5

lockfile=./"$user_id".lock
exec 200>"$lockfile"
flock -n 200 || {
    echo 1 > "$pipe_client"
    echo "show wait"
    echo "$user_id is logging. Please wait" > "$pipe_client"
    exit 1 
}

FILE_TEMP=`mktemp`
#echo "client: $pipe_client user: $user_id start"
./show.sh "$user_id" "$service_path" > "$FILE_TEMP"
exit_code=$?
echo $exit_code > "$pipe_client"
if [ $exit_code -eq 0 ]; then
    #login_id=`sed -n '1p' $FILE_TEMP | sed 's/login: //'`
    #password=`sed -n '2p' $FILE_TEMP | sed 's/pass: //'`
    ##echo -e "$login_id\n$password"
    #echo "$login_id" > $pipe_client
    ## bug: deadlock happend if the following line deleted
    #echo "show in service"
    #echo "$password" > $pipe_client

    payload=`cat $FILE_TEMP`
    echo $payload
    ./encrypt.sh "$encrypt_password" "$payload" > "$pipe_client"
    #echo `./encrypt.sh "$encrypt_password" "$payload"`
    #cat $FILE_TEMP > $pipe_client
else
    cat "$FILE_TEMP" > "$pipe_client"
fi
rm -f $FILE_TEMP
#echo "client: $pipe_client user: $user_id end"

rm -f "$lockfile"
exit 0
