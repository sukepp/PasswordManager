#!/bin/bash

root_dir="./PasswordManagementData"

if [ ! -d "$root_dir" ]; then
    mkdir "$root_dir"
fi

if [[ $# -ne 1 && $# -ne 2 ]]; then
    echo "Error: parameters problem"
    exit 1
fi

user_dir="$1"


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

if [ $# -eq 1 ]; then
    echo "OK:"
    echo " ."
    tree "$root_dir"/"$user_dir" | head -n -2 | tail -n +2
    rm -f "$lockfile"
    exit 0
else
    service_dir="$2"
    if [ ! -d "$root_dir"/"$user_dir"/"$service_dir" ]; then
        echo "Error: folder does not exist"
        rm -f "$lockfile"
        exit 3
    fi
    echo "OK:"
    echo "$service_dir"
    tree "$root_dir"/"$user_dir"/"$service_dir" | head -n -2 | tail -n +2
    rm -f "$lockfile"
    exit 0
fi
