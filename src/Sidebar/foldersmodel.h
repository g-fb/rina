/*
 * SPDX-FileCopyrightText: 2025 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#ifndef FOLDERSMODEL_H
#define FOLDERSMODEL_H

#include <QAbstractListModel>
#include <QFileSystemWatcher>
#include <QUrl>
#include <QtQmlIntegration/qqmlintegration.h>

struct Folder {
    QUrl url;
    QString name;
};

class FoldersModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit FoldersModel(QObject *parent = nullptr);

    enum Roles {
        UrlRole,
        NameRole,
    };
    Q_ENUM(Roles)

    Q_PROPERTY(uint count READ rowCount NOTIFY countChanged FINAL)
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_PROPERTY(QUrl dataFolder READ dataFolder WRITE setDataFolder NOTIFY dataFolderChanged FINAL)
    Q_SIGNAL void dataFolderChanged();
    QUrl dataFolder() const;
    void setDataFolder(const QUrl &url);

    Q_PROPERTY(uint lastFolderIndex READ lastFolderIndex WRITE setLastFolderIndex NOTIFY lastFolderIndexChanged FINAL)
    uint lastFolderIndex() const;
    void setLastFolderIndex(uint newLastFolderIndex);

Q_SIGNALS:
    void countChanged();
    void lastFolderIndexChanged();

private:
    void getItems();
    QList<Folder> m_data;
    QUrl m_dataFolder;
    std::unique_ptr<QFileSystemWatcher> m_fileSystemWatcher;
    uint m_lastFolderIndex{0};
};

#endif // FOLDERSMODEL_H
