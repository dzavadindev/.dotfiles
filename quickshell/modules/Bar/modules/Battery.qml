import QtQuick

import Quickshell

import qs.config
import qs.components
import qs.services

Rectangle {
    id: root

    visible: UPower.isLaptop

    color: Appearance.colors.primary_light

    implicitWidth: contentRow.implicitWidth + Appearance.padding.sm * 2
    implicitHeight: contentRow.implicitHeight + Appearance.padding.sm

    Row {
        id: contentRow
        spacing: Appearance.padding.xs
        anchors.centerIn: parent

        MaterialIcon {
            id: icon

            name: UPower.batteryIcon
            color: Appearance.colors.secondary
            size: Appearance.font.size.md
            weight: Font.Bold
        }

        Text {
            id: charge

            text: UPower.rounded_percentage + "%"

            anchors.verticalCenter: parent.verticalCenter

            color: Appearance.colors.secondary
            font.pointSize: Appearance.font.size.sm
            font.family: Appearance.font.family.mono
        }
    }
}
