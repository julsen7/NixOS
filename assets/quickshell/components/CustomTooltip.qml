import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import "../"

PopupWindow {
    id: root

    // Ziel-Element, an das der Tooltip geheftet wird
    property Item target: null

    property string text: ""
    property string command: ""
    property int interval: 5000

    // Verankerung direkt am übergebenen Ziel-Element
    anchor.item: target
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom

    implicitWidth: bgRect.implicitWidth
    implicitHeight: bgRect.implicitHeight

    color: "transparent"

    Rectangle {
        id: bgRect
        implicitWidth: Math.max(80, title.implicitWidth + 20)
        implicitHeight: Math.max(30, title.implicitHeight + 10)
        color: Theme.bg
        radius: 6
        border.color: Qt.rgba(1, 1, 1, 0.15)
        border.width: 1

        CustomText {
            id: title
            anchors.centerIn: parent
            text: root.command !== "" ? (proc.output !== "" ? proc.output : "Lade...") : root.text
            color: Theme.fg
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Process {
        id: proc
        property string output: ""
        running: root.command !== "" && root.visible
        command: ["sh", "-c", root.command]
        
        stdout: StdioCollector {
            onStreamFinished: {
                proc.output = this.text.trim();
            }
        }
    }

    Timer {
        running: root.command !== "" && root.visible
        interval: root.interval
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!proc.running) {
                proc.running = true;
            }
        }
    }
}