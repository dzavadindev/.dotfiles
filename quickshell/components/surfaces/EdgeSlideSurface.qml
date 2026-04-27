import QtQuick

PanelSurface {
    id: root

    required property real hostWidth

    property int duration: 200
    property int easingType: Easing.OutQuad
    property real hiddenOffset: 0

    readonly property real openX: hostWidth - surfaceWidth
    readonly property real closedX: hostWidth + hiddenOffset

    x: open ? openX : closedX

    Behavior on x {
        NumberAnimation {
            id: xAnimation

            duration: root.duration
            easing.type: root.easingType

            onRunningChanged: {
                root.transitionRunning = running;
                if (!running)
                    root.emitPendingSignal();
            }
        }
    }
}
