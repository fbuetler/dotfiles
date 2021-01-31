#/bin/bash

X_USER="florian"
X_USERID="1000"

notify_cmd='sudo -u '"$X_USER"' DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/'"$X_USERID"'/bus notify-send'

$notify_cmd hei

