import Quickshell
import Quickshell.Hyprland

import QtQuick

import qs.config

PopupWindow {
    id: root

    required property HyprlandFocusGrab grab
    required property QsWindow parentWindow
    required property int barHeight

    anchor {
        window: parentWindow
        gravity: Edges.Top | Edges.Left
        rect.x: 0
        rect.y: screen.height - barHeight - Appearance.padding.sm
    }

    visible: grab.active

    function openPopup() {
        grab.active = true;
    }
}
