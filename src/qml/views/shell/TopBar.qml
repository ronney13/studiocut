import QtQuick

Rectangle {
    id: bar
    color: theme.surface

    ShellTheme { id: theme }

    gradient: Gradient {
        GradientStop { position: 0.0; color: "#0c1628" }
        GradientStop { position: 1.0; color: theme.surface }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 2
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: theme.accentDeep }
            GradientStop { position: 0.35; color: theme.accent }
            GradientStop { position: 1.0; color: theme.accentDeep }
        }
        opacity: 0.85
    }

    // Grupo esquerdo: identidade e menus
    Row {
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4

        Item {
            width: 40
            height: 40

            Rectangle {
                anchors.fill: parent
                radius: 11
                color: theme.surfaceRaised
                border.color: theme.border
                border.width: 1
            }

            Image {
                anchors.centerIn: parent
                width: 30
                height: 30
                source: "qrc:/icons/videostudiobr-mark.svg"
                fillMode: Image.PreserveAspectFit
                smooth: true
            }
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            width: 172
            spacing: 2

            Text {
                text: "VÍDEO STUDIO BR"
                color: theme.text
                font.pixelSize: 12
                font.bold: true
                font.letterSpacing: 1.3
            }
            Text {
                text: shell.projectTitle
                color: theme.muted
                font.pixelSize: 11
                width: 172
                elide: Text.ElideRight
            }
        }

        Rectangle {
            width: 1
            height: 26
            anchors.verticalCenter: parent.verticalCenter
            color: theme.border
        }

        Repeater {
            model: ListModel {
                ListElement { menu: "menuFile"; label: "Arquivo" }
                ListElement { menu: "menuEdit"; label: "Editar" }
                ListElement { menu: "menuView"; label: "Exibir" }
                ListElement { menu: "menuPlayer"; label: "Player" }
                ListElement { menu: "menuSettings"; label: "Configurações" }
                ListElement { menu: "menuHelp"; label: "Ajuda" }
            }
            delegate: Item {
                width: labelText.implicitWidth + 22
                height: 38

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 3
                    radius: 8
                    color: mouse.containsMouse ? theme.surfaceHover : "transparent"
                    Behavior on color { ColorAnimation { duration: 120 } }
                }
                Text {
                    id: labelText
                    anchors.centerIn: parent
                    text: model.label
                    color: mouse.containsMouse ? theme.accentLight : theme.text
                    font.pixelSize: 12
                }
                MouseArea {
                    id: mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: shell.showMenu(model.menu, mapToGlobal(0, height))
                }
            }
        }
    }

    // Grupo direito: exportação e controles de janela
    Row {
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6

        Rectangle {
            width: 118
            height: 36
            radius: 10
            color: exportMouse.containsMouse ? theme.accentBright : theme.accent
            border.color: theme.accentLight
            border.width: exportMouse.containsMouse ? 1 : 0
            Behavior on color { ColorAnimation { duration: 120 } }

            Text {
                id: exportText
                anchors.centerIn: parent
                text: "⤒   Exportar"
                color: "#ffffff"
                font.pixelSize: 12
                font.bold: true
            }
            MouseArea {
                id: exportMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: shell.trigger("actionExportVideo")
            }
        }

        Rectangle {
            width: 1
            height: 24
            anchors.verticalCenter: parent.verticalCenter
            color: theme.border
        }

        Repeater {
            model: ListModel {
                ListElement { symbol: "−"; action: "minimize" }
                ListElement { symbol: "□"; action: "maximize" }
                ListElement { symbol: "×"; action: "close" }
            }
            delegate: Item {
                width: 34
                height: 34

                Rectangle {
                    anchors.fill: parent
                    radius: 8
                    color: {
                        if (!winMouse.containsMouse)
                            return "transparent"
                        return model.action === "close" ? "#7a2230" : theme.surfaceHover
                    }
                    Behavior on color { ColorAnimation { duration: 120 } }
                }
                Text {
                    anchors.centerIn: parent
                    text: model.symbol
                    color: winMouse.containsMouse ? theme.text : theme.muted
                    font.pixelSize: 17
                }
                MouseArea {
                    id: winMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (model.action === "minimize")
                            shell.minimizeWindow()
                        else if (model.action === "maximize")
                            shell.toggleMaximize()
                        else
                            shell.closeWindow()
                    }
                }
            }
        }
    }
}
