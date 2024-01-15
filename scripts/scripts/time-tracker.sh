#!/bin/bash

CLEAR_LINE="\r"

TIMELOG_FILE="$HOME/timelog.csv"

function start_time {
    TODAY=$(date "+%Y-%m-%d")

    START=$(date +"%T")
    START_UNIX=$(date --date "$TODAY $START" "+%s")
}

function stop_time {
    END=$(date +"%T")
    END_UNIX=$(date --date "$TODAY $END" "+%s")

    DURATION_UNIX=$(($END_UNIX - $START_UNIX))
    DURATION=$(date --utc --date @"$DURATION_UNIX" "+%T")

    echo "$TODAY,$START,$END,$DURATION" >> "$TIMELOG_FILE"

    HEADER=$(head -n 1 "$TIMELOG_FILE")
    LAST_ENTRY=$(tail -n 1 "$TIMELOG_FILE")
    echo ""
    echo -e "$HEADER\n$LAST_ENTRY" | sed 's/,/ ,/g' | column -t -s,
}

trap stop_time EXIT

start_time

while true; do
    NOW_UNIX=$(date "+%s")
    ONGOING_UNIX=$(($NOW_UNIX - $START_UNIX))
    ONGOING=$(date --utc --date @"$ONGOING_UNIX" "+%T")

    echo -en "${CLEAR_LINE}${START} ${ONGOING}"
    sleep 1
done

