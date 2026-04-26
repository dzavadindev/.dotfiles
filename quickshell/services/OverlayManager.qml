pragma Singleton

import Quickshell

import QtQuick

Singleton {

    readonly property Panel panel: Panel {}
    property string activePanelId: ""
    readonly property bool isOpen: activePanelId !== ""

    signal activeChanged(string oldId, string newId)

    function isActive(id: string): bool {
        return activePanelId === id;
    }

    function open(id: string) {
        if (!isKnownPanel(id)) {
            console.log(`ERROR: Unknown OverlayManager panel id: ${id}`);
            return;
        }

        if (activePanelId === id) {
            closeAll();
            return;
        }

        const oldId = activePanelId;
        activePanelId = id;
        activeChanged(oldId, id);
    }

    function toggle(id: string) {
        open(id);
    }

    function closeAll() {
        if (!isOpen)
            return;

        const oldId = activePanelId;
        activePanelId = "";
        activeChanged(oldId, "");
    }

    function isKnownPanel(id: string): bool {
        return id === panel.audioMixer || id === panel.notificationCenter;
    }

    component Panel: QtObject {
        readonly property string audioMixer: "audio_mixer"
        readonly property string notificationCenter: "notification_center"
    }
}
