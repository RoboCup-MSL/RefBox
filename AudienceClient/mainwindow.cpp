#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QLayout>
#include <QMessageBox>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow),
    connected(false)
{
    ui->setupUi(this);

    //field = new FieldWidget3D(ui->centralWidget);

    timer.setInterval(20);
    connect(&timer, SIGNAL(timeout()), this, SLOT(update()));
    //timer.start();

    tcpSocket = new QTcpSocket(this);
    QByteArray *buffer = new QByteArray();
    qint32 *s = new qint32(0);
    buffers.insert(tcpSocket, buffer);
    sizes.insert(tcpSocket, s);
    connect(tcpSocket, SIGNAL(readyRead()), this, SLOT(readData()));
    connect(tcpSocket, SIGNAL(error(QAbstractSocket::SocketError)), this, SLOT(displayError(QAbstractSocket::SocketError)));

}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_btn_connect_clicked()
{
    //this->addDockWidget(Qt::LeftDockWidgetArea, field);
    //this->setCentralWidget(field);

    //ui->centralWidget->children()

    if(!connected)
    {

        QString hostIpPort = ui->txt_host->text();
        if(!hostIpPort.contains(':'))
            return;

        QStringList list = hostIpPort.split(":");
        if(list.size() != 2)
            return;

        QString host = list[0];
        QString port = list[1];

        tcpSocket->connectToHost(host, port.toInt());

        field = new FieldWidget3D();
        ui->centralWidget->layout()->addWidget(field);
        field->initAll();

        // Update field when data is received
        connect(this, SIGNAL(jsonData(QByteArray)), field, SLOT(update_robot_info(QByteArray)));

        ui->btn_connect->setText("Disconnect");
        connected = true;
    }else{
        disconnect(this, SIGNAL(jsonData(QByteArray)), field, SLOT(update_robot_info(QByteArray)));
        delete field;
        ui->btn_connect->setText("Connect");
        connected = false;
    }
    //timer.start();
}

qint32 ArrayToInt(QByteArray source)
{
    qint32 temp;
    QDataStream data(&source, QIODevice::ReadWrite);
    data >> temp;
    return temp;
}

void MainWindow::readData()
{
    QTcpSocket *socket = static_cast<QTcpSocket*>(sender());
    QByteArray *buffer = buffers.value(socket);

    while (socket->bytesAvailable() > 0)
    {
        buffer->append(socket->readAll());

        if(buffer->contains('\0'))
        {
            qint32 size = buffer->indexOf('\0');
            QByteArray data = buffer->mid(0, size);
            buffer->remove(0, size + 1);

            emit jsonData(data);

            //fprintf(stderr, "RX: %s\n", dataRx.toStdString().c_str());
        }

    }
}

void MainWindow::displayError(QAbstractSocket::SocketError socketError)
{
    switch (socketError) {
    case QAbstractSocket::RemoteHostClosedError:
        break;
    case QAbstractSocket::HostNotFoundError:
        QMessageBox::information(this, tr("Fortune Client"),
                                 tr("The host was not found. Please check the "
                                    "host name and port settings."));
        break;
    case QAbstractSocket::ConnectionRefusedError:
        QMessageBox::information(this, tr("Fortune Client"),
                                 tr("The connection was refused by the peer. "
                                    "Make sure the fortune server is running, "
                                    "and check that the host name and port "
                                    "settings are correct."));
        break;
    default:
        QMessageBox::information(this, tr("Fortune Client"),
                                 tr("The following error occurred: %1.")
                                 .arg(tcpSocket->errorString()));
    }

    //getFortuneButton->setEnabled(true);
}

void MainWindow::update()
{
    field->update_robot_info("");
}
