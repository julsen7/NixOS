import QtQuick
import Quickshell

import "../"

PanelWindow {
    id: root

    implicitWidth: notifications.width + 20
    implicitHeight: notifications.height + 20

    ListView {
        id: notifications

        clip: true
        spacing: 10

        model: notificationEntries

        delegate: CustomListViewElement {
            imageSource: Quickshell.iconPath(icon)
            titleText: name ?? ""
            contentText: (comment || genericName || name) ?? ""

            implicitWidth: appList.width
            implicitHeight: 68

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.shortcutOpen = false
                    
                    if (runInTerminal) {
                        let termCommand = ["kitty", "-e"].concat(command)
                        Quickshell.execDetached(termCommand)
                    } else {
                        execute()
                    }
                }
            }
        }
    }
}