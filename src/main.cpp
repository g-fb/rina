#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtWebEngineQuick>

#include <KLocalizedString>

using namespace Qt::StringLiterals;

int main(int argc, char *argv[])
{
    QtWebEngineQuick::initialize();

    QGuiApplication app(argc, argv);
    QGuiApplication::setWindowIcon(QIcon::fromTheme(u"rina"_s));
    KLocalizedString::setApplicationDomain("rina");

    QQmlApplicationEngine engine;
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     &app, []() { QCoreApplication::exit(-1); },
    Qt::QueuedConnection);
    engine.rootContext()->setContextObject(new KLocalizedContext(&app));
    engine.loadFromModule("com.georgefb.rina", "Main");

    return app.exec();
}
