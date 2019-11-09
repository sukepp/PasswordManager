#!/bin/bash

counter=1
while true;
do
    ./client.sh $counter show sukepp ucd >> log.txt
    let "counter=$counter+1"
    ./client.sh $counter "ls" sukepp >> log.txt
    let "counter=$counter+1"
    ./client.sh $counter init sukepp >> log.txt
    let "counter=$counter+1"
done
