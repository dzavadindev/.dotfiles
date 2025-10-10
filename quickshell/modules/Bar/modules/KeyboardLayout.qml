import QtQuick

import Quickshell
import Quickshell.Widgets

import qs.config
import qs.components
import qs.services

Rectangle {
    id: root

    color: Appearance.colors.primary_light

    implicitWidth: contentRow.implicitWidth + Appearance.padding.sm * 2
    implicitHeight: contentRow.implicitHeight + Appearance.padding.sm

    Row {
        id: contentRow
        spacing: Appearance.padding.xs
        anchors.centerIn: parent

        MaterialIcon {
            id: icon

            name: "keyboard"
            color: Appearance.colors.secondary
            size: Appearance.font.size.md
        }

        Text {
            id: charge

            text: Hyprland.kbLayout

            anchors.verticalCenter: parent.verticalCenter

            color: Appearance.colors.secondary
            font.pointSize: Appearance.font.size.sm
            font.family: Appearance.font.family.mono
        }
    }
}
