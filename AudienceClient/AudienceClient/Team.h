#ifndef TEAM_H
#define TEAM_H

#include <QString>
#include <QColor>
#include <QList>
#include <QVector3D>

#include <QVariantMap>

class RobotWS
{
public:
    RobotWS()
    {
        id = -1;
    }

    RobotWS(int id, QVector3D pos, QVector3D vel, float oriRad)
    {
        this->id = id;
        this->pos = pos;
        this->vel = vel;
        this->oriDeg = oriRad*180/M_PI;
    }

    int id;
    QVector3D pos;
    QVector3D vel;
    float oriDeg;
};

class TeamWS
{
private:
    QVector3D json2vec(QVariant elem)
    {
        QVector3D vec;
        QList<QVariant> elemList = elem.toList();
        if(elemList.size() == 3)
        {
            vec.setX(elemList[0].toFloat());
            vec.setY(elemList[1].toFloat());
            vec.setZ(elemList[2].toFloat());
        }else if(elemList.size() == 2)
        {
            vec.setX(elemList[0].toFloat());
            vec.setY(elemList[1].toFloat());
            vec.setZ(0.0);
        }
        return vec;
    }

public:
    TeamWS()
    {
        ballConfidence = 0.0;
    }

    void update(QVariantMap ws)
    {

        // Ball

        QList<QVariant> ballsArray = ws["balls"].toList();

        if(ballsArray.size() > 0)
        {
            QVariantMap ballMap = ballsArray.at(0).toMap();
            ballPos = json2vec(ballMap["position"]);
            ballVel = json2vec(ballMap["velocity"]);
            ballConfidence = ballMap["confidence"].toFloat();
        }else{
            ballPos.setX(2015);
            ballPos.setY(2015);
            ballConfidence = 0.0f;
        }

        // Robots
        robots.clear();
        QList<QVariant> robList = ws["robots"].toList();
        foreach(QVariant rob, robList)
        {

            QVariantMap r = rob.toMap();

            int id = r["id"].toInt();
            QVector3D pose = json2vec(r["pose"]);
            QVector3D position(pose.x(),pose.y(),0.0);
            float orientation = pose.z();
            QVector3D velocity = json2vec(r["velocity"]);
            velocity.setZ(0.0);

            robots.append(RobotWS(id, position, velocity, orientation));

            /*fprintf(stderr,"ROBOT pos %.2f %.2f vel %.2f %.2f ori %.2f\n", json2vec(r["position"]).x(), json2vec(r["position"]).y(), json2vec(r["velocityLin"]).x(), json2vec(r["velocityLin"]).y()
                    ,r["orientation"].toFloat()
                    );*/
        }
    }

    QVector3D ballPos;
    QVector3D ballVel;
    float ballConfidence;
    QList<RobotWS> robots;
};

class Team
{
public:
    Team()
    {
        longName = QString("_");
        shortName = QString("_");
        score = 0;

        color = QColor::fromRgb(0,0,0);
    }

    void update(QVariantMap team_map)
    {
        longName = team_map["longName"].toString();
        shortName = team_map["shortName"].toString();

        score = team_map["score"].toInt();
        color = QColor(QString("#") + team_map["color"].toString());

        robotState.clear();
        foreach (QVariant state, team_map["robotState"].toList()) {
            robotState.append(state.toString());
        }

        robotWaitTime.clear();
        foreach (QVariant waitTime, team_map["robotWaitTime"].toList()) {
            robotWaitTime.append(waitTime.toInt());
        }

        // Team worldstate update
        world.update(team_map["worldState"].toMap());
    }

    QString longName;
    QString shortName;
    int score;

    QColor color;

    QList<QString> robotState;
    QList<int> robotWaitTime;

    TeamWS world;
};

#endif // TEAM_H
