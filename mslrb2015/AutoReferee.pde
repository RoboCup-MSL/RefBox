/** Provides interface with automatic referee
 *  Uses the same JSON communication protocol as communication with base stations */
static class AutoReferee
{
  private enum MessageTarget {
    BOTH_TEAMS,
    TEAM_A,
    TEAM_B,
    UNKNOWN
  }
  
  private enum CommandHandling {
    IGNORE, /* No state change + automatic referee cannot request this */
    UPDATE_STATE, /* Update state, communication will be done in StateMachine */
    UPDATE_SEND, /* Update state and send command to teams */
  }
  
  Client refereeClient;
  MyServer refereeServer = new MyServer(mainApplet, Config.autoRefereeServerPort);
  
  /* Last message */
  String commandString = "";
  String teamString = "";
  int robotID = 0;
  
  MessageTarget targetTeam = MessageTarget.UNKNOWN;

  public void checkIncomingMessages() {
    // Todo check if client is connecting
    // Todo check if client is null
    refereeClient = refereeServer.available();
    
    if (refereeClient == null) return;
    
    String msg = new String(refereeClient.readBytes());
    
    org.json.JSONObject command;
    
    try // Check for malformed JSON
    {
      command = new org.json.JSONObject(msg);
    } catch(JSONException e) {
      String errorMsg = "ERROR malformed JSON from Automatic Referee\n";
      println(errorMsg);
      return;
    }
    
    // JSON is valid
    try {
      commandString = command.getString("command");
      // Invalid commands are ignored by validateCommand()
    } catch(JSONException e) {
      println("Missing command in message from Automatic Referee");
      return;
    }
    try {
      teamString = command.getString("targetTeam");
    } catch(JSONException e) {
      println("Missing target team in message from Automatic Referee");
      return;
    }
    try {
      robotID = command.getInt("robotID");
    } catch(JSONException e) { 
      /* It is to be expected that not all messages have a robotID */
      robotID = -1;
    }
    
    println("Received " + commandString + " for " + (teamString.isEmpty() ? "both teams" : teamString) + " from automatic referee (" + robotID + ")");
    
    updateTeams();
    CommandHandling ch = validateCommand();
    if (ch == CommandHandling.IGNORE) {
      println("Will not handle command " + commandString);
      return;
    }
    
    updateRefboxState();
    if (ch == CommandHandling.UPDATE_STATE) return;
    
    // Implies ch == UPDATE_SEND
    forwardToTeams();
  }
  
  public void closeServer() {
    refereeServer.stop();
  }
  
  private void updateTeams() {
    if (teamString.equals("teamA")) {
      targetTeam = MessageTarget.TEAM_A;
    } else if (teamString.equals("teamB")) {
      targetTeam = MessageTarget.TEAM_B;
    } else if (teamString.isEmpty()) {
      targetTeam = MessageTarget.BOTH_TEAMS;
    } else {
      targetTeam = MessageTarget.UNKNOWN;
      println("Error unknown team identifier from AutoReferee: " + teamString);
    }
  }

  private CommandHandling validateCommand() {
    switch(commandString) {
      case COMM_FIRST_HALF:
      case COMM_SECOND_HALF:
      case COMM_FIRST_HALF_OVERTIME:
      case COMM_SECOND_HALF_OVERTIME:
      case COMM_HALF_TIME:
      case COMM_END_GAME:
      case COMM_END_PART:
      case COMM_GAMEOVER:
      case COMM_RESET:
      case COMM_YELLOW_CARD:
      case COMM_RED_CARD:
        return CommandHandling.UPDATE_STATE;
      case COMM_STOP:
      case COMM_START:
      case COMM_GOAL:
      case COMM_KICKOFF:
      case COMM_FREEKICK:
      case COMM_GOALKICK:
      case COMM_THROWIN:
      case COMM_CORNER:
      case COMM_PENALTY:
      case COMM_DROP_BALL:
      case COMM_PARK:
      case COMM_SUBGOAL:
        return CommandHandling.UPDATE_SEND;
      default: // Ignore any other (or illegal ones) command
        return CommandHandling.IGNORE;
    }
  }
  
