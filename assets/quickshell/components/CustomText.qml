import QtQuick
import Quickshell

import "../"

Text {
    id: root

    horizontalAlignment: Text.AlignLeft
    verticalAlignment: Text.AlignVCenter

    color: Theme.fg
    font.family: "JetBrainsMono Nerd Font Propo"
    font.pixelSize: 14
    font.weight: Font.Medium
    elide: Text.ElideRight
    visible: text.length > 0
}