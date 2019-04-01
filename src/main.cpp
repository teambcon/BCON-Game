#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <BCONNetwork/bconnetwork.h>
/*--------------------------------------------------------------------------------------------------------------------*/

extern BCONNetwork *pBackend;
extern QQmlApplicationEngine *pEngine;
/*--------------------------------------------------------------------------------------------------------------------*/

BCONNetwork *pBackend = nullptr;
QQmlApplicationEngine *pEngine = nullptr;
/*--------------------------------------------------------------------------------------------------------------------*/

int main(int argc, char *argv[])
{
    /* Bring in the Virtual Keyboard. */
    qputenv( "QT_IM_MODULE", QByteArray( "qtvirtualkeyboard" ) );

    QCoreApplication::setAttribute( Qt::AA_EnableHighDpiScaling );

    QGuiApplication App( argc, argv );

    /* Create the QML context. */
    QQmlApplicationEngine Engine;
    Engine.load( QUrl( QStringLiteral( "qrc:/main.qml" ) ) );
    if ( !Engine.rootObjects().isEmpty() )
    {
        pEngine = &Engine;
    }
    else
    {
        return -1;
    }

    /* Initialize the BCON network. */
    pBackend = new BCONNetwork();

    return App.exec();
}
