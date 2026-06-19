pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

import QtQuick

import qs.components
import qs.components.surfaces
import qs.config
import qs.services

import "panels/AudioMixer"
import "panels/Notifications"
import "panels/PowerMenu"
import "panels/WallpaperCarousel"
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
    readonly property bool powerMenuActive: OverlayManager.isActive(OverlayManager.panel.powerMenu)
    readonly property bool wallpaperCarouselActive: OverlayManager.isActive(OverlayManager.panel.wallpaperCarousel)

    readonly property list<PanelSurface> managedSurfaces: [wallpaperCarouselSurface, audioMixerSurface, notificationCenterSurface, powerMenuSurface]
    readonly property PanelSurface activeSurface: managedSurfaces.find(surface => surface.open) ?? null

    FocusScope {
        id: keyEventScope

        anchors.fill: parent
        focus: OverlayManager.isOpen

        Keys.onPressed: event => {
            if (!root.activeSurface)
                return;

            if (root.activeSurface.handleKeypress(event)) {
                event.accepted = true;
                return;
            }

            if (!root.activeSurface.closeOnAnyKeypress)
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
            x: root.powerMenuActive ? powerMenuSurface.x : 0
            y: root.powerMenuActive ? powerMenuSurface.y : 0
            width: root.powerMenuActive ? powerMenuSurface.width : 0
            height: root.powerMenuActive ? powerMenuSurface.height : 0
        }

        Region {
            x: root.wallpaperCarouselActive ? wallpaperCarouselSurface.x : 0
            y: root.wallpaperCarouselActive ? wallpaperCarouselSurface.y : 0
            width: root.wallpaperCarouselActive ? wallpaperCarouselSurface.width : 0
            height: root.wallpaperCarouselActive ? wallpaperCarouselSurface.height : 0
        }

        Region {
            item: notificationPopupLane
        }
    }

    FadeSurface {
        id: wallpaperCarouselSurface

        managedPanelId: OverlayManager.panel.wallpaperCarousel
        open: root.wallpaperCarouselActive
        closeOnAnyKeypress: true

        function handleKeypress(event): bool {
            if (event.key === Qt.Key_Left) {
                wallpaperCarouselPanel.moveLeft();
                return true;
            }

            if (event.key === Qt.Key_Right) {
                wallpaperCarouselPanel.moveRight();
                return true;
            }

            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                wallpaperCarouselPanel.applySelected();
                OverlayManager.closeAll();
                return true;
            }

            return false;
        }

        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: Appearance.padding.md

        WallpaperCarouselPanel {
            id: wallpaperCarouselPanel
        }
    }

    EdgeSlideSurface {
        id: audioMixerSurface

        managedPanelId: OverlayManager.panel.audioMixer
        open: root.audioMixerActive
        closeOnAnyKeypress: true
        hostWidth: root.width
        hostHeight: root.height

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
        hostHeight: root.height

        anchors.bottom: parent.bottom
        anchors.bottomMargin: Appearance.padding.md

        NotificationCenterPanel {}
    }

    FadeSurface {
        id: powerMenuSurface

        managedPanelId: OverlayManager.panel.powerMenu
        open: root.powerMenuActive
        closeOnAnyKeypress: true

        onOpened: powerMenuPanel.resetSelection()

        function handleKeypress(event): bool {
            if (event.key === Qt.Key_Left) {
                powerMenuPanel.moveLeft();
                return true;
            }

            if (event.key === Qt.Key_Right) {
                powerMenuPanel.moveRight();
                return true;
            }

            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                powerMenuPanel.executeSelected();
                OverlayManager.closeAll();
                return true;
            }

            return false;
        }

        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: Appearance.padding.md

        PowerMenuPanel {
            id: powerMenuPanel
        }
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
