#!/bin/bash

root_dir="./PasswordManagementData"

if [ ! -d "$root_dir" ]; then
    mkdir "$root_dir"
fi

if [ $# -ne 1 ]; then
    echo "Error: parameters problem"
    exit 1
fi

user_dir="$1"

if [ -d "$root_dir"/"$user_dir" ]; then
    echo "Error: user already exists"
    exit 2
fi

lockfile=./"$user_dir".lock
exec 200>"$lockfile"
flock -n 200 || {
    echo "$user_dir is logging. Please wait"
    exit 1
}

mkdir "$root_dir"/"$user_dir"
echo "OK: user created"
rm "$lockfile"
exit 0
