#!/bin/bash

DIR=./passManager
if [ ! -d "$DIR" ]; then
    mkdir $DIR
fi

if [ $# -ne 1 ]; then
    echo "Error: parameters problem"
    exit 1
fi

if [ -d "$DIR/$1" ]; then
    echo "Error: user already exists"
    exit 2
fi

mkdir $DIR/$1
echo "OK: user created"
exit 0
