pragma Singleton

import Quickshell
import Quickshell.Services.UPower as QSUP

import QtQuick

Singleton {
    id: root

    // Display device is the "main" device for the system
    readonly property QSUP.UPowerDevice displayDevice: QSUP.UPower.displayDevice
    readonly property real percentage: displayDevice.percentage
    readonly property bool isLaptop: displayDevice.isLaptopBattery
    readonly property var batteryState: displayDevice.state

    readonly property BatteryState batteryIcons: BatteryState {}

    property string batteryIcon: batteryIcons.full
    property int rounded_percentage: 0

    function updatePowerInfo() {
        rounded_percentage = Math.round(percentage * 100);

        if (batteryState === QSUP.UPowerDeviceState.Charging) {
            batteryIcon = batteryIcons.charging;
            return;
        }

        if (percentage > 0.84)
            batteryIcon = batteryIcons.full;
        else if (percentage > 0.68)
            batteryIcon = batteryIcons.almost_half;
        else if (percentage > 0.52)
            batteryIcon = batteryIcons.half;
        else if (percentage > 0.36)
            batteryIcon = batteryIcons.almost_critical;
        else
            batteryIcon = batteryIcons.critical;
    }

    onPercentageChanged: updatePowerInfo()
    onBatteryStateChanged: updatePowerInfo()

    Component.onCompleted: updatePowerInfo()

    component BatteryState: QtObject {
        readonly property string full: "battery_6_bar"
        readonly property string almost_full: "battery_5_bar"
        readonly property string almost_half: "battery_4_bar"
        readonly property string half: "battery_3_bar"
        readonly property string almost_critical: "battery_2_bar"
        readonly property string critical: "battery_alert"
        readonly property string charging: "bolt"
    }
}
