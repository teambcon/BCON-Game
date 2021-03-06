#include <QCommandLineParser>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <BCONNetwork/bconnetwork.h>

#include "datamanager.h"
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

    QCoreApplication::setApplicationName( "BCON Game" );
    QCoreApplication::setApplicationVersion( "1.0.0" );

    QCoreApplication::setAttribute( Qt::AA_EnableHighDpiScaling );

    QGuiApplication App( argc, argv );

    /* Parse the command line arguments. */
    QCommandLineParser Parser;
    QCommandLineOption ServerOption( QStringList() << "s" << "server",
                                     QCoreApplication::translate( "main", "Address of the backend server to connect to." ),
                                     QCoreApplication::translate( "main", "IP:Port" ) );
    QCommandLineOption NFCOption( QStringList() << "n" << "nonfc",
                                  QCoreApplication::translate( "main", "Do not use NFC functionality." ) );
    Parser.setApplicationDescription( "BCON Kiosk" );
    Parser.addHelpOption();
    Parser.addVersionOption();
    Parser.addOption( ServerOption );
    Parser.addOption( NFCOption );
    Parser.process( App );

    /* Check the command line arguments. */
    QString sServerAddress = Parser.isSet( "server" ) ? Parser.value( "server" ) : "http://localhost:3000";
    qDebug() << "Connecting to server at address" << sServerAddress;
    bool bUseNFC = Parser.isSet( "nonfc" ) ? false : true;
    qDebug() << ( bUseNFC ? "Enabling NFC functionality" : "Not using NFC functionality" );

    /* Register the Data Manager in the QML context. */
    qmlRegisterSingletonType<DataManager>( "com.bcon.datamanager", 1, 0, "DataManager", datamanager_singletontype_provider );
    QQmlEngine::setObjectOwnership( qobject_cast<QObject *>( DataManager::instance() ), QQmlEngine::CppOwnership );
    DataManager::instance()->setParent( &App );

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
    pBackend = new BCONNetwork( sServerAddress, bUseNFC );
    pBackend->getGame(GAME_ID);

    return App.exec();
}
