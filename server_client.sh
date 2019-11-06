

while true; do
req=read pipe_server
case "$1" in
    init)
        ./init para1 para2 & > pipe_clientId
