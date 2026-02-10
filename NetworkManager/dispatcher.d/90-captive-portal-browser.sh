#!/usr/bin/env bash

INTERFACE="$1"
EVENT="$2"

if [[ "$EVENT" != "up" ]]; then
    exit 0
fi

CONNECTIVITY=$(nmcli -t -f CONNECTIVITY general)

if [[ "$CONNECTIVITY" == "portal" ]]; then
    # Avoid opening multiple tabs
    LOCK="/tmp/nm-captive-${INTERFACE}.lock"
    if [[ -f "$LOCK" ]]; then
        exit 0
    fi
    touch "$LOCK"

    notify-send "Network login required" "Opening captive portal"

    # Force a HTTP request to trigger redirect
    xdg-open "http://neverssl.com" >/dev/null 2>&1 &
fi
