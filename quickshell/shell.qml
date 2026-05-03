import Quickshell

import QtQuick

import qs.modules.Bar
import qs.modules.Overlay

import qs.services

ShellRoot {
    QtObject {
        readonly property var _overlayManager: OverlayManager
    }

    Bar {}
    OverlayHost {}
}
