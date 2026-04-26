import QtQuick

import qs.config

Rectangle {
    id: root

    color: Appearance.colors.primary

    implicitWidth: Appearance.elementSize.notificationListItem_width + Appearance.padding.lg
    implicitHeight: 360

    topLeftRadius: Appearance.rounding.normal
    bottomLeftRadius: Appearance.rounding.normal

    Text {
        anchors.centerIn: parent

        color: Appearance.colors.secondary
        font.family: Appearance.font.family.mono
        font.pointSize: Appearance.font.size.md
        text: "Notification Center"
    }
}
