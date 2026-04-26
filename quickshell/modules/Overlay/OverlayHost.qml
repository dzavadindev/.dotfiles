pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland

import QtQuick

import qs.components
import qs.config
import qs.services

import "panels/AudioMixer"
import "panels/Notifications"
import "ambient"

StyledWindow {
    id: root
    name: "overlay"

    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }

    exclusiveZone: 0
    exclusionMode: ExclusionMode.Ignore

    readonly property bool audioMixerActive: OverlayManager.isActive(OverlayManager.panel.audioMixer)
    readonly property bool notificationCenterActive: OverlayManager.isActive(OverlayManager.panel.notificationCenter)

    mask: Region {
        Region {
            x: root.audioMixerActive ? audioMixerSurface.x : 0
            y: root.audioMixerActive ? audioMixerSurface.y : 0
            width: root.audioMixerActive ? audioMixerSurface.width : 0
            height: root.audioMixerActive ? audioMixerSurface.height : 0
        }
        Region {
            x: root.notificationCenterActive ? notificationCenterSurface.x : 0
            y: root.notificationCenterActive ? notificationCenterSurface.y : 0
            width: root.notificationCenterActive ? notificationCenterSurface.width : 0
            height: root.notificationCenterActive ? notificationCenterSurface.height : 0
        }
        Region {
            item: notificationPopupLane
        }
    }

    EdgeSlideSurface {
        id: audioMixerSurface
        open: root.audioMixerActive
        hostWidth: root.width

        anchors.bottom: parent.bottom
        anchors.bottomMargin: Appearance.padding.md

        AudioMixerPanel {
            id: audioMixerPanel
        }
    }

    EdgeSlideSurface {
        id: notificationCenterSurface
        open: root.notificationCenterActive
        hostWidth: root.width

        anchors.bottom: parent.bottom
        anchors.bottomMargin: Appearance.padding.md

        NotificationCenterPanel {}
    }

    // The element to hold the notifications that pop out at the top of the screen
    Item {
        id: notificationPopupLane

        implicitHeight: notificationPopupSurface.implicitHeight
        implicitWidth: notificationPopupSurface.implicitWidth + Appearance.padding.lg

        anchors.top: parent.top
        anchors.left: parent.left

        NotificationPopupSurface {
            id: notificationPopupSurface
        }
    }

    HyprlandFocusGrab {
        id: grab
        windows: [root]
    }

    Connections {
        target: OverlayManager

        function onActiveChanged(_oldId, newId) {
            grab.active = newId !== "";
        }
    }

    Connections {
        target: grab

        function onActiveChanged() {
            if (!grab.active)
                OverlayManager.closeAll();
        }
    }
}
