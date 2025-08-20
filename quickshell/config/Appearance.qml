pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property Colors colors: Colors {}
    readonly property Rounding rounding: Rounding {}
    readonly property Padding padding: Padding {}
    readonly property DrawerSize drawerSize: DrawerSize {}
    readonly property FontProps font: FontProps {}

    // Colors -------------------------------------
    component Colors: QtObject {
        readonly property string primary: "#0F3325"
        readonly property string secondary: "#FFDCAB"
        readonly property string accent: "#18230F"
    }

    // Rounding -----------------------------------
    component Rounding: QtObject {
        readonly property real full: 1000
    }

    // Padding ------------------------------------
    component Padding: QtObject {
        readonly property real lg: 30
        readonly property real md: 20
        readonly property real sm: 10
        readonly property real xs: 5
    }

    // Drawer Sizes -------------------------------
    component DrawerSize: QtObject {
        readonly property vector2d tall: Qt.vector2d(300, 400)
        readonly property vector2d wide: Qt.vector2d(500, 200)
    }

    // Fonts --------------------------------------
    component FontProps: QtObject {
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
