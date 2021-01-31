#!/usr/bin/env bash
# Author: Harshvardhan Pandit
# Email: me@harshp.com
# License: MIT

# Script to automatically setup secondary monitors
# Uses xrandr and env variables to determine monitor and positioning
# Checks if display is connected using grep to find non-primary output
# Gets positioning using env variable MONITOR_POSITION
# Arguments:
#   default: does nothing
#   off: switches off secondary display
#   on: switches on secondary display
# Get primary display

DEBUG=true;

debug() {
    if [ "$DEBUG" = true ]
    then
        echo "$1";
    fi
}

DISPLAY_PRIMARY=$(xrandr --query | grep "eDP1" | grep -oP "^[\w-]+ ")
if [[ -z $DISPLAY_PRIMARY ]]; then
    debug "ERROR: Primary Monitor eDP1 cannot be detected";
    exit 1;
else
    debug "found primary display $DISPLAY_PRIMARY";
fi
# Get secondary display
DISPLAY_SECONDARY=$(xrandr --query | grep "\bconnected" | grep -v "$DISPLAY_PRIMARY" | grep -oP "^[\w-]+ ")
if [[ -z $DISPLAY_SECONDARY ]]; then
    debug "Secondary display not detected";
else
    debug "found secondary display $DISPLAY_SECONDARY";
fi
# Get monitor position from env
# shellcheck source=/dev/null
source ~/.env
#source ~/.config/monitors

# Primary display only
display_only_primary() {
    echo "switching to primary only..."
    DISPLAY_SECONDARY=$(xrandr --query | grep " disconnected [0-9]" | grep -oP "^[\w-]+ ")
    if [[ -z $DISPLAY_SECONDARY ]]; then
        debug "Secondary display not detected";
    else
        debug "switched off $DISPLAY_SECONDARY";
        eval "xrandr --output $DISPLAY_SECONDARY --off"
    fi
    eval "xrandr --output $DISPLAY_PRIMARY --auto --primary"
}
# Secondary display only
display_only_secondary() {
    eval "xrandr --output $DISPLAY_PRIMARY --off --output $DISPLAY_SECONDARY --auto --primary"
}
# Dual display, primary is laptop display
display_dual_primary_inbuilt() {
    eval "xrandr --output $DISPLAY_PRIMARY --auto --primary --output $DISPLAY_SECONDARY --auto --$MONITOR_POSITION $DISPLAY_PRIMARY"
}
# Dual display, primary is external display
display_dual_primary_external() {
    eval "xrandr --output $DISPLAY_PRIMARY --auto --output $DISPLAY_SECONDARY --auto --primary --$MONITOR_POSITION $DISPLAY_PRIMARY"
}
# Dual display, primary mirrored to secondary
display_mirror() {
    # ensure displays are on
    display_dual_primary_inbuilt
    eval "xrandr --output $DISPLAY_SECONDARY --same-as $DISPLAY_PRIMARY"
}

# switch on secondary display
switch_on() {
    display_dual_primary_inbuilt
}
# switch off secondary display
switch_off() {
    eval "xrandr --output ${DISPLAY_SECONDARY} --off --output $DISPLAY_PRIMARY --primary --auto"
}

# If no secondary display is connected, exit gracefully
exit_if_not_secondary_display() {
    if [ -z "$DISPLAY_SECONDARY" ]
    then
        debug "SECONDARY display not detected; switched to primary only"
        display_only_primary
        exit 0;
    fi
}
exit_if_not_secondary_display

# Handle arguments
while test $# -gt 0; do
    case "$1" in
        -h|--help)
            echo "xrandr display script"
            echo "  default: check for secondary display, if exists, activate;"
            echo "  -off: switches off secondary display"
            echo "  -on: switches on secondary display"
            echo "  -h: shows this message"
            ;;
        -n|--on)
            switch_on
            ;;
        -f|--off)
            switch_off
            ;;
        -a|--auto)
            if [ -z "$DISPLAY_SECONDARY" ]
            then
                debug "no secondary display; switching to primary output"
                display_only_primary 
            else
                debug "switching to dual output"
                display_dual_primary_inbuilt
            fi
            ;;
        -p|--primary-only)
            display_only_primary
            ;;
        -s|--secondary-only)
            display_only_secondary
            ;;
        -m|--mirror)
            if [ -z "$DISPLAY_SECONDARY" ]
            then
                debug "no secondary display; aborting"
            else
                display_mirror
            fi
            ;;
        *)
            if [ -z "$DISPLAY_SECONDARY" ]
            then
                switch_off
            else
                switch_on
            fi
            ;;
    esac
    break;
done
