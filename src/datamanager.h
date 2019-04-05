#ifndef DATAMANAGER_H
#define DATAMANAGER_H

#include <QJSEngine>
#include <QObject>
#include <QQmlEngine>

#include <BCONNetwork/bconnetwork.h>

class DataManager : public QObject, public DataSubscriber
{
    Q_OBJECT
public:
    Q_PROPERTY( QString playerId MEMBER sCurrentPlayerId NOTIFY playerIdChanged() )
    Q_PROPERTY( QString screenName MEMBER sCurrentPlayerScreenName NOTIFY screenNameChanged() )
    Q_PROPERTY( int tokens MEMBER iCurrentPlayerTokens NOTIFY tokensChanged() )
    Q_PROPERTY( int tickets MEMBER iCurrentPlayerTickets NOTIFY ticketsChanged() )
    Q_PROPERTY( int statusCode MEMBER iLastStatusCode NOTIFY statusCodeChanged() )
    Q_PROPERTY( int tokenCost MEMBER iTokenCost NOTIFY tokenCostChanged() )

    static DataManager * instance();
    static DataManager * qmlAttachedProperties( QObject * pObject );

signals:
    void cardInserted();

    void playerIdChanged();
    void screenNameChanged();
    void tokensChanged();
    void ticketsChanged();
    void tokenCostChanged();

    void statusCodeChanged();

public slots:
    void handleData( const DataPoint & Data ) override;
    void publishStats( const int & tickets, const int & tokens);
    void deductTokens();

private slots:
    void on_nfcManagerCardInserted();
    void on_nfcManagerCardRead( const QString & sId );

private:
    QString sCurrentPlayerId;
    QString sCurrentGameId;
    QString sCurrentPlayerScreenName;
    QString sGameId;
    int iCurrentPlayerTokens;
    int iCurrentPlayerTickets;
    int iTokenCost;

    int iLastStatusCode;

    explicit DataManager( QObject * pParent = nullptr );
};

QObject * datamanager_singletontype_provider( QQmlEngine * pEngine, QJSEngine * pScriptEngine );

QML_DECLARE_TYPEINFO( DataManager, QML_HAS_ATTACHED_PROPERTIES );

#endif // DATAMANAGER_H
