#!/usr/bin/env bash

set -eEuo pipefail

PLUGIN_DIR="$CONFIG_DIR/plugins"

sketchybar --add event show_indicator
sketchybar --add event hide_indicator

indicator=(
    display="active"

    drawing="off"
    label=""

    label.color=0xff000000
    label.align="center"
    label.padding_left=8
    label.padding_right=8
    icon.padding_left=0
    icon.padding_right=0

    background.color=0xffffcc00
    background.corner_radius=5
    background.height=25

    script="$PLUGIN_DIR/update_indicator.sh"
)

sketchybar \
    --add item "indicator" center \
    --set "indicator" "${indicator[@]}" \
    --subscribe indicator show_indicator \
    --subscribe indicator hide_indicator
