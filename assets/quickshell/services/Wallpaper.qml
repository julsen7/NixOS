pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // Pfade aus den NixOS-Environment-Variablen
    readonly property string wallpaperDir: Quickshell.env("QS_WALLPAPER_DIR") || ""
    readonly property string defaultWallpaper: Quickshell.env("QS_DEFAULT_WALLPAPER") || ""

    // Persistenter Speicherort unter ~/.local/state/quickshell/wallpaper.txt
    readonly property string stateDir: (Quickshell.env("XDG_STATE_HOME") || (Quickshell.env("HOME") + "/.local/state")) + "/quickshell"
    readonly property string stateFilePath: stateDir + "/wallpaper.txt"

    // Der fertige Pfad / URL für dein Background-Modul
    property string currentWallpaper: ""

    // Hilfsfunktion: Macht aus einem Dateinamen oder Pfad eine saubere file://-URL
    function resolveWallpaperUrl(nameOrPath) {
        if (!nameOrPath || nameOrPath.trim() === "")
            return defaultWallpaper ? ("file://" + defaultWallpaper) : "";

        let clean = nameOrPath.trim();
        // Falls bereits ein absoluter Pfad übergeben wurde, Dateinamen extrahieren
        let fileName = clean.includes("/") ? clean.split("/").pop() : clean;

        if (wallpaperDir !== "") {
            return "file://" + wallpaperDir + "/" + fileName;
        }
        return clean.startsWith("file://") ? clean : ("file://" + clean);
    }

    // Datei zum Lesen & Schreiben des gemerkten Wallpapers
    FileView {
        id: stateFile
        path: root.stateFilePath
        blockLoading: true

        onLoaded: {
            const savedName = text().trim();
            if (savedName !== "") {
                root.currentWallpaper = root.resolveWallpaperUrl(savedName);
            } else {
                root.fallbackToDefault();
            }
        }

        onLoadFailed: error => {
            // Datei existiert noch nicht (z. B. nach Neuinstallation) -> Fallback!
            root.fallbackToDefault();
        }
    }

    // Stellt sicher, dass ~/.local/state/quickshell existiert
    Process {
        id: ensureDirProc
        command: ["mkdir", "-p", root.stateDir]
    }

    function fallbackToDefault() {
        if (defaultWallpaper !== "") {
            currentWallpaper = defaultWallpaper.startsWith("file://")
                ? defaultWallpaper
                : ("file://" + defaultWallpaper);
        }
    }

    // Diese Funktion rufst du später aus deiner SettingsApp / deinem Picker auf
    function setWallpaper(fileNameOrPath) {
        if (!fileNameOrPath) return;

        // 1. Nur den Dateinamen extrahieren, damit Store-Hash-Änderungen egal sind
        const fileName = fileNameOrPath.includes("/")
            ? fileNameOrPath.split("/").pop()
            : fileNameOrPath;

        // 2. Sofort in der UI aktualisieren
        currentWallpaper = resolveWallpaperUrl(fileName);

        // 3. Ordner anlegen & Dateinamen persistent speichern
        ensureDirProc.running = true;
        stateFile.setText(fileName + "\n");
    }
}