/**
  FieldWidget3D.cpp
  Author: Ricardo Dias <ricardodias@ua.pt>
  A QWidget that uses VTK to draw a field in 3D
  */

#include "FieldWidget3D.h"
#include <vtkLineWidget.h>
#include <qjson/parser.h>
#include <QVariantMap>
#include <unistd.h>

class MouseInteractorStyle : public vtkInteractorStyleTerrain
{
public:
    static MouseInteractorStyle* New();
    vtkTypeMacro(MouseInteractorStyle, vtkInteractorStyleTerrain);

    // Initialize internal variables
    MouseInteractorStyle()
    {
        LastPickedActor = NULL;
        LastPickedProperty = vtkProperty::New();
        FieldCollection = vtkPropCollection::New();

    }
    virtual ~MouseInteractorStyle()
    {
        LastPickedProperty->Delete();
        FieldCollection->Delete();
    }

    void setParent(FieldWidget3D* p)
    {
        this->parent = p;
        FieldCollection->AddItem(parent->field);
    }

    // When the left button of the mouse is pressed
    virtual void OnLeftButtonDown()
    {
        this->parent->parentWidget()->setFocus();

        // Decide if drag of a robot or field orientation change
        //fprintf(stderr,"LEFT MOUSE BUTTON PRESSED\n");
        // Get the position where the mouse pointer was
        int* clickPos = this->GetInteractor()->GetEventPosition();
        // Create a picker with the clickPos information
        vtkSmartPointer<vtkPropPicker>  picker = vtkSmartPointer<vtkPropPicker>::New();
        picker->Pick(clickPos[0], clickPos[1], 0, parent->renderer);
        // Check if the picker returns an actor
        this->LastPickedActor = picker->GetActor();
        if(LastPickedActor != NULL)
        {

        }else{

        }

        vtkInteractorStyleTerrain::OnLeftButtonDown();
    }

    virtual void OnLeftButtonUp()
    {
        fprintf(stderr,"LEFT MOUSE BUTTON RELEASED\n");

        // Get the position where the mouse pointer was
        int* clickPos = this->GetInteractor()->GetEventPosition();
        // Create a picker with the clickPos information
        vtkSmartPointer<vtkPropPicker>  picker = vtkSmartPointer<vtkPropPicker>::New();
        picker->PickProp(clickPos[0], clickPos[1], parent->renderer, FieldCollection);


        //Check if the picker returns an actor
        if(picker->GetActor() != NULL && picker->GetActor() == parent->field)
        {
            double* position = picker->GetPickPosition();
            //fprintf(stderr, "POS: (%.1lf, %.1lf, %.1lf)\n", position[0], position[1], position[2]);
        }

        vtkInteractorStyleTerrain::OnLeftButtonUp();
    }

    virtual void OnMouseMove()
    {
        vtkInteractorStyleTerrain::OnMouseMove();

        if(parent->camera->GetPosition()[2] < 0.0)
            parent->camera->SetPosition(parent->camera->GetPosition()[0], parent->camera->GetPosition()[1], 0.0);
    }


private:
    vtkActor    *LastPickedActor; 
    FieldWidget3D* parent;
    vtkProperty *LastPickedProperty;
    vtkPropCollection *FieldCollection;

};
// define the previous class as a new vtk standard
vtkStandardNewMacro(MouseInteractorStyle);

