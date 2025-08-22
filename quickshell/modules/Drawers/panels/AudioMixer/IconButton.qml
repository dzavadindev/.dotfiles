import Quickshell

import QtQuick

import QtQuick.Controls

import qs.config
import qs.components

Button {
    id: root

    property int buttonSize: Appearance.elementSize.audioMixer_tabSize

    property string iconName: "home"
    property int iconSize: Appearance.font.size.lg
    property int iconWeight: Font.Bold
    property color iconColor: "white"

    property color mainColor: Appearance.colors.primary
    property color secondaryColor: Appearance.colors.secondary

    property string borderWidth: Appearance.borderWidth.sm
    property real borderRadius: Appearance.rounding.full

    background: Rectangle {
        id: background

        implicitWidth: root.buttonSize
        implicitHeight: root.buttonSize

        color: root.mainColor

        radius: root.borderRadius

        border.color: root.secondaryColor
        border.width: root.borderWidth

        Behavior on color {
            ColorAnimation {
                target: background
                duration: 200
            }
        }

        Behavior on border.color {
            ColorAnimation {
                target: background
                duration: 200
            }
        }
    }

    contentItem: MaterialIcon {
        id: icon

        name: root.iconName

        color: root.iconColor

        size: root.iconSize
        weight: root.iconWeight

        Behavior on color {
            ColorAnimation {
                target: icon
                duration: 400
            }
        }
    }
}
