#include "foldersmodel.h"

#include <QDirIterator>

FoldersModel::FoldersModel(QObject *parent)
    : QAbstractListModel(parent)
    , m_fileSystemWatcher{std::make_unique<QFileSystemWatcher>()}
{
    connect(m_fileSystemWatcher.get(), &QFileSystemWatcher::directoryChanged, this, [this](const QString &path) {
        Q_UNUSED(path)
        getItems();
    });
    connect(this, &FoldersModel::dataFolderChanged, this, [this] () {
        getItems();
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

void FoldersModel::getItems()
{
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

    if (!m_dataFolder.toLocalFile().isEmpty()) {
        m_fileSystemWatcher->removePath(m_dataFolder.toLocalFile());
    }
    m_dataFolder = url;
    m_fileSystemWatcher->addPath(url.toLocalFile());
    Q_EMIT dataFolderChanged();
}

#include "moc_foldersmodel.cpp"
