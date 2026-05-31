pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

import qs.config

Singleton {
    id: root

    IpcHandler {
        target: "theme"

        function reload() {
            root.reloadFromConfig();
        }
    }

    function reloadFromConfig() {
        if (!Config.colorThemeFile) {
            console.log("ThemeService: Config.colorThemeFile is empty");
            return;
        }

        themeFile.path = Config.colorThemeFile;
        themeFile.reload();
        root.applyThemeFromJson(themeFile.text());
    }

    function applyThemeFromJson(text: string) {
        if (!text || text.trim().length === 0)
            return;

        let data = null;
        try {
            data = JSON.parse(text);
        } catch (err) {
            console.log(`ThemeService: failed to parse theme JSON: ${err}`);
            return;
        }

        const hasPrimary = data.primary && data.primary.default && data.primary.dark && data.primary.light;
        const hasSecondary = !!data.secondary;
        const hasTertiary = data.tertiary && data.tertiary.default && data.tertiary.contrast;

        if (!hasPrimary) {
            console.log("ThemeService: missing required primary.* keys");
            return;
        }

        if (!hasSecondary) {
            console.log("ThemeService: missing required key: secondary");
            return;
        }

        if (!hasTertiary) {
            console.log("ThemeService: missing required tertiary.* keys");
            return;
        }

        Appearance.colors.primary = data.primary.default;
        Appearance.colors.primary_dark = data.primary.dark;
        Appearance.colors.primary_light = data.primary.light;
        Appearance.colors.secondary = data.secondary;
        Appearance.colors.tertiary = data.tertiary.default;
        Appearance.colors.tertiary_contrast = data.tertiary.contrast;
    }

    FileView {
        id: themeFile

        path: Config.colorThemeFile
        watchChanges: true

        onLoadedChanged: {
            if (loaded)
                root.applyThemeFromJson(text());
        }

        onFileChanged: {
            reload();
            root.applyThemeFromJson(text());
        }
    }

    Component.onCompleted: reloadFromConfig()
}
