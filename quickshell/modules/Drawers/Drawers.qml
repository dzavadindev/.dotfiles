import Quickshell
import Quickshell.Hyprland

import QtQuick

import qs.components
import qs.config
import qs.services

import "panels"

/*
 TODO: Make a 0 width StyledWindow, then make all the popups part of a PopupWinow
    then make the HyprlandFocusGrab based on the parent, not the actual PopupWindow
    this will actually make the drawers "pop up" from the right side of screen
*/
StyledWindow {
    id: root
    name: "drawers"

    required property int barHeight

    property Item activePopup

    anchors.top: true
    anchors.right: true
    anchors.bottom: true

    exclusionMode: ExclusionMode.Ignore

    implicitWidth: activePopup ? activePopup.implicitWidth : 0

    mask: Region {
        item: popup
    }

    Item {
        id: popup

        implicitWidth: root.activePopup.implicitWidth
        implicitHeight: root.activePopup.implicitHeight

        anchors.bottom: parent.bottom
        anchors.bottomMargin: root.barHeight + Appearance.padding.md

        AudioMixer {
            id: mixer
            visible: false
        }

        // qmllint disable unqualified
        Connections {
            target: DrawersManager
            function onAudioMixerCalled() {
                openPopup(mixer);
            }
        }
        // qmllint enable unqualified
    }

    function openPopup(item: Item) {
        grab.active = true;
        root.activePopup = item;
        root.activePopup.visible = true;
    }

    HyprlandFocusGrab {
        id: grab
        windows: [root]
        onCleared: () => {
            root.activePopup.visible = false;
        }
    }
}
