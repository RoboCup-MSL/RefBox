#!/usr/bin/env python
# 2016-11-29 Jan Feitsma
#
# Description: visualize a MSL log file.
#  * spawn a small playbackControl window, which provides a slider and a few buttons to browse
#  * setup port connection to AudienceClient
#  * send data in playback mode to AudienceClient
#
# 


import sys,os,time
import argparse
import threading
import traceback
from playbackControl import PlaybackControl
from matchlog import MatchLogPublisher
from matchStatistics import MatchStatistics


# globals
gPbCtrl = None
gPbGuiTr = None



def cleanup():
    if gPbCtrl != None:
        gPbCtrl.quit()


if __name__ == '__main__':
    # Argument parsing.
    parser     = argparse.ArgumentParser(description='MSL log viewer')
    parser.add_argument('zipfile', help='zip file of the log', nargs='?', default=None)
    parser.add_argument('-s', '--statsonly', help='only statistics', action='store_true')

    args       = parser.parse_args()

    try:

        # Construct MatchLog object 
        matchlog   = MatchLogPublisher(args.zipfile)
        tStart     = matchlog.tStart
        tEnd       = matchlog.tEnd
        tElapsed   = matchlog.tElapsed
        # Override options - TODO


        # Calculate match statistics from matchlog
        try:
            print "calculating statistics ..."
            statistics = MatchStatistics(matchlog)
            print statistics
        except:
            print "statistics error:", sys.exc_info()[0]
            print traceback.format_exc()
            pass
        
        # Stop if statsonly option is used
        if not args.statsonly:
        
            # Construct the playback window and run its GUI loop in a dedicated thread
            gPbCtrl    = PlaybackControl(tStart, tEnd, tElapsed)
            gPbGuiTr   = threading.Thread(target=gPbCtrl.run)
            gPbGuiTr.start()
            
            # Run the matchlog data handler loop to start publishing
            matchlog.run(gPbCtrl)

        
    except:
        print "Unexpected error:", sys.exc_info()[0]
        print traceback.format_exc()
        cleanup()
        raise

    # All went well - cleanup
    cleanup()



