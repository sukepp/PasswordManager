#!/bin/bash

ROOT_DIR=./passManager
USER_DIR=$1
if [ ! -d "$ROOT_DIR" ]; then
    mkdir $ROOT_DIR
fi

if [ $# -ne 1 ]; then
    echo "Error: parameters problem"
    exit 1
fi

if [ -d "$ROOT_DIR/$USER_DIR" ]; then
    echo "Error: user already exists"
    exit 2
fi

mkdir $ROOT_DIR/$USER_DIR
echo "OK: user created"
exit 0
