import QtQuick
import qs.config

import "modules"

Item {
    id: root

    // Set the bar to hug the bottom of the screen
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right

    // Made the height dynamic, based on how high the elements of the bar are
    implicitHeight: child.implicitHeight

    Item {
        id: child

        // Hug the bottom
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        // Make all bar elements center be on the center of the bar itself
        anchors.verticalCenter: parent.verticalCenter

        // Determine the height based on what is the highest bar element
        implicitHeight: Math.max(clock.implicitHeight)

        Clock {
            id: clock

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: Appearance.padding.lg
        }
    }
}
