#ifndef FILESMODEL_H
#define FILESMODEL_H

#include <QAbstractListModel>
#include <QUrl>
#include <QtQmlIntegration/qqmlintegration.h>

struct File {
    QUrl url;
    QString name;
};

class FilesModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit FilesModel(QObject *parent = nullptr);

    enum Roles {
        UrlRole,
        NameRole,
    };
    Q_ENUM(Roles)

    Q_PROPERTY(uint count READ rowCount NOTIFY countChanged FINAL)
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_PROPERTY(QUrl parentFolder READ parentFolder WRITE setParentFolder NOTIFY parentFolderChanged FINAL)
    Q_SIGNAL void parentFolderChanged();
    QUrl parentFolder() const;
    void setParentFolder(const QUrl &url);

Q_SIGNALS:
    void countChanged();

private:
    QList<File> m_data;
    QUrl m_parentFolder;
};

#endif // FILESMODEL_H
