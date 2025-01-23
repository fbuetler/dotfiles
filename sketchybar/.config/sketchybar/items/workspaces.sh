#!/usr/bin/env bash

set -eEuo pipefail

PLUGIN_DIR="$CONFIG_DIR/plugins"

# aerospace/sketchybar monitor mapping
declare -A MONITOR_MAPPING=(
    ["1"]=2
    ["2"]=1
    ["3"]=3
)

sketchybar --add event aerospace_workspace_change

for m in $(aerospace list-monitors --format '%{monitor-id}'); do
    mid="${MONITOR_MAPPING[$m]}"

    for i in $(aerospace list-workspaces --monitor "$m"); do
        sid=$i

        # create spaces
        space=(
            display="$mid"
            space="$sid"

            label="$sid"
            label.align="center"
            label.padding_left=8
            label.padding_right=8
            icon.padding_left=0
            icon.padding_right=0

            background.color=0x40ffffff
            background.corner_radius=5
            background.height=25

            background.border_color=0xffffcc00
            background.border_width=0

            click_script="aerospace workspace $sid"
        )

        sketchybar \
            --add space "space.$sid" left \
            --set "space.$sid" "${space[@]}"
    done

    # hide empty spaces
    for i in $(aerospace list-workspaces --monitor "$m" --empty); do
        sketchybar \
            --set space."$i" \
            display=0
    done
done

# highlight focused space
sketchybar \
    --set space."$(aerospace list-workspaces --focused)" \
    background.border_width=3

# on space change
space_creator=(
    script="$PLUGIN_DIR/update_workspaces.sh"
)

sketchybar \
    --add item space_creator left \
    --set space_creator "${space_creator[@]}" \
    --subscribe space_creator aerospace_workspace_change
