pragma ComponentBehavior: Bound

import Quickshell

import QtQuick

import qs.config
import qs.services

Rectangle {
    id: root

    clip: true
    implicitWidth: Appearance.elementSize.notificationList_width

    color: "red"

    bottomLeftRadius: Appearance.rounding.normal
    bottomRightRadius: Appearance.rounding.normal

    ScriptModel {
        id: popups
        values: NotificationService.notifs.filter(el => el.isPopup)
    }

    Behavior on height {
        NumberAnimation {
            duration: 400
            easing.type: Easing.OutQuad
        }
    }

    Repeater {
        model: popups

        property real padding: Appearance.padding.md

        onItemAdded: (index, item) => {
            if (index !== 0) {
                for (let i = count - 1; i >= 0; i--) {
                    let curr = itemAt(i);
                    curr.y = curr.y + curr.height + padding;
                }
            }
            item.y = padding;
            root.height = padding + (padding + item.height) * count;
        }

        onItemRemoved: (index, item) => {
            item.removeAnim.running = true;
            if (count === 0) {
                root.height = 0;
                return;
            }
            root.height = padding + (padding + item.height) * count;
            item.y = root.height + item.height * 2;
        }

        Rectangle {
            id: popup

            required property var modelData
            property alias removeAnim: removeAnim

            color: "green"

            y: -implicitHeight * 2

            anchors.horizontalCenter: root.horizontalCenter

            radius: Appearance.rounding.normal

            implicitHeight: Appearance.elementSize.notificationList_height
            implicitWidth: root.width - Appearance.padding.sm * 2

            PropertyAnimation {
                id: removeAnim
                target: popup
                property: "y"
                to: root.height + popup.height
                duration: 500
            }

            Behavior on y {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.OutQuad
                }
            }

            Text {
                text: parent.modelData.body + " " + parent.modelData.summary
            }
        }
    }
}
