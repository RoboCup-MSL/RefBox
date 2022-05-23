// New accepted connections
public static void serverEvent(MyServer whichServer, Client whichClient) {
	try {
		if (whichServer.equals(BaseStationServer)) {
			Log.logMessage("New BaseStation @ "+whichClient.ip());
		}
//		else if (mslRemote != null && mslRemote.server != null && whichServer != null && whichServer.equals(mslRemote.server)) {
//			Log.logMessage("New Remote @ " + whichClient.ip());
//		}
	}catch(Exception e){}
}

// Client authentication
public static void clientValidation(MyServer whichServer, Client whichClient) {
	try{
		// BASESTATION CLIENTS AUTH
		if (whichServer.equals(BaseStationServer)) {
			if (!Popup.isEnabled()) {
				if(setteamfromip(whichClient.ip()))
				connectingClient = whichClient; // Accept client!
				else
				{
					// Invalid team
					Log.logMessage("Invalid team " + whichClient.ip());
					send_event_v2(COMM_RESET,COMM_RESET,null,-1);
					whichClient.stop();
				}
			} else {
				Log.logMessage("ERR Another team connecting");
				//whichClient.write(COMM_RESET);
				send_event_v2(COMM_RESET,COMM_RESET,null,-1);
				whichClient.stop();
			}
		}
		// REMOTE CLIENTS AUTH
		/*else if (mslRemote != null && mslRemote.server != null && whichServer.equals(mslRemote.server)) {
			
		} */
	}catch(Exception e){}
}


public static void send_to_basestation(String c, String teamIP, int robotID, Client client){

	JSONObject jsonObject = new JSONObject();
	jsonObject.put("command", c);
	jsonObject.put("targetTeam", teamIP);
	if(robotID > -1)
	{
		jsonObject.put("robotID", robotID);
	}
	String send = jsonObject.toString() + "\0";
	System.out.println(send);
  if (client == null) {
	  BaseStationServer.write(send);
  } else {
    BaseStationServer.write(send, client);
  }
}

public static void event_message_v2(ButtonsEnum btn, boolean on)
{
	String cmd = buttonFromEnum(btn).cmd;
	String msg = buttonFromEnum(btn).msg;
	if(!on)
	{
		cmd = buttonFromEnum(btn).cmd_off;
		msg = buttonFromEnum(btn).msg_off;
	}

	Team t = null;
	if(btn.isLeft()) t = teamA;
	if(btn.isRight()) t = teamB;

	if(cmd != null && msg != null)
	{
		send_event_v2(cmd, msg, t, -1);
	}
}
/*
	Method send_event_v2()
	Parameters:
		cmd > string with message to send to basestations, scoreClients and Log
		msg > string with description message to send to scoreclients @mbc (check if needed)
		t > id of the team. If null, message is to both teams
		robotID > ID number of the target robot. (-1) means no robot
    client > Selectively send event to one client, null is sending to all client teams
*/
public static void send_event_v2(String cmd, String msg, Team t, int robotID, Client client)
{
	String teamIP, teamName;

	if( t == null)
	{
		teamIP = "";
		teamName = "";
	}else{
		teamIP = t.multicastIP;
		teamName = t.team;
	}
	send_to_basestation(cmd, teamIP, robotID, client);  //send to basestation
	scoreClients.update_tEvent(cmd, msg, teamName, robotID); //send to referee client
	//mslRemote.update_tEvent(cmd, msg, t); //remote command

	Log.logactions(cmd, teamName, robotID);
	//	mslRemote.setLastCommand(send);      // Update MSL remote module with last command sent to basestations 
	// Look into command connection later

}

public static void send_event_v2(String cmd, String msg, Team t, int robotID)
{
   send_event_v2(cmd, msg, t, robotID, null); 
}

