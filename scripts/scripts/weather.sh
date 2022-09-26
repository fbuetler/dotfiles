#!/bin/bash

i3status | while :
do
        sleep 3600
        curl -Ss 'https://wttr.in?0&T&Q' |  cut -c 16- | head -3 | xargs echo
done
