import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications

import "./../"

Scope {
    id: root

    NotificationServer {
        id: server
        actionsSupported: true
        bodySupported: true
        imageSupported: true

        onNotification: n => {
            console.log("got: ", n.summary, "---", n.body)
            n.tracked = true
        }
    }

    PanelWindow {
        anchors {
            top: true
            right: true
        }
        margins {
            top: 12
            right: 12
        }

        implicitWidth: 380
        implicitHeight: Math.max(1, column.implicitHeight)
        color: "transparent"

        exclusionMode: ExclusionMode.Ignore

        ColumnLayout {
            id: column
            width: parent.width
            spacing: 10

            Repeater {
                model: server.trackedNotifications

                delegate: Rectangle {
                    id: card
                    required property var modelData

                    Layout.fillWidth: true
                    // Layout.preferredHeight: layout.implicitHeight + 20
                    radius: 8
                    color: Theme.bg
                    border.width: 2
                    border.color: modelData.urgency === NotificationUrgency.Critical ? Theme.red : Theme.accent

                }
            }
        }
    }
}