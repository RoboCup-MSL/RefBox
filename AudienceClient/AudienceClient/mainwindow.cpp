#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QLayout>
#include <QMessageBox>
#include <QDesktopWidget>
#include <QFileDialog>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    timer.setInterval(20);
    connect(&timer, SIGNAL(timeout()), this, SLOT(update()));

    tcpSocket = new QUdpSocket(this);
    QByteArray *buffer = new QByteArray();
    qint32 *s = new qint32(0);
    buffers.insert(tcpSocket, buffer);
    sizes.insert(tcpSocket, s);
    connect(tcpSocket, SIGNAL(readyRead()), this, SLOT(readData()));
    connect(tcpSocket, SIGNAL(error(QAbstractSocket::SocketError)), this, SLOT(displayError(QAbstractSocket::SocketError)));

    field = new FieldWidget3D(this);
    ui->centralWidget->layout()->addWidget(field);
    field->initAll();
}

MainWindow::~MainWindow()
{
    delete ui;
}

// Widget has been made visible
void MainWindow::showEvent( QShowEvent* event ) {
    QWidget::showEvent( event );
    //your code here

    //on_btn_connect_clicked();
}

void MainWindow::keyPressEvent(QKeyEvent *event)
{
	if(event->key() == Qt::Key_F)
    {
    	if(field)
	    	field->flip();
    }
}

void MainWindow::goFullScreen(int screenIdx)
{
    this->setWindowFlags(Qt::WindowStaysOnTopHint | Qt::X11BypassWindowManagerHint);

    QRect screenRes = QApplication::desktop()->screenGeometry(screenIdx);
    this->move(QPoint(screenRes.x(), screenRes.y()));
    this->resize(screenRes.width(), screenRes.height());

    this->showFullScreen();
}

void MainWindow::goWindowed(int screenIdx)
{
    Qt::WindowFlags flags = this->windowFlags();
    flags &= ~Qt::WindowStaysOnTopHint;
    flags &= ~Qt::X11BypassWindowManagerHint;

    this->setWindowFlags(flags);

    QRect screenRes = QApplication::desktop()->screenGeometry(screenIdx);
    this->move(QPoint(screenRes.x() + screenRes.width()/4, screenRes.y() + screenRes.height()/4));
    this->resize(screenRes.width()/2, screenRes.height()/2);

    this->showNormal();
}

void MainWindow::toggleConnection(int port)
{
    if(isConnected())
        closeConnection();
    else
        openConnection(port);
}

bool MainWindow::openConnection(int port)
{
    if(isConnected())
        return true;

    fprintf(stderr,"Binding to port %d\n", port);
    if(tcpSocket->bind(port, QUdpSocket::ShareAddress))
    {
        // Update field when data is received
        connect(this, SIGNAL(jsonData(QByteArray)), field, SLOT(update_robot_info(QByteArray)));
    }

    return isConnected();
}

void MainWindow::closeConnection()
{
    if(!isConnected())
        return;

    tcpSocket->close();
    disconnect(this, SIGNAL(jsonData(QByteArray)), field, SLOT(update_robot_info(QByteArray)));
}

bool MainWindow::isConnected()
{
    bool connected = tcpSocket->state() == QAbstractSocket::BoundState;
    //fprintf(stderr,"isConnected: %d", connected ? 1 : 0);
    return connected;
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
    QUdpSocket *socket = static_cast<QUdpSocket*>(sender());
    QByteArray *buffer = buffers.value(socket);

    while (socket->bytesAvailable() > 0)
    {
        QHostAddress host;
        quint16 port;

        QByteArray buf(socket->pendingDatagramSize(), Qt::Uninitialized);
        socket->readDatagram(buf.data(), buf.size(), &host, &port);

        //fprintf(stderr, "RX %d bytes!\n", (int)size);

        buffer->append(buf);

        if(buffer->contains('\0'))
        {
            qint32 size = buffer->indexOf('\0');
            QByteArray data = buffer->mid(0, size);
            buffer->remove(0, size + 1);

            emit jsonData(data);
            emit receivedJsonData();

            ui->lcdA->display(field->tA.score);
            if(field->tA.score >= 10) ui->lcdA->setDigitCount(2);
            ui->lcdB->display(field->tB.score);
            if(field->tB.score >= 10) ui->lcdB->setDigitCount(2);

            ui->lbl_ta->setText(field->tA.shortName);
            ui->lbl_tb->setText(field->tB.shortName);

            ui->lbl_time->setText(field->gametime_str);

            //fprintf(stderr, "RX: %s\n", QString(data).toStdString().c_str());
        }

    }
}

void MainWindow::displayError(QAbstractSocket::SocketError socketError)
{
    switch (socketError) {
    case QAbstractSocket::RemoteHostClosedError:
        break;
    case QAbstractSocket::HostNotFoundError:
        QMessageBox::information(this, tr("Audience Client"),
                                 tr("The host was not found. Please check the "
                                    "host name and port settings."));
        break;
    case QAbstractSocket::ConnectionRefusedError:
        QMessageBox::information(this, tr("Audience Client"),
                                 tr("The connection was refused by the peer. "
                                    "Make sure the fortune server is running, "
                                    "and check that the host name and port "
                                    "settings are correct."));
        break;
    default:
        QMessageBox::information(this, tr("Audience Client"),
                                 tr("The following error occurred: %1.")
                                 .arg(tcpSocket->errorString()));
    }

    //getFortuneButton->setEnabled(true);
}

void MainWindow::update()
{
    field->update_robot_info("");
}

void MainWindow::setShowMode(MainWindowShowMode newShowMode)
{
    ui->centralWidget->setVisible(false);
    this->setStyleSheet("background-color: black;");

    switch(newShowMode)
    {
    case MW_SHOW_BLACKSCREEN: break;
    case MW_SHOW_FIELD3D: ui->centralWidget->setVisible(true); break;
    case MW_SHOW_PICTURE:
        QString fileName = QFileDialog::getOpenFileName(this, tr("Open Image"), "", tr("Image Files (*.png)"));
        this->setStyleSheet("background-color: black; background-image: url(" + fileName + "); background-repeat: no-repeat; background-position: center center;");
        //border-image: url(:/res/background.jpg) 0 0 0 0 stretch stretch;
        break;
    }
}
