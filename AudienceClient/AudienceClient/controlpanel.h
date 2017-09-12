#ifndef CONTROLPANEL_H
#define CONTROLPANEL_H

#include <QDialog>
#include "mainwindow.h"
#include <QElapsedTimer>

namespace Ui {
class ControlPanel;
}

class ControlPanel : public QDialog
{
    Q_OBJECT

public:
    explicit ControlPanel(QWidget *parent = 0);
    ~ControlPanel();

    MainWindow* mainWindow;

private slots:
    void on_pushButton_clicked();

    void on_btn_flip_clicked();

    void on_btn_fullscreen_clicked();

    void on_btn_windowed_clicked();

    void on_json_received();

    void on_btn_popup_clicked();

    void on_pushButton_pushing_clicked();

    void on_pushButton_ballholding_clicked();

    void on_pushButton_longdribble_clicked();

    void on_pushButton_2robots_clicked();

    void on_pushButton_illegaldefense_clicked();

    void on_pushButton_illegalattack_clicked();

    void on_pushButton_repair_clicked();

    void on_pushButton_mode_black_clicked();

    void on_pushButton_mode_3d_clicked();

    void on_pushButton_mode_image_clicked();

private:
    Ui::ControlPanel *ui;
    QElapsedTimer timer_fps;

    void reject();
};

#endif // CONTROLPANEL_H
