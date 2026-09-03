#!/usr/bin/env bash
set -euo pipefail

screenshots_dir="$HOME/Pictures/Screenshots"
mkdir -p "$screenshots_dir"

file="$screenshots_dir/screenshot-$(date +%Y-%m-%d_%H-%M-%S).png"

grim -g "$(slurp)" "$file"
notify-send "Screenshot saved" "$file"
