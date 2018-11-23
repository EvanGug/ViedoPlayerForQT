#ifndef PLAYER_H
#define PLAYER_H

#include "resultreceiver.h"
#include <QWidget>
#include <QUrl>

class Player : public QWidget
{
    Q_OBJECT
public:
    Q_PROPERTY(QUrl fileNameUrl READ fileNameUrl CONSTANT)
    Q_INVOKABLE void openFile();

public:
    Player(QWidget *parent = 0);
    ~Player();

    QUrl fileNameUrl() const;

public slots:
    void handleData(QString data);

private:
    QUrl m_fileNameUrl;

    ResultReceiver *m_receiver;
};

#endif // PLAYER_H
