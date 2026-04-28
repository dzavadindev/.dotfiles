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

    spacing: Appearance.padding.sm

    RadioButton {
        id: defaultSelector

        visible: root.supportsDefaultSelection
        enabled: root.supportsDefaultSelection && !!root.node
        checked: root.supportsDefaultSelection && AudioService.isDefaultNode(root.node, root.category)

        onClicked: AudioService.setPreferredDefault(root.node, root.category)

        background: MaterialIcon {
            name: defaultSelector.checked ? "radio_button_checked" : "radio_button_unchecked"
            size: Appearance.font.size.lg
        }

        contentItem: Item {}
        indicator: Item {}
    }

    Slider {
        id: volume

        enabled: !!root.audio

        implicitWidth: Appearance.elementSize.audioMixer_sliderWidth

        from: 0
        to: 1.0

        value: root.audio ? root.audio.volume : 1.0

        onMoved: {
            if (root.audio)
                root.audio.volume = value;
        }

        background: RevealTrack {
            progress: volume.visualPosition

            radius: Appearance.rounding.full

            baseColor: Appearance.colors.accent
            fillColor: Appearance.colors.secondary
        }

        handle: Rectangle {
            implicitHeight: Appearance.elementSize.audioMixer_sliderThickness
            implicitWidth: Appearance.padding.xs

            color: Appearance.colors.secondary
        }
    }
}
