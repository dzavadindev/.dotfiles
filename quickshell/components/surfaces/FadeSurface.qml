import QtQuick
import qs.components.surfaces

PanelSurface {
    id: root

    opacity: open ? 1 : 0

    Behavior on opacity {
        NumberAnimation {
            id: fadeAnim

            duration: 200
            easing.type: root.easingType

            onRunningChanged: {
                root.transitionRunning = running;
                if (!running)
                    root.emitPendingSignal();
            }
        }
    }
}
