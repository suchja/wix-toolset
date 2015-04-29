#!/bin/sh

echo "Start waiting on pid!"
echo "variable: $@"
for pid in "$@"; do
		echo "Working on $pid"
		while kill -0 "$pid"; do
				sleep 0.5
		done
done
