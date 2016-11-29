#!/usr/bin/env python
# 2016-11-29 Jan Feitsma
#
# Description: load a MSL log file in memory and browse through it.
# TODO statistics



import subprocess
import time,datetime
from inspect import isfunction
from collections import defaultdict
import traceback
from pygame import time
import json
from zipfile import ZipFile
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
        self.setupPorts()

    def setupPorts(self):
        # TODO implement
        pass

    def processBuffer(self):
        """
        Send the contents of buffer over the port.
        """
        for (k,v) in self.buffer.items():
            # process the message
            try:
                # TODO process the data element
                pass
            except:
                print "something went wrong when executing callback for topic %s, message follows" % k
                print v
                traceback.print_exc()
                pass
        self.buffer = {}
        self.host(self)
        # init buffer
        self.buffer = ''
        # connection

    def host(self):
        HOST = ''
        PORT = 12345
        self.s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.s.bind((HOST, PORT))
        self.s.listen(1)
        conn,addr = self.s.accept()
        return conn,addr

    def loadZipFile(self, zipfile):
        print "Loading {0}...".format(zipfile)

        with ZipFile(zipfile, 'r') as mslzip:
            files = mslzip.filelist

            # find files and parse json
            for f in files:
                if f.filename.endswith(".A.msl"):
                    json_a = json.loads(mslzip.read(f.filename).encode("utf-8"))
                elif f.filename.endswith(".B.msl"):
                    json_b = json.loads(mslzip.read(f.filename).encode("utf-8"))

        if json_a != None:
            self.data_a, self.meta_a = self.createData(json_a)
            print "Team A loaded, meta:", self.meta_a

        if json_b != None:
            self.data_b, self.meta_b = self.createData(json_b)
            print "Team B loaded, meta:", self.meta_b

    def createData(dataself, json_data):
        data = meta = {}
        first = True

        for entry in json_data:
            time = long(entry['timestamp'])
            if first:
                tStart = time
                tEnd = time
                first = False
            else:
                tStart = min(tStart, time)
                tEnd = max(tEnd, time)

        meta['tElapsed'] = tEnd - tStart
        meta['tStart'] = tStart
        meta['tEnd'] = tEnd

        return (data, meta)

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

    def run(self, playback):
        done = False

        dt = 1.0 / self.frequency
        conn, addr = self.host()
        while not done:
            # get timestamp from playback
            t = playback.updateTime(dt)
            # advance and publish
            self.advance(t)
            # send msg buffer
            self.conn.sendall(self.buffer)
            # sleep
            time.Clock.tick_busy_loop(self.frequency)
            if rospy.is_shutdown():
                done = True
            if t > self.tElapsed:
                done = True

        conn.close()
