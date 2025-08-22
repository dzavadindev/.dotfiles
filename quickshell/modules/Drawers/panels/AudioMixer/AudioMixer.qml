pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.Pipewire as PW

import QtQuick
import QtQuick.Controls

import qs.services
import qs.config
import qs.components

Rectangle {
    id: root

    color: Appearance.colors.primary

    property string category: "playbacks"

    implicitHeight: wrapper.implicitHeight
    implicitWidth: wrapper.implicitWidth

    Rectangle {
        id: wrapper

        implicitHeight: list.implicitHeight + tabs.implicitHeight + Appearance.padding.md
        implicitWidth: list.implicitWidth + Appearance.padding.xl

        color: Appearance.colors.primary

        Component.onCompleted: () => {
            console.log(list.implicitWidth);
            console.log(tabs.implicitWidth);
        }

        Row {
            id: tabs

            spacing: Appearance.padding.sm

            anchors.horizontalCenter: parent.horizontalCenter

            AudioTab {
                id: playbacks
                name: "headphones"
                group: "playbacks"
            }

            AudioTab {
                id: apps
                name: "ad"
                group: "apps"
            }

            AudioTab {
                id: mics
                name: "mic"
                group: "mics"
            }
        }

        ListView {
            id: list

            model: root.category === "apps" ? appsModel : root.category === "playbacks" ? sinksModel : micsModel

            anchors.top: tabs.bottom

            implicitHeight: Appearance.elementSize.audioMixer_listHeight
            implicitWidth: Appearance.elementSize.audioMixer_sliderWidth

            delegate: AudioElement {}
        }
    }

    // --------------------------- MODELS AND COMPONENTS -----------------------------------

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

    component AudioElement: Rectangle {
        id: audio_element

        required property var modelData

        color: "transparent"
        implicitHeight: name.implicitHeight + slider.implicitHeight + Appearance.padding.md

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
                color: Appearance.colors.secondary
                font.pointSize: Appearance.font.size.sm
                font.family: Appearance.font.family.mono
            }

            VolumeSlider {
                id: slider

                audio: audio_element.modelData.audio
            }
        }
    }

    component AudioTab: IconButton {
        id: tab

        required property string name
        required property string group

        property bool selected: root.category === group

        iconName: name

        mainColor: selected ? Appearance.colors.secondary : Appearance.colors.primary
        iconColor: selected ? Appearance.colors.primary : Appearance.colors.secondary

        onClicked: root.category = group
    }
}
