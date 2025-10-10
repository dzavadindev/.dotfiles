pragma ComponentBehavior: Bound

import Quickshell

import QtQuick

import qs.config
import qs.services

Rectangle {
    id: root

    clip: true

    property bool isEmpty: true

    implicitWidth: Appearance.elementSize.notificationList_width
    implicitHeight: isEmpty ? popupList.implicitHeight + Appearance.padding.sm : 0

    color: "red"

    bottomLeftRadius: Appearance.rounding.normal
    bottomRightRadius: Appearance.rounding.normal

    ScriptModel {
        id: popups
        values: NotificationService.notifs.filter(el => el.isPopup)
    }

    Behavior on implicitHeight {
        NumberAnimation {
            duration: 400
            easing.type: Easing.OutQuad
        }
    }

    ListView {
        id: popupList

        model: popups

        property real padding: Appearance.padding.sm

        verticalLayoutDirection: ListView.BottomToTop

        implicitHeight: isEmpty ? contentHeight + padding : 0
        implicitWidth: contentItem.childrenRect.width + padding

        anchors.horizontalCenter: root.horizontalCenter

        spacing: padding

        onContentHeightChanged: () => root.isEmpty = contentHeight != 0

        // displaced: Transition {
        //     NumberAnimation {
        //         properties: "y"
        //         duration: 400
        //     }
        // }
        //
        // add: Transition {
        //     NumberAnimation {
        //         property: "y"
        //         from: -popupList.implicitHeight - 100
        //         duration: 400
        //     }
        // }
        //
        // remove: Transition {
        //     NumberAnimation {
        //         properties: "y"
        //         from: 4000
        //         duration: 400
        //     }
        // }

        delegate: Rectangle {
            id: popup

            required property var modelData
            property alias removeAnim: removeAnim

            color: "green"

            radius: Appearance.rounding.normal

            implicitHeight: Appearance.elementSize.notificationList_height
            implicitWidth: root.width - Appearance.padding.sm * 2

            PropertyAnimation {
                id: removeAnim
                target: popup
                property: "y"
                to: root.height + popup.height
                duration: 400
            }

            Behavior on y {
                NumberAnimation {
                    duration: 400
                    easing.type: Easing.OutQuad
                }
            }

            Text {
                text: parent.modelData.body + " " + parent.modelData.summary
            }
        }
    }
}
