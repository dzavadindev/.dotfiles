import Quickshell

import QtQuick

import qs.services
import qs.config
import qs.components

Rectangle {
    id: notifications

    readonly property bool active: OverlayManager.isActive(OverlayManager.panel.notificationCenter)

    color: active ? Appearance.colors.secondary : Appearance.colors.primary_light

    implicitWidth: notificationsIcon.implicitWidth + Appearance.padding.sm * 2
    implicitHeight: notificationsIcon.implicitHeight + Appearance.padding.sm

    MouseArea {
        anchors.fill: parent

        onClicked: OverlayManager.toggle(OverlayManager.panel.notificationCenter)
    }

    Behavior on color {
        ColorAnimation {
            duration: 300
            easing.type: Easing.OutQuad
        }
    }

    MaterialIcon {
        id: notificationsIcon

        anchors.centerIn: parent

        name: "notifications"
        size: Appearance.font.size.md
        color: notifications.active ? Appearance.colors.primary : Appearance.colors.secondary
        weight: Font.Bold

        Behavior on color {
            ColorAnimation {
                duration: 300
                easing.type: Easing.OutQuad
            }
        }
    }
}
