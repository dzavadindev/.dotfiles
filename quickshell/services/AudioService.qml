pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire as QSPW

import QtQuick

Singleton {
    id: root

    readonly property VolumeState volumeState: VolumeState {}

    readonly property QSPW.PwNode defaultSink: QSPW.Pipewire.defaultAudioSink
    readonly property QSPW.PwNode defaultSource: QSPW.Pipewire.defaultAudioSource
    readonly property var nodes: QSPW.Pipewire.nodes

    property string volumeIcon: volumeState.mute
    property int volume: Math.round(defaultSink.audio.volume * 100)
    property bool isMuted: volume == 0 | defaultSink.audio.muted

    // Bind the defaultSink prop to get access to all props
    property var pw: QSPW.PwObjectTracker {
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

    function getNodeName(node: QSPW.PwNode): string {
        if (node.nickname)
            return node.nickname;
        if (node.description)
            return node.description;
        return node.name;
    }

    function isDefaultNode(node: QSPW.PwNode, category: string): bool {
        if (!node)
            return false;

        if (category === "playbacks")
            return !!defaultSink && defaultSink.id === node.id;

        if (category === "mics")
            return !!defaultSource && defaultSource.id === node.id;

        return false;
    }

    function setPreferredDefault(node: QSPW.PwNode, category: string) {
        if (!node)
            return;

        if (category === "playbacks") {
            if (isDefaultNode(node, category))
                return;
            QSPW.Pipewire.preferredDefaultAudioSink = node;
            return;
        }

        if (category === "mics") {
            if (isDefaultNode(node, category))
                return;
            QSPW.Pipewire.preferredDefaultAudioSource = node;
        }
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
