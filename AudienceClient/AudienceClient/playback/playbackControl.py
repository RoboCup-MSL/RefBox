#!/usr/bin/env python
# 2016-11-29 Jan Feitsma - creation based on Falcons repository
#
# Description: part of playbackMatchlog: little window with sliders and buttons
# Requires pygame and pgu library.
#
# 


import sys,os
import signal
import pygame
from pygame.locals import *
from pgu import gui


class PlaybackControl(gui.Table):
    def __init__(self, tStart, tEnd, tElapsed, **params):
        gui.Table.__init__(self, **params)
        self.speed = 1.0
        self.t = 0.0
        self.paused = False
        def cb_slider_changed(slider):
            self.t = slider.value
        def cb_faster():
            self.speed *= 2.0
        def cb_slower():
            self.speed /= 2.0
        def cb_pause():
            self.paused = True
        def cb_play():
            self.paused = False
        fg = (255,255,255)
        self.tr()
        # first row of buttons: 
        #   - pause       ||
        #   - resume      >
        #   - slow down   <<
        #   - speedup     >>
        #   - time slider 
        btn = gui.Button("||")
        btn.connect(gui.CLICK, cb_pause)
        self.td(btn)
        btn = gui.Button(">")
        btn.connect(gui.CLICK, cb_play)
        self.td(btn)
        btn = gui.Button("<<")
        btn.connect(gui.CLICK, cb_slower)
        self.td(btn)
        btn = gui.Button(">>")
        btn.connect(gui.CLICK, cb_faster)
        self.td(btn)
        self.td(gui.Label(""))
        self.td(gui.Label(""))
        self.td(gui.Label(""))
        self.timeslider = gui.HSlider(0.0, 0.0, tElapsed, size=20, width=400, height=16, name='time', colspan=15)
        self.timeslider.connect(gui.CHANGE, cb_slider_changed, self.timeslider)
        self.td(self.timeslider)
        self.app = gui.App()
        self.app.init(self)

    def run(self):
        self.app.connect(gui.QUIT,self.app.quit,None)
        self.app.run()
        
    def quit(self):
        self.app.quit()

    def updateTime(self, dt):
        if not self.paused:
            self.t += self.speed * dt
            self.timeslider.value = self.t
        return self.t


