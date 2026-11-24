import QtQuick

Rectangle {
    id: bar
    color: theme.surface

    ShellTheme { id: theme }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: theme.border
    }

    // Grupo esquerdo: identidade e menus
    Row {
        anchors.left: parent.left
        anchors.leftMargin: 14
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6

        Image {
            width: 34
            height: 34
            source: "qrc:/icons/studiocut-logo-64.svg"
            fillMode: Image.PreserveAspectFit
            smooth: true
        }

        Column {
            width: 170
            spacing: 0
            Text {
                text: "VÍDEO STUDIO BR"
                color: theme.text
                font.pixelSize: 13
                font.bold: true
                font.letterSpacing: 1.1
            }
            Text {
                text: shell.projectTitle
                color: theme.muted
                font.pixelSize: 11
                width: 170
                elide: Text.ElideRight
            }
        }

        Rectangle {
            width: 1
            height: 28
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
                width: labelText.implicitWidth + 20
                height: 36

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
                    onClicked: shell.showMenu(model.menu, Qt.point(0, 0))
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
            width: 110
            height: 34
            radius: 8
            color: exportMouse.containsMouse ? "#3d92ff" : theme.accent
            Text {
                anchors.centerIn: parent
                text: "Exportar"
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
                    radius: 7
                    color: winMouse.containsMouse ? theme.surfaceHover : "transparent"
                }
                Text {
                    anchors.centerIn: parent
                    text: model.symbol
                    color: model.action === "close" && winMouse.containsMouse ? "#ff6b6b"
                                                                             : theme.text
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
