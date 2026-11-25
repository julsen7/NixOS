pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property string currentWallpaper: "file:///home/julsen/wallpaper/Mountain4.jpg"
    property bool isLocked: false
    property bool isSettingsOpen: false
    property int settingsTab: 0
}