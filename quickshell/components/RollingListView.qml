pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets

import QtQuick

/*
 * Rolling List View
 * A simple wrapper around the ListView component that adds FIFO slide animation
 *
 * - The width of the RollingListView determines the width of the delegates
 *   Default `implicitWidth` is 100, and should be modified to your needs
 *   If you wish to add padding, use wrapperYPadding and wrapperXPadding
 *
 */
Rectangle {
    id: root

    required property var model

    required property Component delegate

    property string wrapperColor: "transparent"

    property real wrapperYPadding: 10
    property real wrapperXPadding: 10
    property real wrapperBottomRadius: 10
    property real spacing: 10

    property bool isEmpty: rollingList.count == 0

    color: "transparent"

    implicitHeight: isEmpty ? viewport.animatedHeight : 0
    implicitWidth: 100 // DEFAULT VALUE

    Rectangle {
        id: viewport
        clip: true

        property real animatedHeight
        property real targetHeight

        color: root.wrapperColor
        bottomLeftRadius: root.wrapperBottomRadius
        bottomRightRadius: root.wrapperBottomRadius

        implicitWidth: root.implicitWidth + root.wrapperXPadding * 2
        implicitHeight: animatedHeight

        onTargetHeightChanged: animatedHeight = targetHeight

        Behavior on animatedHeight {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutQuad
            }
        }

        ListView {
            id: rollingList

            model: root.model

            implicitWidth: root.implicitWidth

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.bottom: parent.bottom

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

                implicitWidth: ListView.view.width
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

            onLoaded: {
                if (!item)
                    return;
                item.modelData = animationHandler.modelData;
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
                target: animationHandler
                property: "ListView.delayRemove"
                value: true
            }

            NumberAnimation {
                target: t
                property: "y"
                to: viewport.height + animationHandler.height
                duration: 400
                easing.type: Easing.OutQuad
            }

            PropertyAction {
                target: animationHandler
                property: "ListView.delayRemove"
                value: false
            }
        }

        ListView.onRemove: {
            removeAnim.start();
            viewport.targetHeight = viewport.targetHeight - (implicitHeight + root.wrapperYPadding);
        }

        ListView.onAdd: {
            addAnim.start();
            viewport.targetHeight = viewport.targetHeight + implicitHeight + root.wrapperYPadding;
        }
    }
}
