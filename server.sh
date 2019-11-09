#!/bin/bash

echo "server started."

PIPE_SERVER="server_pipe"

if [ ! -e $PIPE_SERVER ]; then
   mkfifo $PIPE_SERVER
fi

while true; do
    echo "waiting for request..."
    read args < $PIPE_SERVER
    echo "Receive: $args"

    client_id=${args%% *}
    sub_args=${args#* }
    option=${sub_args%% *}
    sub_args=${sub_args#* }
    
    PIPE_CLIENT=$client_id"_pipe"
    
    case "$option" in
        init)
            ./init.sh $sub_args > $PIPE_CLIENT &
            ;;
        insert)
            user_id=${sub_args%% *}
            sub_args=${sub_args#* }
            service_file=${sub_args%% *}
            sub_args=${sub_args#* }
            login_id=${sub_args%% *}
            password=${sub_args#* }
            #echo "$user_id $service_file $login_id\n$password"
            ./insert.sh $user_id $service_file "login: $login_id\npass: $password" > $PIPE_CLIENT &
            ;;
        show)
            user_id=${sub_args%% *}
            sub_args=${sub_args#* }
            service_file=${sub_args%% *}
            sub_args=${sub_args#* }
            ./show_helper.sh $user_id $service_file $PIPE_CLIENT $login_id $password &
            ;;
        update)
            #echo "$sub_args"
            user_id=${sub_args%% *}
            sub_args=${sub_args#* }
            service_file=${sub_args%% *}
            sub_args=${sub_args#* }
            login_id=${sub_args%% *}
            password=${sub_args#* }
            #echo "$user_id $service_file f \"login: $login_id\npass: $password\""
            ./insert.sh $user_id $service_file f "login: $login_id\npass: $password" > $PIPE_CLIENT &
            ;;
        rm)
            ./rm.sh $sub_args > $PIPE_CLIENT &
            ;;
        ls)
            ./ls.sh $sub_args > $PIPE_CLIENT &
            ;;
        shutdown)
            exit 0
            ;;
        *)
            echo "Error, bad request"
            exit 1
    esac
done

rm $PIPE_SERVER
