import QtQuick

Item {
    id: root

    required property bool open
    required property real hostWidth

    property int duration: 200
    property int easingType: Easing.OutQuad
    property real hiddenOffset: 0

    readonly property real surfaceWidth: contentRoot.implicitWidth
    readonly property real surfaceHeight: contentRoot.implicitHeight

    signal opened
    signal closed

    default property alias content: contentRoot.data

    implicitWidth: surfaceWidth
    implicitHeight: surfaceHeight
    width: surfaceWidth
    height: surfaceHeight

    readonly property real openX: hostWidth - surfaceWidth
    readonly property real closedX: hostWidth + hiddenOffset

    property bool pendingSignal: false
    property bool pendingOpenState: false

    enabled: open
    visible: open || xAnimation.running

    x: open ? openX : closedX

    onOpenChanged: {
        pendingSignal = true;
        pendingOpenState = open;

        Qt.callLater(() => {
            if (!pendingSignal || xAnimation.running)
                return;

            pendingSignal = false;
            if (pendingOpenState)
                opened();
            else
                closed();
        });
    }

    Behavior on x {
        NumberAnimation {
            id: xAnimation

            duration: root.duration
            easing.type: root.easingType

            onRunningChanged: {
                if (running || !root.pendingSignal)
                    return;

                root.pendingSignal = false;
                if (root.pendingOpenState)
                    root.opened();
                else
                    root.closed();
            }
        }
    }

    Item {
        id: contentRoot

        implicitWidth: childrenRect.width
        implicitHeight: childrenRect.height
    }
}
