import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import "../"

WrapperRectangle {
    id: root

    property alias text: text.text

    signal clicked()

    implicitWidth: 44
    implicitHeight: implicitWidth

    radius: 10
    margin: 10

    color: Theme.accent

    CustomText {
        id: text
        color: Theme.bg3
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 30
    }

    HoverHandler { cursorShape: Qt.PointingHandCursor }

    TapHandler { onTapped: root.clicked() }
}