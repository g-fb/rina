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
    QString getFileContent(const QUrl &fileurl);
    void saveContentToFile(const QUrl &fileurl, const QString &content);

private:
    Q_DISABLE_COPY_MOVE(Bridge)
};

#endif // BRIDGE_H
