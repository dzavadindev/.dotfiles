import QtQuick
import Quickshell
import qs.config
import qs.components

import "modules"

StyledWindow {
    name: "bar"
    // Made the height dynamic, based on how high the elements of the bar are + the padding
    implicitHeight: child.implicitHeight + Appearance.padding.sm

    // Hug the bottom
    anchors.left: true
    anchors.right: true
    anchors.bottom: true

    Item {
        id: child

        // Make all bar elements center be on the center of the bar itself, this creates the padding effect
        anchors.verticalCenter: parent.verticalCenter
        // Make the main wrapper span the whole panel
        anchors.left: parent.left
        anchors.right: parent.right

        // Determine the height based on what is the highest bar element
        implicitHeight: Math.max(clock.implicitHeight)

        // Elements of the bar
        Workspaces {
            id: workspaces

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: Appearance.padding.md
        }

        Clock {
            id: clock

            anchors.verticalCenter: parent.verticalCenter
            anchors.centerIn: parent
        }
    }
}
