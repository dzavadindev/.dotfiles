import QtQuick
import QtQuick.Layouts

import Quickshell
import Quickshell.Hyprland as HL

import qs.config
import qs.services

// REWRITE
// Render all workspaces, empty or not >
// Show them based on if they have a toplevel or not >
// Keep the logic of animated bg sliding
// DEPENDS on if QML has a thing for 'display:none'

Rectangle {
    id: root
    color: Appearance.colors.primary
    radius: Appearance.rounding.full

    implicitHeight: layoutWrapper.implicitHeight + Appearance.padding.md / 2
    implicitWidth: layoutWrapper.implicitWidth + Appearance.padding.lg

    // Wrap the layout so that I can put the background outside of the layout
    Item {
        id: layoutWrapper
        anchors.centerIn: parent

        // Expose implicit size from the RowLayout (so root can size around it)
        implicitWidth: layout.implicitWidth
        implicitHeight: layout.implicitHeight

        // The sliding background rectangle
        Rectangle {
            id: focusBackground
            z: -1
            radius: Appearance.rounding.full
            color: Appearance.colors.secondary
            visible: width > 0 && height > 0 // prevent flickers

            // Animations trigger on property change
            Behavior on x {
                NumberAnimation {
                    duration: 190
                    easing.type: Easing.OutBack
                }
            }
            Behavior on width {
                NumberAnimation {
                    duration: 160
                    easing.type: Easing.OutCubic
                }
            }
            Behavior on height {
                NumberAnimation {
                    duration: 160
                    easing.type: Easing.OutCubic
                }
            }
            Behavior on opacity {
                NumberAnimation {
                    duration: 160
                    easing.type: Easing.OutCubic
                }
            }
        }

        RowLayout {
            id: layout
            anchors.fill: parent
            spacing: Appearance.padding.md

            Repeater {
                id: workspaces
                model: Hyprland.workspaces

                // One rectangle per workspace
                Rectangle {
                    id: ws
                    required property HL.HyprlandWorkspace modelData

                    Layout.preferredWidth: number.implicitWidth + Appearance.padding.md
                    Layout.preferredHeight: number.implicitHeight
                    color: "transparent"
                    radius: Appearance.rounding.full

                    readonly property bool isFocused: Hyprland.activeWsId === modelData.id

                    Text {
                        id: number
                        anchors.centerIn: parent
                        text: ws.modelData.name
                        color: ws.isFocused ? Appearance.colors.primary : Appearance.colors.secondary
                        font.pointSize: Appearance.font.size.sm
                        font.family: Appearance.font.family.mono
                    }
                }
            }
        }
    }

    // Find the delegate whose modelData.id matches Hyprland.activeWsId
    function findFocusedItem() {
        // Walk the actual created items to avoid guessing the model shape
        for (let i = 0; i < workspaces.count; ++i) {
            const item = workspaces.itemAt(i);
            if (item && item.modelData && item.modelData.id === Hyprland.activeWsId)
                return item;
        }
        return null;
    }

    // Assign geometry to the background (Behaviors will animate the movement)
    function updateFocusBg() {
        const item = findFocusedItem();
        if (!item) {
            focusBackground.opacity = 0;
            return;
        }// items aren’t ready or id not present

        // extra horizontal padding beyond the delegate
        const inset = Appearance.padding.sm;

        // Position/size are in the same coord space because focusBackground and RowLayout share layoutWrapper as parent
        focusBackground.opacity = 1;
        focusBackground.x = item.x - inset;
        focusBackground.y = item.y; // normally 0 in a RowLayout row
        focusBackground.width = item.width + inset * 2;
        focusBackground.height = item.height;
    }

    // On Hyprland focus change
    Connections {
        target: Hyprland
        function onActiveWsIdChanged() {
            root.updateFocusBg();
        }
    }

    // Ensure the placement is correct when the bg just rendered
    onVisibleChanged: if (visible)
        deferredUpdate.restart()

    // Restart when model count changes
    Connections {
        target: workspaces
        function onCountChanged() {
            deferredUpdate.restart();
        }
    }

    // If fonts or theme padding change and layout reflows, you can also tie into these:
    onWidthChanged: deferredUpdate.restart()
    onHeightChanged: deferredUpdate.restart()

    // Defer updates to the next tick to prevent stale values
    Timer {
        id: deferredUpdate
        interval: 0
        repeat: false
        onTriggered: updateFocusBg()
        running: true // also run once on startup
    }
}
