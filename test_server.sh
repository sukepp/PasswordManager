#!/bin/bash

counter=1
while true;
do
    if [ $counter -lt 4 ]; then
        #./client.sh $counter show sukepp ucd >> log.txt &
        #let "counter=$counter+1"
        #sleep 1
        ./client.sh "$counter" "ls" sukepp >> log.txt &
        let "counter=$counter+1"
        sleep 1
        #./client.sh "$counter" init sukepp & >> log.txt &
        #let "counter=$counter+1"
    else
        exit 0
    fi
done
