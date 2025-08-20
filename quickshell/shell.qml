import Quickshell

import qs.modules.Bar
import qs.modules.Drawers

import qs.components

ShellRoot {
    Drawers {
        id: drawers
        barHeight: bar.implicitHeight
    }

    Bar {
        id: bar
    }
}
