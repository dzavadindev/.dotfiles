pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.Notifications

import QtQuick

Singleton {
    id: root

    property bool showNotificationCenter: false

    readonly property real customExpireTime: 5000

    readonly property list<NotificationItem> notifs: []
    readonly property list<NotificationItem> popups: notifs.filter(el => el.isPopup)

    NotificationServer {
        id: server

        keepOnReload: false
        actionsSupported: false
        bodyHyperlinksSupported: false
        bodyImagesSupported: false
        bodyMarkupSupported: false
        imageSupported: false

        onNotification: notification => {
            notification.tracked = true;

            root.notifs.push(creator.createObject(root, {
                notification: notification
            }));
        }
    }

    component NotificationItem: QtObject {
        id: notificationItem

        property bool isPopup: true
        required property Notification notification

        readonly property date time: new Date()

        readonly property string summary: notification.summary
        readonly property string body: notification.body
        readonly property string appIcon: notification.appIcon
        readonly property string appName: notification.appName
        readonly property string image: notification.image
        readonly property int urgency: notification.urgency
        readonly property list<NotificationAction> actions: notification.actions

        readonly property string timeStr: {
            const diff = Time.date.getTime() - time.getTime();
            const m = Math.floor(diff / 60000);
            const h = Math.floor(m / 60);

            if (h < 1 && m < 1)
                return "now";
            if (h < 1)
                return `${m}m`;
            return `${h}h`;
        }

        readonly property Timer timer: Timer {
            running: true
            interval: notificationItem.notification.expireTimeout > 0 ? notificationItem.notification.expireTimeout : root.customExpireTime
            onTriggered: {
                notificationItem.isPopup = false;
            }
        }

        readonly property Connections conn: Connections {
            target: notificationItem.notification.Retainable

            function onDropped(): void {
                root.notifs.splice(root.notifs.indexOf(notificationItem), 1);
            }

            function onAboutToDestroy(): void {
                notificationItem.destroy();
            }
        }
    }

    Component {
        id: creator

        NotificationItem {}
    }
}
