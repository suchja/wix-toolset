#!/bin/sh

echo "Start waiting on $@"
while pgrep -u xclient "$@" > /dev/null; do 
		echo "waiting ..."
		sleep 1; 
done
echo "$@ completed"
