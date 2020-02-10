#!/bin/bash

asadmin start-domain domain1

pid=`ps -ef | grep java | grep -v grep | awk '{print $2}'`

if echo "$pid" | egrep "^[0-9]+" > /dev/null
then
	while ps --pid $pid > /dev/null
	do
		sleep 30
	done
fi

