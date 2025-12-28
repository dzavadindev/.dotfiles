pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets

import QtQuick

import qs.components

Rectangle {
    id: root

    required property var model

    required property Component delegate

    property real wrapperWidth: 100
    property real wrapperYPadding: 10

    property real wrapperBottomRadius: 10
    property string wrapperColor: "transparent"

    property real spacing: 10

    color: "transparent"

    implicitHeight: viewport.animatedHeight
    implicitWidth: popupList.contentItem.width

    Rectangle {
        id: viewport
        clip: true

        property real animatedHeight

        color: root.wrapperColor
        bottomLeftRadius: root.wrapperBottomRadius
        bottomRightRadius: root.wrapperBottomRadius

        anchors.horizontalCenter: parent.horizontalCenter

        implicitWidth: root.wrapperWidth
        implicitHeight: animatedHeight

        ListView {
            id: popupList

            model: root.model
            anchors.fill: parent

            anchors.topMargin: root.wrapperYPadding
            anchors.bottomMargin: root.wrapperYPadding

            spacing: root.spacing

            displaced: Transition {
                NumberAnimation {
                    properties: "y"
                    duration: 400
                    easing.type: Easing.OutQuad
                }
            }

            delegate: DelegateAnimationHandler {
                id: wrapper

                required property var modelData

                Binding {
                    target: wrapper.contentDelegate
                    property: wrapper.modelData
                }

                contentDelegate: root.delegate
            }
        }
    }

    component DelegateAnimationHandler: Item {
        id: animationHandler

        property Component contentDelegate

        implicitWidth: loader.item ? loader.item.implicitWidth : 0
        implicitHeight: loader.item ? loader.item.implicitHeight : 0

        Loader {
            id: loader
            anchors.fill: parent

            sourceComponent: animationHandler.contentDelegate

            property var modelData: animationHandler.modelData

            Binding {
                target: loader.item
                property: "modelData"
                value: loader.modelData
                when: loader.item !== null
            }
        }

        transform: Translate {
            id: t
            y: 0
        }

        SequentialAnimation {
            id: addAnim

            PropertyAction {
                target: t
                property: "y"
                value: -animationHandler.height
            }

            ParallelAnimation {
                NumberAnimation {
                    target: t
                    property: "y"
                    to: 0
                    duration: 400
                    easing.type: Easing.OutQuad
                }
                NumberAnimation {
                    target: viewport
                    property: "animatedHeight"
                    to: popupList.contentHeight + root.wrapperYPadding * 2
                    duration: 400
                    easing.type: Easing.OutQuad
                }
            }
        }

        SequentialAnimation {
            id: removeAnim

            PropertyAction {
                target: animationHandler
                property: "ListView.delayRemove"
                value: true
            }

            ParallelAnimation {
                NumberAnimation {
                    target: t
                    property: "y"
                    to: viewport.height + animationHandler.height
                    duration: 400
                    easing.type: Easing.OutQuad
                }

                NumberAnimation {
                    target: viewport
                    property: "animatedHeight"
                    to: viewport.animatedHeight - animationHandler.implicitHeight - popupList.spacing
                    duration: 400
                    easing.type: Easing.OutQuad
                }
            }

            PropertyAction {
                target: animationHandler
                property: "ListView.delayRemove"
                value: false
            }
        }

        ListView.onRemove: removeAnim.start()
        ListView.onAdd: addAnim.start()
    }
}
