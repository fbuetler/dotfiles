#!/usr/bin/env bash

set -eEuo pipefail

export MONITOR_0="eDP-1"
export MONITOR_1="DP-2"
export MONITOR_2="DP-2-1"
export MONITOR_3="DP-2-2"

xrandr --output "$MONITOR_0" --primary --mode 1920x1080 --pos 0x0
xrandr --output "$MONITOR_1" --off > /dev/null 2>&1 # might not exists
xrandr --output "$MONITOR_2" --off > /dev/null 2>&1
xrandr --output "$MONITOR_3" --off > /dev/null 2>&1

"$HOME"/.config/polybar/launch.sh
