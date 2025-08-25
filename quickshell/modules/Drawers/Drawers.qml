pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland

import QtQuick

import qs.components
import qs.config
import qs.services

import "panels/AudioMixer"

StyledWindow {
    id: root
    name: "drawers"

    anchors {
        right: true
        top: true
        bottom: true
    }

    exclusiveZone: 0
    exclusionMode: ExclusionMode.Ignore

    implicitWidth: Math.max(audioMixerWrapper.implicitWidth)

    mask: Region {
        Region {
            item: audioMixerWrapper
        }
    }

    DrawerSlot {
        id: audioMixerWrapper

        implicitHeight: audioMixer.implicitHeight
        implicitWidth: audioMixer.implicitWidth

        AudioMixer {
            id: audioMixer
        }
    }

    Connections {
        target: DrawersManager
        function onAudioMixerCalled() {
            grab.active = true;
            audioMixerWrapper.open();
        }
    }

    HyprlandFocusGrab {
        id: grab
        windows: [root]
    }

    component DrawerSlot: Item {
        id: slot

        anchors.bottom: parent.bottom
        anchors.bottomMargin: Appearance.padding.md

        x: implicitWidth

        function open() {
            this.x = 0;
        }

        function close() {
            this.x = this.implicitWidth;
        }

        Connections {
            target: grab
            function onActiveChanged() {
                if (grab.active)
                    slot.open();
                else
                    slot.close();
            }
        }

        Behavior on x {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutQuad
            }
        }
    }
}
