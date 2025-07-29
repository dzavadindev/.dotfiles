#!/bin/bash

CHOICE=$(printf "Shutdown\nReboot\nSuspend\nLogout\nLock" | fuzzel --dmenu --prompt="Power:")

case "$CHOICE" in
Shutdown) systemctl poweroff ;;
Reboot) systemctl reboot ;;
Logout) swaymsg exit ;;
Lock) swaylock ;;
esac
