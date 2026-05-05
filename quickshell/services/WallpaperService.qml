pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

import qs.services

Singleton {
    id: root

    readonly property string wallpapersDir: `${Quickshell.env("HOME")}/Pictures/Wallpapers`
    property list<string> wallpapers: []
    property string currentWallpaper: ""

    function reloadWallpapers() {
        listProcess.exec(["sh", "-c", `find "${wallpapersDir}" -maxdepth 1 -type f \\( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \\) | sort`]);
    }

    function isManagedWallpaper(path: string): bool {
        return wallpapers.includes(path);
    }

    function setWallpaper(path: string) {
        if (!path) {
            console.log("WallpaperService: empty wallpaper path");
            return;
        }

        if (!isManagedWallpaper(path)) {
            console.log(`WallpaperService: rejected unmanaged wallpaper path: ${path}`);
            return;
        }

        applyProcess.exec(["awww", "img", "--transition-type", "random", "--transition-duration", "0.5", "--transition-fps", "144", path]);
        currentWallpaper = path;
        ThemeService.applyPaletteFromImage(path);
    }

    function setWallpaperByIndex(index: int) {
        if (index < 0 || index >= wallpapers.length) {
            console.log(`WallpaperService: index out of bounds: ${index}`);
            return;
        }

        setWallpaper(wallpapers[index]);
    }

    Component.onCompleted: {
        reloadWallpapers();
        queryProcess.exec(["awww", "query", "-j"]);
        watcherProcess.running = true;
    }

    // One-shot scanner to rebuild list
    Process {
        id: listProcess

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.split("\n").map(line => line.trim()).filter(line => line.length > 0);
                root.wallpapers = lines;
                if (root.currentWallpaper && !root.wallpapers.includes(root.currentWallpaper))
                    root.currentWallpaper = "";
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                if (text.trim().length > 0)
                    console.log(`WallpaperService list error: ${text.trim()}`);
            }
        }
    }

    // Query current wallpaper
    Process {
        id: queryProcess

        stdout: StdioCollector {
            onStreamFinished: {
                const raw = JSON.parse(text);
                // const a = Object.entries(raw).map(([output, state]) => ({ output, ...state }))
                console.log(JSON.stringify(raw));
                // if (!root.currentWallpaper)
                //     root.currentWallpaper = raw[0].displaying.image;
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                if (text.trim().length > 0)
                    console.log(`WallpaperService list error: ${text.trim()}`);
            }
        }
    }

    // Applies wallpaper
    Process {
        id: applyProcess

        stderr: StdioCollector {
            onStreamFinished: {
                if (text.trim().length > 0)
                    console.log(`WallpaperService apply error: ${text.trim()}`);
            }
        }
    }

    // Watches directory changes live
    Process {
        id: watcherProcess

        command: ["inotifywait", "-m", "-e", "create", "-e", "moved_to", "-e", "delete", "-e", "moved_from", "--format", "%w%f", root.wallpapersDir]

        stdout: SplitParser {
            onRead: _line => {
                root.reloadWallpapers();
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                if (text.trim().length > 0)
                    console.log(`WallpaperService watcher error: ${text.trim()}`);
            }
        }

        onRunningChanged: {
            if (!running) {
                console.log("WallpaperService: watcher stopped (is inotifywait installed?)");
            }
        }
    }
}
