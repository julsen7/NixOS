import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Quickshell

import "../"
import "../components"

PanelWindow {
    id: root

    property bool appMode: !searchBar.text.startsWith(">")
    property var customApps: [{
        name: "Settings",
        genericName: "Control Center",
        comment: "Manage Audio, Bluetooth and Network",
        icon: "/home/julsen/nixos/assets/quickshell/assets/settings.jpg",
        runInTerminal: false,
        execute: () => { GlobalState.isSettingsOpen = true }
    }]
    property var allEntries: DesktopEntries.applications.values.concat(customApps)

    function getFilteredApps(entries, query) {
        let arr = entries;
        if (query && appMode) {
            let lowerQuery = query.toLowerCase();
            arr = arr.filter(app => 
                (app.name || "").toLowerCase().includes(lowerQuery) || 
                (app.genericName || "").toLowerCase().includes(lowerQuery)
            );
        }
        return arr.sort((a, b) => (a.name || "").toLowerCase().localeCompare((b.name || "").toLowerCase()));
    }

    FolderListModel {
        id: wallpaperModel
        folder: "file:///home/julsen/wallpaper"
        nameFilters: ["*.jpg", "*.jpeg", "*.png", "*.webp"]
        showDirs: false
    }

    anchors.bottom: true
    exclusionMode: ExclusionMode.Ignore
    focusable: true

    implicitWidth: appMode ? 600 : Math.min(1600, (Quickshell.screens[0]?.width || 1920) - 40)
    implicitHeight: hoverHandler.hovered ? (appMode ? 600 : 250) : 8
    color: "transparent"

    Behavior on implicitWidth { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
    Behavior on implicitHeight { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }

    HoverHandler { id: hoverHandler }

    Rectangle {
        anchors.fill: parent

        color: Theme.bg
        topLeftRadius: 20
        topRightRadius: 20

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 15

            // App Content
            ListView {
                id: appList

                Layout.fillWidth: true
                Layout.fillHeight: true

                visible: appMode
                clip: true
                spacing: 10

                model: getFilteredApps(root.allEntries, searchBar.text)

                delegate: CustomListViewElement {
                    property var app: modelData

                    image: Quickshell.iconPath(app.icon || "")
                    title: app.name ?? ""
                    description: (app.comment || app.name) ?? ""

                    implicitWidth: appList.width
                    implicitHeight: 68

                    TapHandler {
                        onTapped: {
                            if (app.runInTerminal) {
                                Quickshell.execDetached(["kitty", "-e"].concat(app.command))
                            } else {
                                app.execute()
                            }
                            searchBar.text = ""
                        }
                    }
                }

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOn
                    visible: parent.contentHeight > parent.height
                    contentItem: Rectangle {
                        implicitWidth: 6
                        radius: width / 2
                        color: Theme.accent
                    }
                }
            }

            // Wallpaper content
            PathView {
                id: wallpaperList

                Layout.fillWidth: true
                Layout.fillHeight: true

                visible: !appMode
                model: wallpaperModel

                property int totalItemWidth: 210

                pathItemCount: Math.ceil(width / totalItemWidth) + 4

                preferredHighlightBegin: 0.5
                preferredHighlightEnd: 0.5
                highlightMoveDuration: 250

                path: Path {
                    startX: (wallpaperList.width / 2) - ((wallpaperList.pathItemCount / 2) * wallpaperList.totalItemWidth)
                    startY: wallpaperList.height / 2

                    PathLine {
                        x: (wallpaperList.width / 2) + ((wallpaperList.pathItemCount / 2) * wallpaperList.totalItemWidth)
                        y: wallpaperList.height / 2 
                    }
                }

                delegate: CustomImage {
                    id: delegateRoot
                    
                    property string imageUrl: model.fileUrl
                    
                    source: imageUrl
                    radius: 20 

                    width: PathView.isCurrentItem ? 200 : 170
                    height: PathView.isCurrentItem ? 120 : 90
                    opacity: PathView.isCurrentItem ? 1.0 : 0.6

                    Behavior on width { NumberAnimation { duration: 250; easing.type: Easing.OutQuart } }
                    Behavior on height { NumberAnimation { duration: 250; easing.type: Easing.OutQuart } }
                    Behavior on opacity { NumberAnimation { duration: 250; easing.type: Easing.OutQuart } }

                    HoverHandler { cursorShape: Qt.PointingHandCursor }

                    TapHandler { onTapped: { wallpaperList.currentIndex = index } }
                }

                onCurrentItemChanged: {
                    if (currentItem && currentItem.imageUrl !== "") {
                        GlobalState.currentWallpaper = currentItem.imageUrl
                    }
                }
            }

            CustomTextField {
                id: searchBar
                leftIcon: ""
                placeholderText: 'Type ">" for wallpapers'
                color: Theme.bg2
                Layout.fillWidth: true
            }
        }
    }
}