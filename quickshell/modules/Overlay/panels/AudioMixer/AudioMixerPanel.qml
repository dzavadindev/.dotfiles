pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
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

    implicitHeight: layout.implicitHeight + Appearance.padding.lg
    implicitWidth: layout.implicitWidth + Appearance.padding.lg
    width: parent ? parent.width : implicitWidth
    height: parent ? parent.height : implicitHeight

    topLeftRadius: Appearance.rounding.normal
    bottomLeftRadius: Appearance.rounding.normal

    Column {
        id: layout

        spacing: Appearance.padding.sm

        anchors.centerIn: parent

        Row {
            id: tabs

            spacing: Appearance.padding.md

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

            clip: true

            model: root.category === "apps" ? appsModel : root.category === "playbacks" ? sinksModel : micsModel

            implicitHeight: Appearance.elementSize.audioMixer_listHeight
            implicitWidth: contentItem.childrenRect.width

            width: implicitWidth

            delegate: AudioElement {}
        }
    }

    // --------------------------- MODELS AND COMPONENTS -----------------------------------

    ScriptModel {
        id: appsModel
        values: AudioService.nodes.values.filter(n => n.audio && PW.PwNodeType.toString(n.type) === "AudioOutStream")
    }

    ScriptModel {
        id: sinksModel
        values: AudioService.nodes.values.filter(n => n.audio && PW.PwNodeType.toString(n.type) === "AudioSink")
    }

    ScriptModel {
        id: micsModel
        values: AudioService.nodes.values.filter(n => n.audio && !n.isSink && !n.isStream)
    }

    component AudioElement: Rectangle {
        id: audio_element

        required property var modelData

        color: "transparent"
        implicitHeight: name.implicitHeight + slider.implicitHeight + Appearance.padding.sm
        implicitWidth: slider.implicitWidth

        PW.PwObjectTracker {
            id: binder
            objects: [audio_element.modelData]
        }

        Column {
            id: column

            MarqueeText {
                id: name

                maxWidth: slider.implicitWidth

                text: AudioService.getNodeName(audio_element.modelData)
            }

            VolumeSlider {
                id: slider

                node: audio_element.modelData
                category: root.category
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
