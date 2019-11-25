#!/bin/bash

user_id=$1
service_file=$2
PIPE_CLIENT=$3
login_id=$4
password=$5

lockfile="./$user_id.lock"
exec 200>$lockfile
flock -n 200 || {
    echo 1 > $PIPE_CLIENT
    echo "show wait"
    echo "$user_id is logging. Please wait" > $PIPE_CLIENT
    exit 1 
}

FILE_TEMP=`mktemp`
#echo "client: $PIPE_CLIENT user: $user_id start"
./show.sh $user_id $service_file > $FILE_TEMP
exit_code=$?
echo $exit_code > $PIPE_CLIENT
if [ $exit_code -eq 0 ]; then
    #login_id=`sed -n '1p' $FILE_TEMP | sed 's/login: //'`
    #password=`sed -n '2p' $FILE_TEMP | sed 's/pass: //'`
    ##echo -e "$login_id\n$password"
    #echo "$login_id" > $PIPE_CLIENT
    ## bug: deadlock happend if the following line deleted
    #echo "show in service"
    #echo "$password" > $PIPE_CLIENT
    cat $FILE_TEMP > $PIPE_CLIENT
else
    cat $FILE_TEMP > $PIPE_CLIENT
fi
rm $FILE_TEMP
#echo "client: $PIPE_CLIENT user: $user_id end"

rm $lockfile
exit 0
