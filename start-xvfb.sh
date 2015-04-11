#!/bin/bash

# Set Environment

	export DISPLAY=:1.0

# Start xvfb

	Xvfb :1 -screen 0 640x480x8 &> ~/xvfb.log &
