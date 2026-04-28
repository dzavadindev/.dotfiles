pragma Singleton

import Quickshell
import Quickshell.Hyprland as QSH
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property var toplevels: QSH.Hyprland.toplevels
    readonly property var workspaces: QSH.Hyprland.workspaces
    readonly property var monitors: QSH.Hyprland.monitors
    readonly property QSH.HyprlandToplevel activeToplevel: QSH.Hyprland.activeToplevel
    readonly property QSH.HyprlandWorkspace focusedWorkspace: QSH.Hyprland.focusedWorkspace
    readonly property QSH.HyprlandMonitor focusedMonitor: QSH.Hyprland.focusedMonitor
    readonly property int activeWsId: focusedWorkspace?.id ?? 1

    property string kbLayout: "?"

    signal activeWindowChanged

    function dispatch(request: string): void {
        QSH.Hyprland.dispatch(request);
    }

    Connections {
        target: QSH.Hyprland

        function onRawEvent(event: QSH.HyprlandEvent): void {
            const name = event.name;

            // ignore v2 events
            if (name.endsWith("v2"))
                return;

            // get the active layout name to show
            if (name === "activelayout") {
                root.kbLayout = event.parse(2)[1].slice(0, 2).toLowerCase();
            }

            // ensure that workspace list is refreshed after changes
            if (name.includes("workspace")) {
                QSH.Hyprland.refreshWorkspaces();
            }

            if (name === "activewindow") {
                root.activeWindowChanged();
            }
        }
    }

    Process {
        running: true
        command: ["hyprctl", "-j", "devices"]
        stdout: StdioCollector {
            onStreamFinished: root.kbLayout = JSON.parse(text).keyboards.find(k => k.main).active_keymap.slice(0, 2).toLowerCase()
        }
    }
}
