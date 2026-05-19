import QtQuick

Rectangle {
    id: root

    property int colorAnimationDuration: 220
    property int colorAnimationEasing: Easing.OutQuad
    property bool animateColor: true

    Behavior on color {
        enabled: root.animateColor

        ColorAnimation {
            duration: root.colorAnimationDuration
            easing.type: root.colorAnimationEasing
        }
    }
}
