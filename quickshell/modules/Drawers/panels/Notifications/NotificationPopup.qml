pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets

import QtQuick

import qs.config
import qs.services

Rectangle {
    id: root

    property bool isEmpty: popupList.count == 0

    color: "transparent"

    implicitHeight: viewport.implicitHeight
    implicitWidth: {
        let size = Appearance.elementSize.notificationListItem_width;
        let h_pad = Appearance.padding.md;
        return size + h_pad;
    }

    ScriptModel {
        id: popups
        values: NotificationService.notifs.filter(el => el.isPopup).reverse()
    }

    Rectangle {
        id: viewport
        clip: true

        property real animatedHeight: popupList.contentHeight

        color: Appearance.colors.primary
        bottomLeftRadius: Appearance.rounding.normal
        bottomRightRadius: Appearance.rounding.normal

        anchors.horizontalCenter: parent.horizontalCenter

        implicitWidth: parent.width
        implicitHeight: animatedHeight

        ListView {
            id: popupList

            model: popups
            anchors.fill: parent

            spacing: Appearance.padding.sm

            displaced: Transition {
                NumberAnimation {
                    properties: "y"
                    duration: 400
                    easing.type: Easing.OutQuad
                }
            }

            delegate: NotificationItem {}
        }
    }

    component NotificationItem: Rectangle {
        id: popup

        required property var modelData
        required property int index

        color: Appearance.colors.secondary
        radius: Appearance.rounding.normal

        implicitHeight: Appearance.elementSize.notificationListItem_height
        implicitWidth: root.width - Appearance.padding.sm * 2

        transform: Translate {
            id: t
            y: 0
        }

        SequentialAnimation {
            id: addAnim

            PropertyAction {
                target: t
                property: "y"
                value: -popup.height
            }

            NumberAnimation {
                target: t
                property: "y"
                to: 0
                duration: 400
                easing.type: Easing.OutQuad
            }
        }

        SequentialAnimation {
            id: removeAnim

            PropertyAction {
                target: popup
                property: "ListView.delayRemove"
                value: true
            }

            ParallelAnimation {
                NumberAnimation {
                    target: t
                    property: "y"
                    to: viewport.height + popup.height
                    duration: 400
                    easing.type: Easing.OutQuad
                }

                NumberAnimation {
                    target: viewport
                    property: "animatedHeight"
                    to: viewport.animatedHeight - popup.implicitHeight - popupList.spacing
                    duration: 400
                    easing.type: Easing.OutQuad
                }
            }

            PropertyAction {
                target: popup
                property: "ListView.delayRemove"
                value: false
            }
        }

        ListView.onRemove: () => removeAnim.start()
        ListView.onAdd: () => addAnim.start()

        Text {
            anchors.centerIn: parent
            color: Appearance.colors.primary
            text: parent.modelData.body + " " + parent.modelData.summary
        }
    }
}
