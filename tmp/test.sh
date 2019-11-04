#!/bin/bash

lockfile="./lock.tmp"
exec 200>$lockfile
flock -n 200 || {
    echo "please wait"
    exit 1
}
while :
do
    echo "sukepp"
    sleep 1
done