FieldWidget3D::FieldWidget3D(QWidget *parent) :
    QVTKWidget(parent)
{
    ConfigXML config;
    if( config.parse("../config/field.conf.xml") == false )
    {
        cerr << "ERROR " << endl;
        exit(1);
    }

    /* Dimensions */
    _FIELD_LENGTH			= config.getField("field_length")/1000.0;
    _FIELD_WIDTH			= config.getField("field_width")/1000.0;
    _LINE_THICKNESS			= config.getField("line_thickness")/1000.0;
    _GOAL_AREA_LENGTH		= config.getField("goal_area_length")/1000.0;
    _GOAL_AREA_WIDTH		= config.getField("goal_area_width")/1000.0;
    _PENALTY_AREA_LENGTH	= config.getField("penalty_area_length")/1000.0;
    _PENALTY_AREA_WIDTH		= config.getField("penalty_area_width")/1000.0;
    _CENTER_CIRCLE_RADIUS	= config.getField("center_circle_radius")/1000.0;
    _BALL_DIAMETER			= config.getField("ball_diameter")/1000.0;
    _CORNER_CIRCLE_RADIUS	= config.getField("corner_arc_radius")/1000.0;
    _PENALTY_MARK_DISTANCE	= config.getField("penalty_marker_distance")/1000.0;
    _BLACK_POINT_WIDTH		= _FIELD_WIDTH/4.0;
    _BLACK_POINT_LENGTH		= config.getField("penalty_marker_distance")/1000.0;
    _ROBOT_RADIUS			= config.getField("robot_radius")/1000.0;

    /* Init Colors */
    float robotsColorR[] = { 0, 1};
    float robotsColorG[] = { 0, 0};
    float robotsColorB[] = { 1, 0};
    for(int i = 0; i < 2; i++)
    {
        this->robotsColorR[i] = robotsColorR[i];
        this->robotsColorG[i] = robotsColorG[i];
        this->robotsColorB[i] = robotsColorB[i];
    }

    renderWindow = vtkRenderWindow::New();
    renderer = vtkRenderer::New();
    renderer->SetBackground(0.0, 0.0, 0.0);

    renderWindow->AddRenderer(renderer);
    this->SetRenderWindow(renderWindow);

    renderWindow->Render();
    renderer->Render();

    timer.setInterval(30);
    connect(&timer, SIGNAL(timeout()), this, SLOT(refresh()));

    textOverlay_en = false;
    textOverlay_fadeInMs = 500;
    textOverlay_HoldMs = 2000;
    textOverlay_fadeOutMs = 500;
    textOverlay_totalTimeMs = textOverlay_fadeInMs + textOverlay_HoldMs + textOverlay_fadeOutMs;
}

void FieldWidget3D::initAll()
{
    drawField(renderer);
    drawGoals(renderer);
    renderWindow->Render();
    initBalls(renderer);

    // Camera properties
    camera = vtkCamera::New();
    camera->SetPosition(_FIELD_WIDTH, 0, 22);
    camera->SetFocalPoint(0, 0, -2);
    camera->SetViewUp(0,0,1);
    renderer->SetActiveCamera(camera);

    // Interactor
    QVTKInteractor* iren = this->GetInteractor();

    vtkSmartPointer<MouseInteractorStyle> intStyle = vtkSmartPointer<MouseInteractorStyle>::New();
    intStyle->setParent(this);
    iren->SetInteractorStyle(intStyle);
    renderWindow->SetInteractor(iren);

    renderWindow->Render();

    /* Read CAMBADA model */
    vtkSmartPointer<vtkOBJReader> readerCbd = vtkSmartPointer<vtkOBJReader>::New();
    readerCbd->SetFileName("../config/cambada_base.obj");

    vtkSmartPointer<vtkPolyDataMapper> actorMapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    actorMapper->SetInput(readerCbd->GetOutput());

    renderer->Render();

    for(int i = 0; i < NROBOTS; i++)
    {
        robots_teamA[i] = vtkActor::New();
        robots_teamA[i]->SetMapper(actorMapper);
        robots_teamA[i]->GetProperty()->SetRepresentationToSurface();
        robots_teamA[i]->GetProperty()->SetColor(robotsColorR[0],robotsColorG[0],robotsColorB[0]);

        renderer->AddActor(robots_teamA[i]);
        robots_teamA[i]->SetPosition(1000,1000,1000);

        robots_teamB[i] = vtkActor::New();
        robots_teamB[i]->SetMapper(actorMapper);
        robots_teamB[i]->GetProperty()->SetRepresentationToSurface();
        robots_teamB[i]->GetProperty()->SetColor(robotsColorR[1],robotsColorG[1],robotsColorB[1]);
        renderer->AddActor(robots_teamB[i]);
        robots_teamB[i]->SetPosition(1000,1000,1000);
    }

    textOverlay_actor = vtkTextActor::New();
    textOverlay_actor->SetInput("TEST");
    textOverlay_actor->GetTextProperty()->SetFontSize ( 96 );
    textOverlay_actor->GetTextProperty()->SetFontFamilyToArial();
    textOverlay_actor->GetTextProperty()->SetJustificationToCentered();
    textOverlay_actor->GetTextProperty()->SetColor(1.0,179.0/255,0);
    textOverlay_actor->GetTextProperty()->BoldOn();
    textOverlay_actor->SetLayerNumber(7);
    renderer->AddActor2D(textOverlay_actor);

    renderer->Render();

    timer.start();
}

