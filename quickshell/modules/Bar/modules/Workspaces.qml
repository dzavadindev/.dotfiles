import QtQuick
import QtQuick.Layouts

import Quickshell
import Quickshell.Hyprland as HL

import qs.config
import qs.services

Rectangle {
    id: root

    implicitHeight: layout.implicitHeight + Appearance.padding.md / 2
    implicitWidth: layout.implicitWidth + Appearance.padding.lg

    color: Appearance.colors.primary
    radius: Appearance.rounding.full

    RowLayout {
        id: layout

        spacing: Appearance.padding.md

        anchors.centerIn: root

        Repeater {
            id: workspaces
            model: Hyprland.workspaces

            Rectangle {
                id: workspace
                required property HL.HyprlandWorkspace modelData

                readonly property bool isFocused: Hyprland.activeWsId === modelData.id

                // Layout.preferredWidth: workspace_number.implicitWidth + Appearance.padding.sm
                Layout.preferredWidth: isFocused ? workspace_number.implicitWidth + Appearance.padding.md : workspace_number.implicitWidth
                Layout.preferredHeight: workspace_number.implicitHeight

                color: isFocused ? Appearance.colors.secondary : "transparent"
                radius: Appearance.rounding.full

                Text {
                    id: workspace_number

                    text: workspace.modelData.name

                    anchors.centerIn: workspace

                    color: isFocused ? Appearance.colors.primary : Appearance.colors.secondary
                    font.pointSize: Appearance.font.size.sm
                    font.family: Appearance.font.family.mono
                }
            }
        }
    }
}
