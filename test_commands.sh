#!/bin/bash

counter=1
while true;
do
    if [ $counter -lt 100 ]; then
        ./show.sh sukepp ucd >> log.txt &
        #sleep 1
        ./ls.sh sukepp >> log.txt &
        #sleep 1
        ./init.sh sukepp >> log.txt &
        let "counter=$counter+1"
    else
        exit 0
    fi
done
