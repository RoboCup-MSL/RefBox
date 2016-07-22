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

private:
    Ui::ControlPanel *ui;
    QElapsedTimer timer_fps;

    void reject();
};

#endif // CONTROLPANEL_H
