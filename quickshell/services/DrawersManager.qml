pragma Singleton

import Quickshell

import QtQuick

Singleton {

    readonly property Call call: Call {}

    signal audioMixerCalled

    function dispatch(name: string) {
        switch (name) {
        case call.audioMixer:
            audioMixerCalled();
            break;
        default:
            console.log("ERROR: Unknown DrawersManager call");
        }
    }

    component Call: QtObject {
        readonly property string audioMixer: "audio_mixer"
    }
}
