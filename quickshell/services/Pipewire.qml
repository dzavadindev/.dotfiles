pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

import QtQuick

Singleton {
    id: root

    readonly property VolumeState volumeState: VolumeState {}
    readonly property PwNode defaultSink: Pipewire.defaultAudioSink

    property var pw: PwObjectTracker {
        objects: [root.defaultSink]
    }

    property string volumeIcon: volumeState.high
    property int volume: Math.round(defaultSink.audio.volume * 100)
    property bool isMuted: false

    // Triggers every time the sink changes (plug/unplug headphones)
    onDefaultSinkChanged: () => {}

    onVolumeChanged: () => {
        const volume = root.volume;

        if (volume == 0) {
            isMuted = true;
            volumeIcon = volumeState.mute;
            return;
        }

        isMuted = false;

        if (volume > 50) {
            volumeIcon = volumeState.high;
            return;
        }

        if (volume > 1) {
            volumeIcon = volumeState.mid;
            return;
        }
    }

    component VolumeState: QtObject {
        readonly property string high: "volume_up"
        readonly property string mid: "volume_down"
        readonly property string mute: "no_sound"
    }
}
