#include "bridge.h"

#include <QFile>

Bridge::Bridge(QObject *parent)
    : QObject{parent}
{

}

QString Bridge::getFileContent(const QUrl &fileurl)
{
    QFile file(fileurl.toLocalFile());
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Cannot open file:" << file.errorString();
        return {};
    }

    QTextStream in(&file);

    return in.readAll();
}

void Bridge::saveContentToFile(const QUrl &fileurl, const QString &content)
{
    QFile file(fileurl.toLocalFile());
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "Cannot open file:" << file.errorString();
        return;
    }

    QTextStream out(&file);
    out << content;

    file.close();
}
