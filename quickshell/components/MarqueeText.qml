pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets

import QtQuick

import qs.config

ClippingRectangle {
    id: root

    required property real maxWidth
    required property string text

    property color textColor: Appearance.colors.secondary
    property int fontSize: Appearance.font.size.sm
    property string fontFamily: Appearance.font.family.mono

    readonly property int scrollTime: 7000

    implicitWidth: root.maxWidth
    implicitHeight: original.implicitHeight

    color: "transparent"

    Text {
        id: original

        text: root.text + "   "

        x: 0
        color: root.textColor
        font.pointSize: root.fontSize
        font.family: root.fontFamily
    }

    Loader {
        active: original.width > root.maxWidth
        sourceComponent: Text {
            id: duplicate

            text: original.text

            x: this.implicitWidth
            color: root.textColor
            font.pointSize: root.fontSize
            font.family: root.fontFamily

            SequentialAnimation {
                running: original.width > root.maxWidth
                loops: Animation.Infinite

                NumberAnimation {
                    target: duplicate
                    property: "x"
                    from: -duplicate.implicitWidth
                    to: 0
                    duration: root.scrollTime
                }

                PropertyAction {
                    target: duplicate
                    property: "x"
                    value: -duplicate.implicitWidth
                }
            }

            SequentialAnimation {
                running: original.width > root.maxWidth
                loops: Animation.Infinite

                NumberAnimation {
                    target: original
                    property: "x"
                    from: 0
                    to: original.implicitWidth
                    duration: root.scrollTime
                }

                PropertyAction {
                    target: original
                    property: "x"
                    value: 0
                }
            }
        }
    }
}
