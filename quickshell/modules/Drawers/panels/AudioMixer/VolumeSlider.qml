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

        enabled: !!root.audio

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

        background: Rectangle {
            radius: Appearance.rounding.full

            color: Appearance.colors.accent

            Rectangle {
                implicitWidth: volume.visualPosition * parent.width
                implicitHeight: parent.height

                radius: Appearance.rounding.full

                color: Appearance.colors.secondary
            }
        }

        handle: Rectangle {
            implicitHeight: Appearance.elementSize.audioMixer_sliderThickness

            color: Appearance.colors.secondary
        }
    }
}
