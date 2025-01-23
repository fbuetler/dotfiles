#!/usr/bin/env bash

# Aerospace and Sketchybar use a different API for listing connected monitors.
# Aerospace uses a public API, where no order is defined, hence aerospace introduces its own: top left to bottom right
# Sketchybar uses a private API, where the order is not known but it might be: main monitor, top left to bottom right
#
# https://github.com/FelixKratz/SketchyBar/issues/628
# https://github.com/nikitabobko/AeroSpace/issues/336

MONITOR_IDS=$(aerospace list-monitors --format '%{monitor-appkit-nsscreen-screens-id}')
N_MONITORS=$(echo "$MONITOR_IDS" | wc -l)

declare -A MONITOR_MAPPING
for i in $(seq 1 "$N_MONITORS"); do
    MONITOR_MAPPING[$i]=$(sed "${i}q;d" <(echo "$MONITOR_IDS"))
done

for i in "${!MONITOR_MAPPING[@]}"; do printf "%s=%s\n" "$i" "${MONITOR_MAPPING[$i]}"; done
