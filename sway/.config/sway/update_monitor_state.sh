#!/bin/bash

connected=$(xrandr | rg "$MONITOR_1 connected")
active=$(xrandr | rg "$MONITOR_1 connected (primary )?\d+")

if [ "$connected" ] && [ ! "$active" ]
then
    echo "activate"
    xrandr --output "$MONITOR_0" --auto --output "$MONITOR_1" --auto --above "$MONITOR_0" --primary
    i3-msg -q restart
fi

if [ "$connected" ] && [ "$active" ]
then
    echo "deactivate"
    xrandr --output "$MONITOR_1" --off
    i3-msg -q restart
fi
