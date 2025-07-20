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

private:
    Q_DISABLE_COPY_MOVE(Bridge)
};

#endif // BRIDGE_H
