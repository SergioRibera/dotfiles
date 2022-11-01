#!/bin/env bash

DOW=$(date +%u)
U=$2
YESTERDAY=$(date -d "yesterday 07:00" -u +"%Y-%m-%dT%H:%M:%SZ")
TODAY=$(date -d "07:00" -u +"%Y-%m-%dT%H:%M:%SZ")
CAL_REGIONS=("es.bo")

function launch_work_day {
    # Launch Slack
    slack -u -s $U &
    # Enable and start AWS VPN
    systemctl start awsvpnclient &
    # Start Email Client
    mailspring --background $U &
    # Show Notification
    sleep 2m && notify-send -u NORMAL "System Notification" "Have a good work day"
}

function stop_work_day {
    systemctl stop awsvpnclient &
    exit 0
}

if [ "$1" = "end" ]; then
    stop_work_day
fi

if [[ $DOW -lt 6 && $DOW -gt 0 ]]; then
    HOLIDAY=0
    for region in $CAL_REGIONS; do
        url="${CAL_BASE_URL}/${region}%23${BASE_CALENDAR_ID_FOR_PUBLIC_HOLIDAY}/events?key=${CALENDAR_API_KEY}&timeMax=${TODAY}&timeMin=${YESTERDAY}&timeZone=UTC"
        res_json=$(curl -s $url)
        if echo $res_json | jq -e '.items[]'; then
            HOLIDAY=$(echo $res_json | jq -r '.items[] | .summary,.start.date')
            break
        fi
    done
    if [ "$HOLIDAY" = "0" ]; then
        launch_work_day
    else
        sleep 2m && notify-send -u NORMAL "${HOLIDAY[0]}" "${HOLIDAY[1]}"
    fi
fi
