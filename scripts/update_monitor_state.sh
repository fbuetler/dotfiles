#!/bin/bash

intern="eDP-1"
extern="HDMI-2"

connected=$(xrandr | grep "$extern connected")
active=$(xrandr | grep -E "$extern connected (primary )?[1-9]+")

if [ "$connected" ] && [ ! "$active" ]
then
    echo "activate"
    xrandr --output $intern --auto --output $extern --auto --above $intern --primary
    i3-msg -q restart
fi

if [ "$connected" ] && [ "$active" ]
then
    echo "deactivate"
    xrandr --output $extern --off
    i3-msg -q restart
fi