/**
  Actualiza a informação dos objectos
  */
void FieldWidget3D::update_robot_info(const QByteArray& json_status)
{
    // Parse json
    // create a Parser instance
    QJson::Parser parser;
    bool ok;

    //fprintf(stderr,"JSON: %s", QString(json_status).toStdString().c_str());

    // json is a QString containing the data to convert
    bool newTeamsInfo = false;
    bool newEvent = false;
    QVariantMap result = parser.parse (json_status, &ok).toMap();
    if(ok)
    {
        if(result.contains("type"))
        {
            if(result["type"].toString().contains("teams"))
            {
                fprintf(stderr,"new teams JSON: %s\n", QString(json_status).toStdString().c_str());

                //QString version = result["version"].toString();
                gametime_str = result["gameTime"].toString();

                tA.update(result["teamA"].toMap());
                tB.update(result["teamB"].toMap());

                // Invert team B coordinates
                tB.world.ballPos.setX(tB.world.ballPos.x()*-1);
                tB.world.ballPos.setY(tB.world.ballPos.y()*-1);

                newTeamsInfo = true;
            }
            else if(result["type"].toString().contains("event"))
            {
                QString event = result["eventDesc"].toString();
                QString team = result["team"].toString();
                QString eventText = event + "\n" + team + "\0";

                showPopup(eventText);
            }
        }
    }

}

void FieldWidget3D::showPopup(QString msg)
{
    if(canOverlay())
    {
        textOverlay_actor->SetInput(msg.toStdString().c_str());
        textOverlay_en = true;
        textOverlay_startTime.start();
    }
}

void FieldWidget3D::flip(void)
{
    if(camera->GetPosition()[0] < 0)
        camera->SetPosition(_FIELD_WIDTH, 0, 22);
    else
        camera->SetPosition(-_FIELD_WIDTH, 0, 22);

    camera->SetFocalPoint(0, 0, -2);
    camera->SetViewUp(0,0,1);
}

void FieldWidget3D::drawGoals(vtkRenderer* renderer)
{
    // Goals
    vtkSmartPointer<vtkOBJReader> reader = vtkSmartPointer<vtkOBJReader>::New();
    reader->SetFileName("../config/goal.obj");
    reader->Update();

    vtkSmartPointer<vtkPolyDataMapper> goalMapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    goalMapper->SetInput(reader->GetOutput());

    vtkSmartPointer<vtkActor> goalBlue = vtkSmartPointer<vtkActor>::New();
    goalBlue->SetMapper(goalMapper);
    goalBlue->RotateX(90);
    goalBlue->SetPosition(0,-_FIELD_LENGTH/2,0);
    goalBlue->GetProperty()->SetColor(1,1,1);
    goalBlue->GetProperty()->SetDiffuse(0.4);
    goalBlue->GetProperty()->SetAmbient(0.8);
    renderer->AddActor(goalBlue);

    vtkSmartPointer<vtkActor> goalYellow = vtkSmartPointer<vtkActor>::New();
    goalYellow->SetMapper(goalMapper);
    goalYellow->RotateX(90);
    goalYellow->SetPosition(0,_FIELD_LENGTH/2,0);
    goalYellow->GetProperty()->SetColor(1,1,1);
    goalYellow->GetProperty()->SetDiffuse(0.4);
    goalYellow->GetProperty()->SetAmbient(0.8);
    renderer->AddActor(goalYellow);
}

