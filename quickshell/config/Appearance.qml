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
    readonly property BorderWidth borderWidth: BorderWidth {}
    readonly property ElementSize elementSize: ElementSize {}

    // Colors -------------------------------------
    component Colors: QtObject {
        readonly property string primary: "#0F3325"
        readonly property string secondary: "#FFDCAB"
        readonly property string accent: "#18230F"
    }

    // ELEMENT SIZES -------------------------------
    component ElementSize: QtObject {
        readonly property int audioMixer_tabSize: 40
        readonly property int audioMixer_sliderWidth: 250
        readonly property int audioMixer_listHeight: 350
        readonly property int audioMixer_sliderThickness: 5
    }

    // Border Width -------------------------------
    component BorderWidth: QtObject {
        readonly property int sm: 3
        readonly property int md: 4
    }

    // Rounding -----------------------------------
    component Rounding: QtObject {
        readonly property real full: 1000
    }

    // Padding ------------------------------------
    component Padding: QtObject {
        readonly property real xl: 60
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
        readonly property real md: 15
        readonly property real lg: 17
    }
}
