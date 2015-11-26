/*
 * packetStructureRefboxLogger.hpp
 *
 *  Created on: Nov 24, 2015
 *      Author: Tim Kouters
 */

#ifndef PACKETSTRUCTUREREFBOXLOGGER_HPP_
#define PACKETSTRUCTUREREFBOXLOGGER_HPP_

#include <cstdio>
#include <stdint.h>
#include <vector>

#include "position2d.hpp"
#include "vector2d.hpp"
#include "vector3d.hpp"

namespace packetRefboxLogger
{
    typedef struct
    {
    	uint8_t     robotId;
		Position2D  pose;
		Position2D  velocity;
		Position2D  targetPose;
		std::string intention;
		float       batteryLevel;
		bool        hasBall;
    } robotStructure;
    typedef std::vector<robotStructure> robotList;

    typedef struct
    {
    	Vector3D position;
    	Vector3D velocity;
        float    confidence;
    } ballStructure;
    typedef std::vector<ballStructure> ballList;

    typedef struct
    {
    	Vector2D position;
    	Vector2D velocity;
    	float    radius;
    	float    confidence;
    } obstacleStructure;
    typedef std::vector<obstacleStructure> obstacleList;

    typedef struct
    {
    	std::string type;
    	std::string teamName;
    	std::string globalIntention;
    	robotList robots;
    	ballList balls;
    	obstacleList obstacles;
    	size_t age;
    } packetStructureDeserialized;
}

#endif /* PACKETSTRUCTUREREFBOXLOGGER_HPP_ */
