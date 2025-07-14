#include "foldersmodel.h"

#include <QDirIterator>

FoldersModel::FoldersModel(QObject *parent)
    : QAbstractListModel(parent)
{
    connect(this, &FoldersModel::dataFolderChanged, this, [this] () {
        beginResetModel();
        m_data.clear();
        endResetModel();

        QDirIterator it(dataFolder().toLocalFile(), QDir::Dirs | QDir::NoDotAndDotDot, QDirIterator::NoIteratorFlags);
        while (it.hasNext()) {
            QFileInfo fi = it.nextFileInfo();
            Folder f;
            f.url = QUrl::fromUserInput(fi.absoluteFilePath());
            f.name = fi.fileName();

            beginInsertRows({}, rowCount(), rowCount());
            m_data.append(f);
            endInsertRows();
        }
    });
}

int FoldersModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) {
        return 0;
    }

    return m_data.count();
}

QVariant FoldersModel::data(const QModelIndex &index, int role) const
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

QHash<int, QByteArray> FoldersModel::roleNames() const
{
    static QHash<int, QByteArray> roles {
        {UrlRole,  QByteArrayLiteral("folderUrl")},
        {NameRole, QByteArrayLiteral("folderName")},
    };

    return roles;
}

QUrl FoldersModel::dataFolder() const
{
    return m_dataFolder;
}

void FoldersModel::setDataFolder(const QUrl &url)
{
    if (m_dataFolder == url) {
        return;
    }

    m_dataFolder = url;
    Q_EMIT dataFolderChanged();
}

#include "moc_foldersmodel.cpp"
