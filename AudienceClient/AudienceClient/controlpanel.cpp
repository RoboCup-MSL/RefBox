#include "controlpanel.h"
#include "ui_controlpanel.h"
#include <QCloseEvent>
#include <QMessageBox>
#include <QDesktopWidget>

ControlPanel::ControlPanel(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::ControlPanel)
{
    ui->setupUi(this);


    // Get screens
    ui->select_screen->setMinimum(1);
    ui->select_screen->setMaximum(QApplication::desktop()->screenCount());
    ui->select_screen->setValue(ui->select_screen->maximum());
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
        // is disconnected
        ui->pushButton->setText("Connect");
        disconnect(mainWindow, SIGNAL(receivedJsonData()), this, SLOT(on_json_received()));
        ui->pb_fps->setValue(0); // Set 0 FPS
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
    // ESC on Fullscreen
    if(mainWindow->isFullScreen())
        mainWindow->goWindowed(ui->select_screen->value() - 1);
    else
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
}

void ControlPanel::on_btn_flip_clicked()
{
    mainWindow->field->flip();
}

void ControlPanel::on_btn_fullscreen_clicked()
{
    mainWindow->goFullScreen(ui->select_screen->value() - 1);
}

void ControlPanel::on_btn_windowed_clicked()
{
    mainWindow->goWindowed(ui->select_screen->value() - 1);
}

void ControlPanel::on_btn_popup_clicked()
{
    mainWindow->field->showPopup(ui->txt_msg->text());
}

void ControlPanel::on_pushButton_pushing_clicked()
{
    mainWindow->field->showPopup("Foul: Pushing");
}

void ControlPanel::on_pushButton_ballholding_clicked()
{
    mainWindow->field->showPopup("Foul: Ball Holding");
}

void ControlPanel::on_pushButton_longdribble_clicked()
{
    mainWindow->field->showPopup("Foul: Long Dribble");
}

void ControlPanel::on_pushButton_2robots_clicked()
{
    mainWindow->field->showPopup("Foul: 2 Robots on the Ball");
}

void ControlPanel::on_pushButton_illegaldefense_clicked()
{
    mainWindow->field->showPopup("Foul: Illegal Defense");
}

void ControlPanel::on_pushButton_illegalattack_clicked()
{
    mainWindow->field->showPopup("Foul: Illegal Attack");
}

void ControlPanel::on_pushButton_repair_clicked()
{
    mainWindow->field->showPopup("Robot Repair");
}

void ControlPanel::on_pushButton_mode_black_clicked()
{
    mainWindow->setShowMode(MW_SHOW_BLACKSCREEN);
}

void ControlPanel::on_pushButton_mode_3d_clicked()
{
    mainWindow->setShowMode(MW_SHOW_FIELD3D);
}

void ControlPanel::on_pushButton_mode_image_clicked()
{
    mainWindow->setShowMode(MW_SHOW_PICTURE);
}
