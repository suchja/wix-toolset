#!/bin/bash

# we need to tell GUI applications which display to use
export DISPLAY=xserver:0

# we also need to use the proper magic cookie for authorization
xauth merge /Xauthority/xserver.xauth -q
