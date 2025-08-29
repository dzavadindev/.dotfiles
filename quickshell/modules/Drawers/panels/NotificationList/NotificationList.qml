pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.Notifications

import QtQuick

import qs.config
import qs.services

Rectangle {
    id: root

    readonly property bool showNotificationCenter: NotificationService.showNotificationCenter
    readonly property bool hasContent: notificationsList.contentHeight !== 0

    implicitWidth: Appearance.elementSize.notificationList_width
    implicitHeight: notificationsList.contentHeight + Appearance.padding.lg
    // implicitHeight: hasContent ? notificationsList.contentHeight + Appearance.padding.lg : 0

    color: Appearance.colors.primary

    bottomLeftRadius: Appearance.rounding.normal
    bottomRightRadius: Appearance.rounding.normal

    Behavior on implicitHeight {
        NumberAnimation {
            duration: 500
            easing.type: Easing.OutQuad
        }
    }

    ListView {
        id: notificationsList

        anchors.fill: parent
        anchors.topMargin: Appearance.padding.sm

        clip: true
        spacing: Appearance.padding.sm

        orientation: Qt.Vertical
        verticalLayoutDirection: Qt.TopToBottom

        model: root.showNotificationCenter ? NotificationService.notifs : NotificationService.notifs.filter(el => el.isPopup)

        Transition {
            id: slideFromTop
            NumberAnimation {
                properties: "y"
                from: 0
                duration: 500
            }
        }

        Transition {
            id: slideToBottom
            NumberAnimation {
                properties: "y"
                to: 0
                duration: 500
            }
        }

        Transition {
            id: displaced
            NumberAnimation {
                properties: "x,y"
                duration: 1000
            }
        }

        // add: slideFromTop
        // displaced: displaced
        // remove: slideToBottom
        // populate: slideFromTop

        delegate: NotificationItem {
            width: ListView.view.width - Appearance.padding.sm * 2
            height: 100

            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    component NotificationItem: Rectangle {
        required property var modelData

        radius: Appearance.rounding.normal

        border.color: Appearance.colors.secondary
        border.width: Appearance.borderWidth.sm

        color: Appearance.colors.primary

        Text {
            anchors.centerIn: parent

            color: "#fff000"
            font.pointSize: 15

            text: modelData.body + " | " + modelData.summary
        }
    }
}