vtkSmartPointer<vtkActor> FieldWidget3D::createLine(float x1, float y1, float z1, float x2, float y2, float z2)
{
    vtkSmartPointer<vtkLineSource> line = vtkSmartPointer<vtkLineSource>::New();
    vtkSmartPointer<vtkPolyDataMapper> lineMapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    vtkSmartPointer<vtkActor> lineActor = vtkSmartPointer<vtkActor>::New();
    line->SetPoint1(x1, y1, z1);
    line->SetPoint2(x2, y2, z2);
    lineMapper->SetInputConnection(line->GetOutputPort());
    lineActor->SetMapper(lineMapper);
    lineActor->GetProperty()->SetLineWidth(3);

    return lineActor;
}

void FieldWidget3D::addArc(vtkRenderer *renderer, float x, float y, float radius, float startDeg, float endDeg)
{
    float x1,y1,x2,y2;
    x2 = x + radius*cos(startDeg*M_PI/180);
    y2 = y + radius*sin(startDeg*M_PI/180);
    for(int i = startDeg + 10; i <= endDeg; i+= 10)
    {
        x1 = x + radius*cos(i*M_PI/180);
        y1 = y + radius*sin(i*M_PI/180);
        renderer->AddActor(createLine(x1,y1,0,x2,y2,0));
        x2 = x1;
        y2 = y1;
    }
}

