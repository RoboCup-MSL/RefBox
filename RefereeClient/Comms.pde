
public static void serverEvent(Server whichServer, Client whichClient) {
/*  if (whichServer.equals(BaseStationServer)) {
    println(getAbsoluteTime()+": New BaseStationClient @ "+whichClient.ip());
    if (!Popup.isEnabled()) {
      if(setteamfromip(whichClient.ip()))
        connectingClient = whichClient; 
      else
      {
        // Invalid team
        whichClient.write(COMM_RESET);
        BaseStationServer.disconnect(whichClient);
      }
    } else {
      whichClient.write(COMM_RESET);
      BaseStationServer.disconnect(whichClient);
      Log.logMessage("ERR Another team connecting");
    }
  }
  if (whichServer.equals(scoreClients.scoreServer))
    println(getAbsoluteTime()+": New ScoreClient @ " + whichClient.ip());
  if (whichServer.equals(mslRemote.server))
    println(getAbsoluteTime()+": New RemoteControl @ " + whichClient.ip());
    */
}

// -------------------------
// Referee Box Protocol 2015

// TODO generate this? enum2str converter?

// default commands
public static final String COMM_STOP = "STOP";
public static final String COMM_START = "START";
public static final String COMM_WELCOME = "WELCOME";  //NEW 2015CAMBADA: welcome message
public static final String COMM_RESET = "RESET";  //NEW 2015CAMBADA: Reset Game
public static final String COMM_TESTMODE_ON = "TESTMODE_ON";  //NEW 2015CAMBADA: TestMode On
public static final String COMM_TESTMODE_OFF = "TESTMODE_OFF";  //NEW 2015CAMBADA: TestMode Off

// penalty Commands 
public static final String COMM_YELLOW_CARD = "YELLOW_CARD";//NEW 2015CAMBADA: @remote
public static final String COMM_RED_CARD = "RED_CARD";//NEW 2015CAMBADA: @remote
public static final String COMM_DOUBLE_YELLOW = "DOUBLE_YELLOW"; //NEW 2015CAMBADA: exits field

// game flow commands
public static final String COMM_FIRST_HALF = "FIRST_HALF";
public static final String COMM_SECOND_HALF = "SECOND_HALF";
public static final String COMM_FIRST_HALF_OVERTIME = "FIRST_HALF_OVERTIME";  //NEW 2015CAMBADA: 
public static final String COMM_SECOND_HALF_OVERTIME = "SECOND_HALF_OVERTIME";  //NEW 2015CAMBADA: 
public static final String COMM_HALF_TIME = "HALF_TIME";
public static final String COMM_END_GAME = "END_GAME";    //ends 2nd part, may go into overtime
public static final String COMM_END_PART = "END_PART";    //ends 2nd part, may go into overtime
public static final String COMM_GAMEOVER = "GAMEOVER";  //NEW 2015CAMBADA: Game Over
public static final String COMM_PARK = "PARK";

// goal status
public static final String COMM_GOAL = "GOAL";
public static final String COMM_SUBGOAL = "SUBGOAL";

// game flow commands
public static final String COMM_KICKOFF = "KICKOFF";
public static final String COMM_FREEKICK = "FREEKICK";
public static final String COMM_GOALKICK = "GOALKICK";
public static final String COMM_THROWIN = "THROWIN";
public static final String COMM_CORNER = "CORNER";
public static final String COMM_PENALTY = "PENALTY";
public static final String COMM_DROP_BALL = "DROP_BALL";

// repair Commands
public static final String COMM_REPAIR = "REPAIR";
public static final String COMM_SUBSTITUTION = "SUBSTITUTION";

//free: 056789 iIfFHlmMnqQwxX
//------------------------------------------------------

public static StringDict Description;
void comms_initDescriptionDictionary() {
  Description = new StringDict();
  Description.set(COMM_STOP, "STOP");
  Description.set(COMM_START, "START");
  Description.set(COMM_DROP_BALL, "Drop Ball");
  Description.set(COMM_HALF_TIME, "Halftime");
  Description.set(COMM_END_GAME, "End Game");
  Description.set(COMM_END_PART, "End Part");
  Description.set(COMM_GAMEOVER, "Game Over");
  Description.set(COMM_RESET, "Reset Game");
  Description.set(COMM_WELCOME, "Welcome");
  Description.set(COMM_TESTMODE_ON, "Test Mode on");
  Description.set(COMM_TESTMODE_OFF, "Test Mode off");
  Description.set(COMM_FIRST_HALF, "1st half");
  Description.set(COMM_SECOND_HALF, "2nd half");
  Description.set(COMM_FIRST_HALF_OVERTIME, "Overtime 1st half");
  Description.set(COMM_SECOND_HALF_OVERTIME, "Overtime 2nd half");
  Description.set(COMM_PARK, "Park");
  Description.set(COMM_SUBSTITUTION, "Substitution");

  Description.set(COMM_KICKOFF,       "Kickoff");
  Description.set(COMM_FREEKICK,      "Freekick");
  Description.set(COMM_GOALKICK,      "Goalkick");
  Description.set(COMM_THROWIN,       "Throw In");
  Description.set(COMM_CORNER,        "Corner");
  Description.set(COMM_PENALTY,       "Penalty");
  Description.set(COMM_GOAL,          "Goal+");
  Description.set(COMM_SUBGOAL,       "Goal-");
  Description.set(COMM_REPAIR,    "Repair");
  Description.set(COMM_RED_CARD,      "Red Card");
  Description.set(COMM_YELLOW_CARD,   "Yellow Card");
  Description.set(COMM_DOUBLE_YELLOW, "Double Yellow");
}
