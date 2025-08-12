import Quickshell

import qs.modules.Bar
import qs.modules.Drawers

ShellRoot {
    Drawers {
        id: drawers
        barHeight: bar.implicitHeight
    }
    Bar {
        id: bar
    }
}
