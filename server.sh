#!/bin/bash
while true; do
read -p "Enter your option: " args
option=${args%% *}
sub_args=${args#* }
case "$option" in
    init)
        ./init.sh $sub_args
        ;;
    insert)
        ./insert.sh $sub_args
        ;;
    show)
        ./show.sh $sub_args
        ;;
    update)
        ./insert.sh $sub_args
        ;;
    rm)
        ./insert.sh $sub_args
        ;;
    ls)
        ./ls.sh $sub_args
        ;;
    shutdown)
        exit 0
        ;;
    *)
        echo "Error, bad request"
        exit 1
esac
done
