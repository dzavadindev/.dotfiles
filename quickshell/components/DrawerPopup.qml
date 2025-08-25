import Quickshell
import Quickshell.Hyprland

import QtQuick

import qs.config

PopupWindow {
    id: root

    required property HyprlandFocusGrab grab
    required property QsWindow parentWindow
    required property int barHeight
    required property real popupWidth

    implicitWidth: root.popupWidth

    anchor.window: parentWindow
    anchor.gravity: Edges.Top | Edges.Left
    anchor.rect.x: 0
    anchor.rect.y: screen.height - barHeight - Appearance.padding.sm

    color: "transparent"

    visible: grab.active

    function openPopup() {
        grab.active = true;
    }
}
