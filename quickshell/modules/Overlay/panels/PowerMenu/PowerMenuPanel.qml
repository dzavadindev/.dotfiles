pragma ComponentBehavior: Bound

import Quickshell

import QtQuick
import QtQuick.Shapes
import Qt5Compat.GraphicalEffects

import qs.config
import qs.components

Item {
    id: root

    readonly property var options: [
        {
            label: "shutdown",
            icon: "power_settings_circle",
            command: ["shutdown", "now"]
        },
        {
            label: "reboot",
            icon: "refresh",
            command: ["reboot"]
        },
        {
            label: "log out",
            icon: "logout",
            command: ["logout"]
        }
    ]

    property int selectedIndex: 0
    readonly property real panelRadius: Appearance.rounding.normal

    implicitWidth: optionRow.implicitWidth + Appearance.padding.sm * 2
    implicitHeight: optionRow.implicitHeight + Appearance.padding.sm * 2

    function wrapIndex(index: int): int {
        return ((index % options.length) + options.length) % options.length;
    }

    function syncVisualState() {
        for (let i = 0; i < optionRepeater.count; i++) {
            const item = optionRepeater.itemAt(i);

            if (item)
                item.setSelectedInstant(i === selectedIndex);
        }
    }

    function selectIndex(index: int) {
        const nextIndex = wrapIndex(index);

        if (nextIndex === selectedIndex)
            return;

        const previousIndex = selectedIndex;
        const previousItem = optionRepeater.itemAt(previousIndex);
        const nextItem = optionRepeater.itemAt(nextIndex);

        selectedIndex = nextIndex;

        if (previousItem)
            previousItem.animateOut();

        if (nextItem)
            nextItem.animateIn(previousItem ? previousItem.fadeOutDuration : 0);
    }

    function moveLeft() {
        selectIndex(selectedIndex - 1);
    }

    function moveRight() {
        selectIndex(selectedIndex + 1);
    }

    function resetSelection() {
        selectedIndex = 0;
        syncVisualState();
    }

    function executeSelected() {
        Quickshell.execDetached({
            command: options[selectedIndex].command
        });
    }

    function roundedRectPath(x: real, y: real, width: real, height: real, radius: real): string {
        const safeRadius = Math.max(0, Math.min(radius, width / 2, height / 2));

        if (safeRadius === 0)
            return `M ${x} ${y} H ${x + width} V ${y + height} H ${x} Z`;

        return `M ${x + safeRadius} ${y} H ${x + width - safeRadius} A ${safeRadius} ${safeRadius} 0 0 1 ${x + width} ${y + safeRadius} V ${y + height - safeRadius} A ${safeRadius} ${safeRadius} 0 0 1 ${x + width - safeRadius} ${y + height} H ${x + safeRadius} A ${safeRadius} ${safeRadius} 0 0 1 ${x} ${y + height - safeRadius} V ${y + safeRadius} A ${safeRadius} ${safeRadius} 0 0 1 ${x + safeRadius} ${y} Z`;
    }

    function buildMaskPath(): string {
        let path = roundedRectPath(0, 0, width, height, panelRadius);

        for (let i = 0; i < optionRepeater.count; i++) {
            const item = optionRepeater.itemAt(i);

            if (!item)
                continue;

            path += ` ${roundedRectPath(optionRow.x + item.x, optionRow.y + item.y, item.width, item.height, item.radius)}`;
        }

        return path;
    }

    Item {
        id: panelSource

        anchors.fill: parent
        visible: false

        Rectangle {
            anchors.fill: parent

            radius: root.panelRadius
            color: Appearance.colors.primary
        }
    }

    Shape {
        id: panelMask

        anchors.fill: parent
        visible: false

        ShapePath {
            fillColor: "white"
            fillRule: ShapePath.OddEvenFill
            strokeColor: "transparent"
            strokeWidth: 0

            PathSvg {
                path: root.buildMaskPath()
            }
        }
    }

    OpacityMask {
        anchors.fill: parent
        source: panelSource
        maskSource: panelMask
    }

    Row {
        id: optionRow

        anchors.centerIn: parent
        spacing: Appearance.padding.sm

        Repeater {
            id: optionRepeater

            model: root.options

            Item {
                required property int index
                required property var modelData

                readonly property bool selected: index === root.selectedIndex
                readonly property real borderInset: Appearance.borderWidth.sm
                readonly property real radius: Appearance.rounding.normal
                readonly property int fadeOutDuration: 210

                property int fadeInDelay: 0

                implicitWidth: contentRow.implicitWidth + Appearance.padding.lg * 2
                implicitHeight: contentRow.implicitHeight + Appearance.padding.sm * 2
                width: implicitWidth
                height: implicitHeight

                function setSelectedInstant(active: bool) {
                    fadeOutFlicker.stop();
                    fadeInFlicker.stop();
                    selectedFill.opacity = active ? 1 : 0;
                }

                function animateOut() {
                    fadeInFlicker.stop();
                    fadeOutFlicker.stop();
                    selectedFill.opacity = 1;
                    fadeOutFlicker.start();
                }

                function animateIn(delay: int) {
                    fadeOutFlicker.stop();
                    fadeInFlicker.stop();
                    fadeInDelay = delay;
                    selectedFill.opacity = 0;
                    fadeInFlicker.start();
                }

                Rectangle {
                    id: selectedFill

                    anchors.fill: parent
                    anchors.margins: parent.borderInset

                    radius: Math.max(0, parent.radius - parent.borderInset)
                    color: Appearance.colors.secondary
                    opacity: parent.selected ? 1 : 0
                }

                SequentialAnimation {
                    id: fadeOutFlicker

                    running: false

                    NumberAnimation {
                        target: selectedFill
                        property: "opacity"
                        to: 0.58
                        duration: 55
                        easing.type: Easing.OutQuad
                    }

                    NumberAnimation {
                        target: selectedFill
                        property: "opacity"
                        to: 0.82
                        duration: 40
                        easing.type: Easing.InQuad
                    }

                    NumberAnimation {
                        target: selectedFill
                        property: "opacity"
                        to: 0.32
                        duration: 50
                        easing.type: Easing.OutQuad
                    }

                    NumberAnimation {
                        target: selectedFill
                        property: "opacity"
                        to: 0
                        duration: 65
                        easing.type: Easing.OutCubic
                    }
                }

                SequentialAnimation {
                    id: fadeInFlicker

                    running: false

                    PauseAnimation {
                        duration: parent.fadeInDelay
                    }

                    NumberAnimation {
                        target: selectedFill
                        property: "opacity"
                        to: 0.38
                        duration: 60
                        easing.type: Easing.OutQuad
                    }

                    NumberAnimation {
                        target: selectedFill
                        property: "opacity"
                        to: 0.16
                        duration: 45
                        easing.type: Easing.InQuad
                    }

                    NumberAnimation {
                        target: selectedFill
                        property: "opacity"
                        to: 0.74
                        duration: 70
                        easing.type: Easing.OutQuad
                    }

                    NumberAnimation {
                        target: selectedFill
                        property: "opacity"
                        to: 1
                        duration: 120
                        easing.type: Easing.OutCubic
                    }
                }

                Row {
                    id: contentRow

                    anchors.centerIn: parent
                    spacing: Appearance.padding.xs

                    MaterialIcon {
                        id: icon

                        color: Appearance.colors.primary

                        name: modelData.icon
                        size: Appearance.font.size.md
                        weight: Font.Bold

                        Behavior on color {
                            ColorAnimation {
                                duration: 140
                            }
                        }
                    }

                    Text {
                        id: label

                        color: Appearance.colors.primary

                        font.family: Appearance.font.family.mono
                        font.pointSize: Appearance.font.size.md
                        font.bold: true
                        text: modelData.label

                        Behavior on color {
                            ColorAnimation {
                                duration: 140
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: syncVisualState()
}
