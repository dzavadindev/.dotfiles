import QtQuick

import Quickshell

import qs.services
import qs.config

Rectangle {
    id: focused_window

    implicitHeight: app_id.implicitHeight + Appearance.padding.md / 2
    implicitWidth: app_id.implicitWidth + Appearance.padding.md

    color: Appearance.colors.secondary
    radius: Appearance.rounding.full

    Behavior on opacity {
        NumberAnimation {
            duration: 100
        }
    }

    Text {
        id: app_id

        anchors.centerIn: parent

        color: Appearance.colors.primary
        text: Hyprland.activeToplevel.wayland.appId
        font.pointSize: Appearance.font.size.sm
        font.family: Appearance.font.family.mono
        font.bold: true
    }

    function hide() {
        if (Hyprland.focusedWorkspace.toplevels.values.length != 0) {
            focused_window.opacity = 1;
            return;
        }
        focused_window.opacity = 0;
    }

    Connections {
        target: Hyprland
        function onFocusedWorkspaceChanged() {
            focused_window.hide();
        }
        function onActiveWindowChanged() {
            focused_window.hide();
        }
    }
}
