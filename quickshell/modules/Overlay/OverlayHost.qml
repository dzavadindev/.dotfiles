pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

import QtQuick

import qs.components
import qs.components.surfaces
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
    focusable: OverlayManager.isOpen
    WlrLayershell.keyboardFocus: OverlayManager.isOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    readonly property bool audioMixerActive: OverlayManager.isActive(OverlayManager.panel.audioMixer)
    readonly property bool notificationCenterActive: OverlayManager.isActive(OverlayManager.panel.notificationCenter)
    readonly property list<PanelSurface> managedSurfaces: [audioMixerSurface, notificationCenterSurface]
    readonly property PanelSurface activeSurface: managedSurfaces.find(surface => surface.open) ?? null

    FocusScope {
        id: keyEventScope

        anchors.fill: parent
        focus: OverlayManager.isOpen

        Keys.onPressed: event => {
            if (!root.activeSurface || !root.activeSurface.closeOnAnyKeypress)
                return;

            if (!root.activeSurface.shouldCloseOnKeypress(event))
                return;

            OverlayManager.closeAll();
            event.accepted = true;
        }
    }

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
        managedPanelId: OverlayManager.panel.audioMixer
        open: root.audioMixerActive
        closeOnAnyKeypress: true
        hostWidth: root.width

        anchors.bottom: parent.bottom
        anchors.bottomMargin: Appearance.padding.md

        AudioMixerPanel {
            id: audioMixerPanel
        }
    }

    EdgeSlideSurface {
        id: notificationCenterSurface
        managedPanelId: OverlayManager.panel.notificationCenter
        open: root.notificationCenterActive
        closeOnAnyKeypress: true
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
        anchors.right: parent.right

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
            if (newId !== "")
                keyEventScope.forceActiveFocus();
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
