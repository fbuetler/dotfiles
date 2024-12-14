#!/usr/bin/env bash

set -eEuo pipefail

export MONITOR_0="eDP-1"
export MONITOR_1="DP-2"
export MONITOR_2="DP-2-1"
export MONITOR_3="DP-2-2"

monitors=$(xrandr --listmonitors | awk '{ print $4}' | tail -n +2)
for m in $monitors; do
    xrandr --output "$m" --off > /dev/null 2>&1 # might not exists
done
xrandr --output "$MONITOR_0" --primary --mode 1920x1080 --pos 0x0

"$HOME"/.config/polybar/launch.sh