void FieldWidget3D::drawField(vtkRenderer* renderer)
{
    // Draw plane
    vtkSmartPointer<vtkPlaneSource> planeSrc = vtkSmartPointer<vtkPlaneSource>::New();
    planeSrc->SetOrigin(0,0,0);
    planeSrc->SetPoint1(+_FIELD_WIDTH + 2.0,0,0);
    planeSrc->SetPoint2(0,_FIELD_LENGTH + 2.0,0);
    vtkSmartPointer<vtkPolyDataMapper> planeMapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    planeMapper->SetInput(planeSrc->GetOutput());
    this->field = vtkActor::New();
    this->field->SetMapper(planeMapper);
    this->field->GetProperty()->SetColor(0.278,0.64,0.196);
    this->field->SetPosition(-_FIELD_WIDTH/2 - 1.0, -_FIELD_LENGTH/2 - 1.0, -0.02);
    this->field->GetProperty()->SetAmbient(1);
    this->field->GetProperty()->SetDiffuse(0);
    this->field->GetProperty()->SetSpecular(0);
    renderer->AddActor(field);

    // Draw Field
    renderer->AddActor(createLine(-_FIELD_WIDTH/2, 0.0, 0.0, _FIELD_WIDTH/2, 0.0, 0.0));
    renderer->AddActor(createLine(-_FIELD_WIDTH/2, -_FIELD_LENGTH/2, 0.0, -_FIELD_WIDTH/2, _FIELD_LENGTH/2, 0.0));
    renderer->AddActor(createLine(_FIELD_WIDTH/2, -_FIELD_LENGTH/2, 0.0, _FIELD_WIDTH/2, _FIELD_LENGTH/2, 0.0));
    renderer->AddActor(createLine(-_FIELD_WIDTH/2, _FIELD_LENGTH/2, 0.0, _FIELD_WIDTH/2, _FIELD_LENGTH/2, 0.0));
    renderer->AddActor(createLine(-_FIELD_WIDTH/2, -_FIELD_LENGTH/2, 0.0, _FIELD_WIDTH/2, -_FIELD_LENGTH/2, 0.0));

    // Goal Areas
    renderer->AddActor(createLine(-_GOAL_AREA_WIDTH/2, -_FIELD_LENGTH/2 + _GOAL_AREA_LENGTH, 0.0, _GOAL_AREA_WIDTH/2, -_FIELD_LENGTH/2 + _GOAL_AREA_LENGTH, 0.0));
    renderer->AddActor(createLine(-_GOAL_AREA_WIDTH/2, -_FIELD_LENGTH/2, 0.0, -_GOAL_AREA_WIDTH/2, -_FIELD_LENGTH/2 + _GOAL_AREA_LENGTH, 0.0));
    renderer->AddActor(createLine(_GOAL_AREA_WIDTH/2, -_FIELD_LENGTH/2, 0.0, _GOAL_AREA_WIDTH/2, -_FIELD_LENGTH/2 + _GOAL_AREA_LENGTH, 0.0));
    renderer->AddActor(createLine(-_GOAL_AREA_WIDTH/2, _FIELD_LENGTH/2 - _GOAL_AREA_LENGTH, 0.0, _GOAL_AREA_WIDTH/2, _FIELD_LENGTH/2 - _GOAL_AREA_LENGTH, 0.0));
    renderer->AddActor(createLine(-_GOAL_AREA_WIDTH/2, _FIELD_LENGTH/2, 0.0, -_GOAL_AREA_WIDTH/2, _FIELD_LENGTH/2 - _GOAL_AREA_LENGTH, 0.0));
    renderer->AddActor(createLine(_GOAL_AREA_WIDTH/2, _FIELD_LENGTH/2, 0.0, _GOAL_AREA_WIDTH/2, _FIELD_LENGTH/2 - _GOAL_AREA_LENGTH, 0.0));

    // Penalty Areas
    renderer->AddActor(createLine(-_PENALTY_AREA_WIDTH/2, -_FIELD_LENGTH/2 + _PENALTY_AREA_LENGTH, 0.0,
                                  _PENALTY_AREA_WIDTH/2, -_FIELD_LENGTH/2 + _PENALTY_AREA_LENGTH, 0.0));
    renderer->AddActor(createLine(-_PENALTY_AREA_WIDTH/2, -_FIELD_LENGTH/2, 0.0,
                                  -_PENALTY_AREA_WIDTH/2, -_FIELD_LENGTH/2 + _PENALTY_AREA_LENGTH, 0.0));
    renderer->AddActor(createLine(_PENALTY_AREA_WIDTH/2, -_FIELD_LENGTH/2, 0.0,
                                  _PENALTY_AREA_WIDTH/2, -_FIELD_LENGTH/2 + _PENALTY_AREA_LENGTH, 0.0));
    renderer->AddActor(createLine(-_PENALTY_AREA_WIDTH/2, _FIELD_LENGTH/2 - _PENALTY_AREA_LENGTH, 0.0,
                                  _PENALTY_AREA_WIDTH/2, _FIELD_LENGTH/2 - _PENALTY_AREA_LENGTH, 0.0));
    renderer->AddActor(createLine(-_PENALTY_AREA_WIDTH/2, _FIELD_LENGTH/2, 0.0,
                                  -_PENALTY_AREA_WIDTH/2, _FIELD_LENGTH/2 - _PENALTY_AREA_LENGTH, 0.0));
    renderer->AddActor(createLine(_PENALTY_AREA_WIDTH/2, _FIELD_LENGTH/2, 0.0,
                                  _PENALTY_AREA_WIDTH/2, _FIELD_LENGTH/2 - _PENALTY_AREA_LENGTH, 0.0));

    // Corner Circles
    addArc(renderer, _FIELD_WIDTH/2, _FIELD_LENGTH/2, _CORNER_CIRCLE_RADIUS, 180, 270);
    addArc(renderer, -_FIELD_WIDTH/2, _FIELD_LENGTH/2, _CORNER_CIRCLE_RADIUS, 270, 360);
    addArc(renderer, -_FIELD_WIDTH/2, -_FIELD_LENGTH/2, _CORNER_CIRCLE_RADIUS, 0, 90);
    addArc(renderer, _FIELD_WIDTH/2, -_FIELD_LENGTH/2, _CORNER_CIRCLE_RADIUS, 90, 180);

    // Center Circle
    addArc(renderer, 0, 0, _CENTER_CIRCLE_RADIUS, 0, 360);

    // Black Dots
    createDot(renderer, _FIELD_WIDTH/4, 0, true);
    createDot(renderer, -_FIELD_WIDTH/4, 0, true);

    createDot(renderer, _FIELD_WIDTH/4, _FIELD_LENGTH/2 - _PENALTY_MARK_DISTANCE, true);
    createDot(renderer, -_FIELD_WIDTH/4, _FIELD_LENGTH/2 - _PENALTY_MARK_DISTANCE, true);
    createDot(renderer, 0, _FIELD_LENGTH/2 - _PENALTY_MARK_DISTANCE, false);

    createDot(renderer, _FIELD_WIDTH/4, -_FIELD_LENGTH/2 + _PENALTY_MARK_DISTANCE, true);
    createDot(renderer, -_FIELD_WIDTH/4, -_FIELD_LENGTH/2 + _PENALTY_MARK_DISTANCE, true);
    createDot(renderer, 0, -_FIELD_LENGTH/2 + _PENALTY_MARK_DISTANCE, false);

    createDot(renderer, 0, 0, false, 0.1);

    renderer->AddActor(createLine(_PENALTY_AREA_WIDTH/2, _FIELD_LENGTH/2, 0.0,
                                  _PENALTY_AREA_WIDTH/2, _FIELD_LENGTH/2 - _PENALTY_AREA_LENGTH, 0.0));
}

