import QtQuick
import Quickshell
import Quickshell.Widgets

import "../"

ClippingRectangle {
    id: root

    property alias source: image.source

    radius: 15
    color: "transparent"

    Image {
        id: image
        anchors.fill: parent
        asynchronous: true
        smooth: true
        fillMode: Image.PreserveAspectCrop
    }
}