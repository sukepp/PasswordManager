#!/bin/bash

ROOT_DIR=./passManager

if [ ! -d "$ROOT_DIR" ]; then
    mkdir $ROOT_DIR
fi

if [ $# -ne 2 ]; then
    echo "Error: parameters problem"
    exit 1
fi

USER_DIR=$1
SERVICE_DIR=`dirname $2`
SERVICE_FILE=`basename $2`

if [ ! -d "$ROOT_DIR/$USER_DIR" ]; then
    echo "Error: user does not exist"
    exit 2
fi

if [ ! -f "$ROOT_DIR/$USER_DIR/$SERVICE_DIR/$SERVICE_FILE" ]; then
    echo "Error: service does not exist"
    exit 3
fi

lockfile="./$USER_DIR.lock"
exec 200>$lockfile
flock -n 200 || {
    echo "$USER_DIR is logging. Please wait"
    exit 1
}

rm $ROOT_DIR/$USER_DIR/$SERVICE_DIR/$SERVICE_FILE
echo "OK: service removed"
rm $lockfile
exit 0
