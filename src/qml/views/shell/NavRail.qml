import QtQuick

Rectangle {
    id: rail
    width: 82
    color: theme.surface

    ShellTheme { id: theme }

    gradient: Gradient {
        GradientStop { position: 0.0; color: "#0a1426" }
        GradientStop { position: 1.0; color: theme.surface }
    }

    Rectangle {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 1
        color: theme.border
    }

    Column {
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 4

        Repeater {
            model: ListModel {
                ListElement { panel: "inicio"; glyph: "◉"; label: "Início" }
                ListElement { panel: "media"; glyph: "▤"; label: "Mídia" }
                ListElement { panel: "playlist"; glyph: "☰"; label: "Playlist" }
                ListElement { panel: "filters"; glyph: "✦"; label: "Filtros" }
                ListElement { panel: "properties"; glyph: "◈"; label: "Propriedades" }
                ListElement { panel: "export"; glyph: "⤒"; label: "Exportar" }
                ListElement { panel: "history"; glyph: "↶"; label: "Histórico" }
                ListElement { panel: "jobs"; glyph: "⚙"; label: "Tarefas" }
            }
            delegate: Item {
                id: navItem
                width: 70
                height: 64

                property bool active: model.panel === "inicio"
                                     ? shell.welcomeVisible
                                     : shell.activePanel === model.panel

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 2
                    radius: 13
                    color: navItem.active ? theme.accentDeep
                                          : (navMouse.containsMouse ? theme.surfaceHover : "transparent")
                    opacity: navItem.active ? 0.28 : 1.0
                    border.color: navItem.active ? theme.accent : "transparent"
                    border.width: navItem.active ? 1 : 0
                    Behavior on color { ColorAnimation { duration: 140 } }
                    Behavior on opacity { NumberAnimation { duration: 140 } }
                }

                Rectangle {
                    anchors.left: parent.left
                    anchors.leftMargin: 1
                    anchors.top: parent.top
                    anchors.topMargin: 14
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 14
                    width: navItem.active ? 3 : 0
                    radius: 2
                    color: theme.accentLight
                    Behavior on width { NumberAnimation { duration: 140 } }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 8
                    text: model.glyph
                    color: navItem.active ? theme.accentLight
                                          : (navMouse.containsMouse ? theme.text : theme.muted)
                    font.pixelSize: 22
                    Behavior on color { ColorAnimation { duration: 140 } }
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 6
                    text: model.label
                    color: navItem.active ? theme.text : theme.muted
                    font.pixelSize: 9
                }

                MouseArea {
                    id: navMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (model.panel === "inicio")
                            shell.showWelcome()
                        else {
                            shell.hidePanels()
                            shell.selectPanel(model.panel)
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: footColumn.top
        anchors.bottomMargin: 8
        width: 46
        height: 1
        color: theme.border
    }

    Column {
        id: footColumn
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 2

        Repeater {
            model: ListModel {
                ListElement { menu: "menuSettings"; glyph: "⚙︎"; label: "Ajustes" }
                ListElement { menu: "menuHelp"; glyph: "?"; label: "Ajuda" }
            }
            delegate: Item {
                width: 70
                height: 54

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 3
                    radius: 11
                    color: footMouse.containsMouse ? theme.surfaceHover : "transparent"
                    Behavior on color { ColorAnimation { duration: 120 } }
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    text: model.glyph
                    color: footMouse.containsMouse ? theme.accentLight : theme.muted
                    font.pixelSize: 18
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 4
                    text: model.label
                    color: theme.muted
                    font.pixelSize: 9
                }
                MouseArea {
                    id: footMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: shell.showRailMenu(model.menu, Qt.point(0, 0))
                }
            }
        }
    }
}
