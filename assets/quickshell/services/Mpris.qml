pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    readonly property var player: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null
    readonly property bool hasMedia: player !== null
    readonly property bool isPlaying: hasMedia && player.isPlaying

    readonly property string trackTitle: player?.trackTitle || "No media"
    readonly property string trackArtist: player?.trackArtist || "Unknown artist"
    readonly property string artUrl: player?.trackArtUrl || "file:///home/julsen/nixos/assets/quickshell/assets/default_cover.jpg"

    readonly property string playerIdentity: player?.identity || ""
    readonly property string desktopEntry: player?.desktopEntry || ""

    readonly property string playerIcon: {
        let name = (desktopEntry + " " + playerIdentity).toLowerCase();
        if (name.includes("spotify")) return "";
        if (name.includes("zen") || name.includes("firefox")) return "";
        if (name.includes("vlc")) return "󰕼";
        if (name.includes("mpv")) return "󰐊";
        if (name.includes("chrome") || name.includes("chromium")) return "";
        return "";
    }
}