#include "controlpanel.h"
#include "ui_controlpanel.h"
#include <QCloseEvent>
#include <QMessageBox>

ControlPanel::ControlPanel(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::ControlPanel)
{
    ui->setupUi(this);
}

ControlPanel::~ControlPanel()
{
    delete ui;
}

void ControlPanel::on_pushButton_clicked()
{
    //mainWindow->on_btn_connect_clicked();
    mainWindow->toggleConnection(ui->txt_port->text().toInt());

    if(mainWindow->isConnected())
    {
        ui->pushButton->setText("Disconnect");
        connect(mainWindow, SIGNAL(receivedJsonData()), this, SLOT(on_json_received()));
    }else{
        ui->pushButton->setText("Connect");
        disconnect(mainWindow, SIGNAL(receivedJsonData()), this, SLOT(on_json_received()));
    }
}

void ControlPanel::on_json_received()
{
    float fps = 1000.0/timer_fps.elapsed();
    ui->pb_fps->setValue((int)fps);
    timer_fps.restart();
}

void ControlPanel::reject()
{
    // Close button was pressed
    QMessageBox::StandardButton resBtn = QMessageBox::question( this, "Audience Client",
                                        tr("Are you sure you want to quit?\n"),
                                        QMessageBox::Yes | QMessageBox::No,
                                        QMessageBox::Yes);
    if (resBtn == QMessageBox::Yes) {
        exit(0);
    }
}

void ControlPanel::on_btn_flip_clicked()
{
    mainWindow->field->flip();
}

void ControlPanel::on_btn_fullscreen_clicked()
{
    mainWindow->goFullScreen(1);
}

void ControlPanel::on_btn_windowed_clicked()
{
    mainWindow->goWindowed(1);
}

void ControlPanel::on_btn_popup_clicked()
{
    mainWindow->field->showPopup(ui->txt_msg->text());
}
