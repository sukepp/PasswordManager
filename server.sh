#!/bin/bash

echo "server started."

PIPE_SERVER="server.pipe"

if [ ! -e "$PIPE_SERVER" ]; then
   mkfifo "$PIPE_SERVER"
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
            ./insert.sh "$user_id" "$service_path" "$payload" > "$pipe_client" &
            ;;
        show)
            user_id=${sub_args%%\"*}
            service_path=${sub_args#*\"}
            ./show_helper.sh "$user_id" "$service_path" "$pipe_client" &
            ;;
        update)
            user_id=${sub_args%%\"*}
            sub_args=${sub_args#*\"}
            service_path=${sub_args%%\"*}
            payload=${sub_args#*\"}
            ./insert.sh "$user_id" "$service_path" f "$payload" > "$pipe_client" &
            ;;
        rm)
            user_id=${sub_args%%\"*}
            service_path=${sub_args#*\"}
            ./"rm.sh" "$user_id" "$service_path" > "$pipe_client" &
            ;;
        ls)
            delimter="\""
            echo "$sub_args" | grep -q "$delimter"
            if [ $? -eq 0 ]; then
                user_id=${sub_args%%\"*}
                service_dir=${sub_args#*\"}
                ./"ls.sh" "$user_id" "$service_dir" > "$pipe_client" &
            else
                user_id="$sub_args"
                ./"ls.sh" "$user_id" > "$pipe_client" &
            fi
            ;;
        shutdown)
            rm -f "$PIPE_SERVER"
            echo "OK: server is shut down" > "$pipe_client" &
            exit 0
            ;;
        *)
            echo "Error, bad request"
            exit 1
    esac
done

rm -f "$PIPE_SERVER"
exit 0

