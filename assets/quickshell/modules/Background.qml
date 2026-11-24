import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland

import "../"

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Background

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            Rectangle {
                anchors.fill: parent
                color: Theme.bg

                Rectangle {
                    id: maskSource
                    anchors.fill: wallpaper
                    radius: 20
                    layer.enabled: true
                    visible: false
                }

                Image {
                    id: wallpaper

                    anchors.fill: parent
                    anchors.margins: 10

                    fillMode: Image.PreserveAspectCrop

                    source: GlobalState.currentWallpaper

                    asynchronous: true
                    visible: false
                }

                MultiEffect {
                    id: effect
                    anchors.fill: wallpaper
                    source: wallpaper
                    maskEnabled: true
                    maskSource: maskSource

                    opacity: wallpaper.status === Image.Ready ? 1 : 0

                    Behavior on opacity {
                        NumberAnimation { 
                            duration: 400 
                            easing.type: Easing.InOutQuad 
                        }
                    }
                }
            }
        }
    }
}