#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include "FieldWidget3D.h"

#include <QTimer>
#include <QUdpSocket>
#include <QAbstractSocket>
#include <QKeyEvent>

namespace Ui {
class MainWindow;
}

enum MainWindowShowMode
{
    MW_SHOW_BLACKSCREEN = 0,
    MW_SHOW_FIELD3D,
    MW_SHOW_PICTURE
};

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

    void showEvent(QShowEvent* event);
	void keyPressEvent(QKeyEvent *event);

    void goFullScreen(int screenIdx);
    void goWindowed(int screenIdx);

    void toggleConnection(int port);
    bool openConnection(int port);
    void closeConnection();
    bool isConnected();
    bool isFullscreen();

    void setShowMode(MainWindowShowMode newShowMode);

    FieldWidget3D* field;

private slots:

    void update();
    void displayError(QAbstractSocket::SocketError socketError);
    void readData();

signals:
    void jsonData(const QByteArray& data);
    void receivedJsonData();

private:
    Ui::MainWindow *ui;
    QTimer timer;
    MainWindowShowMode showMode;

    QUdpSocket *tcpSocket;
    QString currentFortune;

    QHash<QUdpSocket*, QByteArray*> buffers; //We need a buffer to store data until block has completely received
    QHash<QUdpSocket*, qint32*> sizes; //We need to store the size to verify if a block has received completely
};

#endif // MAINWINDOW_H
