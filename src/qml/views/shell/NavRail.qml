import QtQuick

Rectangle {
    id: rail
    width: 78
    color: theme.surface

    ShellTheme { id: theme }

    Rectangle {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 1
        color: theme.border
    }

    Column {
        anchors.top: parent.top
        anchors.topMargin: 12
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
                width: 66
                height: 62

                Rectangle {
                    anchors.fill: parent
                    radius: 12
                    color: active ? theme.surfaceHover : (navMouse.containsMouse ? theme.surfaceRaised : "transparent")

                    property bool active: model.panel === "inicio"
                                         ? shell.welcomeVisible
                                         : shell.activePanel === model.panel

                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: parent.active ? 3 : 0
                        radius: 2
                        color: theme.accent
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 8
                    text: model.glyph
                    color: model.panel === "inicio" ? shell.welcomeVisible ? theme.accentLight : theme.muted
                                                    : shell.activePanel === model.panel ? theme.accentLight : theme.muted
                    font.pixelSize: 22
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 6
                    text: model.label
                    color: theme.text
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

    Column {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 12
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 4

        Repeater {
            model: ListModel {
                ListElement { menu: "menuSettings"; glyph: "⚙︎"; label: "Ajustes" }
                ListElement { menu: "menuHelp"; glyph: "?"; label: "Ajuda" }
            }
            delegate: Item {
                width: 66
                height: 50
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 4
                    text: model.glyph
                    color: footMouse.containsMouse ? theme.accentLight : theme.muted
                    font.pixelSize: 18
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 3
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
