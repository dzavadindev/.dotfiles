#!/bin/bash

ARTIST_PROFILE=krita_preset
ABSOLUTE_PROFILE=osu_preset

notification(){
    notify-send -a 'Krita Launcher' -i /usr/share/pixmaps/otd.png "$@"
}

otd applypreset "$ARTIST_PROFILE" &

krita &

wait %1
notification "Artist Mode enabled"

wait %2
otd applypreset "$ABSOLUTE_PROFILE"
notification "Artist Mode disabled (osu profile loaded)"
