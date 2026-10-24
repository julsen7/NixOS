import QtQuick
import QtQuick.Controls
import Quickshell

import "../"

Slider {
    id: root

    property string icon: ""

    property alias sliderValue: root.value
    property alias maxValue: root.to

    implicitWidth: 200
    implicitHeight: 20

    maxValue: 100
    stepSize: 1
    snapMode: Slider.SnapOnRelease

    background: Rectangle {
        color: Theme.bg2
        radius: height / 2

        Rectangle {
            implicitWidth: root.visualPosition * parent.width
            implicitHeight: parent.height
            color: Theme.accent
            radius: parent.radius
        }
    }

    handle: Rectangle {
        x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
        y: root.topPadding + (root.availableHeight - height) / 2
        implicitWidth: root.implicitHeight + 10
        implicitHeight: width
        radius: height / 2
        color: Theme.bg3

        HoverHandler { cursorShape: Qt.PointingHandCursor }

        CustomText {
            text: root.pressed ? Math.round(root.value) : root.icon
            font.pixelSize: 18
            anchors.centerIn: parent
        }
    }
}