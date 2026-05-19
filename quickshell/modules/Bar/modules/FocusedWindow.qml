import QtQuick

import Quickshell

import qs.services
import qs.config
import qs.components

AnimatedColorRect {
    id: root

    implicitHeight: app_id.implicitHeight + Appearance.padding.md / 2
    implicitWidth: app_id.implicitWidth + Appearance.padding.md

    readonly property var activeToplevel: WMService.activeToplevel

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
        if (WMService.focusedWorkspace.toplevels.values.length != 0) {
            root.opacity = 1;
            return;
        }
        root.opacity = 0;
    }

    Connections {
        target: WMService
        function onFocusedWorkspaceChanged() {
            root.hide();
        }
        function onActiveWindowChanged() {
            root.hide();
        }
    }
}
