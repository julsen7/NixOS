import QtQuick
import QtQuick.Layouts
import Quickshell

import "../"

Rectangle {
    id: root

    property alias imageSource: image.source
    property alias titleText: title.text
    property alias contentText: content.text

    color: mouseArea.containsMouse ? Theme.bg_hov : "transparent"
    radius: 20

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12

        spacing: 10

        CustomImage {
            id: image
            Layout.preferredWidth: height
            Layout.fillHeight: true
            radius: 6
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter

            spacing: 2

            CustomText {
                id: title
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignLeft
            }

            CustomText {
                id: content
                color: Theme.fg2
                font.pixelSize: 12
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignLeft
            }
        }
    }
}