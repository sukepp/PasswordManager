#!/bin/bash

echo "server started."

PIPE_SERVER="server_pipe"

if [ ! -e $PIPE_SERVER ]; then
   mkfifo $PIPE_SERVER
fi

while true; do
    echo "waiting for request..."
    read args < $PIPE_SERVER
    
    client_id=${args%% *}
    sub_args=${args#* }
    option=${sub_args%% *}
    sub_args=${sub_args#* }
    
    PIPE_CLIENT=$client_id"_pipe"
    
    case "$option" in
        init)
            ./init.sh $sub_args > $PIPE_CLIENT
            ;;
        insert)
            echo -e $sub_args
            ./insert.sh $sub_args > $PIPE_CLIENT
            ;;
        show)
            ./show.sh $sub_args > "./tmp"
            echo $? > $PIPE_CLIENT
            echo `cat ./tmp` > $PIPE_CLIENT
            rm ./tmp
            ;;
        update)
            user_id=${sub_args%% *}
            sub_args=${sub_args#* }
            service_file=${sub_args%% *}
            sub_args=${sub_args#* }
            #last_arg=${sub_args##* }
            #sub_args=${sub_args% *}
            ./insert.sh $user_id $service_file f $sub_args > $PIPE_CLIENT
            ;;
        rm)
            ./rm.sh $sub_args > $PIPE_CLIENT
            ;;
        ls)
            ./ls.sh $sub_args > $PIPE_CLIENT
            ;;
        shutdown)
            exit 0
            ;;
        *)
            echo "Error, bad request"
            exit 1
    esac
done

