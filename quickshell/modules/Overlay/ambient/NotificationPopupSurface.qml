pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets

import QtQuick
import QtQuick.Layouts

import qs.config
import qs.services
import qs.components

RollingListView {
    id: root

    model: notificationsModel

    wrapperColor: Appearance.colors.primary
    wrapperBottomRadius: Appearance.rounding.normal
    wrapperYPadding: Appearance.padding.sm

    implicitWidth: Appearance.elementSize.notificationListItem_width

    ScriptModel {
        id: notificationsModel
        values: NotificationService.notifs.filter(el => el.isPopup).reverse()
    }

    delegate: Rectangle {
        id: notificationItem

        property var modelData

        color: Appearance.colors.secondary
        radius: Appearance.rounding.normal

        implicitHeight: Appearance.elementSize.notificationListItem_height

        Item {
            id: icon

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            anchors.leftMargin: root.implicitWidth * 0.025

            implicitHeight: notificationItem.implicitHeight - Appearance.padding.md
            implicitWidth: root.implicitWidth * 0.2

            IconImage {
                anchors.fill: parent

                source: Quickshell.iconPath(notificationItem.modelData.appIcon, "")
            }
        }

        Item {
            anchors.left: icon.right
            anchors.top: icon.top

            anchors.leftMargin: root.implicitWidth * 0.025
            anchors.topMargin: root.implicitWidth * 0.035

            Text {
                id: appName

                anchors.top: parent.top
                anchors.left: parent.left

                color: Appearance.colors.primary
                font.family: Appearance.font.family.mono
                font.pointSize: Appearance.font.size.md
                text: notificationItem.modelData.appName.toUpperCase()
            }

            Text {
                id: summary

                anchors.left: appName.right
                anchors.top: parent.top

                anchors.leftMargin: root.implicitWidth * 0.025

                color: Appearance.colors.primary
                font.family: Appearance.font.family.mono
                font.pointSize: Appearance.font.size.sm
                text: notificationItem.modelData.summary
            }

            Text {
                id: body

                anchors.top: summary.bottom
                anchors.left: appName.left
                anchors.topMargin: root.implicitWidth * 0.01

                color: Appearance.colors.primary
                text: notificationItem.modelData.body
                font.pointSize: Appearance.font.size.sm
            }
        }
    }
}
