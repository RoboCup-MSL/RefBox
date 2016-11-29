#!/usr/bin/env python
# 2016-11-29 Jan Feitsma
#
# Description: load a MSL log file in memory and browse through it.
# TODO statistics



import subprocess
import time,datetime
import rospy # only for rate/sleep
from inspect import isfunction
from collections import defaultdict
import traceback
import socket


class MatchLogPublisher():
    """
    This class can load a MSL zip file and stimulate AudienceClient.
    It needs a playback object to control time, speed and offset (slider etc).
    """
    def __init__(self, zipfile):
        # initialize self
        self.frequency = 20.0
        # load the bag file
        self.loadZipFile(zipfile)
        # setup port connection
        self.host(self)
        # init buffer
        self.buffer = ''
        # connection
        self.conn = None
        self.addr = None

    def __del__(self):
        #disconnect port connection
        self.disconnect(self)
        
    def host(self):
        HOST = ''
        PORT = 12345
        self.s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.s.bind((HOST, PORT))
        self.s.listen(1)
        self.conn, self.addr = self.s.accept()

    def disconnect(self):
        self.conn.close()

    def loadZipFile(self, zipfile):
        # TODO: reimplement, this does not yet work
        print "TODO load " + zipfile
        
        # self.data is an array of tuples (t1, topic, msg, t2), where
        #  * t1 is a posix timestamp (float), e.g. 1437281188.41
        #  * topic the topic on which the message was received
        #  * msg the message data struct
        #  * t2 a datetime converted time object (for display)
        print "loading bagfile ", bagfile
        # load all at once, can take a few seconds though
        bag = rosbag.Bag(bagfile)
        self.data = []
        first = True
        prev = 0
        for topic, msg, t in bag.read_messages():
            if first:
                self.t0 = t.to_time()
                first = False
            t1 = t.to_time()
            assert(t1 >= prev) # check that the data stream is ordered in time
            t2 = datetime.datetime.fromtimestamp(t1)
            self.data.append((t1, topic, msg, t2))
            prev = t1
        self.tElapsed = t1 - self.t0
        self.tStart = self.data[0][0]
        self.tEnd = self.data[-1][0]
        print "done"
        print "  t_start:", str(self.data[0][3])
        print "  t_end  :", str(t2)
        print "  elapsed: %6.2f" % (self.tElapsed)
        self.pointer = 0

    def advance(self, t):
        """
        Advance to given timestamp (relative).
        """
        # translate relative to absolute time
        t = t + self.t0
        # dumb lookup to find latest message just before t
        # invariant: pointer is a valid index and data is not empty
        tpoint = self.data[self.pointer][0]
        if t < tpoint:
            # rewind to zero
            self.pointer = 0
            tpoint = self.data[self.pointer][0]
            self.buffer = ''
        while t > tpoint:
            if t - tpoint < 1.0:
                self.buffer[self.data[self.pointer][1]] = self.data[self.pointer][2]
            # advance until tpoint is just larger than t
            self.pointer += 1
            if self.pointer > len(self.data) - 1:
                self.pointer = len(self.data) - 1
                break
            tpoint = self.data[self.pointer][0]
        # one step back, make sure it is within bounds
        if self.pointer > 0:
            self.pointer -= 1
        if self.pointer > len(self.data) - 1:
            self.pointer = len(self.data) - 1
        # process buffer and clear it
        self.processBuffer()

    def run(self, playback):
        done = False
        rate = rospy.Rate(self.frequency)
        dt = 1.0 / self.frequency
        self.host(self)
        while not done:
            # get timestamp from playback
            t = playback.updateTime(dt)
            # advance and publish
            self.advance(t)
            # send msg buffer
            self.conn.sendall(self.buffer) 
            # sleep
            rate.sleep()
            if rospy.is_shutdown():
                done = True
            if t > self.tElapsed:
                done = True
            



