#!/usr/bin/env python
# 2016-11-29 Jan Feitsma - creation
#
# Description: based on a MSL match log, calculate match statistics.
# 


import sys,os
import numpy
from math import sqrt


# auxiliary
def timeStr(t):
    return "%02d:%02d" % (int(t / 60), int(t) % 60)
           
                
class MatchStatistics():
    def __init__(self, matchlog):
        self._matchlog = matchlog
        self.kpi = {}
        self.calculateAll()
        # determine teamnames
        self._matchlog.advance(self._matchlog.tElapsed-1)
        self.teamnames = []
        self.teamnames.append(self._matchlog.buffer[0]['worldstate']['teamName'])
        self.teamnames.append(self._matchlog.buffer[1]['worldstate']['teamName'])

    def calculateAll(self):
        for team in [0, 1]:
            # team KPI's
            self.kpiPassSuccessRate(team)
            # robot KPI's
            for robot in range(6):
                robotId = robot+1
                #self.kpiStationaryStability(team, robotId)
                self.kpiRobotDistance(team, robotId)
        # TODO instead of going multiple times through the data, do it once and call all processors? this could save on the amount of calls to binary search
        
    def __str__(self):
        s = "KPI's:\n"
        for key in sorted(self.kpi.keys()):
            # show teamname
            mkey = key.replace("T0", self.teamnames[0]).replace("T1", self.teamnames[1])
            s += "%s = %s\n" % (mkey, str(self.kpi[key]))
        return s
        
    def kpiPassSuccessRate(self, team):
        """
        Count attempted passes and success ratio.
        """
        t = 0.0
        dt = 0.5
        passTimeLimit = 5.0
        passTimeStart = 0
        numPassTotal = 0
        numPassSuccess = 0
        numSelfPass = 0
        numPassFail = 0
        lastBallPossession = None # may be own robot ID
        lastBallPass = None
        # TODO: use ball trajectory and direction
        # TODO: the logging protocol will be extended to make this calculation much easier (robot intentions)
        while True:
            # get data from buffer
            data = self._matchlog.buffer
            if data != None:
                # check if we are performing a pass - inspect ball posession transitions
                currentBallPossession = None
                for robot in data[team]['worldstate']['robots']:
                    if robot['ballEngaged'] != 0:
                        currentBallPossession = (robot['id'], robot['pose'][0], robot['pose'][1])
                        break
                if lastBallPossession != None and currentBallPossession == None:
                    # losing ball, start timer
                    print "%s robot %d of team %d lost the ball" % (timeStr(t), lastBallPossession[0], team)
                    passTimeStart = t
                    lastBallPass = lastBallPossession
                elif lastBallPossession == None and currentBallPossession != None:
                    print "%s robot %d of team %d obtained the ball" % (timeStr(t), currentBallPossession[0], team)
                    # obtained ball, check timer if this would count as a pass
                    if lastBallPass != None and t - passTimeStart < passTimeLimit:
                        # count self-passes
                        passType = "regular"
                        if lastBallPass[0] == currentBallPossession[0]:
                            passType = "self"
                        distance = sqrt((currentBallPossession[1]-lastBallPass[1])**2 + (currentBallPossession[2]-lastBallPass[2])**2)
                        if passType == "self":
                            numSelfPass += 1
                            # TODO self-pass is a bit glitchy - require a minimum time/distance?
                            print "%s successful self-pass from robot %d over %4.1fm" % (timeStr(t), currentBallPossession[0], distance)
                        else:
                            numPassSuccess += 1
                            print "%s successful regular pass from robot %d to robot %d over %4.1fm" % (timeStr(t), lastBallPass[0], currentBallPossession[0], distance)
                lastBallPossession = currentBallPossession
                    
            # check for end of matchlog
            t += dt
            if t > self._matchlog.tElapsed:
                break
            # advance
            self._matchlog.advance(t)
        # wrap up
        #self.kpi["T%s_NUM_PASS_TOTAL" % (str(team))] = numPassTotal
        self.kpi["T%s_NUM_PASS_SUCCESS" % (str(team))] = numPassSuccess
        self.kpi["T%s_NUM_SELF_PASS" % (str(team))] = numSelfPass
        #self.kpi["T%s_NUM_PASS_FAIL" % (str(team))] = numPassFail
    
    def kpiRobotDistance(self, team, robotId):
        t = 0
        dt = 1.0 # not too fast, to suppress positioning noise
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
        self.kpi["T%s_R%s_DISTANCE" % (str(team), str(robotId))] = totalDistance

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
        


