import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

import "../"

Rectangle {
    id: root

    signal accepted()

    property alias leftIcon: lefticon.text
    property alias rightIcon: rightIcon.text
    property alias text: textfield.text

    property int pixelSize: 14
    property color textColor: Theme.fg

    property alias placeholderText: textfield.placeholderText
    property alias echoMode: textfield.echoMode
    property alias inputMethodHints: textfield.inputMethodHints
    property alias cursorDelegate: textfield.cursorDelegate

    implicitHeight: 50

    color: Theme.bg
    radius: 12

    focus: true

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        spacing: 10

        CustomText {
            id: lefticon
            color: textColor
            font.pixelSize: 18
            Layout.alignment: Qt.AlignVCenter
        }

        TextField {
            id: textfield

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter

            font.pixelSize: root.pixelSize
            color: textColor

            placeholderTextColor: Qt.alpha(color, 0.5)

            background: Item { }

            Component.onCompleted: forceActiveFocus()

            onAccepted: root.accepted()
        }

        CustomText {
            id: rightIcon
            color: textColor
            font.pixelSize: root.pixelSize
            Layout.alignment: Qt.AlignVCenter
        }
    }
}