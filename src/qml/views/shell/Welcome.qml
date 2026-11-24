import QtQuick

Rectangle {
    id: welcome
    color: theme.background

    ShellTheme { id: theme }

    gradient: Gradient {
        GradientStop { position: 0.0; color: "#07122a" }
        GradientStop { position: 0.55; color: "#050b18" }
        GradientStop { position: 1.0; color: "#03060d" }
    }

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -18
        width: Math.min(720, parent.width - 80)
        height: 430
        radius: 22
        color: theme.surface
        border.color: theme.border
        border.width: 1

        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            radius: 21
            color: "transparent"
            border.color: theme.accent
            border.width: 1
            opacity: 0.18
        }

        Column {
            anchors.top: parent.top
            anchors.topMargin: 34
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                source: "qrc:/icons/studiocut-logo-64.svg"
                width: 88
                height: 88
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Vídeo Studio BR"
                color: theme.text
                font.pixelSize: 30
                font.bold: true
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Seu estúdio de edição, em português."
                color: theme.accentLight
                font.pixelSize: 14
            }
        }

        Row {
            anchors.top: parent.top
            anchors.topMargin: 226
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 14

            Repeater {
                model: ListModel {
                    ListElement {
                        glyph: "＋"
                        title: "Criar projeto"
                        detail: "Comece uma nova edição"
                        kind: "new"
                    }
                    ListElement {
                        glyph: "▣"
                        title: "Abrir mídia"
                        detail: "Importe vídeos e imagens"
                        kind: "open"
                    }
                    ListElement {
                        glyph: "◷"
                        title: "Projetos recentes"
                        detail: "Retome de onde parou"
                        kind: "recent"
                    }
                }
                delegate: Item {
                    width: 196
                    height: 122

                    Rectangle {
                        anchors.fill: parent
                        radius: 14
                        color: cardMouse.containsMouse ? theme.surfaceHover : theme.surfaceRaised
                        border.color: cardMouse.containsMouse ? theme.accent : theme.border
                        border.width: 1
                    }

                    Text {
                        anchors.top: parent.top
                        anchors.topMargin: 18
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: model.glyph
                        color: theme.accentLight
                        font.pixelSize: 30
                    }
                    Text {
                        anchors.top: parent.top
                        anchors.topMargin: 62
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: model.title
                        color: theme.text
                        font.pixelSize: 14
                        font.bold: true
                    }
                    Text {
                        anchors.top: parent.top
                        anchors.topMargin: 84
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: model.detail
                        color: theme.muted
                        font.pixelSize: 10
                    }

                    MouseArea {
                        id: cardMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (model.kind === "new")
                                shell.startNewProject()
                            else if (model.kind === "open")
                                shell.trigger("actionOpen")
                            else
                                shell.showRecent()
                        }
                    }
                }
            }
        }

        Text {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 26
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Dica: arraste arquivos de vídeo para a janela para começar."
            color: theme.muted
            font.pixelSize: 11
        }
    }

    Text {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 18
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Baseado no Shotcut · Copyright © Meltytech, LLC · GPLv3"
        color: "#4a5d78"
        font.pixelSize: 10
    }
}
