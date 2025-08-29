import Quickshell

import QtQuick

import qs.modules.Bar
import qs.modules.Drawers

import qs.components
import qs.services

ShellRoot {
    Drawers {
        id: drawers
    }

    Bar {
        id: bar
    }
}
