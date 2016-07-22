#include "mainwindow.h"
#include "controlpanel.h"
#include <QtGui/QApplication>
#include <QDesktopWidget>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    MainWindow w;



    /*
    w.setWindowFlags(Qt::WindowStaysOnTopHint | Qt::X11BypassWindowManagerHint);
    QRect screenRes = QApplication::desktop()->screenGeometry(1);
    w.move(QPoint(screenRes.x(), screenRes.y()));
    w.resize(screenRes.width(), screenRes.height());

    w.showFullScreen();
*/
    w.show();

    ControlPanel p;
    p.mainWindow = &w;
    p.show();


    return a.exec();
}