void FieldWidget3D::createDot(vtkRenderer* renderer, float x, float y, bool black, float radius)
{
    vtkSmartPointer<vtkCylinderSource> dot = vtkSmartPointer<vtkCylinderSource>::New();
    dot->SetRadius(radius);
    dot->SetHeight(0.001);
    dot->SetResolution(32);
    vtkSmartPointer<vtkPolyDataMapper> dotMapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    dotMapper->SetInput(dot->GetOutput());

    vtkSmartPointer<vtkActor> blackDot1 = vtkSmartPointer<vtkActor>::New();
    blackDot1->SetMapper(dotMapper);

    if(black)
        blackDot1->GetProperty()->SetColor(0,0,0);
    else
        blackDot1->GetProperty()->SetColor(1,1,1);

    blackDot1->SetPosition(x , y , 0.01);
    blackDot1->SetOrientation(90,0,0);
    blackDot1->GetProperty()->SetAmbient(1.0);
    renderer->AddActor(blackDot1);
}


void FieldWidget3D::initBalls(vtkRenderer* renderer)
{
    vtkSmartPointer<vtkSphereSource> sphereSrc = vtkSmartPointer<vtkSphereSource>::New();
    sphereSrc->SetRadius(0.11);
    vtkSmartPointer<vtkPolyDataMapper> sphereMapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    sphereMapper->SetInput(sphereSrc->GetOutput());

    ball_teamA = vtkActor::New();
    ball_teamA->SetMapper(sphereMapper);
    renderer->AddActor(ball_teamA);

    ball_teamA->GetProperty()->SetRepresentationToSurface();
    ball_teamA->GetProperty()->SetColor(robotsColorR[0],robotsColorG[0],robotsColorB[0]);
    ball_teamA->SetPosition(100.0,100.0,0.0);


    ball_teamB = vtkActor::New();
    ball_teamB->SetMapper(sphereMapper);
    renderer->AddActor(ball_teamB);

    ball_teamB->GetProperty()->SetRepresentationToSurface();
    ball_teamB->GetProperty()->SetColor(robotsColorR[1],robotsColorG[1],robotsColorB[1]);
    ball_teamB->SetPosition(100.0,100.0,0.0);
}

