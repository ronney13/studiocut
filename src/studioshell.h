/*
 * Vídeo Studio BR - ponte entre a casca QML e a janela principal.
 * Copyright (c) 2026 Vídeo Studio BR
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

#ifndef STUDIOSHELL_H
#define STUDIOSHELL_H

#include <QObject>
#include <QString>

class MainWindow;
class QPointF;

class StudioShell : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString projectTitle READ projectTitle NOTIFY projectTitleChanged)
    Q_PROPERTY(bool welcomeVisible READ welcomeVisible NOTIFY welcomeVisibleChanged)
    Q_PROPERTY(QString activePanel READ activePanel NOTIFY activePanelChanged)
    Q_PROPERTY(bool maximized READ maximized NOTIFY maximizedChanged)

public:
    explicit StudioShell(MainWindow *window, QObject *parent = nullptr);

    QString projectTitle() const;
    bool welcomeVisible() const;
    QString activePanel() const;
    bool maximized() const;

    Q_INVOKABLE void trigger(const QString &actionName);
    Q_INVOKABLE void showMenu(const QString &menuName, const QPointF &pos);
    Q_INVOKABLE void showRailMenu(const QString &menuName, const QPointF &pos);

    Q_INVOKABLE void selectPanel(const QString &panel);
    Q_INVOKABLE void hidePanels();
    Q_INVOKABLE void showWelcome();
    Q_INVOKABLE void startNewProject();
    Q_INVOKABLE void showRecent();
    Q_INVOKABLE void minimizeWindow();
    Q_INVOKABLE void toggleMaximize();
    Q_INVOKABLE void closeWindow();

public slots:
    void setWelcomeVisible(bool visible);
    void updateProjectTitle();

signals:
    void projectTitleChanged();
    void welcomeVisibleChanged();
    void activePanelChanged();
    void maximizedChanged();

private:
    void showMenuFrom(const QString &menuName, const QPointF &pos);
    void setActivePanel(const QString &panel);

    MainWindow *m_window;
    QString m_projectTitle;
    QString m_activePanel;
    bool m_welcomeVisible{true};
};

#endif // STUDIOSHELL_H
