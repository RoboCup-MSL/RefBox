class MSLRemote
{
	public MyServer server;
	private String lastCommand = " ";

	private static final String GAMESTATUS_PRE_GAME = "Va";
	private static final String GAMESTATUS_PRE_GAME_KICK_OFF_CYAN = "Vb";
	private static final String GAMESTATUS_PRE_GAME_KICK_OFF_MAGENTA = "Vc";
	private static final String GAMESTATUS_GAME_STOP_HALF1 = "Vd";
	private static final String GAMESTATUS_GAME_STOP_HALF2 = "Ve";
	private static final String GAMESTATUS_GAME_ON_HALF1 = "Vf";
	private static final String GAMESTATUS_GAME_ON_HALF2 = "Vg";
	private static final String GAMESTATUS_HALF_TIME = "Vh";
	private static final String GAMESTATUS_HALF_KICK_OFF_CYAN = "Vi";
	private static final String GAMESTATUS_HALF_KICK_OFF_MAGENTA = "Vj";
	private static final String GAMESTATUS_END_GAME = "Vk";
	private static final String GAMESTATUS_SET_PLAY = "Vl";

	// Set plays:
	private static final String COMMAND_KICK_OFF_CYAN = "CK";
	private static final String COMMAND_FREEKICK_CYAN = "CF";
	private static final String COMMAND_THROW_IN_CYAN = "CT";
	private static final String COMMAND_GOALKICK_CYAN = "CG";
	private static final String COMMAND_CORNER_CYAN = "CE";
	private static final String COMMAND_PENALTY_CYAN = "CP";
	private static final String COMMAND_SCORE_CYAN = "CL"; // append score 2 digits (e.g. "CL01" for cyan score = 1)
	private static final String COMMAND_YELLOW_CYAN = "CY1"; // robot 1
	private static final String COMMAND_OUT_CYAN = "Co1"; // robot 1

	private static final String COMMAND_KICK_OFF_MAGENTA= "MK";
	private static final String COMMAND_FREEKICK_MAGENTA = "MF";
	private static final String COMMAND_THROW_IN_MAGENTA = "MT";
	private static final String COMMAND_GOALKICK_MAGENTA = "MG";
	private static final String COMMAND_CORNER_MAGENTA = "ME";
	private static final String COMMAND_PENALTY_MAGENTA = "MP";
	private static final String COMMAND_SCORE_MAGENTA = "ML"; // append score 2 digits (e.g. "CL01" for cyan score = 1)
	private static final String COMMAND_YELLOW_MAGENTA = "MY1"; // robot 1
	private static final String COMMAND_OUT_MAGENTA = "Mo1"; // robot 1

	private static final String COMMAND_DROPBALL = "SD";
	private static final String COMMAND_START = "ST";
	private static final String COMMAND_STOP = "SP";
	private static final String COMMAND_ENDPART = "SG";
	private static final String COMMAND_RESET = "SR";



	public MSLRemote(PApplet parent, int port)
	{
		server = new MyServer(parent, port);
	}

	public void setLastCommand(String cmd)
	{
		lastCommand = cmd;
	}

	public String getEventCommand()
	{
		if(lastCommand.equals(cCommcmds[CMDID_COMMON_START]))
		return COMMAND_START;
		else if(lastCommand.equals(cCommcmds[CMDID_COMMON_STOP]))
		return COMMAND_STOP;
		else if(lastCommand.equals(cCommcmds[CMDID_COMMON_DROP_BALL]))
		return COMMAND_DROPBALL;
		else if(lastCommand.equals(cCommcmds[CMDID_COMMON_HALFTIME]))
		return COMMAND_ENDPART;
		else if(lastCommand.equals(cCommcmds[CMDID_COMMON_RESET]))
		return COMMAND_RESET;
		
		else if(lastCommand.equals(cCTeamcmds[CMDID_TEAM_KICKOFF]))
		return COMMAND_KICK_OFF_CYAN;
		else if(lastCommand.equals(cCTeamcmds[CMDID_TEAM_FREEKICK]))
		return COMMAND_FREEKICK_CYAN;
		else if(lastCommand.equals(cCTeamcmds[CMDID_TEAM_GOALKICK]))
		return COMMAND_GOALKICK_CYAN;
		else if(lastCommand.equals(cCTeamcmds[CMDID_TEAM_THROWIN]))
		return COMMAND_THROW_IN_CYAN;
		else if(lastCommand.equals(cCTeamcmds[CMDID_TEAM_CORNER]))
		return COMMAND_CORNER_CYAN;
		else if(lastCommand.equals(cCTeamcmds[CMDID_TEAM_PENALTY]))
		return COMMAND_PENALTY_CYAN;
		
		else if(lastCommand.equals(cMTeamcmds[CMDID_TEAM_KICKOFF]))
		return COMMAND_KICK_OFF_MAGENTA;
		else if(lastCommand.equals(cMTeamcmds[CMDID_TEAM_FREEKICK]))
		return COMMAND_FREEKICK_MAGENTA;
		else if(lastCommand.equals(cMTeamcmds[CMDID_TEAM_GOALKICK]))
		return COMMAND_GOALKICK_MAGENTA;
		else if(lastCommand.equals(cMTeamcmds[CMDID_TEAM_THROWIN]))
		return COMMAND_THROW_IN_MAGENTA;
		else if(lastCommand.equals(cMTeamcmds[CMDID_TEAM_CORNER]))
		return COMMAND_CORNER_MAGENTA;
		else if(lastCommand.equals(cMTeamcmds[CMDID_TEAM_PENALTY]))
		return COMMAND_PENALTY_MAGENTA;
		
		return "";
	}

	public String getGameStatusCommand()
	{    
		// 0  "Pre-Game",
		// 1  "Game - 1st Half",
		// 2  "Game - Halftime",
		// 3  "Game - 2nd Half", 
		// 4  "Game - End", 
		// 5  "Overtime - 1st",
		// 6  "Overtime - Switch",
		// 7  "Overtime - 2nd",
		// 8  "Penalty",
		// 9  "GameOver"
		
		GameStateEnum gs = StateMachine.GetCurrentGameState(); 
		
		boolean kickoff = false;
		boolean teamCyan = false;
		
		if(lastCommand == cCTeamcmds[CMDID_TEAM_KICKOFF] || lastCommand == cMTeamcmds[CMDID_TEAM_KICKOFF])
		{
			if(gs == GameStateEnum.GS_PREGAME || gs == GameStateEnum.GS_HALFTIME || gs == GameStateEnum.GS_HALFTIME_OVERTIME) // pre or halftime
			{
				kickoff = true;
				if(lastCommand == cCTeamcmds[CMDID_TEAM_KICKOFF])
				teamCyan = true;
			}
		}else if(lastCommand == cCTeamcmds[CMDID_TEAM_FREEKICK]
				|| lastCommand == cCTeamcmds[CMDID_TEAM_GOALKICK]
				|| lastCommand == cCTeamcmds[CMDID_TEAM_THROWIN]
				|| lastCommand == cCTeamcmds[CMDID_TEAM_CORNER]
				|| lastCommand == cCTeamcmds[CMDID_TEAM_PENALTY]
				|| lastCommand == cMTeamcmds[CMDID_TEAM_FREEKICK]
				|| lastCommand == cMTeamcmds[CMDID_TEAM_GOALKICK]
				|| lastCommand == cMTeamcmds[CMDID_TEAM_THROWIN]
				|| lastCommand == cMTeamcmds[CMDID_TEAM_CORNER]
				|| lastCommand == cMTeamcmds[CMDID_TEAM_PENALTY]
				|| lastCommand == cCommcmds[CMDID_COMMON_DROP_BALL])
		return GAMESTATUS_SET_PLAY;

		switch(gs)
		{
		case GS_PREGAME:
			if(kickoff)
			{
				if(teamCyan)
				return GAMESTATUS_PRE_GAME_KICK_OFF_CYAN;
				else
				return GAMESTATUS_PRE_GAME_KICK_OFF_MAGENTA;
			}
			return GAMESTATUS_PRE_GAME;
			
			
		case GS_GAMESTOP_H1:
		case GS_GAMESTOP_H3:
			return GAMESTATUS_GAME_STOP_HALF1;
			
		case GS_GAMEON_H1:
		case GS_GAMEON_H3:
			return GAMESTATUS_GAME_ON_HALF1;

		case GS_HALFTIME:
		case GS_OVERTIME:
		case GS_HALFTIME_OVERTIME:
			if(kickoff)
			{
				if(teamCyan)
				return GAMESTATUS_HALF_KICK_OFF_CYAN;
				else
				return GAMESTATUS_HALF_KICK_OFF_MAGENTA;
			}
			return GAMESTATUS_HALF_TIME;
			
		case GS_GAMESTOP_H2:
		case GS_GAMESTOP_H4:
			return GAMESTATUS_GAME_STOP_HALF2;
			
		case GS_GAMEON_H2:
		case GS_GAMEON_H4:
			return GAMESTATUS_GAME_ON_HALF2;

		case GS_PENALTIES:
			return GAMESTATUS_GAME_STOP_HALF2;
			
		case GS_ENDGAME:
			return GAMESTATUS_END_GAME;
		}
		
		return "";
	}

	// Sends an "event" type update message to the clients
	public void update_tEvent(String eventCode, String eventDesc, Team team)
	{
		int teamId = -1;
		if(team == teamA) teamId = 0;
		else if(team == teamB) teamId = 1;
		
		int scoreA = (teamA != null) ? teamA.Score : 0;
		int scoreB = (teamB != null) ? teamB.Score : 0;
		
		String msg = "{";
		msg += "\"type\": \"event\",";
		msg += "\"eventCode\": \"" + eventCode + "\",";
		msg += "\"eventDesc\": \"" + eventDesc + "\",";
		msg += "\"teamId\": " + teamId + ",";
		msg += "\"teamName\": \"" + ((teamId == -1) ? "" : team.shortName) + "\",";
		msg += "\"gamestatus\": \"" + getGameStatusCommand() + "\",";
		msg += "\"command\": \"" + getEventCommand() + "\",";
		msg += "\"scoreTeamA\": " + scoreA + ",";
		msg += "\"scoreTeamB\": " + scoreB;
		msg += "}";
		msg += (char)0x00;
		
		writeMsg(msg);
	}



	public int clientCount()
	{
		return server.clientCount;
	}

	public void stopServer()
	{
		server.stop();
	}

	public void writeMsg(String message)
	{
		if (server.clientCount > 0){
			server.write(message);
		}
	}

	public void checkMessages()
	{
		try
		{
			// Get the next available client
			Client thisClient = server.available();
			// If the client is not null, and says something, display what it said
			if (thisClient !=null) {
				String whatClientSaid = thisClient.readString();
				if (whatClientSaid != null) {
					
					println("MSL Remote JSON: " + whatClientSaid);
					
					org.json.JSONObject jsonObj = new org.json.JSONObject(whatClientSaid);
					
					int pos = jsonObj.getInt("id");
					
					char group = 'C';
					
					buttonEvent(group, pos);
					
				}
			}
			
		}catch(Exception e){
			println("Invalid JSON received from MSL Remote.");
		}
	}
}
