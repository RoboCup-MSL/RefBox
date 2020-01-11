class ScoreClients
{
	//public MyServer scoreServer1;
	private static final boolean debug = false;
	public ArrayList<UDP> scoreClients = new ArrayList<UDP>();

	public ScoreClients(PApplet parent)
	{
		int numberOfClients = Config.scoreClientHosts.size();
		
		for(int i = 0; i < numberOfClients; i++)
		{
			scoreClients.add(new UDP(parent));
		}
	}

	// Sends an "event" type update message to the clients
	public void update_tEvent(String eventCode, String eventDesc, String team)
	{
		String msg = "{";
		msg += "\"type\": \"event\",";
		msg += "\"eventCode\": \"" + eventCode + "\",";
		msg += "\"eventDesc\": \"" + eventDesc + "\",";
		msg += "\"team\": \"" + team + "\"";
		msg += "}";
		msg += (char)0x00;
		
		if(debug)
		{
			println("Updating clients: " + eventCode + " (" + eventDesc + ")");
		}
		
		writeMsg(msg);
	}

	// Sends a "teams" type update message to the clients
	public void update_tTeams(String gamet,String gamerunt) {
		long startTime = System.currentTimeMillis();
		
		String snA=teamA.shortName;
		String lnA=teamA.longName;
		if (snA.length()>Config.maxShortName) snA=teamA.shortName.substring(0, Config.maxShortName);
		if (lnA.length()>Config.maxLongName) lnA=teamA.longName.substring(0, Config.maxLongName);     
		String snB=teamB.shortName;
		String lnB=teamB.longName;
		if (snB.length()>Config.maxShortName) snB=teamB.shortName.substring(0, Config.maxShortName);     
		if (lnB.length()>Config.maxLongName) lnB=teamB.longName.substring(0, Config.maxLongName);     

		String gamestateText = StateMachine.GetCurrentGameStateString();
		
		String teamA_robotState = "";
		String teamA_robotWaitTime = "";
		String teamA_world_json = "{}";
		if(teamA != null && teamA.worldstate_json != null)
		teamA_world_json = teamA.worldstate_json.toString();
		String teamB_robotState = "";
		String teamB_robotWaitTime = "";
		String teamB_world_json = "{}";
		if(teamB != null && teamB.worldstate_json != null)
		teamB_world_json = teamB.worldstate_json.toString();
		
		for(int i = 0; i < 5; i++){
			teamA_robotState += "\"" + teamA.r[i].state + "\"" + ((i==4)?"":",");
			teamB_robotState += "\"" + teamB.r[i].state + "\"" + ((i==4)?"":",");
			if (teamA.r[i].state.equals("doubleyellow") == true)
			teamA_robotWaitTime += teamA.r[i].DoubleYellowTimer.getTimeSec() + ((i==4)?"":",");
			else
			teamA_robotWaitTime += teamA.r[i].RepairTimer.getTimeSec() + ((i==4)?"":",");
			if (teamB.r[i].state.equals("doubleyellow") == true)
			teamB_robotWaitTime += teamB.r[i].DoubleYellowTimer.getTimeSec() + ((i==4)?"":",");
			else
			teamB_robotWaitTime += teamB.r[i].RepairTimer.getTimeSec() + ((i==4)?"":",");
		}
		
		String msg = "{";
		msg += "\"type\": \"teams\",";
		msg += "\"version\": \"" + MSG_VERSION + "\",";
		msg += "\"gameState\": " + StateMachine.GetCurrentGameState().getValue() + ",";
		msg += "\"gameStateString\": \"" + gamestateText + "\",";
		msg += "\"gameTime\": \"" + gamet + "\",";
		msg += "\"gameRunTime\": \"" + gamerunt + "\",";
		
		msg += "\"teamA\": {"; // Team A
		msg += "\"color\": \"" + hex(teamA.c,6) + "\",";
		msg += "\"shortName\": \"" + snA + "\",";
		msg += "\"longName\": \"" + lnA + "\",";
		msg += "\"score\": \"" + teamA.Score + "\",";
		msg += "\"robotState\": [" + teamA_robotState + "],";
		msg += "\"robotWaitTime\": [" + teamA_robotWaitTime + "],";
		msg += "\"worldState\": " + teamA_world_json;
		msg += "},"; // END Team A
		
		msg += "\"teamB\": {"; // Team B
		msg += "\"color\": \"" + hex(teamB.c,6) + "\",";
		msg += "\"shortName\": \"" + snB + "\",";
		msg += "\"longName\": \"" + lnB + "\",";
		msg += "\"score\": \"" + teamB.Score + "\",";
		msg += "\"robotState\": [" + teamB_robotState + "],";
		msg += "\"robotWaitTime\": [" + teamB_robotWaitTime + "],";
		msg += "\"worldState\": " + teamB_world_json;
		msg += "}"; // END Team B
		
		msg += "}";
		
		msg += (char)0x00;
		
		writeMsg(msg);
		updateScoreClientslasttime=System.currentTimeMillis();
		
		//logMessage("Send to score clients " + (updateScoreClientslasttime-startTime) + " ms");
	}

	public int clientCount()
	{
		return Config.scoreClientHosts.size();
	}

	public void stopServer()
	{
		for(int i = 0; i < clientCount(); i++)
		{
			scoreClients.get(i).close();
		}
	}

	public void writeMsg(String message)
	{
		// Write message to all clients
		for(int i = 0; i < clientCount(); i++)
		scoreClients.get(i).send(message, Config.scoreClientHosts.get(i), Config.scoreClientPorts.get(i));
	}

}
