import Quickshell
import QtQuick
import qs.services
import qs.config

Rectangle {

    implicitHeight: text.implicitHeight + Appearance.padding.md / 2
    implicitWidth: text.implicitWidth + Appearance.padding.md

    color: Appearance.colors.primary
    radius: Appearance.rounding.full

    Text {
        id: text

        color: Appearance.colors.secondary

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        text: Time.time
        font.pointSize: Appearance.font.size.sm
        font.family: Appearance.font.family.mono
    }
}
