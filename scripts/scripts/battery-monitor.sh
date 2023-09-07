#!/bin/bash

set -euo pipefail

# there is a service called 'battery-monitor.service' for running  this script
# is is enabled with systemctl enable battery-monitor.service

X_USER="florian"
X_USERID="1000"

battery_level=$(acpi -b | sed -n 's/.*\ \([[:digit:]]\{1,3\}\)\%.*/\1/;p')
battery_state=$(acpi -b | awk '{print $3}' | tr -d ",")
battery_remaining=$(acpi -b | sed -n '/Discharging/{s/^.*\ \([[:digit:]]\{2\}\)\:\([[:digit:]]\{2\}\).*/\1h \2min/;p}')

backlight_cmd=$(which brightnessctl)
notify_cmd='sudo -u '"$X_USER"' DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/'"$X_USERID"'/bus notify-send'
calculator_cmd=$(which bc)

_battery_threshold_level="20"
_battery_critical_level="10"
_battery_suspend_level="5"

if [ ! -f "/tmp/.battery" ]; then
    echo "${battery_level}" >/tmp/.battery
    echo "${battery_state}" >>/tmp/.battery
    exit
fi

previous_battery_level=$(cat /tmp/.battery | head -n 1)
previous_battery_state=$(cat /tmp/.battery | tail -n 1)
echo "${battery_level}" >/tmp/.battery
echo "${battery_state}" >>/tmp/.battery

backlight_current=$(echo "100.0 * $(brightnessctl get) / $(brightnessctl max)" | bc)

checkBatteryLevel() {
    if [ ${battery_state} != "Discharging" ] || [ "${battery_level}" == "${previous_battery_level}" ]; then
        # target_brightness_perc=75
        # current_brightness=$(${backlight_cmd} get)
        # max_brightness=$(${backlight_cmd} max)
        # current_brightness_perc=$("${calculator_cmd}" <<< "scale=2 ; ${max_brightness} ${current_brightness} * 100")
        # echo $current_brightness_perc
        # out=[[ $("${calculator_cmd}" <<< "scale=2 ; ${max_brightness} ${current_brightness} * 100") -ge "${target_brightness_perc}" ]]
        # echo $out
        exit
    fi

    if [ ${battery_level} -le ${_battery_suspend_level} ]; then
        systemctl suspend
    elif [ ${battery_level} -le ${_battery_critical_level} ]; then
        $notify_cmd "Low Battery" "Your computer will suspend soon unless plugged into a power outlet." -u critical
        if [[ $backlight_current -gt 50 ]]; then
            ${backlight_cmd} set 50%
        fi
    elif [ ${battery_level} -le ${_battery_threshold_level} ]; then
        $notify_cmd "Low Battery" "${battery_level}% (${battery_remaining}) of battery remaining." -u normal
        if [[ $backlight_current -gt 75 ]]; then
            ${backlight_cmd} set 75%
        fi
    fi
}

checkBatteryStateChange() {
    if [ "${battery_state}" != "Discharging" ] && [ "${previous_battery_state}" == "Discharging" ]; then
        $notify_cmd "Charging" "Battery is now plugged in." -u low
        ${backlight_cmd} set 100%
    fi

    if [ "${battery_state}" == "Discharging" ] && [ "${previous_battery_state}" != "Discharging" ]; then
        $notify_cmd "Power Unplugged" "Your computer has been disconnected from power." -u low
    fi
}

checkBatteryStateChange
checkBatteryLevel
