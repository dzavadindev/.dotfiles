pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets

import QtQuick

import qs.config
import qs.services
import qs.components

RollingListView {
    id: root

    ScriptModel {
        id: notificationsModel
        values: NotificationService.notifs.filter(el => el.isPopup).reverse()
    }

    model: notificationsModel

    wrapperColor: Appearance.colors.primary
    wrapperBottomRadius: Appearance.rounding.normal

    implicitWidth: Appearance.elementSize.notificationListItem_width

    delegate: Rectangle {
        id: notificationItem

        property var modelData

        color: Appearance.colors.secondary
        radius: Appearance.rounding.normal

        implicitHeight: Appearance.elementSize.notificationListItem_height

        Row {
            anchors.fill: parent

            leftPadding: 10
            topPadding: 10

            spacing: Appearance.padding.md

            Rectangle {
                implicitHeight: notificationItem.implicitHeight - Appearance.padding.sm
                implicitWidth: implicitHeight
            }

            Text {
                color: Appearance.colors.primary
                text: notificationItem.modelData.body + " " + notificationItem.modelData.summary + " " + notificationItem.modelData.timeStr
            }
        }
    }
}
