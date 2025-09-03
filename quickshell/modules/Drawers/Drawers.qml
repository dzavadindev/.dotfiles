pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland

import QtQuick

import qs.components
import qs.config
import qs.services

import "panels/AudioMixer"
import "panels/Notifications"

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

    implicitWidth: Math.max(audioMixerWrapper.implicitWidth, notificationPopupWrapper.implicitWidth)

    mask: Region {
        Region {
            item: audioMixerWrapper
        }
        Region {
            item: notificationPopupWrapper
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

    // The element to hold the notification that pop out at the top of the screen
    Rectangle {
        id: notificationPopupWrapper

        implicitHeight: notificationPopup.implicitHeight
        implicitWidth: notificationPopup.implicitWidth + Appearance.padding.md * 2

        anchors.top: parent.top
        anchors.right: parent.right

        NotificationPopup {
            id: notificationPopup
        }
    }

    Connections {
        target: DrawersManager
        function onAudioMixerCalled() {
            grab.active = true;
            audioMixerWrapper.open();
        }
        // function onNotificationCenterCalled() {
        //     grab.active = true;
        //     notificationListWrapper.open();
        // }
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
