import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import "../"

RowLayout {
    id: root

    Layout.alignment: Qt.AlignVCenter
    spacing: 10

    property string command: ""
    property string value: ""

    property alias interval: timer.interval
    property alias icon: iconText.text

    Process {
        id: process
        command: ["sh", "-c", root.command]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let raw = text.trim()
                if (raw.includes("\t")) {
                    let parts = raw.split("\t")
                    iconText.text = parts[0]
                    root.value = parts[1]
                } else {
                    root.value = raw
                }
            }
        }
    }

    Timer {
        id: timer
        running: true
        repeat: true
        onTriggered: process.running = true
    }

    CustomText {
        id: iconText
        color: Theme.accent
        font.pixelSize: 18
        Layout.alignment: Qt.AlignVCenter
    }

    CustomText {
        text: root.value
        font.pixelSize: 18
        Layout.alignment: Qt.AlignVCenter
    }
}