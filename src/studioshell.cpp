/*
 * Vídeo Studio BR - ponte entre a casca QML e a janela principal.
 * Copyright (c) 2026 Vídeo Studio BR
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

#include "studioshell.h"

#include "mainwindow.h"

#include <QAction>
#include <QCursor>
#include <QFileInfo>
#include <QMenu>
#include <QPoint>
#include <QWidget>

StudioShell::StudioShell(MainWindow *window, QObject *parent)
    : QObject(parent)
    , m_window(window)
{
    connect(m_window, &MainWindow::producerOpened, this, [this]() {
        m_window->showStudioStage(false);
        setWelcomeVisible(false);
        updateProjectTitle();
    });
    connect(m_window, &MainWindow::profileChanged, this, &StudioShell::updateProjectTitle);
    updateProjectTitle();
}

QString StudioShell::projectTitle() const
{
    return m_projectTitle;
}

bool StudioShell::welcomeVisible() const
{
    return m_welcomeVisible;
}

QString StudioShell::activePanel() const
{
    return m_activePanel;
}

bool StudioShell::maximized() const
{
    return m_window->isMaximized();
}

void StudioShell::trigger(const QString &actionName)
{
    if (QAction *action = m_window->findChild<QAction *>(actionName)) {
        if (action->isEnabled())
            action->trigger();
    }
}

void StudioShell::showMenu(const QString &menuName, const QPointF &)
{
    showMenuFrom(menuName);
}

void StudioShell::showRailMenu(const QString &menuName, const QPointF &)
{
    showMenuFrom(menuName);
}

void StudioShell::showMenuFrom(const QString &menuName)
{
    // Os menus do .ui não têm objectName em runtime; o MainWindow resolve os
    // ponteiros diretamente. QCursor::pos() já fornece coordenadas globais.
    if (QMenu *menu = m_window->studioMenu(menuName))
        menu->popup(QCursor::pos());
}

void StudioShell::selectPanel(const QString &panel)
{
    const bool visible = m_window->showStudioPanel(panel);
    setActivePanel(visible ? panel : QString());
}

void StudioShell::hidePanels()
{
    m_window->hideStudioPanels();
    setActivePanel(QString());
}

void StudioShell::showWelcome()
{
    m_window->showStudioStage(true);
    setWelcomeVisible(true);
}

void StudioShell::startNewProject()
{
    // Fecha o projeto atual e revela o formulário de novo projeto do Player.
    m_window->beginNewProject();
}

void StudioShell::showRecent()
{
    m_window->showStudioStage(false);
    setWelcomeVisible(false);
    selectPanel(QStringLiteral("recent"));
}

void StudioShell::minimizeWindow()
{
    m_window->showMinimized();
}

void StudioShell::toggleMaximize()
{
    if (m_window->isMaximized())
        m_window->showNormal();
    else
        m_window->showMaximized();
    emit maximizedChanged();
}

void StudioShell::closeWindow()
{
    m_window->close();
}

void StudioShell::setWelcomeVisible(bool visible)
{
    if (m_welcomeVisible == visible)
        return;
    m_welcomeVisible = visible;
    emit welcomeVisibleChanged();
}

void StudioShell::updateProjectTitle()
{
    const QString fileName = m_window->fileName();
    const QString title = fileName.isEmpty() ? QStringLiteral("Sem título")
                                             : QFileInfo(fileName).fileName();
    if (title == m_projectTitle)
        return;
    m_projectTitle = title;
    emit projectTitleChanged();
}

void StudioShell::setActivePanel(const QString &panel)
{
    if (m_activePanel == panel)
        return;
    m_activePanel = panel;
    emit activePanelChanged();
}
