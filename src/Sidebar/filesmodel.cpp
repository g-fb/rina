#include "filesmodel.h"

#include <QDirIterator>

FilesModel::FilesModel(QObject *parent)
    : QAbstractListModel(parent)
{
    connect(this, &FilesModel::parentFolderChanged, this, [this] () {
        beginResetModel();
        m_data.clear();
        endResetModel();

        QDirIterator it(parentFolder().toLocalFile(), QDir::Files | QDir::NoDotAndDotDot, QDirIterator::NoIteratorFlags);
        while (it.hasNext()) {
            QFileInfo fi = it.nextFileInfo();
            File f;
            f.url = QUrl::fromUserInput(fi.absoluteFilePath());
            f.name = fi.fileName();

            beginInsertRows({}, rowCount(), rowCount());
            m_data.append(f);
            endInsertRows();
        }
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

QUrl FilesModel::parentFolder() const
{
    return m_parentFolder;
}

void FilesModel::setParentFolder(const QUrl &url)
{
    if (m_parentFolder == url) {
        return;
    }

    m_parentFolder = url;
    Q_EMIT parentFolderChanged();
}

#include "moc_filesmodel.cpp"
