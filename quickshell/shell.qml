import Quickshell

import QtQuick

import qs.modules.Bar
import qs.modules.Drawers

import qs.components
import qs.config
import qs.services

ShellRoot {
    FloatingWindow {
        id: testWindow
        property int counter: 0
        property bool stuck: false

        color: "black"

        Timer {
            interval: 2000
            repeat: true
            running: true

            onTriggered: {
                if (testWindow.stuck) {
                    testWindow.stuck = false;
                    testModel.insert(0, {
                        number: testWindow.counter
                    });
                    return;
                }

                if (testWindow.counter >= 3) {
                    testWindow.stuck = true;
                    testWindow.counter++;
                    testModel.remove(testModel.count - 1, 1);
                    return;
                }

                for (let i = 0; i < 1; i++) {
                    testWindow.counter++;
                    testModel.append({
                        number: testWindow.counter
                    });
                }
            }
        }

        ListModel {
            id: testModel
        }

        RollingListView {
            id: testListView

            model: testModel

            wrapperWidth: {
                let size = Appearance.elementSize.notificationListItem_width;
                let h_pad = Appearance.padding.md;
                return size + h_pad;
            }
            wrapperColor: Appearance.colors.primary
            wrapperBottomRadius: Appearance.rounding.normal

            delegate: Rectangle {

                color: Appearance.colors.secondary
                radius: Appearance.rounding.normal

                implicitHeight: Appearance.elementSize.notificationListItem_height
                implicitWidth: testListView.width

                Text {
                    anchors.centerIn: parent
                    color: Appearance.colors.primary
                    text: parent.modelData.number
                }
            }
        }
    }

    Drawers {
        id: drawers
    }

    Bar {
        id: bar
    }
}
