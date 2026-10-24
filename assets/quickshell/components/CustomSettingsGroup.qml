import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import "../"

WrapperRectangle {
    id: root

    property alias text: text.text
    property alias mainControl: mainControl.data
    property alias content: content.data

    Layout.fillWidth: true

    radius: 20
    margin: 12

    color: Theme.bg3

    ColumnLayout {
        RowLayout {
            CustomText {
                id: text
                Layout.fillWidth: true
                font.pixelSize: 18
            }

            Item {
                id: mainControl
                Layout.preferredWidth: childrenRect.width
                Layout.preferredHeight: childrenRect.height
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 4
            color: Theme.bg2
        }

        Item {
            id: content
            Layout.preferredWidth: childrenRect.width
            Layout.preferredHeight: childrenRect.height
        }
    }
}