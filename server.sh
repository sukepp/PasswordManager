#!/bin/bash

echo "server started."

PIPE_SERVER="server.pipe"

if [ ! -e $PIPE_SERVER ]; then
   mkfifo $PIPE_SERVER
fi

while true; do
    echo "waiting for request..."
    read args < $PIPE_SERVER
    echo "Receive length: ${#args}"
    echo "Receive: $args"

    client_id=${args%%\"*}
    sub_args=${args#*\"}
    option=${sub_args%%\"*}
    sub_args=${sub_args#*\"}
    decrypt_password="password"
    pipe_client="$client_id".pipe
    
    case "$option" in
        init)
            user_id="$sub_args"
            ./init.sh "$user_id" > "$pipe_client" &
            ;;
        insert)
            user_id=${sub_args%%\"*}
            sub_args=${sub_args#*\"}
            service_path=${sub_args%%\"*}
            payload=${sub_args#*\"}
            echo "$client_id"
            #echo "$user_id"
            #echo "$service_path"
            #echo "$payload"
            ./decrypt.sh "$decrypt_password" "$payload" > tmp1.txt
            text=`cat tmp1.txt`
            ./insert.sh "$user_id" "$service_path" "$text" > "$pipe_client"
            #echo `./insert.sh "$user_id" "$service_path" "$text"`
            ;;
        show)
            user_id=${sub_args%%\"*}
            sub_args=${sub_args#*\"}
            service_path=${sub_args%%\"*}
            sub_args=${sub_args#*\"}
            ./show_helper.sh "$user_id" "$service_path" "$pipe_client"
            ;;
#        update)
#            #echo "$sub_args"
#            user_id=${sub_args%% *}
#            sub_args=${sub_args#* }
#            service_path=${sub_args%% *}
#            sub_args=${sub_args#* }
#            login_id=${sub_args%% *}
#            password=${sub_args#* }
#            ./insert.sh $user_id $service_path f "login: $login_id\npassword: $password" > $pipe_client &
#            ;;
#        rm)
#            ./rm.sh $sub_args > $pipe_client &
#            ;;
#        ls)
#            ./ls.sh $sub_args > $pipe_client &
#            ;;
#        shutdown)
#            exit 0
#            ;;
        *)
            echo "Error, bad request"
            exit 1
    esac
done

rm $PIPE_SERVER
