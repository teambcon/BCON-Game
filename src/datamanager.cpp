#include <QCoreApplication>
#include <QDebug>
#include <QQmlApplicationEngine>
#include <QRegularExpression>

#include "datamanager.h"

extern BCONNetwork *pBackend;
extern QQmlApplicationEngine *pEngine;
/*--------------------------------------------------------------------------------------------------------------------*/

static DataManager *pInstance = nullptr;
/*--------------------------------------------------------------------------------------------------------------------*/

DataManager::DataManager( QObject * pParent ) : QObject( pParent )
{
    sCurrentPlayerId = "";
    sCurrentPlayerScreenName = "";
    iCurrentPlayerTokens = -1;
    iCurrentPlayerTickets = -1;
    iLastStatusCode = 0;
    iTokenCost = 0;

    /* Wire up to the NFCManager signals. */
    connect( NFCManager::instance(), SIGNAL( cardInserted() ), this, SLOT( on_nfcManagerCardInserted() ) );
    connect( NFCManager::instance(), SIGNAL( cardRead( const QString & ) ), this, SLOT( on_nfcManagerCardRead( const QString & ) ) );

    /* Subscribe to player information. */
    DataStore::subscribe( "playerId",    this );
    DataStore::subscribe( "screenName",  this );
    DataStore::subscribe( "tokens",      this );
    DataStore::subscribe( "tickets",     this );
    DataStore::subscribe( "tokenCost",   this );

    /* Subscribe to the HTTP status code for errors. */
    DataStore::subscribe( "statusCode", this );
}
/*--------------------------------------------------------------------------------------------------------------------*/

DataManager * DataManager::instance()
{
    if ( nullptr == pInstance )
    {
        pInstance = new DataManager();
    }

    return pInstance;
}
/*--------------------------------------------------------------------------------------------------------------------*/

void DataManager::handleData( const DataPoint & Data )
{
    QRegularExpression Regex;
    QRegularExpressionMatch Matches;

    Regex.setPattern( "^screenName$" );
    Matches = Regex.match( Data.sTag );
    if ( Matches.hasMatch() )
    {
        sCurrentPlayerScreenName = Data.Value.toString();
        emit screenNameChanged();
        return;
    }

    Regex.setPattern( "^tokens$" );
    Matches = Regex.match( Data.sTag );
    if ( Matches.hasMatch() )
    {
        iCurrentPlayerTokens = Data.Value.toInt();
        emit tokensChanged();
        return;
    }

    Regex.setPattern( "^tickets$" );
    Matches = Regex.match( Data.sTag );
    if ( Matches.hasMatch() )
    {
        iCurrentPlayerTickets = Data.Value.toInt();
        emit ticketsChanged();
        return;
    }

    Regex.setPattern( "^tokenCost$" );
    Matches = Regex.match( Data.sTag );
    if ( Matches.hasMatch() )
    {
        iTokenCost = Data.Value.toInt();
        emit tokenCostChanged();
        return;
    }

    /* Error codes. */
    Regex.setPattern( "^statusCode$" );
    Matches = Regex.match( Data.sTag );
    if ( Matches.hasMatch() )
    {
        iLastStatusCode = Data.Value.toInt();
        emit statusCodeChanged();
        return;
    }
}

/*--------------------------------------------------------------------------------------------------------------------*/

void DataManager::deductTokens()
{
    iCurrentPlayerTokens -= iTokenCost;
    pBackend->updatePlayerTokens( sCurrentPlayerId, iCurrentPlayerTokens);
    emit tokensChanged();
}

/*--------------------------------------------------------------------------------------------------------------------*/

void DataManager::publishStats( const int & iTickets, const int & iScore)
{
    /* Update the backend with the player's game stats */
    pBackend->publishPlayerStats( sCurrentPlayerId, sGameId, iTickets, iScore) ;
}

/*--------------------------------------------------------------------------------------------------------------------*/

void DataManager::on_nfcManagerCardInserted()
{
    /* Pass the signal through so QML can pick it up. */
    emit cardInserted();
}
/*--------------------------------------------------------------------------------------------------------------------*/

void DataManager::on_nfcManagerCardRead( const QString & sId )
{
    sCurrentPlayerId = sId;
    emit playerIdChanged();

    /* Fetch the player information from the backend. */
    pBackend->getPlayer( sCurrentPlayerId );
}
/*--------------------------------------------------------------------------------------------------------------------*/

QObject * datamanager_singletontype_provider( QQmlEngine * pEngine, QJSEngine * pScriptEngine )
{
     Q_UNUSED( pEngine )
     Q_UNUSED( pScriptEngine )

     return DataManager::instance();
}
/*--------------------------------------------------------------------------------------------------------------------*/
