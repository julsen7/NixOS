import QtQuick
import QtQuick.Layouts
import Quickshell

import "../"

Rectangle {
    id: root

    property alias image: image.source
    property alias title: title.text
    property alias description: description.text

    color: hoverHandler.hovered ? Theme.bg_hov : Theme.bg2
    radius: 20

    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.PointingHandCursor
    }

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
            Layout.alignment: Qt.AlignVCenter

            spacing: 2

            CustomText {
                id: title
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignLeft
            }

            CustomText {
                id: description
                color: Theme.fg2
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignLeft
            }
        }
    }
}