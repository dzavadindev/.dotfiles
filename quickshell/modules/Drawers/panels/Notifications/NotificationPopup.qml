pragma ComponentBehavior: Bound

import Quickshell

import QtQuick

import qs.config
import qs.services

Rectangle {
    id: root

    implicitWidth: Appearance.elementSize.notificationList_width

    color: "red"

    bottomLeftRadius: Appearance.rounding.normal
    bottomRightRadius: Appearance.rounding.normal

    ScriptModel {
        id: popups
        values: NotificationService.notifs.filter(el => el.isPopup)
    }

    Repeater {
        model: popups

        onItemAdded: (index, item) => {
            item.y = item.height * index + Appearance.padding.sm * count;
            root.height = item.height + item.y + Appearance.padding.md;
        }

        onItemRemoved: (index, item) => {
            if (count === 0) {
                root.height = 0;
                return;
            }
            root.height = item.height * count + Appearance.padding.md;
        }

        Rectangle {
            color: "green"

            y: -implicitHeight * 2

            anchors.horizontalCenter: root.horizontalCenter

            radius: Appearance.rounding.normal

            implicitHeight: Appearance.elementSize.notificationList_height
            implicitWidth: root.width - Appearance.padding.sm * 2
        }
    }
}
