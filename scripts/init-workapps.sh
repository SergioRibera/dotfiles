#!/bin/env bash

DOW=$(date +%u)
U=$1

if [[ $DOW -lt 6 && $DOW -gt 0 ]]; then
    # Launch Slack
    slack -u -s $1 &
    # Enable and start AWS VPN
    systemctl start awsvpnclient &
    # Show Notification
    notify-send -u NORMAL "System Notification" "Have a good work day"
fi
