#!/bin/sh

echo "Start waiting on $@"
while pgrep -u xclient "$@"; do 
		sleep 1; 
done
