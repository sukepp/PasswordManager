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
cat "$FILE_TEMP" > "$pipe_client"
rm -f $FILE_TEMP
#echo "client: $pipe_client user: $user_id end"

rm -f "$lockfile"
exit 0
