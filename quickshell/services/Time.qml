pragma Singleton

import Quickshell

Singleton {
    id: root

    readonly property date date: clock.date
    readonly property string time: {
        Qt.formatDateTime(clock.date, 'hh:mm');
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
