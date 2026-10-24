import QtQuick
import Quickshell

Scope {
  Variants {
    model: Quickshell.screens

        PanelWindow {
            id: topBar

            required property var modelData
            screen: modelData

            implicitHeight: island.implicitHeight

            exclusiveZone: 40
            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
            }

            SliderSettingsBar {
                anchors.left: parent.left
            }

            DynamicIsland {
                id: island
                anchors.centerIn: parent
            }

            ControlCenterBar {
                anchors.right: parent.right
            }
        }
    }
}