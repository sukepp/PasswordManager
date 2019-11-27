#!/bin/bash

root_dir="./PasswordManagementData"

if [ ! -d "$root_dir" ]; then
    mkdir "$root_dir"
fi

if [ $# -ne 2 ]; then
    echo "Error: parameters problem"
    exit 1
fi

user_dir="$1"
service_dir=`dirname "$2"`
service_file=`basename "$2"`

if [ ! -d "$root_dir"/"$user_dir" ]; then
    echo "Error: user does not exist"
    exit 2
fi

if [ ! -f "$root_dir"/"$user_dir"/"$service_dir"/"$service_file" ]; then
    echo "Error: service does not exist"
    exit 3
fi

#lockfile="./$user_dir.lock"
#exec 200>$lockfile
#flock -n 200 || {
#    echo "please wait"
#    exit 1
#}

cat "$root_dir"/"$user_dir"/"$service_dir"/"$service_file"
exit 0
