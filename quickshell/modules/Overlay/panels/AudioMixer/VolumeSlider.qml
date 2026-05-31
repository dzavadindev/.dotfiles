import Quickshell
import Quickshell.Services.Pipewire as PW

import QtQuick
import QtQuick.Controls

import qs.config
import qs.components
import qs.services

Row {
    id: root

    required property PW.PwNodeAudio audio
    required property PW.PwNode node
    required property string category

    readonly property bool supportsDefaultSelection: category === "playbacks" || category === "mics"
    readonly property bool isDefaultNode: root.supportsDefaultSelection && AudioService.isDefaultNode(root.node, root.category)
    property real pendingVolume: 0
    property real lastSentVolume: -1
    readonly property real volumeWriteEpsilon: 0.01

    spacing: Appearance.padding.sm

    Item {
        id: defaultSelector
        visible: root.supportsDefaultSelection
        enabled: !!root.node

        implicitWidth: indicatorIcon.implicitWidth
        implicitHeight: indicatorIcon.implicitHeight

        MaterialIcon {
            id: indicatorIcon

            anchors.centerIn: parent

            name: root.isDefaultNode ? "radio_button_checked" : "radio_button_unchecked"
            size: Appearance.font.size.lg
        }

        MouseArea {
            anchors.fill: parent
            enabled: parent.enabled

            onClicked: AudioService.setPreferredDefault(root.node, root.category)
        }
    }

    Slider {
        id: volume

        enabled: !!root.audio
        live: true

        implicitWidth: Appearance.elementSize.audioMixer_sliderWidth

        from: 0
        to: 1.0

        value: root.audio ? root.audio.volume : 1.0

        onValueChanged: {
            if (!root.audio || !pressed)
                return;

            root.pendingVolume = value;
            if (!volumeFlush.running)
                volumeFlush.start();
        }

        onPressedChanged: {
            if (pressed || !root.audio)
                return;

            volumeFlush.stop();
            root.pendingVolume = value;
            root.flushPendingVolume(true);
        }

        background: Item {
            implicitHeight: Appearance.elementSize.audioMixer_sliderThickness

            MaskedProgressTrack {
                anchors.fill: parent

                progress: volume.visualPosition
                radius: Appearance.rounding.full
                baseColor: Appearance.colors.tertiary
                fillColor: Appearance.colors.tertiary_contrast
            }
        }

        handle: Item {
            implicitHeight: Appearance.elementSize.audioMixer_sliderThickness
            implicitWidth: Appearance.elementSize.audioMixer_sliderThickness
        }
    }

    Timer {
        id: volumeFlush

        interval: 30
        repeat: true
        running: false

        onTriggered: root.flushPendingVolume(false)
    }

    function flushPendingVolume(force: bool) {
        if (!root.audio)
            return;

        if (!force && Math.abs(root.pendingVolume - root.lastSentVolume) < root.volumeWriteEpsilon)
            return;

        root.audio.volume = root.pendingVolume;
        root.lastSentVolume = root.pendingVolume;
    }
}