void FieldWidget3D::drawRobots(vtkActor** actor_array, Team* team)
{
    int r,g,b;
    team->color.getRgb(&r, &g, &b);

    float inv = 1.0;
    float addAngle = 180;

    if(team == &tB)
    {
        inv = -1.0;
        addAngle = 0.0;
    }

    for (unsigned int i = 0; i < NROBOTS; i++)
    {
        if(i < team->world.robots.size())
        {
            actor_array[i]->SetPosition(inv*team->world.robots[i].pos.x(), inv*team->world.robots[i].pos.y(), 0.02f);
            actor_array[i]->SetOrientation(0,0,team->world.robots[i].oriDeg + addAngle);
            actor_array[i]->GetProperty()->SetOpacity(1.0);
            actor_array[i]->GetProperty()->SetColor(r/255.0, g/255.0, b/255.0);
        }else{
            //actor_array[i]->SetPosition(2015, 2015, 0.0f);
            actor_array[i]->GetProperty()->SetOpacity(0.0);
        }
    }
}

vtkActor* FieldWidget3D::createText(QString text){
    vtkActor* actor = vtkActor::New();
    vtkSmartPointer<vtkVectorText> txt = vtkSmartPointer<vtkVectorText>::New();
    txt->SetText(text.toStdString().c_str());
    vtkSmartPointer<vtkPolyDataMapper> txtRobotMapper = vtkSmartPointer<vtkPolyDataMapper>::New();
    txtRobotMapper->SetInput(txt->GetOutput());
    actor->SetMapper(txtRobotMapper);
    actor->GetProperty()->SetColor(0.0,0.0,0.0);
    actor->GetProperty()->SetAmbient(1.0);
    actor->SetOrientation(0,0,90);
    return actor;
}

bool FieldWidget3D::canOverlay()
{
    return true;
}

void FieldWidget3D::refresh()
{
    //fprintf(stderr,"REFRESH\n");

    int width = renderWindow->GetSize()[0];
    int height = renderWindow->GetSize()[1];

    // Remove all actors that need to be deleted
    for(unsigned int i = 0; i < toDeleteActors.size(); i++)
    {
        renderer->RemoveActor(toDeleteActors.at(i));
        toDeleteActors.at(i)->Delete();
    }
    toDeleteActors.clear();

    // Set ball position
    ball_teamA->SetPosition(tA.world.ballPos.x(), tA.world.ballPos.y(), 0.11);
    ball_teamB->SetPosition(tB.world.ballPos.x(), tB.world.ballPos.y(), 0.11);

    // Show Robots
    drawRobots(robots_teamA, &tA);
    drawRobots(robots_teamB, &tB);

    int msecs = textOverlay_startTime.elapsed();

    if(textOverlay_en)
    {
        if(msecs < textOverlay_totalTimeMs)
        {
            float opacity = 0.0;
            if(msecs < textOverlay_fadeInMs)
            {
                opacity = msecs/textOverlay_fadeInMs;
            }else if(msecs < textOverlay_fadeInMs + textOverlay_HoldMs)
            {
                opacity = 1.0;
            }else if(msecs < textOverlay_totalTimeMs)
            {
                opacity = 1.0 - (msecs - textOverlay_fadeInMs - textOverlay_HoldMs)/textOverlay_fadeOutMs;
            }

            textOverlay_actor->GetPositionCoordinate()->SetCoordinateSystemToNormalizedViewport();
            textOverlay_actor->SetPosition(0.5,0.2);
            textOverlay_actor->GetProperty()->SetOpacity(opacity);

            // Fade out background
            opacity *= 0.5;
            renderer->SetAmbient(1.0 - opacity, 1.0 - opacity, 1.0 - opacity);

        }else{
            textOverlay_en = false;
            textOverlay_actor->GetProperty()->SetOpacity(0.0);
            renderer->SetAmbient(1.0, 1.0, 1.0);
        }

    }else{
        textOverlay_actor->GetProperty()->SetOpacity(0.0);
    }

    if(!renderWindow->CheckInRenderStatus())
        renderWindow->Render();
}
