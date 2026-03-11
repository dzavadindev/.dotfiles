import Quickshell
import QtQuick

import qs.services
import qs.config

Rectangle {

    implicitHeight: text.implicitHeight + Appearance.padding.md / 2
    implicitWidth: text.implicitWidth + Appearance.padding.md

    color: "transparent"

    Text {
        id: text

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        text: Time.time

        color: Appearance.colors.secondary
        font.pointSize: Appearance.font.size.sm
        font.family: Appearance.font.family.mono
        font.bold: true
    }
}
