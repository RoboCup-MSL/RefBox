#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include "FieldWidget3D.h"

#include <QTimer>
#include <QTcpSocket>
#include <QAbstractSocket>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

private slots:
    void on_btn_connect_clicked();
    void update();
    void displayError(QAbstractSocket::SocketError socketError);
    void readData();

signals:
    void jsonData(const QByteArray& data);

private:
    Ui::MainWindow *ui;
    FieldWidget3D* field;
    QTimer timer;

    bool connected;

    QTcpSocket *tcpSocket;
    QString currentFortune;

    QHash<QTcpSocket*, QByteArray*> buffers; //We need a buffer to store data until block has completely received
    QHash<QTcpSocket*, qint32*> sizes; //We need to store the size to verify if a block has received completely
};

#endif // MAINWINDOW_H
