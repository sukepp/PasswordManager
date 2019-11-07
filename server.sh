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
            ./init.sh $sub_args > $PIPE_CLIENT
            ;;
        insert)
            user_id=${sub_args%% *}
            sub_args=${sub_args#* }
            service_file=${sub_args%% *}
            sub_args=${sub_args#* }
            login_id=${sub_args%% *}
            password=${sub_args#* }
            #echo "$user_id $service_file $login_id\n$password"
            ./insert.sh $user_id $service_file "login: $login_id\npass: $password" > $PIPE_CLIENT
            ;;
        show)
            user_id=${sub_args%% *}
            sub_args=${sub_args#* }
            service_file=${sub_args%% *}
            sub_args=${sub_args#* }
            ./show.sh $user_id $service_file > "./tmp"
            exit_code=$?
            echo $exit_code > $PIPE_CLIENT
            if [ $exit_code -eq 0 ]; then
                login_id=`sed -n '1p' ./tmp | sed 's/login: //'`
                password=`sed -n '2p' ./tmp | sed 's/pass: //'`
                #echo -e "$login_id\n$password"
                echo "$login_id" > $PIPE_CLIENT
                #echo -e "write $password"
                echo "$password" > $PIPE_CLIENT
            else
                cat ./tmp > $PIPE_CLIENT
            fi
            rm ./tmp
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
            ./insert.sh $user_id $service_file f "login: $login_id\npass: $password" > $PIPE_CLIENT
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

rm $PIPE_SERVER
