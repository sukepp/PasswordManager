#!/bin/bash

ROOT_DIR=./passManager

if [ ! -d "$ROOT_DIR" ]; then
    mkdir $ROOT_DIR
fi

if [ $# -ne 1 ]; then
    echo "Error: parameters problem"
    exit 1
fi

USER_DIR=$1

if [ -d "$ROOT_DIR/$USER_DIR" ]; then
    echo "Error: user already exists"
    exit 2
fi

lockfile="./$USER_DIR.lock"
exec 200>$lockfile
flock -n 200 || {
    echo "$USER_DIR is logging. Please wait"
    exit 1
}

mkdir $ROOT_DIR/$USER_DIR
echo "OK: user created"
rm $lockfile
exit 0
