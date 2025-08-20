pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

import QtQuick

Singleton {
    id: root

    readonly property VolumeState volumeState: VolumeState {}

    readonly property PwNode defaultSink: Pipewire.defaultAudioSink
    readonly property var nodes: Pipewire.nodes

    property string volumeIcon: volumeState.mute
    property int volume: Math.round(defaultSink.audio.volume * 100)
    property bool isMuted: volume == 0 | defaultSink.audio.muted

    // Bind the defaultSink prop to get access to all props
    property var pw: PwObjectTracker {
        objects: [root.defaultSink]
    }

    // Triggers every time the sink changes (plug/unplug headphones)
    onDefaultSinkChanged: () => updateAudioVolume()

    Connections {
        target: root.defaultSink.audio
        function onMutedChanged() {
            root.updateAudioVolume();
        }
        function onVolumeChanged() {
            root.updateAudioVolume();
        }
    }

    function getNodeName(node: PwNode): string {
        if (node.nickname)
            return node.nickname;
        if (node.description)
            return node.description;
        return node.name;
    }

    function updateAudioVolume() {
        const volume = root.volume;

        if (isMuted) {
            volumeIcon = volumeState.mute;
            return;
        }

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
