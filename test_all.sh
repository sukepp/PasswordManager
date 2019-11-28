#!/bin/bash

# Example of script that could be used to test the 2019 COMP30640 project
chmod u+x ./*.sh

rootFolder="./PasswordManagementData"

#Test the basic commands
#Test init.sh
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "#Test init.sh"
echo "#Should fail because no parameter"
./init.sh
echo "#Should succeed"
./init.sh myUser
if [ -e "$rootFolder/myUser" ]; then
	echo "Created the folder "$rootFolder/myUser" correctly"
else
	echo "Did not create the folder"
fi
echo "#Should fail because user already exists"
./init.sh myUser

#test insert.sh
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "#Test insert.sh"
echo "#Should fail because user does not exist"
./insert.sh newUser newService "" "login: log\npassword: pass"
echo "#Should succeed"
./insert.sh myUser newService "" "login: log\npassword: pass"
if [ -f "$rootFolder/myUser/newService" ]; then
        echo "Created the file correctly"
	echo "Content of the file:"
	cat "$rootFolder/myUser/newService"
else
        echo "Did not create the file"
fi
echo "#Should succeed"
./insert.sh myUser newService "f" "login: newlog\npassword: newpass"
if [ -f "$rootFolder/myUser/newService" ]; then
        echo "Created the file correctly"
        echo "Content of the file:"
        cat "$rootFolder/myUser/newService"
else
        echo "Did not create the file"
fi

#test show.sh
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "#Test show.sh"
echo "#Should succeed"
./show.sh myUser newService

#test rm.sh
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "#Test rm.sh"
echo "#Should succeed"
./rm.sh myUser newService
if [ -f "$rootFolder/myUser/newService" ]; then
        echo "Did not delete the file"
else
        echo "Deleted the file correctly"
fi

#test server
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "#Test server.sh"
./server.sh &> "./servout1.txt" &
serverPID=$!
sleep 1
if [ -p "./server.pipe" ]; then
	echo "server.pipe created"
    client_pipe="first client.pipe"
    mkfifo "$client_pipe"

	echo "first client\"init\"first user" > ./server.pipe
        echo "Server's answer to init fisrt user:"
        cat "$client_pipe"
	if [ -e "$rootFolder/first user" ]; then
		echo "Server seems OK"
	else 
		echo "Server seems to have a problem"
	fi

	echo "first client\"shutdown" > ./server.pipe
        cat "$client_pipe"
	sleep 1
	if ps -p $serverPID > /dev/null; then
		echo "Shutdown did not work"
		kill $serverPID
	else
		echo "shutdown worked"
	fi
        if [ -e "./server.pipe" ]; then
                echo "server.pipe not cleaned"
                rm server.pipe
        fi
        rm "$client_pipe"
else
	echo "server.pipe not created"
	kill $serverPID
fi

#test client
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Test client.sh"

./server.sh &> "servout2.txt" &
serverPID=$!
client_pipe="second client.pipe"
sleep 1

#Test init.sh on the client
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "#Test client init"
echo "#Should fail because no parameter"
./client.sh "second client" init
echo "#Should succeed"
./client.sh "second client" init "second user"
if [ -e "$rootFolder/myUser" ]; then
	echo "Created the folder "$rootFolder/second user" correctly"
else
	echo "Did not create the folder"
fi
echo "#Should fail because user already exists"
./client.sh "second client" init "second user"


##test insert.sh on the client
#echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
#echo "#Test client insert"
#echo "./client.sh \"second client\" insert \"second user\" \"new service\"" 
#echo "#Should succeed"
#./client.sh "second client" insert "second user" "new service" < ./test_service.txt
#if [ -f "$rootFolder/second user/new service" ]; then
#    echo "Created the file new service correctly"
#	echo "Content of the file:"
#	cat "$rootFolder/second user/new service" | xargs -0 ./decrypt.sh "password"
#else
#        echo "Did not create the file"
#fi
#echo "#Should succeed"
#./insert.sh myUser newService "f" "login: newlog\npassword: newpass"
#if [ -f "$rootFolder/myUser/newService" ]; then
#        echo "Created the file correctly"
#        echo "Content of the file:"
#        cat "$rootFolder/myUser/newService"
#else
#        echo "Did not create the file"
#fi


echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "#Test client shutdown"
./client.sh "second client" shutdown
if ps -p $serverPID > /dev/null; then
	echo "Server did not shut down"
	kill $serverPID
fi

if [ -p "$client_pipe" ]; then
        echo "Cleanup not done"
        rm "$client_pipe"
else
	echo "Cleanup OK"
fi

