pragma ComponentBehavior: Bound

import QtQuick

import qs.config
import qs.services

Rectangle {
    id: root

    property int notifHeight: 100

    implicitWidth: Appearance.elementSize.notificationList_width

    color: Appearance.colors.primary

    bottomLeftRadius: Appearance.rounding.normal
    bottomRightRadius: Appearance.rounding.normal

    Behavior on height {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutQuad
        }
    }

    Item {
        id: list

        property int spacing: Appearance.padding.sm
        property var notifsModel: NotificationService.popups

        anchors.fill: parent
        clip: true

        function targetYForIndex(i) {
            var y = 0;
            for (var k = rep.count - 1; k > i; --k) {
                const it = rep.itemAt(k);
                if (!it)
                    continue;
                y += it.height + spacing;
            }
            return y;
        }

        function relayout(skipIndex) {
            for (var j = 0; j < rep.count; ++j) {
                if (j === skipIndex)
                    continue;
                const it = rep.itemAt(j);
                if (!it)
                    continue;
                it.y = targetYForIndex(j);
            }
            root.height = list.notifsModel.length * root.notifHeight + Appearance.padding.md;
        }

        Repeater {
            id: rep
            model: list.notifsModel

            onItemAdded: (i, item) => {
                item.width = list.width - Appearance.padding.md * 2;
                item.x = Appearance.padding.md;

                item.y = -(item.height + list.spacing);
                list.relayout(i);
                Qt.callLater(() => {
                    item.opacity = 1;
                    item.y = list.targetYForIndex(i);
                });
            }

            onItemRemoved: (i, item) => {
                const abs = item.mapToItem(root, 0, 0);
                item.parent = root;
                item.x = abs.x;
                item.y = abs.y;
                Qt.callLater(list.relayout);
            }

            delegate: NotificationItem {
                id: row

                required property int index

                y: 0
                width: list.width - Appearance.padding.md

                anchors.horizontalCenter: list.horizontalCenter

                Behavior on y {
                    NumberAnimation {
                        duration: 600
                        easing.type: Easing.OutCubic
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
    }

    component NotificationItem: Rectangle {
        id: notificationItem

        required property var modelData

        height: root.notifHeight

        color: Appearance.colors.primary
        radius: Appearance.rounding.normal
        border.color: Appearance.colors.secondary
        border.width: Appearance.borderWidth.sm

        Text {
            anchors.centerIn: parent
            color: "#fff000"
            font.pointSize: 15
            text: parent.modelData.body + " | " + parent.modelData.summary
        }
    }
}
