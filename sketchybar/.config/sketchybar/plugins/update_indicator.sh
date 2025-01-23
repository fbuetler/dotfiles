#!/usr/bin/env bash

set -eEuo pipefail

if [ "$SENDER" = "show_indicator" ]; then
    sketchybar \
        --set "indicator" \
        label="$INDICATOR" \
        drawing=on
fi

if [ "$SENDER" = "hide_indicator" ]; then
    sketchybar \
        --set "indicator" \
        label="" \
        drawing=off
fi
