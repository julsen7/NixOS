pragma Singleton

import QtQuick
import Quickshell
import "services"

Singleton {
    readonly property string currentWallpaper: WallpaperService.currentWallpaper
    property bool isLocked: false
    property bool isSettingsOpen: false
    property int settingsTab: 0
}