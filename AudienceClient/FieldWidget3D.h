/**
  FieldWidget3D.h
  Author: Ricardo Dias <ricardodias@ua.pt>
  A QWidget that uses VTK to draw a field in 3D
  */

#ifndef FIELDWIDGET3D_H
#define FIELDWIDGET3D_H

#include <QFile>
#include <QVector3D>
#include <QColor>

#include <QVTKWidget.h>

#include <vtkCallbackCommand.h>
#include <vtkSmartPointer.h>
#include <vtkLineSource.h>
#include <vtkSphereSource.h>
#include <vtkProperty.h>
#include <vtkProperty2D.h>
#include <vtkRenderWindow.h>
#include <vtkRenderer.h>
#include <vtkTextSource.h>
#include <vtkCylinderSource.h>
#include <vtkVectorText.h>
#include <vtkPolyDataMapper.h>
#include <vtkActor.h>
#include <vtkCamera.h>
#include <vtkInteractorStyleSwitch.h>
#include <vtkInteractorStyleTerrain.h>
#include <vtkOBJReader.h>
#include <vtkTriangleStrip.h>
#include <vtkCellArray.h>
#include <vtkDataSetMapper.h>
#include <vtkFloatArray.h>
#include <vtkTransform.h>
#include <vtkTransformPolyDataFilter.h>
#include <vtkTextWidget.h>
#include <vtkTextActor.h>
#include <vtkScaledTextActor.h>
#include <vtkTextProperty.h>
#include <vtkViewport.h>
#include <vtkPointWidget.h>
#include <vtkPolygon.h>
#include <vtkPNGReader.h>
#include <vtkImageCanvasSource2D.h>
#include <vtkImageData.h>
#include <vtkImageMapper.h>
#include <vtkPropPicker.h>
#include <vtkObjectFactory.h>
#include <vtkPlaneSource.h>
#include <vtkPropCollection.h>
#include <vtkDelaunay2D.h>
#include <vtkLookupTable.h>
#include <vtkMath.h>
#include <vtkPointData.h>

#include <QVTKInteractor.h>
#include <QTimer>
#include <QTime>

#include "ConfigXML.h"
#include "Team.h"

#define NROBOTS 10
#define OBSTACLE_HEIGHT 0.2


class FieldWidget3D : public QVTKWidget
{
    Q_OBJECT
public:
    explicit FieldWidget3D(QWidget *parent = 0);

    vtkRenderWindow *renderWindow;
    vtkRenderer *renderer;
    vtkCamera* camera;

    vtkActor* field;

    vtkActor* robots_teamA[NROBOTS];
    vtkActor* robotNum_teamA[NROBOTS];
    vtkActor* balls_teamA[NROBOTS];

    vtkActor* robots_teamB[NROBOTS];
    vtkActor* robotNum_teamB[NROBOTS];
    vtkActor* balls_teamB[NROBOTS];

    vector<vtkActor*> toDeleteActors;

    void initAll();

    bool top;
    bool lockCam;

private:
    float _FIELD_LENGTH;
    float _FIELD_WIDTH;
    float _LINE_THICKNESS;
    float _GOAL_AREA_LENGTH;
    float _GOAL_AREA_WIDTH;
    float _PENALTY_AREA_LENGTH;
    float _PENALTY_AREA_WIDTH;
    float _CENTER_CIRCLE_RADIUS;
    float _BALL_DIAMETER;
    float _CORNER_CIRCLE_RADIUS;
    float _PENALTY_MARK_DISTANCE;
    float _BLACK_POINT_WIDTH;
    float _BLACK_POINT_LENGTH;
    float _ROBOT_RADIUS;

    vtkSmartPointer<vtkActor> createLine(float x1, float y1, float z1, float x2, float y2, float z2);
    void addArc(vtkRenderer* renderer, float x, float y, float radius, float startDeg, float endDeg);
    void drawField(vtkRenderer* renderer);
    void drawGoals(vtkRenderer* renderer);
    void initBalls(vtkRenderer* renderer);
    void drawRobots(vtkActor** actor_array, Team* team);

    vtkActor* createText(QString text);
    vtkActor* createObstacle();
    vtkActor* createDebugPt();
    vtkActor* createDashedLine(float x1, float y1, float z1, float x2, float y2, float z2);
    vtkActor* createBall(QVector3D pos, QColor color);
    void createDot(vtkRenderer* renderer, float x, float y, bool black, float radius=0.05);

    // Score board
    vtkActor2D* score_board;
    int scoreInt_teamA, scoreInt_teamB;
    vtkTextActor* score_teamA;
    vtkTextActor* score_teamB;
    vtkTextActor* score_goals;
    vtkTextActor* score_time;

    Team tA, tB;

    float robotsColorR[2];
    float robotsColorG[2];
    float robotsColorB[2];

    QTimer timer;
    QTime textOverlay_startTime;
    bool textOverlay_en;
    float textOverlay_fadeInMs;
    float textOverlay_HoldMs;
    float textOverlay_fadeOutMs;
    float textOverlay_totalTimeMs;
    vtkTextActor* textOverlay_actor;
    vtkActor2D* textOverlay_background;
    QString textOverlay_text;
    bool canOverlay();

    // HACK - TODO a proper class
    QString gametime_str;
    QString tA_shortname, tB_shortname;

signals:
    
public slots:
    void flip(void);
    void setTop(bool);
    void lock(bool);
    void update_robot_info(const QByteArray& json_status);
    void refresh();
};

#endif // FIELDWIDGET3D_H
