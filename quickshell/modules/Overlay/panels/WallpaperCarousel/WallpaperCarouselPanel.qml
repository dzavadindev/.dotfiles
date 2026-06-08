pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects

import qs.config
import qs.services

Rectangle {
    id: root

    readonly property var wallpapers: WallpaperService.wallpapers
    property int selectedIndex: wallpapers.length > 0 ? 0 : -1
    readonly property real previewWidth: 150
    readonly property real previewHeight: 82
    readonly property real previewSpacing: Appearance.padding.sm
    readonly property int previewSlotCount: wallpapers.length > 0 ? Math.min(wallpapers.length, (selectedIndex <= 0 || selectedIndex >= wallpapers.length - 1) ? 2 : 3) : 3
    readonly property real oversizedImageScale: 1.08

    color: Appearance.colors.primary

    implicitWidth: previewSlotCount * previewWidth + Math.max(0, previewSlotCount - 1) * previewSpacing + Appearance.padding.sm * 2
    implicitHeight: Appearance.elementSize.wallpaperCarousel_height

    radius: Appearance.rounding.normal

    function wrapIndex(index: int, count: int): int {
        if (count <= 0)
            return -1;
        return ((index % count) + count) % count;
    }

    function selectedWallpaperPath(): string {
        if (selectedIndex < 0 || selectedIndex >= wallpapers.length)
            return "";
        return wallpapers[selectedIndex];
    }

    function moveLeft() {
        if (wallpapers.length <= 0)
            return;

        selectedIndex = wrapIndex(selectedIndex - 1, wallpapers.length);
    }

    function moveRight() {
        if (wallpapers.length <= 0)
            return;

        selectedIndex = wrapIndex(selectedIndex + 1, wallpapers.length);
    }

    function applySelected() {
        const selectedPath = selectedWallpaperPath();
        if (!selectedPath)
            return;
        WallpaperService.setWallpaper(selectedPath);
    }

    onWallpapersChanged: {
        if (wallpapers.length <= 0) {
            selectedIndex = -1;
            return;
        }

        selectedIndex = selectedIndex < 0 ? 0 : wrapIndex(selectedIndex, wallpapers.length);
    }

    function carouselX(): real {
        if (selectedIndex <= 0)
            return 0;

        const contentWidth = wallpapers.length * previewWidth + Math.max(0, wallpapers.length - 1) * previewSpacing;
        if (selectedIndex >= wallpapers.length - 1)
            return viewport.width - contentWidth;

        const selectedCenter = selectedIndex * (previewWidth + previewSpacing) + previewWidth / 2;
        return viewport.width / 2 - selectedCenter;
    }

    Item {
        id: viewport

        anchors.fill: parent
        anchors.margins: Appearance.padding.sm
        clip: true

        Row {
            id: carousel

            spacing: root.previewSpacing
            y: (viewport.height - root.previewHeight) / 2
            x: root.carouselX()

            Behavior on x {
                NumberAnimation {
                    duration: 170
                    easing.type: Easing.OutQuad
                }
            }

            Repeater {
                model: root.wallpapers

                Rectangle {
                    id: listItem

                    required property int index
                    required property var modelData

                    readonly property string path: modelData
                    readonly property bool selected: index === root.selectedIndex

                    width: root.previewWidth
                    height: root.previewHeight
                    radius: Appearance.rounding.normal

                    color: Appearance.colors.primary_dark
                    clip: true
                    opacity: selected ? 1 : 0.58

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 120
                            easing.type: Easing.OutQuad
                        }
                    }

                    Image {
                        id: wallpaperImage

                        anchors.centerIn: parent
                        width: parent.width * root.oversizedImageScale
                        height: parent.height * root.oversizedImageScale

                        source: listItem.path ? `file://${listItem.path}` : ""
                        fillMode: Image.PreserveAspectCrop
                        sourceSize.width: Math.max(1, Math.round(width))
                        sourceSize.height: Math.max(1, Math.round(height))
                        asynchronous: true
                        cache: true
                        smooth: true
                        mipmap: true
                        visible: false
                    }

                    Rectangle {
                        id: imageMask

                        anchors.fill: parent
                        radius: parent.radius
                        color: "white"
                        visible: false
                        layer.enabled: true
                    }

                    MultiEffect {
                        anchors.fill: parent

                        source: wallpaperImage
                        maskEnabled: true
                        maskSource: imageMask
                    }

                    Rectangle {
                        anchors.fill: parent
                        radius: parent.radius
                        color: "transparent"
                        border.width: listItem.selected ? Appearance.borderWidth.sm : 0
                        border.color: listItem.selected ? Appearance.colors.secondary : "transparent"
                    }
                }
            }
        }
    }

    Text {
        anchors.centerIn: parent
        visible: root.wallpapers.length <= 0

        color: Appearance.colors.secondary
        font.family: Appearance.font.family.mono
        font.pointSize: Appearance.font.size.md
        text: "No wallpapers found"
    }
}
