import Quickshell

import QtQuick
import QtQuick.Controls

import QtQml.Models

import qs.services
import qs.config

Rectangle {
    id: root

    implicitHeight: 400
    implicitWidth: 400

    color: Appearance.colors.primary

    DelegateModel {
        id: nodesModel
        model: Pipewire.nodes
        groups: [
            DelegateModelGroup {
                name: "sinks"
                includeByDefault: false
            },
            DelegateModelGroup {
                name: "sources"
                includeByDefault: false
            },
            DelegateModelGroup {
                name: "inputs"
                includeByDefault: false
            }
        ]
        filterOnGroup: "sinks"
        delegate: Rectangle {
            id: item

            required property var modelData

            implicitHeight: (device_name.implicitHeight + volume_slider.implicitHeight) + Appearance.padding.sm
            implicitWidth: Appearance.drawerSize.lg

            color: Appearance.colors.accent

            Component.onCompleted: () => {
                item.DelegateModel.inSinks = modelData.isSink;
                item.DelegateModel.inSources = modelData.isStream;
                item.DelegateModel.inInputs = !modelData.isStream;
                console.log(item.DelegateModel.inSinks);
                console.log(item.DelegateModel.inSources);
                console.log(item.DelegateModel.inInputs);
            }

            Text {
                id: device_name

                text: item.modelData.name

                color: Appearance.colors.secondary
            }

            Slider {
                id: volume_slider
            }
        }
    }

    ListView {
        id: list
        anchors.fill: parent
        model: nodesModel
    }

    Row {
        anchors.bottom: parent.bottom
        spacing: 8
        Button {
            text: "Sinks"
            onClicked: nodesModel.filterOnGroup = "sinks"
        }
        Button {
            text: "Sources"
            onClicked: nodesModel.filterOnGroup = "sources"
        }
        Button {
            text: "Inputs"
            onClicked: nodesModel.filterOnGroup = "inputs"
        }
    }
}
