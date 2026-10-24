import QtQuick
import QtQuick.Controls
import Quickshell

import "../"

Button {
    id: root

    property alias buttonText: text.text

    property int radius: height / 2
    property color color: Theme.fg
    property color backgroundColor: Theme.accent

    implicitHeight: 40

    background: Rectangle {
        radius: root.radius
        color: root.hovered ? root.color : root.backgroundColor

        Behavior on color { ColorAnimation { duration: 200; easing.type: Easing.InOutCubic } }
    }

    contentItem: CustomText {
        id: text
        color: hoverHandler.hovered ? root.backgroundColor : root.color
    }

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }
}