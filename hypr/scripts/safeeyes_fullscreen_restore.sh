#!/usr/bin/env bash

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
SAFE_CLASS="io.github.slgobinath.SafeEyes"

prev_addr=""
prev_fullscreen_mode="0"
safeeyes_addr=""

get_client_field() {
    local addr="$1"
    local field="$2"

    hyprctl -j clients | jq -r --arg addr "$addr" --arg field "$field" '
        .[]
        | select(.address == $addr)
        | .[$field] // empty
    '
}

get_previous_focused_client() {
    local safe_addr="$1"

    hyprctl -j clients | jq -r --arg safe "$safe_addr" '
        [
            .[]
            | select(.address != $safe)
            | select(.hidden == false)
        ]
        | sort_by(.focusHistoryID)
        | .[0].address // empty
    '
}

focus_client() {
    local addr="$1"
    hyprctl dispatch focuswindow "address:$addr" >/dev/null 2>&1
}

restore_fullscreen_mode() {
    local addr="$1"
    local mode="$2"

    [[ -z "$addr" || "$mode" == "0" || "$mode" == "null" ]] && return

    focus_client "$addr"
    sleep 0.1

    current_mode="$(get_client_field "$addr" fullscreen)"

    if [[ "$current_mode" != "$mode" ]]; then
        hyprctl dispatch fullscreen "$mode" >/dev/null 2>&1
    fi
}

socat -U - UNIX-CONNECT:"$SOCKET" | while read -r line; do
    event="${line%%>>*}"
    data="${line#*>>}"

    case "$event" in
        openwindow)
            IFS=',' read -r addr workspace class title <<< "$data"

            if [[ "$class" == "$SAFE_CLASS" ]]; then
                safeeyes_addr="$addr"

                prev_addr="$(get_previous_focused_client "$safeeyes_addr")"

                if [[ -n "$prev_addr" ]]; then
                    prev_fullscreen_mode="$(get_client_field "$prev_addr" fullscreen)"
                else
                    prev_fullscreen_mode="0"
                fi
            fi
            ;;

        closewindow)
            closed_addr="$data"

            if [[ "$closed_addr" == "$safeeyes_addr" ]]; then
                if [[ "$prev_fullscreen_mode" != "0" ]]; then
                    restore_fullscreen_mode "$prev_addr" "$prev_fullscreen_mode"
                fi

                prev_addr=""
                prev_fullscreen_mode="0"
                safeeyes_addr=""
            fi
            ;;
    esac
done
