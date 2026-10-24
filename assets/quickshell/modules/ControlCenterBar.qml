import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

import "../"
import "../components"

Rectangle {
    id: root

    readonly property int padding: 40

    implicitWidth: controlCenterRow.implicitWidth + padding
    implicitHeight: 40

    color: Theme.bg
    bottomLeftRadius: height / 2

    HoverHandler {
        id: hoverHandler
        margin: root.height
    }

    y: hoverHandler.hovered ? 0 : -height

    Behavior on y { NumberAnimation { duration: 200; easing.type: Easing.InOutCubic } }

    RowLayout {
        id: controlCenterRow
        anchors.fill: parent
        anchors.leftMargin: padding / 2
        anchors.rightMargin: padding / 2
        spacing: 20

        // --- SYSTEM TRAY ---
        RowLayout {
            spacing: 10
            Repeater {
                model: SystemTray.items

                delegate: CustomImage {
                    id: trayIcon
                    width: 20
                    height: 20
                    source: modelData.icon

                    CustomTooltip {
                        visible: mouseArea.containsMouse
                        text: modelData.title !== undefined ? modelData.title : "App"
                    }

                    QsMenuAnchor {
                        id: menuAnchor
                        menu: modelData.menu
                        anchor.item: parent
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        acceptedButtons: Qt.LeftButton | Qt.RightButton

                        onClicked: {
                            (mouse) => {
                                if (mouse.button === Qt.LeftButton) {
                                    modelData.activate()
                                } else if (mouse.button === Qt.RightButton) {
                                    menuAnchor.open()
                                } else {
                                    modelData.contextMenu(mouse.x, mouse.y)
                                }
                            }
                        }
                    }
                }
            }
        }

        // --- BLUETOOTH ---
        CustomTopSetting {
            id: btSetting
            icon: "󰂯"
            command: "bluetoothctl devices connected | wc -l"
            interval: 10000

            HoverHandler { id: btHover; cursorShape: Qt.PointingHandCursor }

            TapHandler { onTapped: { GlobalState.isSettingsOpen = true; GlobalState.settingsTab = 1 } }

            CustomTooltip {
                target: btSetting
                visible: btHover.hovered
                command: "devices=$(bluetoothctl devices Connected | cut -d' ' -f3-); [ -z \"$devices\" ] && echo \"Keine Geräte verbunden\" || echo \"$devices\""
                interval: 5000
            }
        }

        // --- NETWORK ---
        CustomTopSetting {
            id: netSetting
            command: "nmcli -t -f TYPE,NAME connection show --active | head -n1 | awk -F: 'BEGIN{i=\"\"; v=\"Keine Verbindung\"} {if($1 ~ \"ethernet\"){i=\"󰌗\"; v=\"LAN\"} else if($1 ~ \"wireless\"){i=\"\"; v=$2}} END{print i\"\\t\"v}'"
            interval: 10000

            HoverHandler { id: netHover; cursorShape: Qt.PointingHandCursor }
            
            TapHandler { onTapped: { GlobalState.isSettingsOpen = true; GlobalState.settingsTab = 0 } }

            CustomTooltip {
                target: netSetting
                visible: netHover.hovered
                command: "iface=$(ip route show default | awk '/default/ {print $5}' | head -n1); if [ -n \"$iface\" ]; then r1=$(awk -v iface=\"$iface\" '$1==iface\":\" {print $2}' /proc/net/dev); t1=$(awk -v iface=\"$iface\" '$1==iface\":\" {print $10}' /proc/net/dev); sleep 1; r2=$(awk -v iface=\"$iface\" '$1==iface\":\" {print $2}' /proc/net/dev); t2=$(awk -v iface=\"$iface\" '$1==iface\":\" {print $10}' /proc/net/dev); dl=$(( (r2 - r1) )); ul=$(( (t2 - t1) )); echo \"↓ $((dl / 1024)) KB/s  ↑ $((ul / 1024)) KB/s\"; else echo \"Keine Verbindung\"; fi"
                interval: 3000
            }
        }

        // --- BATTERY ---
        CustomTopSetting {
            id: batSetting
            command: "cat /sys/class/power_supply/BAT1/capacity" 
            interval: 30000
            
            HoverHandler { id: batHover; cursorShape: Qt.PointingHandCursor }

            TapHandler { onTapped: { GlobalState.isSettingsOpen = true; GlobalState.settingsTab = 3 } }

            onValueChanged: {
                let c = parseInt(value);
                if (c < 20) icon = "";
                else if (c < 40) icon = "";
                else if (c < 60) icon = "";
                else if (c < 80) icon = "";
                else icon = "";

                value = c + "%";
            }

            CustomTooltip {
                target: batSetting
                visible: batHover.hovered
                text: "Batterie: " + batSetting.value
            }
        }

        // --- POWER ---
        CustomText {
            id: powerBtn
            text: ""
            font.pixelSize: 22
            color: powerHandler.hovered ? Theme.red : Theme.fg

            HoverHandler { id: powerHandler; cursorShape: Qt.PointingHandCursor }

            TapHandler { onTapped: GlobalState.isLocked = true }
        }
    }
}