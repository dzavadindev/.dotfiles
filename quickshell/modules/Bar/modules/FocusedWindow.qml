import QtQuick

import Quickshell
import Quickshell.Hyprland as HL

import qs.services
import qs.config

Rectangle {
    id: root

    implicitHeight: app_id.implicitHeight + Appearance.padding.md / 2
    implicitWidth: app_id.implicitWidth + Appearance.padding.md

    readonly property HL.HyprlandToplevel activeToplevel: Hyprland.activeToplevel

    color: Appearance.colors.primary_light

    Behavior on opacity {
        NumberAnimation {
            duration: 100
        }
    }

    Text {
        id: app_id

        anchors.centerIn: parent

        color: Appearance.colors.secondary
        text: root.activeToplevel.wayland ? root.activeToplevel.wayland.appId : ""
        font.pointSize: Appearance.font.size.sm
        font.family: Appearance.font.family.mono
        font.bold: true
    }

    function hide() {
        if (Hyprland.focusedWorkspace.toplevels.values.length != 0) {
            root.opacity = 1;
            return;
        }
        root.opacity = 0;
    }

    Connections {
        target: Hyprland
        function onFocusedWorkspaceChanged() {
            root.hide();
        }
        function onActiveWindowChanged() {
            root.hide();
        }
    }
}
