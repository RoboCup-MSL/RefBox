#!/usr/bin/env python
# 2016-11-29 Jan Feitsma - creation
#
# Description: based on a MSL match log, calculate match statistics.
# 


import sys,os
import numpy
from math import sqrt

class MatchStatistics():
    def __init__(self, matchlog):
        self._matchlog = matchlog
        self.kpi = {}
        self.calculateAll()

    def calculateAll(self):
        for team in [0, 1]:
            # team KPI's
            #self.kpiPassSuccessRate(team)
            # robot KPI's
            for robot in range(6):
                robotId = robot+1
                #self.kpiStationaryStability(team, robotId)
                self.kpiRobotDistance(team, robotId)
        # TODO instead of going multiple times through the data, do it once and call all processors
        
    def __str__(self):
        s = "KPI's:\n"
        for key in sorted(self.kpi.keys()):
            s += "%s = %s\n" % (key, str(self.kpi[key]))
        return s
        
    def kpiPassSuccessRate(self, team):
        t = self._matchlog.tStart
        dt = 1.0
        numPassTotal = 0
        numPassSuccess = 0
        numPassFail = 0
        while True:
            # get data from buffer
            data = self._matchlog.buffer
            # TODO implement pass detection logic
            
            
            # check for end of matchlog
            t += dt
            if t > self._matchlog.tEnd:
                break
            # advance
            self._matchlog.advance(t)
        # wrap up
        self.kpi["T%s_NUM_PASS_TOTAL" % (team)] = numPassTotal
        self.kpi["T%s_NUM_PASS_SUCCESS" % (team)] = numPassSuccess
        self.kpi["T%s_NUM_PASS_FAIL" % (team)] = numPassFail
    
    def kpiRobotDistance(self, team, robotId):
        t = 0
        dt = 1.0
        lastX = None
        lastY = None
        totalDistance = 0.0
        while True:
            # get data from buffer
            data = self._matchlog.buffer
            if data != None:
                for robot in data[team]['worldstate']['robots']:
                    if robot['id'] == robotId:
                        x = robot['pose'][0]
                        y = robot['pose'][1]
                        if lastX != None:
                            dr = sqrt((x-lastX)*(x-lastX) + (y-lastY)*(y-lastY))
                            totalDistance += dr
                        lastX = x
                        lastY = y
            # check for end of matchlog
            t += dt
            if t > self._matchlog.tElapsed:
                break
            # advance
            self._matchlog.advance(t)
        # wrap up
        self.kpi["T%sR%s_DISTANCE" % (str(team), str(robotId))] = totalDistance

    def kpiStationaryStability(self, team, robot):
        t = self._matchlog.tStart
        dt = 0.15
        lastRefbox = None
        xAll = []
        yAll = []
        x = []
        y = []
        stationary = False
        # TODO: make sure we do not report 0 noise while robot is not updating itself
        while True:
            # get data from buffer
            data = self._matchlog.buffer
            if data != None:
                print "debug KPI data"
                print data
                refboxCommand = ""
                # start/stop measuring?
                if refboxCommand != lastRefbox:
                    # new command
                    if refboxCommand == "STOP":
                        stationary = True
                    else:
                        stationary = False
                        # calculate and finish this buffer:
                        # * subtract average position, so noise remains
                        # * store the remainder so we can calculate standarddeviation at the end
                        xMean = numpy.mean(x)
                        yMean = numpy.mean(y)
                        x -= xMean
                        y -= yMean
                        xAll += x
                        yAll += y
                        x = []
                        y = []
                    lastRefboxCommand = refboxCommand
                # measuring
                if stationary:
                    x.append(data.team[team].robot[robot].x)
                    y.append(data.team[team].robot[robot].y)
            # check for end of matchlog
            t += dt
            if t > self._matchlog.tEnd:
                break
            # advance
            self._matchlog.advance(t)
        # wrap up
        self.kpi["T%sR%s_POS_STAB_X" % (team, robot)] = numpy.std(xAll)
        self.kpi["T%sR%s_POS_STAB_Y" % (team, robot)] = numpy.std(yAll)
        


