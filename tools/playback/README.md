# LogFileAnalyzer

The log file analyzer reads the generic MSL logging found here:
http://wiki.robocup.org/wiki/MSL_logging_database

And feeds the information to the AudienceClient.

The LogFileAnalyzer:
* parses the log file,
* populates a message to the AudienceClient,
* sends the message to the AudienceClient

Example:
* in a terminal, start audienceClient, then press "connect" (keep default port 12345)
* in another terminal, run:
 playbackMatchlog.py logfile.zip


## JSON format MSL Logging
``` json
{
    "teamName": "CAMBADA",
    "timestamp": 1467378856235,
    "gametimeMs": 24693,
    "worldstate": {
        "type": "worldstate",
        "teamName": "CBD",
        "intention": "Win",
        "balls": [{
            "position": [-0.030, 0.084, 0.110],
            "velocity": [0.020, -0.061, 0],
            "confidence": 0.829
        }, {
            "position": [0.241, 0.024, 0.110],
            "velocity": [0.000, -0.002, 0],
            "confidence": 0.827
        }, {
            "position": [0.073, 0.067, 0.110],
            "velocity": [0.002, 0.002, 0],
            "confidence": 0.821
        }, {
            "position": [-0.069, 0.044, 0.110],
            "velocity": [0.025, -0.047, 0],
            "confidence": 0.821
        }],
        "robots": [{
            "id": 1,
            "pose": [-0.061, -8.932, 0.149],
            "targetPose": [-0.061, -8.932, 0.149],
            "velocity": [-0.013, -0.003, -0.022],
            "intention": "Stop",
            "batteryLevel": 0,
            "ballEngaged": 0
        }, {
            "id": 2,
            "pose": [1.558, -3.143, 0.113],
            "targetPose": [1.558, -3.143, 0.113],
            "velocity": [-0.001, -0.001, -0.002],
            "intention": "Stop",
            "batteryLevel": 0,
            "ballEngaged": 0
        }, {
            "id": 3,
            "pose": [0.619, -3.265, 0.005],
            "targetPose": [0.619, -3.265, 0.005],
            "velocity": [-0.011, 0.001, 0.005],
            "intention": "Stop",
            "batteryLevel": 0,
            "ballEngaged": 0
        }, {
            "id": 4,
            "pose": [-2.429, -2.175, 6.261],
            "targetPose": [-2.429, -2.175, 6.261],
            "velocity": [-0.001, -0.007, 0.006],
            "intention": "Stop",
            "batteryLevel": 0,
            "ballEngaged": 0
        }, {
            "id": 6,
            "pose": [-0.621, -3.440, 0.113],
            "targetPose": [-0.621, -3.440, 0.113],
            "velocity": [0.008, -0.007, 0.005],
            "intention": "Stop",
            "batteryLevel": 0,
            "ballEngaged": 0
        }],
        "obstacles": [],
        "ageMs": 16
    }
}
```

## JSON format Audience Client
``` json
{
    "type": "teams",
    "version": "1.2.0",
    "gameState": 0,
    "gameStateString": "Pre-Game",
    "gameTime": "00:17",
    "gameRunTime": "00:00",
    "teamA": {
        "color": "007BA7",
        "shortName": "***",
        "longName": "Disconnected",
        "score": "0",
        "robotState": ["play", "play", "play", "play", "play"],
        "robotWaitTime": [-1, -1, -1, -1, -1],
        "worldState": {
            "teamName": "Falcons",
            "balls": [],
            "obstacles": [],
            "robots": [{
                "pose": [0.062, -8.434, 1.565],
                "id": 3,
                "velocity": [0, 0, 0],
                "targetPose": [0, 0, 0],
                "ballEngaged": 0,
                "intention": "",
                "batteryLevel": 0
            }],
            "type": "worldstate",
            "intention": "undefined"
        }
    },
    "teamB": {
        "color": "DA70D6",
        "shortName": "***",
        "longName": "Disconnected",
        "score": "0",
        "robotState": ["play", "play", "play", "play", "play"],
        "robotWaitTime": [-1, -1, -1, -1, -1],
        "worldState": {}
    }
}
```
