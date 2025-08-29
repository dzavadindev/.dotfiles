pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland

import QtQuick

import qs.components
import qs.config
import qs.services

import "panels/AudioMixer"
import "panels/NotificationList"

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

    implicitWidth: Math.max(audioMixerWrapper.implicitWidth, notificationListWrapper.implicitWidth)

    mask: Region {
        Region {
            item: audioMixerWrapper
        }
        Region {
            item: notificationListWrapper
        }
    }

    DrawerSlot {
        id: audioMixerWrapper

        implicitHeight: audioMixer.implicitHeight
        implicitWidth: audioMixer.implicitWidth

        anchors.bottom: parent.bottom
        anchors.bottomMargin: Appearance.padding.md

        x: root.implicitWidth

        onOpen: () => this.x = root.implicitWidth - implicitWidth
        onClose: () => this.x = root.implicitWidth

        AudioMixer {
            id: audioMixer
        }
    }

    DrawerSlot {
        id: notificationListWrapper

        implicitHeight: notificationList.implicitHeight
        implicitWidth: notificationList.implicitWidth + Appearance.padding.lg

        anchors.top: parent.top
        anchors.right: parent.right

        onOpen: () => NotificationService.showNotificationCenter = true
        onClose: () => NotificationService.showNotificationCenter = false

        NotificationList {
            id: notificationList
        }
    }

    Connections {
        target: DrawersManager
        function onAudioMixerCalled() {
            grab.active = true;
            audioMixerWrapper.open();
        }
        function onNotificationCenterCalled() {
            grab.active = true;
            notificationListWrapper.open();
        }
    }

    HyprlandFocusGrab {
        id: grab
        windows: [root]
    }

    component DrawerSlot: Item {
        id: slot

        signal open
        signal close

        Connections {
            target: grab
            function onActiveChanged() {
                if (!grab.active)
                    slot.close();
            }
        }

        Behavior on x {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutQuad
            }
        }

        Behavior on y {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutQuad
            }
        }
    }
}
