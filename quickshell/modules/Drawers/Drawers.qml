import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

import QtQuick

import qs.components
import qs.config
import qs.services

import "panels/AudioMixer"

StyledWindow {
    id: root
    name: "drawers"

    required property int barHeight

    anchors.top: true
    anchors.right: true
    anchors.bottom: true

    implicitWidth: 0

    exclusionMode: ExclusionMode.Ignore

    DrawerPopup {
        id: audiomixer

        grab: grab
        parentWindow: root
        barHeight: root.barHeight

        implicitHeight: Appearance.drawerSize.tall.y
        implicitWidth: Appearance.drawerSize.tall.x

        AudioMixer {
            id: audioMixerMenu

            anchors.fill: parent
        }

        Connections {
            target: DrawersManager
            function onAudioMixerCalled() {
                audiomixer.openPopup();
            }
        }
    }

    HyprlandFocusGrab {
        id: grab
        windows: [root, audiomixer]
    }
}
