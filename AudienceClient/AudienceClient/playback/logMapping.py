import datetime

def MSLLog2AudienceClientLog(logEntryTeamA, logEntryTeamB):
    output = {}

    output["type"] = "teams"
    output["version"] = "1.2.0"

    '''
    GS_PREGAME(0),            // Period from start until first Kickoff Start 
  
    GS_GAMESTOP_H1(1),        // Game stopped during first half
    GS_GAMEON_H1(2),          // Game on during first half

    GS_HALFTIME(3),            // First half time

    GS_GAMESTOP_H2(4),        // Game stopped during second half
    GS_GAMEON_H2(5),          // Game on during second half

    GS_OVERTIME(6),            // Game end (ready for overtime)

    GS_GAMESTOP_H3(7),        // Game stopped during first half of overtime
    GS_GAMEON_H3(8),          // Game on during first half of overtime

    GS_HALFTIME_OVERTIME(9),  // First half time of oertime

    GS_GAMESTOP_H4(10),        // Game stopped during second half of overtime
    GS_GAMEON_H4(11),          // Game on during second half of overtime

    GS_PENALTIES(12),          // Penalties period on mbc????
    GS_PENALTIES_ON(13),       // Penalties period on mbc????
    GS_ENDGAME(14),            // Game over

    GS_ILLEGAL(99);
    '''
    output["gameState"] = 0

    '''
    "Pre-Game", 
    "1st Half - STOP",
    "1st Half", 
    "Halftime",
    "2nd Half - STOP",
    "2nd Half",
    "Pre-Overtime",
    "Overtime - 1st Half - STOP",
    "Overtime - 1st Half", 
    "Overtime - Halftime",
    "Overtime - 2nd Half - STOP",
    "Overtime - 2nd Half",
    "Penalties/STOP",
    "Penalties",
    "End Game"
    '''
    output["gameStateString"] = "Pre-Game"

    #TODO
    output["gameTime"] = "00:00"

    output["gameRunTime"] = str(datetime.timedelta(seconds=logEntryTeamA["gametimeMs"]/1000))

    output["teamA"] = {}
    output["teamA"]["color"] = "007BA7"
    output["teamA"]["shortName"] = logEntryTeamA["worldstate"]["teamName"]
    output["teamA"]["longName"] = logEntryTeamA["teamName"]

    #TODO
    output["teamA"]["score"] = "0"
    output["teamA"]["robotState"] = ["play", "play", "play", "play", "play"]
    output["teamA"]["robotWaitTime"] = [-1, -1, -1, -1, -1]

    output["teamA"]["worldState"] = logEntryTeamA["worldstate"]


    output["teamB"] = {}
    output["teamB"]["color"] = "DA70D6"
    output["teamB"]["shortName"] = logEntryTeamB["worldstate"]["teamName"]
    output["teamB"]["longName"] = logEntryTeamB["teamName"]

    #TODO
    output["teamB"]["score"] = "0"
    output["teamB"]["robotState"] = ["play", "play", "play", "play", "play"]
    output["teamB"]["robotWaitTime"] = [-1, -1, -1, -1, -1]

    output["teamB"]["worldState"] = logEntryTeamB["worldstate"]

    return output
