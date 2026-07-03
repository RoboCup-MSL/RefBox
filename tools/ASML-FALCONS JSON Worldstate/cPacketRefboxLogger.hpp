/*
 * cPacketRefboxLogger.hpp
 *
 *  Created on: Nov 24, 2015
 *      Author: Tim Kouters
 */

#ifndef CPACKETREFBOXLOGGER_HPP_
#define CPACKETREFBOXLOGGER_HPP_

#include <stddef.h>
#include <string>
#include <json-c/json.h>

#include "position2d.hpp"
#include "vector2d.hpp"
#include "vector3d.hpp"

#include "packetStructureRefboxLogger.hpp"

namespace packetRefboxLogger
{
    class cPacketRefboxLogger
    {
        public:
    		cPacketRefboxLogger();
            ~cPacketRefboxLogger();

            size_t getSize();

            void getSerialized(std::string &packet);

            /*
             * Team level setters
             */
            void setType(const std::string type);
            void setTeamIntention(const std::string intention);

            /*
             * Robot level setters
             */
            void setRobotPose(const uint8_t robotId, const Position2D pose);
            void setRobotTargetPose(const uint8_t robotId, const Position2D targetPose);
            void setRobotVelocity(const uint8_t robotId, const Position2D velocity);
            void setRobotIntention(const uint8_t robotId, const std::string intention);
            void setRobotBatteryLevel(const uint8_t robotId, const float level);
            void setRobotBallPossession(const uint8_t robotId, const bool hasBall);

            /*
             * Ball setters
             */
            void addBall(const Vector3D position, const Vector3D velocity, const float confidence);

            /*
             * Obstacle setters
             */
            void addObstacle(const Vector2D position, const Vector2D velocity, const float confidence);

            /*
             * Global setters
             */
            void setAgeMilliseconds(const size_t age);

        private:
            packetStructureDeserialized _mPacket;
            json_object *_jsonObject;

            /* Robot functions */
            void isRobotPresent(const uint8_t robotId, bool &isPresent, size_t &index);
            void addRobot(const uint8_t);

            /* JSON functions */
            void cleanupJSONObject();
            void generateJSON();
            void addRobotsJSON(json_object *obj);
            void addBallsJSON(json_object *obj);
            void addObstaclesJSON(json_object *obj);
};
}

#endif /* CPACKETREFBOXLOGGER_HPP_ */
