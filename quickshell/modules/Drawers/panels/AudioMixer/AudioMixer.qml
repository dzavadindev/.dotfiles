import Quickshell
import Quickshell.Services.Pipewire as PW

import QtQuick
import QtQuick.Controls

import qs.services
import qs.config

Rectangle {
    id: root

    color: Appearance.colors.primary

    property string category: "playbacks"

    ScriptModel {
        id: appsModel
        values: Pipewire.nodes.values.filter(n => n.audio && PW.PwNodeType.toString(n.type) === "AudioOutStream")
    }

    ScriptModel {
        id: sinksModel
        values: Pipewire.nodes.values.filter(n => n.audio && PW.PwNodeType.toString(n.type) === "AudioSink")
    }

    ScriptModel {
        id: micsModel
        values: Pipewire.nodes.values.filter(n => n.audio && !n.isSink && !n.isStream)
    }

    PW.PwObjectTracker {
        id: binder
        objects: [...appsModel.values.map(v => v.node), ...sinksModel.values.map(v => v.node), ...micsModel.values.map(v => v.node)]
    }

    component AudioElement: Rectangle {
        id: audio_element

        required property var modelData

        color: "transparent"
        implicitHeight: name.implicitHeight + vol.implicitHeight + Appearance.padding.md

        Component.onCompleted: () => {
            console.log(Pipewire.getNodeName(modelData), " ", PW.PwNodeType.toString(modelData.type));
        }

        PW.PwObjectTracker {
            id: binder
            objects: [audio_element.modelData]
        }

        Column {
            anchors.margins: 6
            anchors.fill: parent
            Text {
                id: name
                text: Pipewire.getNodeName(audio_element.modelData)
            }

            Row {
                spacing: 8
                Slider {
                    id: vol
                    from: 0.0
                    to: 1.0
                    value: audio_element.modelData.audio ? audio_element.modelData.audio.volume : 1.0
                    onMoved: if (audio_element.modelData.audio)
                        audio_element.modelData.audio.volume = value
                    enabled: !!audio_element.modelData.audio
                }
                CheckBox {
                    text: "Mute"
                    checked: audio_element.modelData.audio ? audio_element.modelData.audio.muted : false
                    onToggled: if (audio_element.modelData.audio)
                        audio_element.modelData.audio.muted = checked
                    enabled: !!audio_element.modelData.audio
                }
            }
        }
    }
    // ------------------------------------------------------ VISUALS

    Row {
        id: tabs

        spacing: Appearance.padding.sm

        Button {
            text: "Playbacks"
            onClicked: root.category = "playbacks"
        }

        Button {
            text: "Applications"
            onClicked: root.category = "apps"
        }

        Button {
            text: "Microphones"
            onClicked: root.category = "mics"
        }
    }

    ListView {
        id: list

        model: root.category === "apps" ? appsModel : root.category === "playbacks" ? sinksModel : micsModel

        anchors.top: tabs.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        delegate: AudioElement {}
    }
}
