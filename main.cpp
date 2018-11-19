#include <QApplication>
#include <QtQml>
#include <QQmlApplicationEngine>
#include "player.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);

    Player * player = new Player();

    QQmlApplicationEngine engine;
    //把Player类加载到qml中使用
    engine.rootContext()->setContextProperty("mymediaplayer", player);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
