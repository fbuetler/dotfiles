#!/usr/bin/env bash

set -eEuo pipefail

# polybar dp0 >> "$HOME/.local/log/polybar.log" 2>&1 & disown

polybar-msg cmd quit >> "$HOME/.local/log/polybar.log" 2>&1

MONITORS=$(xrandr --listmonitors | awk '{ print $4}' | tail -n +2)
for m in $MONITORS; do
    MONITOR=$m polybar dp0 >> "$HOME/.local/log/polybar.log" 2>&1 & disown
done
