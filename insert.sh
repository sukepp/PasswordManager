#!/bin/bash

ROOT_DIR=./passManager
OPTION="none"

if [ ! -d "$ROOT_DIR" ]; then
    mkdir $ROOT_DIR
fi

if [ $# -ne 3 ]; then
    if [ $# -ne 4 ]; then
        echo "Error: parameters problem"
        exit 1
    fi
    OPTION=$3
    if [[ $OPTION != "f" && $OPTION != "" ]]; then
        echo "Error: parameters problem"
        exit 1
    else
        CONTENT=$4
    fi
else
    CONTENT=$3
fi

USER_DIR=$1
SERVICE_DIR=`dirname $2`
SERVICE_FILE=`basename $2`

if [ ! -d "$ROOT_DIR/$USER_DIR" ]; then
    echo "$ROOT_DIR/$USER_DIR"
    echo "Error: user does not exist"
    exit 2
fi


if [[ $OPTION == "f" ]]; then
    if [ -f "$ROOT_DIR/$USER_DIR/$SERVICE_DIR/$SERVICE_FILE" ]; then
        echo -e "$CONTENT" > $ROOT_DIR/$USER_DIR/$SERVICE_DIR/$SERVICE_FILE
        echo "OK: service updated"
    else
        if [ ! -d $ROOT_DIR/$USER_DIR/$SERVICE_DIR ]; then
            mkdir -p $ROOT_DIR/$USER_DIR/$SERVICE_DIR
        fi
        echo -e "$CONTENT" > $ROOT_DIR/$USER_DIR/$SERVICE_DIR/$SERVICE_FILE
        echo "OK: service created"
    fi
    exit 0
fi

if [ -f "$ROOT_DIR/$USER_DIR/$SERVICE_DIR/$SERVICE_FILE" ]; then
    echo "Error: service already exists"
    exit 3
fi

if [ ! -d $ROOT_DIR/$USER_DIR/$SERVICE_DIR ]; then
    mkdir -p $ROOT_DIR/$USER_DIR/$SERVICE_DIR
fi
echo -e "$CONTENT" > $ROOT_DIR/$USER_DIR/$SERVICE_DIR/$SERVICE_FILE
echo "OK: service created"
exit 0

