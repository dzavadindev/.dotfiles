pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets

import QtQuick

import qs.config
import qs.services
import qs.components

RollingListView {
    id: root

    ScriptModel {
        id: notificationsModel
        values: NotificationService.notifs.filter(el => el.isPopup).reverse()
    }

    model: notificationsModel

    wrapperWidth: {
        let size = Appearance.elementSize.notificationListItem_width;
        let h_pad = Appearance.padding.md;
        return size + h_pad;
    }
    wrapperColor: Appearance.colors.primary
    wrapperBottomRadius: Appearance.rounding.normal

    delegate: Rectangle {
        id: notificationItem

        property var modelData

        color: Appearance.colors.secondary
        radius: Appearance.rounding.normal

        implicitHeight: Appearance.elementSize.notificationListItem_height
        implicitWidth: root.width

        Text {
            anchors.centerIn: parent
            color: Appearance.colors.primary
            text: notificationItem.modelData.body
        }
    }
}
