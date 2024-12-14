#!/usr/bin/env bash

set -eEuo pipefail

export MONITOR_2="eDP-1" # MONITOR_0 and MONITOR_1 are used by polybars config
export MONITOR_0="DP-1-1"
export MONITOR_1="HDMI-2"

xrandr --output "$MONITOR_2" --off
xrandr --output "$MONITOR_0" --primary --mode 2560x1440 --rate 75 --pos 2560x0
xrandr --output "$MONITOR_1"           --mode 2560x1440 --rate 75 --pos 0x0

i3-msg -q restart
polybar-msg cmd restart > /dev/null 2>&1
