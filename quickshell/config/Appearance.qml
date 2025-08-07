pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property Colors colors: Colors {}
    readonly property Rounding rounding: Rounding {}
    readonly property Padding padding: Padding {}
    readonly property Font font: Font {}

    component Colors: QtObject {
        readonly property string primary: "#0F3325"
        readonly property string secondary: "#FFDCAB"
    }

    component Rounding: QtObject {
        readonly property real full: 1000
    }

    component Padding: QtObject {
        readonly property real lg: 30
        readonly property real md: 20
        readonly property real sm: 10
    }

    component Font: QtObject {
        readonly property FontFamily family: FontFamily {}
        readonly property FontSize size: FontSize {}
    }

    component FontFamily: QtObject {
        readonly property string mono: "FiraCode Nerd Font"
        readonly property string material: "Material Symbols Rounded"
    }

    component FontSize: QtObject {
        readonly property real sm: 12
        readonly property real md: 14
        readonly property real lg: 16
    }
}
