#!/usr/bin/env bash

set -eEuo pipefail

# aerospace/sketchybar monitor mapping
declare -A MONITOR_MAPPING=(
    ["1"]=1
    # ["1"]=2
    # ["2"]=1
    # ["3"]=3
)

# PLUGIN_DIR="$CONFIG_DIR/plugins"
# source "$PLUGIN_DIR/monitor_mapping.sh"

AEROSPACE_FOCUSED_MONITOR=$(aerospace list-monitors --focused --format '%{monitor-id}')
mid="${MONITOR_MAPPING[$AEROSPACE_FOCUSED_MONITOR]}"

if [ -n "$AEROSPACE_FOCUSED_WORKSPACE" ] && [ -n "$AEROSPACE_PREV_WORKSPACE" ]; then
    # highlight focused space
    sketchybar \
        --set space."$AEROSPACE_FOCUSED_WORKSPACE" \
        background.border_width=3

    # unhighlight previous space
    sketchybar \
        --set space."$AEROSPACE_PREV_WORKSPACE" \
        background.border_width=0
fi

# create space for non-empty workspaces
for i in $(aerospace list-workspaces --monitor focused --empty no); do
    sketchybar \
        --set space."$i" \
        display="$mid"
done

# remove space for empty workspaces
for i in $(aerospace list-workspaces --monitor focused --empty); do
    sketchybar \
        --set space."$i" \
        display=0
done

if [ -n "$AEROSPACE_FOCUSED_WORKSPACE" ]; then
    # create space for focused workspaces (even if it is empty)
    sketchybar \
        --set space."$AEROSPACE_FOCUSED_WORKSPACE" \
        display="$mid"
fi
