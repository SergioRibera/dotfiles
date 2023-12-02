#!/bin/env bash

U=$2
START_WORK_DAY="monday"
END_WORK_DAY="friday"
CAL_REGIONS=("es.bo")

DOW=$(date +%u)
START_WD=$(date -d $START_WORK_DAY +%u)
END_WD=$(date -d $END_WORK_DAY +%u)
TODAY_AM=$(date -d "00:01" -u +"%Y-%m-%dT%H:%M:%SZ")
TODAY_PM=$(date -d "23:59" -u +"%Y-%m-%dT%H:%M:%SZ")

function launch_work_day {
    echo "Launching applications and services"
    # Launch Slack
    slack -u -s $U &
    # Enable and start AWS VPN
    systemctl start awsvpnclient
    # Start Email Client
    mailspring --background $U
    # Show Notification
    sleep 30s && notify-send -u NORMAL "System Notification" "Have a good work day"
}

function stop_work_day {
    systemctl stop awsvpnclient &
    exit 0
}

if [ "$1" = "end" ]; then
    stop_work_day
fi

if [[ $DOW -lt $END_WD && $DOW -gt $START_WD ]]; then
    HOLIDAY=0
    for region in $CAL_REGIONS; do
        url="${CAL_BASE_URL}/${region}%23${BASE_CALENDAR_ID_FOR_PUBLIC_HOLIDAY}/events?key=${CALENDAR_API_KEY}&timeMax=${TODAY_PM}&timeMin=${TODAY_AM}&timeZone=UTC"
        res_json=$(curl -s $url)
        if echo $res_json | jq -e '.items[]'; then
            HOLIDAY=$(echo $res_json | jq -r '.items[] | .summary,.start.date')
            break
        fi
    done
    if [ "$HOLIDAY" = "0" ]; then
        launch_work_day
    else
        echo "Happy not working day"
        sleep 30s && notify-send -u NORMAL "${HOLIDAY[0]}" "${HOLIDAY[1]}"
    fi
fi
