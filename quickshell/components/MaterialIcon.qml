import QtQuick

import qs.config

Item {
    id: root

    required property string name
    property color color: Appearance.colors.secondary
    property int size: Appearance.font.size.sm
    property int weight: Font.Normal

    implicitWidth: glyph.implicitWidth
    implicitHeight: glyph.implicitHeight

    Text {
        id: glyph

        anchors.fill: parent
        text: root.name
        color: root.color

        font.pointSize: root.size
        font.family: Appearance.font.family.material
        font.weight: root.weight
        font.kerning: true

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        renderType: Text.NativeRendering

        // Avoid showing wrong glyph if font isn’t ready yet
        visible: (font.family && font.family.length > 0)
    }
}
