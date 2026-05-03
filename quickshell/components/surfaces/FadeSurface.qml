import QtQuick
import qs.components.surfaces

PanelSurface {
    id: root

    property int duration: 180
    property int easingType: Easing.OutQuad

    opacity: open ? 1 : 0

    Behavior on opacity {
        NumberAnimation {
            id: fadeAnim

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
