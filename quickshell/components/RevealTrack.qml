import QtQuick

Item {
    id: root

    required property real progress

    property color baseColor: "#000000"
    property color fillColor: "#ffffff"
    property real radius: 0

    readonly property real clampedProgress: Math.max(0, Math.min(1, progress))

    implicitHeight: 8

    Rectangle {
        anchors.fill: parent

        color: root.baseColor
        radius: root.radius
    }

    Item {
        id: fillMask

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        width: parent.width * root.clampedProgress
        clip: true

        Rectangle {
            anchors.fill: parent

            color: root.fillColor
            radius: root.radius
        }
    }
}
