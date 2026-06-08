import QtQuick
import Quickshell

PanelSurface {
    id: root

    required property real hostWidth
    required property real hostHeight

    property int edge: Edges.Right
    property int duration: 200
    property int easingType: Easing.OutQuad
    property real hiddenOffset: 0

    readonly property bool horizontal: edge === Edges.Left || edge === Edges.Right
    readonly property bool vertical: edge === Edges.Top || edge === Edges.Bottom
    readonly property real hiddenDistance: (horizontal ? surfaceWidth : surfaceHeight) + hiddenOffset
    property real slideProgress: open ? 0 : 1

    Binding on x {
        when: root.horizontal
        value: root.edge === Edges.Left ? -root.hiddenDistance * root.slideProgress : root.hostWidth - root.width + root.hiddenDistance * root.slideProgress
        restoreMode: Binding.RestoreBindingOrValue
    }

    Binding on y {
        when: root.vertical
        value: root.edge === Edges.Top ? -root.hiddenDistance * root.slideProgress : root.hostHeight - root.height + root.hiddenDistance * root.slideProgress
        restoreMode: Binding.RestoreBindingOrValue
    }

    Behavior on slideProgress {
        NumberAnimation {
            id: slideAnimation

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
