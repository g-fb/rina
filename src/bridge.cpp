#include "bridge.h"

#include <QFile>
#include <QDir>

#include <KIO/DeleteOrTrashJob>
#include <KIO/OpenFileManagerWindowJob>

using namespace Qt::StringLiterals;

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
    auto content = in.readAll();
    if (content.isEmpty()) {
        return u"{}"_s;
    }

    return content;
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

void Bridge::highlightInFileManager(const QUrl &fileUrl)
{
    KIO::highlightInFileManager({fileUrl});
}

void Bridge::moveToTrash(const QUrl &fileUrl)
{
    auto *job = new KIO::DeleteOrTrashJob({fileUrl},
                                          KIO::AskUserActionInterface::Trash,
                                          KIO::AskUserActionInterface::DefaultConfirmation,
                                          this);
    job->start();
}
