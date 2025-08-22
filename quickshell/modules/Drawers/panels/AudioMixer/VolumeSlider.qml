import Quickshell
import Quickshell.Services.Pipewire

import QtQuick
import QtQuick.Controls

import qs.config
import qs.components

Row {
    id: root

    required property PwNodeAudio audio

    spacing: Appearance.padding.sm

    CheckBox {
        id: checkbox

        background: MaterialIcon {
            name: checkbox.checked ? "volume_off" : "circle"
            size: Appearance.font.size.lg
        }
        contentItem: Item {}
        indicator: Item {}

        checked: root.audio ? root.audio.muted : false

        onToggled: {
            if (root.audio)
                root.audio.muted = checked;
        }
        enabled: !!root.audio
    }

    Slider {
        id: volume

        implicitWidth: Appearance.elementSize.audioMixer_sliderWidth

        from: 0.0
        to: 1.2

        value: root.audio ? root.audio.volume : 1.0
        onMoved: {
            if (root.audio)
                root.audio.volume = value;
        }

        enabled: !!root.audio

        background: Rectangle {
            x: volume.leftPadding
            y: volume.topPadding + volume.availableHeight / 2 - height / 2

            implicitWidth: Appearance.elementSize.audioMixer_sliderWidth
            implicitHeight: Appearance.elementSize.audioMixer_sliderThickness

            width: volume.availableWidth
            height: implicitHeight

            radius: 2

            color: Appearance.colors.accent

            Rectangle {
                width: volume.visualPosition * parent.width
                height: parent.height
                color: Appearance.colors.secondary
                radius: 2
            }
        }

        handle: Rectangle {
            x: volume.leftPadding + volume.visualPosition * (volume.availableWidth - width)
            y: volume.topPadding + volume.availableHeight / 2 - height / 2

            implicitWidth: 26
            implicitHeight: 26

            radius: 13

            color: Appearance.colors.secondary
        }
    }
}
