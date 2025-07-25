/*
 * SPDX-FileCopyrightText: 2025 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#include "filesmodel.h"

#include <QDirIterator>

#include "sidebarsettings.h"

FilesModel::FilesModel(QObject *parent)
    : QAbstractListModel(parent)
    , m_fileSystemWatcher{std::make_unique<QFileSystemWatcher>()}
{
    connect(m_fileSystemWatcher.get(), &QFileSystemWatcher::directoryChanged, this, [this](const QString &path) {
        Q_UNUSED(path)
        getItems();
    });
    connect(this, &FilesModel::parentFolderChanged, this, [this] () {
        getItems();
    });
}

int FilesModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) {
        return 0;
    }

    return m_data.count();
}

QVariant FilesModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid()) {
        return QVariant{};
    }

    const auto item = m_data.at(index.row());

    switch (role) {
    case UrlRole:
        return item.url;
        break;
    case NameRole:
        return item.name;
        break;
    default:
        break;
    }

    return QVariant{};
}

QHash<int, QByteArray> FilesModel::roleNames() const
{
    static QHash<int, QByteArray> roles {
        {UrlRole,  QByteArrayLiteral("fileUrl")},
        {NameRole, QByteArrayLiteral("fileName")},
    };

    return roles;
}

void FilesModel::getItems()
{
    beginResetModel();
    m_data.clear();
    endResetModel();

    QDirIterator it(parentFolder().toLocalFile(), QDir::Files | QDir::NoDotAndDotDot, QDirIterator::NoIteratorFlags);
    uint i{0};
    while (it.hasNext()) {
        QFileInfo fi = it.nextFileInfo();
        File f;
        f.url = QUrl::fromUserInput(fi.absoluteFilePath());
        f.name = fi.fileName();

        if (SidebarSettings::lastFile() == f.url) {
            setLastFileIndex(i);
        }

        beginInsertRows({}, rowCount(), rowCount());
        m_data.append(f);
        endInsertRows();
        i++;
    }
}

QUrl FilesModel::parentFolder() const
{
    return m_parentFolder;
}

void FilesModel::setParentFolder(const QUrl &url)
{
    if (m_parentFolder == url) {
        return;
    }

    if (!m_parentFolder.toLocalFile().isEmpty()) {
        m_fileSystemWatcher->removePath(m_parentFolder.toLocalFile());
    }
    m_parentFolder = url;
    m_fileSystemWatcher->addPath(url.toLocalFile());
    Q_EMIT parentFolderChanged();
}

uint FilesModel::lastFileIndex() const
{
    return m_lastFileIndex;
}

void FilesModel::setLastFileIndex(uint newLastFileIndex)
{
    if (m_lastFileIndex == newLastFileIndex) {
        return;
    }

    m_lastFileIndex = newLastFileIndex;
    Q_EMIT lastFileIndexChanged();
}

#include "moc_filesmodel.cpp"
