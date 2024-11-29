#!/usr/bin/env bash

set -eEuo pipefail

export MONITOR_0="eDP-1"
export MONITOR_1="DP-2"

xrandr --output "$MONITOR_0" --primary --auto
xrandr --output "$MONITOR_1"           --auto --above "$MONITOR_0"

"$HOME"/.config/polybar/launch.sh

