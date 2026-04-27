import QtQuick

Item {
    id: root

    required property bool open
    required property string managedPanelId

    property bool closeOnAnyKeypress: false

    readonly property real surfaceWidth: contentRoot.implicitWidth
    readonly property real surfaceHeight: contentRoot.implicitHeight

    signal opened
    signal closed

    default property alias content: contentRoot.data

    implicitWidth: surfaceWidth
    implicitHeight: surfaceHeight
    width: surfaceWidth
    height: surfaceHeight

    property bool transitionRunning: false
    property bool pendingSignal: false
    property bool pendingOpenState: false

    enabled: open
    visible: open || transitionRunning

    onOpenChanged: {
        pendingSignal = true;
        pendingOpenState = open;

        Qt.callLater(() => {
            if (!pendingSignal || transitionRunning)
                return;

            emitPendingSignal();
        });
    }

    function emitPendingSignal() {
        if (!pendingSignal)
            return;

        pendingSignal = false;

        if (pendingOpenState)
            opened();
        else
            closed();
    }

    function shouldCloseOnKeypress(event): bool {
        return event.key !== Qt.Key_Shift && event.key !== Qt.Key_Control && event.key !== Qt.Key_Alt && event.key !== Qt.Key_Meta;
    }

    Item {
        id: contentRoot

        implicitWidth: childrenRect.width
        implicitHeight: childrenRect.height
    }
}