public static boolean setteamfromip(String s) {
	String clientipstr="127.0.0.*";
	String[] iptokens;

	if (!s.equals("0:0:0:0:0:0:0:1")) {
		iptokens=split(s,'.');
		if (iptokens!=null) clientipstr=iptokens[0]+"."+iptokens[1]+"."+iptokens[2]+".*"; // Create clientipstr from received IP tokens
	}

	for (TableRow row : teamstable.rows()) {
		String saddr = row.getString("UnicastAddr");
		Team t = null;
		
		if (saddr.equals(clientipstr)) {
			println("Team " + row.getString("Team") + " connected (" + row.getString("shortname8") + "/" + row.getString("longame24") + ")");
			teamselect=row;
			
			boolean noTeamA = teamA.connectedClient == null || !teamA.connectedClient.active();
			boolean noTeamB = teamB.connectedClient == null || !teamB.connectedClient.active();

			
			if(noTeamA && noTeamB) // No team connected. Ask for side
			{
				Popup.show(PopupTypeEnum.POPUP_TEAMSELECTION, "Team: "+row.getString("Team")+"\nSelect side or press ESC to cancel",3, 0, 4, 20, 380, 200);
				return true;				
			}
			else if (noTeamA)
			{
				Popup.show(PopupTypeEnum.POPUP_TEAMSELECTION, "Team: "+row.getString("Team")+"\nwill be selected as Left",8, 0, 0, 20, 380, 200);
				return true;
			}
			else if (noTeamB)
			{
				Popup.show(PopupTypeEnum.POPUP_TEAMSELECTION, "Team: "+row.getString("Team")+"\nwill be selected as Right",8, 0, 0, 20, 380, 200);
				return true;
			}
			else if (StateMachine.GetCurrentGameState() == GameStateEnum.GS_PREGAME) 
			{
				// This else exists for teams that reconnect with a diferent IP
				// when they were previously connected. This only happens in pre-game
				Popup.show(PopupTypeEnum.POPUP_TEAMSELECTION, "Team: "+row.getString("Team")+"\nSelect side or press ESC to cancel",3, 0, 4, 20, 380, 200);
				return true;							
			}
			else
			{
				Log.logMessage("ERR No more connections allowed (Attempt from " + s + ")");
				return false;
			}
			
		}
	}
	Log.logMessage("ERR Unknteam (Attempt from " + s + ")");
	return false;
}

