#!/bin/bash

step=$1

actual_brightness=$(xrandr --verbose | grep -m 1 -i brightness | cut -f2 -d ' ')
new_brightness=$(echo "$step + $actual_brightness" | bc)

if (( $(echo "$new_brightness > 1.0" |bc -l) )); then
    #echo "max reached"
    exit 1;
fi

if (( $(echo "$new_brightness < 0.2" |bc -l) )); then
    #echo "min reached"
    exit 1;
fi

#echo "new brightness $new_brightness"

screenname=$(xrandr | grep " connected" | cut -f1 -d" ")
xrandr --output $screenname --brightness $new_brightness;
