import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import "../"

WrapperRectangle {
    id: root

    property bool activated: false

    signal toggled(bool active)

    radius: 10

    color: Theme.bg3

    Rectangle {
        id: switchTrack
        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        implicitWidth: 46
        implicitHeight: 24
        radius: height / 2

        color: root.activated ? Theme.accent : Theme.bg2

        Behavior on color { ColorAnimation { duration: 150 } }

        Rectangle {
            id: switchKnob
            implicitWidth: 20
            implicitHeight: 20
            radius: width / 2
            color: Theme.fg
            anchors.verticalCenter: parent.verticalCenter
            
            x: root.activated ? (switchTrack.width - width - 3) : 3

            Behavior on x { NumberAnimation { duration: 150; easing.type: Easing.InOutCubic } }
        }
    }

    HoverHandler { cursorShape: Qt.PointingHandCursor }

    TapHandler {
        onTapped: {
            root.activated = !root.activated
            root.toggled(root.activated)
        }
    }
}