public static void checkBasestationsMessages()
{
	try
	{
		// Get the next available client
		Client thisClient = BaseStationServer.available();
		// If the client is not null, and says something, display what it said
		if (thisClient !=null) {
			
			Team t = null;
			int team = -1; // 0=A, 1=B
			if(teamA != null && teamA.connectedClient == thisClient)
			t=teamA;
			else if(teamB != null && teamB.connectedClient == thisClient)
			t=teamB;
			else{
				if(thisClient != connectingClient)
				println("NON TEAM MESSAGE RECEIVED FROM " + thisClient.ip());
				return;
			}
			String whatClientSaid = new String(thisClient.readBytes());
			if (whatClientSaid != null) 
			while(whatClientSaid.length() !=0){
				int idx = whatClientSaid.indexOf('\0');
				if(idx!=-1){
					if(idx!=0)
					{  
						t.wsBuffer+= whatClientSaid.substring(0,idx);
						if(idx < whatClientSaid.length())
						whatClientSaid = whatClientSaid.substring(idx+1);
						else
						whatClientSaid = "";
					}else{
						if(whatClientSaid.length() == 1)
						whatClientSaid = "";
						else
						whatClientSaid = whatClientSaid.substring(1);
					}
					
					// JSON Validation
					boolean ok = true;
					int ageMs = 0;
					String dummyFieldString;
					org.json.JSONArray dummyFieldJsonArray;
					try // Check for malformed JSON
					{
						t.worldstate_json = new org.json.JSONObject(t.wsBuffer);
					} catch(JSONException e) {
						String errorMsg = "ERROR malformed JSON (team=" + t.shortName + ") : " + t.wsBuffer;
						println(errorMsg);
						ok = false;
					}
					
					if(ok)
					{
						try // Check for "type" key
						{
							String type = t.worldstate_json.getString("type");
							
							// type must be "worldstate"
							if(!type.equals("worldstate"))
							{
								String errorMsg = "ERROR key \"type\" is not \"worldstate\" (team=" + t.shortName + ") : " + t.wsBuffer;
								println(errorMsg);
								ok = false;
							}
						} catch(JSONException e) {
							String errorMsg = "ERROR missing key \"type\" (team=" + t.shortName + ") : " + t.wsBuffer;
							println(errorMsg);
							ok = false;
						}
					}
					
					if(ok)
					{
						try // Check for "ageMs" key
						{
							ageMs = t.worldstate_json.getInt("ageMs");
						} catch(JSONException e) {
							String errorMsg = "WS-ERROR missing key \"ageMs\" (team=" + t.shortName + ") : " + t.wsBuffer;
							println(errorMsg);
							ok = false;
						}
					}
					
					if(ok)
					{
						try // Check for "teamName" key
						{
							dummyFieldString = t.worldstate_json.getString("teamName");
						} catch(JSONException e) {
							String errorMsg = "WS-ERROR missing key \"teamName\" (team=" + t.shortName + ") : " + t.wsBuffer;
							println(errorMsg);
							ok = false;
						}
					}
					
					if(ok)
					{
						try // Check for "intention" key
						{
							dummyFieldString = t.worldstate_json.getString("intention");
						} catch(JSONException e) {
							String errorMsg = "WS-ERROR missing key \"intention\" (team=" + t.shortName + ") : " + t.wsBuffer;
							println(errorMsg);
							ok = false;
						}
					}
					
					if(ok)
					{
						try // Check for "robots" key
						{
							dummyFieldJsonArray = t.worldstate_json.getJSONArray("robots");
						} catch(JSONException e) {
							String errorMsg = "WS-ERROR key \"robots\" is missing or is not array (team=" + t.shortName + ") : " + t.wsBuffer;
							println(errorMsg);
							ok = false;
						}
					}
					
					if(ok)
					{
						try // Check for "balls" key
						{
							dummyFieldJsonArray = t.worldstate_json.getJSONArray("balls");
						} catch(JSONException e) {
							String errorMsg = "WS-ERROR key \"balls\" is missing or is not array (team=" + t.shortName + ") : " + t.wsBuffer;
							println(errorMsg);
							ok = false;
						}
					}
					
					if(ok)
					{
						try // Check for "obstacles" key
						{
							dummyFieldJsonArray = t.worldstate_json.getJSONArray("obstacles");
						} catch(JSONException e) {
							String errorMsg = "WS-ERROR key \"obstacles\" is missing or is not array (team=" + t.shortName + ") : " + t.wsBuffer;
							println(errorMsg);
							ok = false;
						}
					}
					
					if(ok)
					{
						t.logWorldstate(t.wsBuffer,ageMs);
					}
					t.wsBuffer="";      
				}else{
					t.wsBuffer+= whatClientSaid;
					break;
				}
				
				// Avoid filling RAM with buffering (for example team is not sending the '\0' character)
				if(t.wsBuffer.length() > 100000) {
					t.wsBuffer = "";
					String errorMsg = "ERROR JSON not terminated with '\\0' (team=" + t.shortName + ")";
					println(errorMsg);
				}
			}
			
			
		}
	}catch(Exception e){
	}
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

// specific team Commands
public static final String COMM_REPAIR = "REPAIR";
public static final String COMM_SUBSTITUTION = "SUBSTITUTION";
public static final String COMM_ISALIVE = "IS_ALIVE";

public static StringDict Description;
void comms_initDescriptionDictionary() {
	Description = new StringDict();
	Description.set(COMM_STOP,          "STOP");
	Description.set(COMM_START,         "START");
	Description.set(COMM_DROP_BALL,     "Drop Ball");
	Description.set(COMM_HALF_TIME,     "Halftime");
	Description.set(COMM_END_GAME,      "End Game");
	Description.set(COMM_END_PART,      "End Part");
	Description.set(COMM_GAMEOVER,      "Game Over");
	Description.set(COMM_RESET,         "Reset Game");
	Description.set(COMM_WELCOME,       "Welcome");
	Description.set(COMM_TESTMODE_ON,   "Test Mode on");
	Description.set(COMM_TESTMODE_OFF,  "Test Mode off");
	Description.set(COMM_FIRST_HALF,    "1st half");
	Description.set(COMM_SECOND_HALF,   "2nd half");
	Description.set(COMM_FIRST_HALF_OVERTIME, "Overtime 1st half");
	Description.set(COMM_SECOND_HALF_OVERTIME, "Overtime 2nd half");
	Description.set(COMM_PARK,          "Park");
	Description.set(COMM_SUBSTITUTION,  "Substitution");
	Description.set(COMM_ISALIVE,       "Is Alive");
	Description.set(COMM_KICKOFF,       "Kickoff");
	Description.set(COMM_FREEKICK,      "Freekick");
	Description.set(COMM_GOALKICK,      "Goalkick");
	Description.set(COMM_THROWIN,       "Throw In");
	Description.set(COMM_CORNER,        "Corner");
	Description.set(COMM_PENALTY,       "Penalty");
	Description.set(COMM_GOAL,          "Goal+");
	Description.set(COMM_SUBGOAL,       "Goal-");
	Description.set(COMM_REPAIR,        "Repair");
	Description.set(COMM_RED_CARD,      "Red Card");
	Description.set(COMM_YELLOW_CARD,   "Yellow Card");
	Description.set(COMM_DOUBLE_YELLOW, "Double Yellow");

}
