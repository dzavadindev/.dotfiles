pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property real worspacesCount: 5
    readonly property string colorThemeFile: "/home/dan/.cache/color-themes/quickshell.json"
}
