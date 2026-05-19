import QtQuick

import Quickshell.Wayland

import qs.config
import qs.services
import qs.components

import "modules"

StyledWindow {
    name: "bar"
    WlrLayershell.layer: WlrLayer.Bottom

    // Made the height dynamic, based on how high the elements of the bar are + the padding
    implicitHeight: WMService.focusedWorkspace.hasFullscreen ? 0 : child.implicitHeight
    implicitWidth: child.implicitWidth

    // Hug the bottom
    anchors.left: true
    anchors.right: true
    anchors.bottom: true

    Behavior on implicitHeight {
        NumberAnimation {
            duration: 100
            easing.type: Easing.OutQuad
        }
    }

    AnimatedColorRect {
        id: fill

        anchors.fill: parent

        color: Appearance.colors.primary
        visible: WMService.focusedWorkspace.hasFullscreen
    }

    AnimatedColorRect {
        id: child

        color: Appearance.colors.primary

        // Make all bar elements center be on the center of the bar itself, this creates the padding effect
        anchors.verticalCenter: parent.verticalCenter
        // Make the main wrapper span the whole panel
        anchors.left: parent.left
        anchors.right: parent.right

        // Determine the height based on what is the highest bar element
        implicitHeight: Math.max(clock.implicitHeight, active_top_level.implicitHeight, clock.implicitHeight, battery.implicitHeight)

        // Elements of the bar
        Workspaces {
            id: workspaces

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: Appearance.padding.md
        }

        FocusedWindow {
            id: active_top_level

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: workspaces.right
            anchors.leftMargin: Appearance.padding.sm
        }

        Clock {
            id: clock

            anchors.verticalCenter: parent.verticalCenter
            anchors.centerIn: parent
        }

        Row {
            spacing: Appearance.padding.sm

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: Appearance.padding.md

            KeyboardLayout {
                id: layout
            }

            Volume {
                id: volume
            }

            Battery {
                id: battery
            }

            Notifications {
                id: notifications
            }
        }
    }
}
