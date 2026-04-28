import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    id: root

    required property real progress

    property color baseColor: "#000000"
    property color fillColor: "#ffffff"
    property real radius: 0

    readonly property real clampedProgress: Math.max(0, Math.min(1, progress))

    implicitHeight: 8

    Rectangle {
        id: baseTrack
        anchors.fill: parent

        radius: root.radius
        color: root.baseColor
    }

    Item {
        id: fillSource
        anchors.fill: parent
        visible: false

        Rectangle {
            width: parent.width
            height: parent.height
            x: (root.clampedProgress - 1) * parent.width

            color: root.fillColor
        }
    }

    Rectangle {
        id: fillMask
        anchors.fill: parent

        visible: false
        radius: root.radius
        color: "white"
    }

    OpacityMask {
        anchors.fill: parent
        source: fillSource
        maskSource: fillMask
    }
}
