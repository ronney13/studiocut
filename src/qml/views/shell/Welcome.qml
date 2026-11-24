import QtQuick

Rectangle {
    id: welcome
    color: theme.background

    ShellTheme { id: theme }

    gradient: Gradient {
        GradientStop { position: 0.0; color: theme.backgroundTop }
        GradientStop { position: 0.55; color: "#050b18" }
        GradientStop { position: 1.0; color: theme.backgroundBottom }
    }

    // Reflexo discreto atrás do cartão principal.
    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -30
        width: Math.min(900, parent.width - 40)
        height: 560
        radius: 280
        color: theme.accentDeep
        opacity: 0.07
    }

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -12
        width: Math.min(760, parent.width - 80)
        height: 470
        radius: 24
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#0c172b" }
            GradientStop { position: 1.0; color: "#070d19" }
        }
        border.color: theme.border
        border.width: 1

        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            radius: 23
            color: "transparent"
            border.color: theme.accent
            border.width: 1
            opacity: 0.22
        }

        Rectangle {
            anchors.top: parent.top
            anchors.topMargin: 18
            anchors.horizontalCenter: parent.horizontalCenter
            width: 44
            height: 3
            radius: 2
            color: theme.accent
        }

        Column {
            anchors.top: parent.top
            anchors.topMargin: 38
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 6

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                source: "qrc:/icons/videostudiobr-logotype.svg"
                width: 320
                height: 86
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Seu estúdio de edição, em português."
                color: theme.accentLight
                font.pixelSize: 14
                font.letterSpacing: 0.4
            }
        }

        Row {
            anchors.top: parent.top
            anchors.topMargin: 244
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 16

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
                    id: actionCard
                    width: 202
                    height: 138

                    property bool hovered: cardMouse.containsMouse

                    y: hovered ? -4 : 0
                    Behavior on y { NumberAnimation { duration: 140 } }

                    Rectangle {
                        anchors.fill: parent
                        radius: 16
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: actionCard.hovered ? theme.surfaceHover : theme.surfaceRaised }
                            GradientStop { position: 1.0; color: theme.surface }
                        }
                        border.color: actionCard.hovered ? theme.accent : theme.border
                        border.width: 1

                        Behavior on border.color { ColorAnimation { duration: 140 } }
                    }

                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 16
                        width: 52
                        height: 52
                        radius: 16
                        color: theme.accentDeep
                        opacity: 0.42
                        border.color: theme.accent
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: model.glyph
                            color: theme.accentLight
                            font.pixelSize: 28
                        }
                    }

                    Text {
                        anchors.top: parent.top
                        anchors.topMargin: 82
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: model.title
                        color: theme.text
                        font.pixelSize: 14
                        font.bold: true
                    }
                    Text {
                        anchors.top: parent.top
                        anchors.topMargin: 105
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
        color: theme.faint
        font.pixelSize: 10
    }
}
