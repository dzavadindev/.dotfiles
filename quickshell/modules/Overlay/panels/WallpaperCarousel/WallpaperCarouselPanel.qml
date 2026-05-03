pragma ComponentBehavior: Bound

import QtQuick

import qs.config
import qs.services

Rectangle {
    id: root

    readonly property var wallpapers: WallpaperService.wallpapers
    property int selectedIndex: wallpapers.length > 0 ? 0 : -1
    readonly property var visibleOffsets: [-2, -1, 0, 1, 2]
    property real slideOffset: 0
    property bool isAnimating: false
    property int queuedDirection: 0
    property int preloadCount: 0
    readonly property int preloadChunkSize: 16

    color: Appearance.colors.primary

    implicitWidth: Appearance.elementSize.wallpaperCarousel_width
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
        animateStep(-1);
    }

    function moveRight() {
        animateStep(1);
    }

    function animateStep(direction: int) {
        if (wallpapers.length <= 0)
            return;

        if (isAnimating) {
            queuedDirection = direction;
            return;
        }

        isAnimating = true;
        const stepDistance = viewport.width * 0.15;
        slideAnimation.from = 0;
        slideAnimation.to = direction > 0 ? -stepDistance : stepDistance;
        slideAnimation.start();
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
            preloadCount = 0;
            preloadTimer.stop();
            return;
        }

        selectedIndex = wrapIndex(selectedIndex, wallpapers.length);
        preloadCount = 0;
        preloadTimer.start();
    }

    Component.onCompleted: {
        if (wallpapers.length > 0)
            preloadTimer.start();
    }

    NumberAnimation {
        id: slideAnimation
        target: root
        property: "slideOffset"
        duration: 170
        easing.type: Easing.OutQuad

        onStopped: {
            if (!root.isAnimating)
                return;

            const direction = to < 0 ? 1 : -1;
            root.selectedIndex = root.wrapIndex(root.selectedIndex + direction, root.wallpapers.length);
            root.slideOffset = 0;
            root.isAnimating = false;

            if (root.queuedDirection !== 0) {
                const nextDirection = root.queuedDirection;
                root.queuedDirection = 0;
                root.animateStep(nextDirection);
            }
        }
    }

    Timer {
        id: preloadTimer
        interval: 10
        repeat: true

        onTriggered: {
            if (root.preloadCount >= root.wallpapers.length) {
                stop();
                return;
            }

            root.preloadCount = Math.min(root.wallpapers.length, root.preloadCount + root.preloadChunkSize);
        }
    }

    Item {
        id: viewport

        anchors.fill: parent
        anchors.margins: Appearance.padding.sm

        Row {
            id: carousel

            spacing: Appearance.padding.sm
            anchors.centerIn: parent
            transform: Translate {
                x: root.slideOffset
            }

            Repeater {
                model: root.visibleOffsets

                Rectangle {
                    id: listItem

                    required property int modelData

                    readonly property int wallpaperCount: root.wallpapers.length
                    readonly property int localIndex: root.wrapIndex(root.selectedIndex + modelData, wallpaperCount)
                    readonly property string path: localIndex >= 0 ? root.wallpapers[localIndex] : ""
                    readonly property bool selected: modelData === 0
                    readonly property real distance: Math.abs(modelData)
                    readonly property real scale: distance === 0 ? 1.0 : distance === 1 ? 0.62 : 0.35

                    width: viewport.width * 0.5 * scale
                    height: viewport.height * 0.92 * scale

                    radius: Appearance.rounding.normal
                    color: Appearance.colors.primary_light

                    border.width: selected ? Appearance.borderWidth.sm : 0
                    border.color: selected ? Appearance.colors.secondary : "transparent"
                    opacity: wallpaperCount > 0 ? (selected ? 1 : distance === 1 ? 0.72 : 0.42) : 0

                    Behavior on width {
                        NumberAnimation {
                            duration: 180
                            easing.type: Easing.OutQuad
                        }
                    }

                    Behavior on height {
                        NumberAnimation {
                            duration: 180
                            easing.type: Easing.OutQuad
                        }
                    }

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 120
                            easing.type: Easing.OutQuad
                        }
                    }

                    Image {
                        anchors.fill: parent
                        anchors.margins: listItem.selected ? Appearance.padding.xs : 0

                        source: listItem.path ? `file://${listItem.path}` : ""
                        fillMode: Image.PreserveAspectCrop
                        sourceSize.width: Math.max(1, Math.round(width))
                        sourceSize.height: Math.max(1, Math.round(height))
                        asynchronous: true
                        cache: true
                        smooth: true
                        mipmap: true
                        clip: true
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

    Item {
        visible: false

        Repeater {
            model: root.preloadCount

            Image {
                required property int modelData

                source: root.wallpapers[modelData] ? `file://${root.wallpapers[modelData]}` : ""
                sourceSize.width: Math.max(1, Math.round(viewport.width * 0.5))
                sourceSize.height: Math.max(1, Math.round(viewport.height * 0.92))
                asynchronous: true
                cache: true
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
