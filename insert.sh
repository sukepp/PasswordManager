#!/bin/bash

root_dir="./PasswordManagementData"
mode="none"

if [ ! -d "$root_dir" ]; then
    mkdir "$root_dir"
fi

if [ $# -ne 3 ]; then
    if [ $# -ne 4 ]; then
        echo "Error: parameters problem"
        exit 1
    fi
    mode=$3
    content=$4
else
    content=$3
fi

user_dir=$1
service_dir=`dirname "$2"`
service_file=`basename "$2"`

if [ ! -d "$root_dir"/"$user_dir" ]; then
    echo "Error: user does not exist"
    exit 2
fi

lockfile=./"$user_dir".lock
exec 200>"$lockfile"
flock -n 200 || {
    echo "$user_dir is logging. Please wait"
    exit 1
}

if [[ "$mode" == "f" ]]; then
    if [ -f "$root_dir"/"$user_dir"/"$service_dir"/"$service_file" ]; then
        echo -e "$content" > "$root_dir"/"$user_dir"/"$service_dir"/"$service_file"
        echo "OK: service updated"
    else
        if [ ! -d "$root_dir"/"$user_dir"/"$service_dir" ]; then
            mkdir -p "$root_dir"/"$user_dir"/"$service_dir"
        fi
        echo -e "$content" > "$root_dir"/"$user_dir"/"$service_dir"/"$service_file"
        echo "OK: service created"
    fi
    rm "$lockfile"
    exit 0
fi

if [ -f "$root_dir"/"$user_dir"/"$service_dir"/"$service_file" ]; then
    echo "Error: service already exists"
    rm "$lockfile"
    exit 3
fi

if [ ! -d "$root_dir"/"$user_dir"/"$service_dir" ]; then
    mkdir -p "$root_dir"/"$user_dir"/"$service_dir"
fi

echo -e "$content" > "$root_dir"/"$user_dir"/"$service_dir"/"$service_file"
echo "OK: service created"
rm "$lockfile"
exit 0

