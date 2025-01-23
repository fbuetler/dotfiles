#!/usr/bin/env bash

# aerospace/sketchybar monitor mapping
declare -A MONITOR_MAPPING=(
    ["1"]=2
    ["2"]=1
    ["3"]=3
)

for m in $(aerospace list-monitors --format '%{monitor-id}'); do
    mid="${MONITOR_MAPPING[$m]}"

    display=(
        display="$m"

        label="$m"
        label.color=0xff000000
        label.align="center"
        label.padding_left=8
        label.padding_right=8
        icon.padding_left=0
        icon.padding_right=0

        background.color=0xffffcc00
        background.corner_radius=5
        background.height=25
    )

    sketchybar \
        --add item "display.$mid" center \
        --set "display.$mid" "${display[@]}"

done
