pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property string osName: "Loading..."
    property string wmName: "Loading..."
    property string username: "Loading..."
    property string uptime: "Loading..."

    property Process staticProc: Process {
        command: ["sh", "-c", "source /etc/os-release 2>/dev/null; echo \"${NAME:-Linux}|${XDG_CURRENT_DESKTOP:-${DESKTOP_SESSION:-Unknown}}|${USER:-$LOGNAME}\""]
        running: true
        stdout: SplitParser {
            onRead: data => {
                let parts = data.trim().split("|");
                if (parts.length >= 3) {
                    root.osName = parts[0];
                    root.wmName = parts[1];
                    root.username = parts[2];
                }
            }
        }
    }

    property Process uptimeProc: Process {
        command: ["awk", "{print int($1/3600)\"h \"int(($1%3600)/60)\"m\"}", "/proc/uptime"]
        running: true
        stdout: SplitParser {
            onRead: data => root.uptime = data.trim()
        }
    }

    property Timer uptimeTimer: Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: root.uptimeProc.running = true
    }
}