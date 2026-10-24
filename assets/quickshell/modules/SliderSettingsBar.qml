import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland

import "../"
import "../components"
import "../services"

Rectangle {
    id: root

    readonly property int padding: 40

    implicitWidth: sliderSettingsRow.implicitWidth + padding
    implicitHeight: 40

    color: Theme.bg
    bottomRightRadius: height / 2

    property int currentBrightness: 50

    property var appIcons: {
        "fallback": "",
        "kitty": "",
        "zen": "",
        "codium": "󰨞",
        "spotify": "",
        "discord": "",
        "obsidian": "",
        "obs": "󱜠",
        "steam": "",
        "blender": "󰂫",
        "krita": "",
        "pinta": "",
        "virtual": "󰍺",
        "prism": "",
        "minecraft": "󰍳",
        "youtube": "",
        "twitch": "",
        "github": "󰊫",
        "moodle": ""
    }

    HoverHandler {
        id: hoverHandler
        margin: root.height
    }

    y: hoverHandler.hovered ? 0 : -height

    Behavior on y { NumberAnimation { duration: 200; easing.type: Easing.InOutCubic } }

    Process {
        running: true
        command: ["sh", "-c", "brightnessctl -m | cut -d, -f4 | tr -d %"]
        stdout: SplitParser {
            onRead: data => {
                let val = parseInt(data.trim())
                if (!isNaN(val)) root.currentBrightness = val
            }
        }
    }

    RowLayout {
        id: sliderSettingsRow
        anchors.fill: parent
        anchors.leftMargin: padding / 2
        anchors.rightMargin: padding / 2
        spacing: 20

        CustomText {
            text: ""
            font.pixelSize: 18

            TapHandler {
                onTapped: Quickshell.execDetached(["kitty"])
            }
            HoverHandler { cursorShape: Qt.PointingHandCursor }
        }

        RowLayout {
            spacing: 10

            Repeater {
                model: Hyprland.workspaces

                Rectangle {
                    required property var modelData

                    implicitWidth: contentRow.implicitWidth + 28
                    implicitHeight: 28

                    color: modelData.active ? Theme.accent : Theme.bg3
                    radius: height / 2

                    Behavior on implicitWidth { NumberAnimation { duration: 200; easing.type: Easing.InOutCubic } }

                    RowLayout {
                        id: contentRow
                        anchors.centerIn: parent
                        spacing: 6

                        Repeater {
                            id: iconRepeater

                            model: {
                                let list = [];
                                let toplevels = Hyprland.toplevels.values;
                                if (!toplevels) return list;

                                for (let i = 0; i < toplevels.length; i++) {
                                    let top = toplevels[i];
                                    if (top.workspace && top.workspace.id === modelData.id) {
                                        list.push(top);
                                    }
                                }
                                return list;
                            }

                            CustomText {
                                text: {
                                    let top = modelData;
                                    let rawClass = top.lastIpcObject ? (top.lastIpcObject["class"] || "") : "";
                                    let appClass = rawClass.toLowerCase();

                                    let icon = root.appIcons[appClass];

                                    if (!icon) {
                                        for (let key in root.appIcons) {
                                            if (key !== "fallback" && appClass.includes(key)) {
                                                icon = root.appIcons[key];
                                                break;
                                            }
                                        }
                                    }

                                    return icon || root.appIcons["fallback"];
                                }
                                color: Theme.bg
                                font.pixelSize: 18
                            }
                        }
                    }

                    HoverHandler { cursorShape: Qt.PointingHandCursor }

                    TapHandler { onTapped: Hyprland.dispatch("hl.dsp.focus({ workspace = '" + modelData.name + "' })") }
                }
            }
        }

        RowLayout {
            spacing: 10

            CustomText {
                text: Pipewire.sourceMuted ? "" : ""
                font.pixelSize: 18

                HoverHandler { cursorShape: Qt.PointingHandCursor }

                TapHandler { onTapped: Pipewire.toggleSourceMuted() }
            }

            CustomSlider {
                icon: {
                    if (Pipewire.muted) return "󰖁";

                    let vol = Math.round(Pipewire.volume * 100);
                    if (vol === 0) return "";
                    if (vol < 33) return "";
                    if (vol < 66) return "";
                    return "";
                }
                sliderValue: Pipewire.source ? Math.round(Pipewire.volume * 100) : 50
                onMoved: Pipewire.setVolume(value / 100.0)

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Pipewire.toggleMuted()
                }
            }

            CustomSlider {
                icon: {
                    let brightness = Math.round(root.currentBrightness)
                    if (brightness === 0) return "󰃞"
                    if (brightness < 50) return "󰃝"
                    return "󰃠"
                }
                sliderValue: root.currentBrightness
                onMoved: Quickshell.execDetached(["brightnessctl", "set", Math.round(value) + "%"])
            }
        }
    }
}