import QtQuick

import Quickshell
import Quickshell.Widgets

import qs.config
import qs.components
import qs.services

WrapperMouseArea {

    onClicked: () => {
        OverlayManager.toggle(OverlayManager.panel.audioMixer);
    }

    Rectangle {
        id: root

        readonly property bool active: OverlayManager.isActive(OverlayManager.panel.audioMixer)

        color: active ? Appearance.colors.secondary : Appearance.colors.primary_light

        implicitWidth: contentRow.implicitWidth + Appearance.padding.sm * 2
        implicitHeight: contentRow.implicitHeight + Appearance.padding.sm

        Behavior on color {
            ColorAnimation {
                duration: 300
                easing.type: Easing.OutQuad
            }
        }

        Row {
            id: contentRow
            spacing: Appearance.padding.xs
            anchors.centerIn: parent

            MaterialIcon {
                id: icon

                name: AudioService.volumeIcon
                color: root.active ? Appearance.colors.primary : Appearance.colors.secondary
                size: Appearance.font.size.md
                weight: Font.Bold
            }

            Text {
                id: charge
                visible: !AudioService.isMuted

                text: AudioService.volume

                anchors.verticalCenter: parent.verticalCenter

                color: root.active ? Appearance.colors.primary : Appearance.colors.secondary
                font.pointSize: Appearance.font.size.sm
                font.family: Appearance.font.family.mono
            }
        }
    }
}
