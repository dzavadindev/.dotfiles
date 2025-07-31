#!/bin/bash

# List paired + discovered devices
devices=$(bluetoothctl devices | awk '{print $2 " " substr($0, index($0,$3))}')
if [ -z "$devices" ]; then
  notify-send "Bluetooth" "No devices found"
  exit 1
fi

selection=$(echo "$devices" | fuzzel --dmenu -p "Bluetooth Device:")

[ -z "$selection" ] && exit

# Extract MAC address from selection
mac=$(echo "$selection" | awk '{print $1}')

# Check if connected
connected=$(bluetoothctl info "$mac" | grep "Connected: yes")

# Toggle: disconnect if connected, connect if not
if [ -n "$connected" ]; then
  bluetoothctl disconnect "$mac"
  notify-send "Bluetooth" "Disconnected $mac"
else
  bluetoothctl connect "$mac"
  notify-send "Bluetooth" "Connected $mac"
fi
