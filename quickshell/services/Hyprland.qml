pragma Singleton

import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property var toplevels: Hyprland.toplevels
    readonly property var workspaces: Hyprland.workspaces
    readonly property var monitors: Hyprland.monitors
    readonly property HyprlandToplevel activeToplevel: Hyprland.activeToplevel
    readonly property HyprlandWorkspace focusedWorkspace: Hyprland.focusedWorkspace
    readonly property HyprlandMonitor focusedMonitor: Hyprland.focusedMonitor
    readonly property int activeWsId: focusedWorkspace?.id ?? 1

    property string kbLayout: "?"

    signal activeWindowChanged

    function dispatch(request: string): void {
        Hyprland.dispatch(request);
    }

    Connections {
        target: Hyprland

        function onRawEvent(event: HyprlandEvent): void {
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
                Hyprland.refreshWorkspaces();
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
