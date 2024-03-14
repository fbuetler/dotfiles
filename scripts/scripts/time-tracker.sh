#!/bin/bash

CLEAR_LINE="\r"

TIMELOG_FILE="$HOME/timelog.csv"

SIGINT_RECEIVED=0

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
}

function read_task_once {
    # in case of multiple ctrl+c invocations, we dont prompt
    if [[ $SIGINT_RECEIVED != 0 ]]; then
        return 0
    fi
    SIGINT_RECEIVED=1

    echo ""
    read -r TASK
}

function append_log {
    if [[ ! -f "$TIMELOG_FILE" || ! -s "$TIMELOG_FILE" ]]; then
        echo "date;start;end;duration;tasks" >> "$TIMELOG_FILE"
    fi

    echo "$TODAY;$START;$END;$DURATION;$TASK" >> "$TIMELOG_FILE"
}

function show_summary {
    HEADER=$(head -n 1 "$TIMELOG_FILE")
    LAST_ENTRY=$(tail -n 1 "$TIMELOG_FILE")

    if [[ ${#LAST_ENTRY} -ge 77 ]]; then
        LAST_ENTRY=$(echo "$LAST_ENTRY" | cut -c -77 | sed 's/$/.../')
    fi

    echo ""
    echo -e "$HEADER\n$LAST_ENTRY" | sed 's/;/ ;/g' | column -t -s\;
}

trap "stop_time;read_task_once;append_log;show_summary;exit" SIGINT

start_time

while true; do
    NOW_UNIX=$(date "+%s")
    ONGOING_UNIX=$(($NOW_UNIX - $START_UNIX))
    ONGOING=$(date --utc --date @"$ONGOING_UNIX" "+%T")

    echo -en "${CLEAR_LINE}${START} ${ONGOING}"
    sleep 1
done

