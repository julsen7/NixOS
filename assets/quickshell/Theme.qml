pragma Singleton

import QtQuick

QtObject {
    // --- Colors ---
    readonly property color bg: "#050505"
    readonly property color bg2: "#0a0a0b"
    readonly property color bg3: "#0f1210"
    readonly property color bg_hov: "#181818"
    readonly property color fg: "#e0e0e0"
    readonly property color fg2: "#888888"
    readonly property color accent: "#24bd5c"
    readonly property color ph: "#303030"
    readonly property color red: "#ff5555"

    // --- Metrics ---
    readonly property int padSmall: 4
    readonly property int padDefault: 8
    readonly property int padLarge: 16
    readonly property int radius: 8

    // --- Typography ---
    readonly property font fontDefault: Qt.font({ family: "JetBrainsMono Nerd Font Propo", pixelSize: 14 })
    readonly property font fontSmall: Qt.font({ family: "JetBrainsMono Nerd Font Propo", pixelSize: 12 })
}