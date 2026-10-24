import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

import "../"
import "../components"
import "../services"

WlSessionLock {
    id: root

    locked: GlobalState.isLocked

    WlSessionLockSurface {
        color: "black"

        Rectangle {
            anchors.centerIn: parent

            implicitWidth: 1600
            implicitHeight: 1000

            color: Theme.bg
            radius: 20

            RowLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 60

                // COLUMN 1: Weather | System Info | Media
                ColumnLayout {
                    Layout.preferredWidth: 400
                    spacing: 20

                    // 1. Weather Module
                    CustomLockScreenModule {
                        Layout.fillHeight: true

                        CustomText {
                            text: Weather.description || "Loading..."
                            font.pixelSize: 18
                            font.bold: true
                            Layout.alignment: Qt.AlignHCenter
                        }

                        CustomText {
                            text: (Weather.temp || "--") + " " + (Weather.icon || "")
                            font.pixelSize: 36
                            font.bold: true
                            Layout.alignment: Qt.AlignHCenter
                        }

                        CustomText {
                            text: "Feels like " + (Weather.feelsLike || "--")
                            opacity: 0.8
                            Layout.alignment: Qt.AlignHCenter
                        }

                        CustomText {
                            text: "High " + (Weather.tempHigh || "--") + " • Low " + (Weather.tempLow || "--")
                            font.bold: true
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Rectangle {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: Theme.bg2
                            radius: 16

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 10

                                CustomText {
                                    text: "󰥔 Hourly forecast"
                                    font.bold: true
                                }

                                RowLayout {
                                    Layout.alignment: Qt.AlignHCenter
                                    spacing: 8

                                    Repeater {
                                        model: Weather.hourlyForecast || []

                                        ColumnLayout {
                                            spacing: 2
                                            Layout.alignment: Qt.AlignHCenter

                                            required property var modelData 
                                            required property int index

                                            CustomText {
                                                text: (modelData.tempC !== undefined ? modelData.tempC : "--") + "°"
                                                font.bold: true
                                                Layout.alignment: Qt.AlignHCenter
                                            }

                                            CustomText {
                                                text: modelData.icon || ""
                                                font.pixelSize: 20
                                                Layout.alignment: Qt.AlignHCenter
                                            }

                                            CustomText {
                                                text: (modelData.precipChance !== undefined ? modelData.precipChance : "0") + "%"
                                                opacity: 0.7
                                                color: (modelData.precipChance && modelData.precipChance > 30) ? "#89b4fa" : Theme.fg
                                                Layout.alignment: Qt.AlignHCenter
                                            }

                                            CustomText {
                                                text: modelData.hour || ""
                                                font.bold: index === 0
                                                Layout.alignment: Qt.AlignHCenter
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // 2. System Info Module
                    CustomLockScreenModule {
                        Layout.preferredHeight: 300

                        CustomText {
                            text: " julsen.sh"
                            font.pixelSize: 18
                            opacity: 0.6
                        }

                        RowLayout {
                            spacing: 40
                            Layout.alignment: Qt.AlignVCenter

                            CustomText {
                                text: ""
                                font.pixelSize: 120
                                font.bold: true
                                color: Theme.accent
                            }

                            ColumnLayout {
                                spacing: 4
                                CustomText {
                                    text: "OS   : " + (OS.osName || "Unknown")
                                    font.bold: true
                                    font.pixelSize: 22
                                }

                                CustomText {
                                    text: "WM   : " + (OS.wmName || "Unknown")
                                    font.bold: true
                                    font.pixelSize: 22
                                }

                                CustomText {
                                    text: "USER : " + (OS.username || "Unknown")
                                    font.bold: true
                                    font.pixelSize: 22
                                }

                                CustomText {
                                    text: "UP   : " + (OS.uptime || "0:00")
                                    font.bold: true
                                    font.pixelSize: 22
                                }
                            }
                        }

                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 10
                            Repeater {
                                model: ["#f38ba8", "#fab387", "#f9e2af", "#a6e3a1", "#89dceb", "#b4befe", "#cba6f7"]
                                Rectangle {
                                    required property color modelData
                                    width: 16
                                    height: 16
                                    radius: 6
                                    color: modelData
                                }
                            }
                        }
                    }

                    // 3. Media Player Modul
                    CustomLockScreenModule {
                        Layout.preferredHeight: 240

                        backgroundContent: [
                            CustomImage {
                                source: Mpris.artUrl || ""
                                anchors.fill: parent
                                opacity: 0.25
                            },
                            Rectangle {
                                anchors.fill: parent
                                color: Qt.rgba(0, 0, 0, 0.06)
                            }
                        ]

                        CustomText {
                            text: Mpris.trackTitle || "No Media"
                            color: Theme.accent
                            font.pixelSize: 18
                            font.bold: true
                            Layout.alignment: Qt.AlignHCenter
                        }

                        CustomText {
                            text: Mpris.trackArtist || ""
                            Layout.alignment: Qt.AlignHCenter
                        }

                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 10

                            CustomButton {
                                buttonText: ""
                                backgroundColor: Theme.bg
                                Layout.preferredWidth: 40
                                Layout.preferredHeight: 40
                                onClicked: if(Mpris.player) Mpris.player.previous()
                            }

                            CustomButton {
                                buttonText: Mpris.isPlaying ? "" : ""
                                radius: 12
                                Layout.preferredWidth: 60
                                Layout.preferredHeight: 40
                                onClicked: if(Mpris.player) Mpris.player.togglePlaying()
                            }

                            CustomButton {
                                buttonText: ""
                                backgroundColor: Theme.bg
                                Layout.preferredWidth: 40
                                Layout.preferredHeight: 40
                                onClicked: if(Mpris.player) Mpris.player.next()
                            }
                        }
                    }
                }

                // COLUMN 2: Clock | Avatar | Unlock Bar
                ColumnLayout {
                    Layout.preferredWidth: 400
                    spacing: 50

                    // Clock & Date
                    ColumnLayout {
                        Layout.alignment: Qt.AlignHCenter

                        CustomText {
                            text: DateTime.time || "00:00"
                            font.pixelSize: 110
                            font.bold: true
                            Layout.alignment: Qt.AlignHCenter
                        }

                        CustomText {
                            text: (DateTime.date || Qt.formatDate(new Date(), "dddd • d MMM")).toUpperCase()
                            font.bold: true
                            opacity: 0.7
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }

                    // Avatar / Icon
                    Rectangle {
                        Layout.preferredWidth: 150
                        Layout.preferredHeight: 150
                        Layout.alignment: Qt.AlignHCenter
                        color: Theme.bg2
                        radius: height / 2
                        border.color: Qt.rgba(1, 1, 1, 0.15)
                        border.width: 4

                        CustomText {
                            anchors.centerIn: parent
                            text: ""
                            font.pixelSize: 50
                        }
                    }

                    // Passwort field
                    CustomTextField {
                        id: pwField
                        leftIcon: "󰌾"
                        rightIcon: ""
                        placeholderText: "Enter password"
                        color: Theme.bg2

                        cursorDelegate: Item { }
                        echoMode: TextInput.Password
                        inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase

                        Layout.fillWidth: true
                        Layout.preferredHeight: 48

                        onAccepted: {
                            GlobalState.isLocked = false
                            text = "" 
                        }

                        Component.onCompleted: {
                            forceActiveFocus()
                        }
                    }

                    CustomButton {
                        buttonText: "Unlock"
                        onClicked: {
                            GlobalState.isLocked = false
                            pwField.text = ""
                        }
                        Layout.preferredWidth: 200
                        Layout.alignment: Qt.AlignHCenter
                    }
                }

                // COLUMN 3: Hardware | Notifications
                ColumnLayout {
                    Layout.preferredWidth: 400
                    spacing: 20

                    // 1. Hardware Monitor Modul
                    CustomLockScreenModule {
                        Layout.preferredHeight: 125

                        property string cpuTemp: "64°C"
                        property string cpuLoad: "2%"
                        property string ramLoad: "56%"
                        property string batLevel: "39%"

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 14
                            spacing: 12

                            // CPU
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                radius: 14
                                color: Qt.rgba(1, 1, 1, 0.05)

                                ColumnLayout {
                                    anchors.centerIn: parent

                                    CustomText {
                                        text: "󰍛" + parent.parent.parent.cpuTemp
                                        font.pixelSize: 13
                                        font.bold: true
                                        color: "#a6e3a1"
                                    }

                                    CustomText { 
                                        text: parent.parent.parent.cpuLoad
                                        font.pixelSize: 22
                                        font.bold: true
                                    }
                                }
                            }

                            // RAM
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                radius: 14
                                color: Qt.rgba(1, 1, 1, 0.05)

                                ColumnLayout {
                                    anchors.centerIn: parent

                                    CustomText { 
                                        text: "󰘚 RAM"
                                        font.pixelSize: 13
                                        font.bold: true
                                    }

                                    CustomText {
                                        text: parent.parent.parent.ramLoad
                                        font.pixelSize: 22
                                        font.bold: true
                                    }
                                }
                            }

                            // Battery
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                radius: 14
                                color: Qt.rgba(1, 1, 1, 0.05)

                                ColumnLayout {
                                    anchors.centerIn: parent
                                    CustomText {
                                        text: "󰁹 BAT"
                                        font.pixelSize: 13
                                        font.bold: true
                                        color: "#a6e3a1"
                                    }

                                    CustomText {
                                        text: parent.parent.parent.batLevel
                                        font.pixelSize: 22
                                        font.bold: true
                                        color: "#a6e3a1"
                                    }
                                }
                            }
                        }
                    }

                    // 2. Notification Module
                    CustomLockScreenModule {
                        Layout.fillHeight: true

                        ColumnLayout {
                            anchors.fill: parent

                            CustomText {
                                text: "Notifications"
                                font.bold: true
                                font.pixelSize: 18
                                Layout.alignment: Qt.AlignTop
                            }

                            ListView {
                                id: notificationList
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                clip: true
                                spacing: 10
                                
                                model: 0 
                            }

                            ColumnLayout {
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                visible: notificationList.count === 0

                                CustomText {
                                    text: "󰂛"
                                    font.pixelSize: 55
                                    opacity: 0.3
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                CustomText {
                                    text: "No Notifications"
                                    font.pixelSize: 15
                                    opacity: 0.5
                                    Layout.alignment: Qt.AlignHCenter
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}