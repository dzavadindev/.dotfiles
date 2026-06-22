#!/usr/bin/env bash
set -euo pipefail

# LOCK="/tmp/screenshot-satty.lock"
#
# if [ -e "$LOCK" ]; then
#   exit 0
# fi
#
# trap 'rm -f "$LOCK"; pkill -x satty 2>/dev/null || true' EXIT
# touch "$LOCK"
#
# current_ws="$(hyprctl activeworkspace -j | jq -r '.name')"
#
# geometry="$(slurp)" || exit 0
#
# hyprctl dispatch 'hl.dsp.workspace.toggle_special("screenshot")'
#
# grim -g "$geometry" - | satty --filename - --copy-command wl-copy
#
# hyprctl dispatch 'hl.dsp.workspace.toggle_special("screenshot")'
# hyprctl dispatch 'hl.dsp.focus({ workspace = "'"$current_ws"'" })'

grim -g "$(slurp)" - | wl-copy
notify-send "" "Screenshot ready to paste"
