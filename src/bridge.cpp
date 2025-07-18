#include "bridge.h"

#include <QFile>
#include <QDir>

Bridge::Bridge(QObject *parent)
    : QObject{parent}
{

}

QString Bridge::getFileContent(const QUrl &fileUrl)
{
    QFile file(fileUrl.toLocalFile());
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Cannot open file:" << file.errorString();
        return {};
    }

    QTextStream in(&file);

    return in.readAll();
}

void Bridge::saveContentToFile(const QUrl &fileUrl, const QString &content)
{
    QFile file(fileUrl.toLocalFile());
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "Cannot open file:" << file.errorString();
        return;
    }

    QTextStream out(&file);
    out << content;

    file.close();
}

bool Bridge::folderExists(const QUrl &url)
{
    QString folder(url.toLocalFile());
    return QDir{}.exists(folder);
}

bool Bridge::createFolder(const QUrl &url)
{
    QString folder(url.toLocalFile());
    return QDir{}.mkpath(folder);
}

bool Bridge::fileExists(const QUrl &fileUrl)
{
    QFile file(fileUrl.toLocalFile());
    QFileInfo fi(file);
    return fi.exists();
}

bool Bridge::createFile(const QUrl &fileUrl)
{
    QFile file(fileUrl.toLocalFile());
    QFileInfo fi(file);
    if (createFolder(QUrl::fromLocalFile(fi.absolutePath()))) {
        return file.open(QFile::WriteOnly);
    }
    return false;
}
