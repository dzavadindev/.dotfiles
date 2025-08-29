pragma Singleton

import Quickshell

import QtQuick

Singleton {

    readonly property Call call: Call {}

    signal audioMixerCalled
    signal notificationCenterCalled

    function dispatch(name: string) {
        switch (name) {
        case call.audioMixer:
            audioMixerCalled();
            break;
        case call.notificationCenter:
            notificationCenterCalled();
            break;
        default:
            console.log("ERROR: Unknown DrawersManager call");
        }
    }

    component Call: QtObject {
        readonly property string audioMixer: "audio_mixer"
        readonly property string notificationCenter: "notification_center"
    }
}
