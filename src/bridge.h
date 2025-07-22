/*
 * SPDX-FileCopyrightText: 2025 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#ifndef BRIDGE_H
#define BRIDGE_H

#include <QObject>
#include <QQmlEngine>

class Bridge : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit Bridge(QObject *parent = nullptr);

public Q_SLOTS:
    QString getFileContent(const QUrl &fileUrl);
    void saveContentToFile(const QUrl &fileUrl, const QString &content);
    bool folderExists(const QUrl &url);
    bool createFolder(const QUrl &url);
    bool fileExists(const QUrl &fileUrl);
    bool createFile(const QUrl &fileUrl);
    void highlightInFileManager(const QUrl &fileUrl);
    void moveToTrash(const QUrl &fileUrl);
    void rename(const QUrl &url);

Q_SIGNALS:
    void renameSucceeded(const QUrl &oldUrl, const QUrl &newUrl);

private:
    Q_DISABLE_COPY_MOVE(Bridge)
};

#endif // BRIDGE_H