  private void updateRefboxState() {
    if (targetTeam == MessageTarget.BOTH_TEAMS) {
      if (commandString.equals(COMM_START))           StateMachine.Update(ButtonsEnum.BTN_START, true);
      else if (commandString.equals(COMM_STOP))       StateMachine.Update(ButtonsEnum.BTN_STOP, true);
      else if (commandString.equals(COMM_DROP_BALL))  StateMachine.Update(ButtonsEnum.BTN_DROPBALL, true);
      else if (commandString.equals(COMM_PARK))       StateMachine.Update(ButtonsEnum.BTN_PARK, true);
      else if (commandString.equals(COMM_END_PART))   StateMachine.Update(ButtonsEnum.BTN_ENDPART, true);
      else if (commandString.equals(COMM_RESET))      StateMachine.Update(ButtonsEnum.BTN_RESET, true);
      else println("No handling specified for the " + commandString + " command");
    } else if (targetTeam == MessageTarget.TEAM_A) {
      if (commandString.equals(COMM_STOP))            StateMachine.Update(ButtonsEnum.BTN_L_KICKOFF, true);
      else if (commandString.equals(COMM_FREEKICK))   StateMachine.Update(ButtonsEnum.BTN_L_FREEKICK, true);
      else if (commandString.equals(COMM_GOALKICK))   StateMachine.Update(ButtonsEnum.BTN_L_GOALKICK, true);
      else if (commandString.equals(COMM_THROWIN))    StateMachine.Update(ButtonsEnum.BTN_L_THROWIN, true);
      else if (commandString.equals(COMM_CORNER))     StateMachine.Update(ButtonsEnum.BTN_L_CORNER, true);
      else if (commandString.equals(COMM_GOAL))       StateMachine.Update(ButtonsEnum.BTN_L_GOAL, true);
      else if (commandString.equals(COMM_SUBGOAL))    StateMachine.Update(ButtonsEnum.BTN_L_GOAL, false);      
      else if (commandString.equals(COMM_RED_CARD))   StateMachine.Update(ButtonsEnum.BTN_L_RED, true);
      else if (commandString.equals(COMM_YELLOW_CARD)) StateMachine.Update(ButtonsEnum.BTN_L_YELLOW, true);
      else println("No handling specified for the " + commandString + " command");
    } else if (targetTeam == MessageTarget.TEAM_B) {
      if (commandString.equals(COMM_STOP))            StateMachine.Update(ButtonsEnum.BTN_R_KICKOFF, true);
      else if (commandString.equals(COMM_FREEKICK))   StateMachine.Update(ButtonsEnum.BTN_R_FREEKICK, true);
      else if (commandString.equals(COMM_GOALKICK))   StateMachine.Update(ButtonsEnum.BTN_R_GOALKICK, true);
      else if (commandString.equals(COMM_THROWIN))    StateMachine.Update(ButtonsEnum.BTN_R_THROWIN, true);
      else if (commandString.equals(COMM_CORNER))     StateMachine.Update(ButtonsEnum.BTN_R_CORNER, true);
      else if (commandString.equals(COMM_GOAL))       StateMachine.Update(ButtonsEnum.BTN_R_GOAL, true);
      else if (commandString.equals(COMM_SUBGOAL))    StateMachine.Update(ButtonsEnum.BTN_R_GOAL, false);      
      else if (commandString.equals(COMM_RED_CARD))   StateMachine.Update(ButtonsEnum.BTN_R_RED, true);
      else if (commandString.equals(COMM_YELLOW_CARD)) StateMachine.Update(ButtonsEnum.BTN_R_YELLOW, true);
      else println("No handling specified for the " + commandString + " command");
    }
  }
  
  private void forwardToTeams() {
    if (targetTeam == MessageTarget.UNKNOWN) return;
    
    String descr = Description.get(commandString) == null ? "" : Description.get(commandString);
    
    if (targetTeam == MessageTarget.TEAM_A) {
      send_event_v2(commandString, descr, teamA, robotID);
    } else if (targetTeam == MessageTarget.TEAM_B) {
      send_event_v2(commandString, descr, teamB, robotID);
    } else {
      // StateMachine handles sending these events
    }
  } //<>// //<>//
}
