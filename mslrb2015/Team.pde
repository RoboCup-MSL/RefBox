class Team {
	String shortName;  //max 8 chars
	String longName;  //max 24 chars
	String team;
	String unicastIP, multicastIP;
	color colorTeam=(#000000);
	boolean isLeft;  //default: 
	boolean newYellowCard, newRedCard, newRepair, newSubstitution, newDoubleYellow, newPenaltyKick, newGoal; // Pending commands, effective only on gamestate change
	int Score, RedCardCount, YellowCardCount, DoubleYellowCardCount, PenaltyCount;
	public int RepairCount;
	public int nOfRepairs;
	int tableindex=0;
	public int nOfSubstitutions;
	org.json.JSONObject worldstate_json;
	String wsBuffer;
	Robot[] r=new Robot[5];

	File logFile;
	PrintWriter logFileOut;
	Client connectedClient;
	boolean firstWorldState;
	
	Team(color c, boolean uileftside) {
		this.colorTeam=c;		//colorTeam;
		this.isLeft=uileftside;
		//robots
		float x=0, y=60; 					//64
		r[0]=new Robot(x, y);
		r[1]=new Robot(x + 56, y);
		r[2]=new Robot(x, y + 50);			//56
		r[3]=new Robot(x + 56, y + 50);
		r[4]=new Robot(x + 28, y + 100);	//112

		this.reset();
	}

	//===================================

	void resetname(){
		if (this.isLeft) {
			this.shortName=Config.defaultLeftTeamShortName;
			this.longName=Config.defaultLeftTeamLongName;
			this.team=Config.defaultLeftTeam;
		}
		else {
			this.shortName=Config.defaultRightTeamShortName;
			this.longName=Config.defaultRightTeamLongName;
			this.team=Config.defaultRightTeam;
		}
		this.unicastIP="172.16.0.0"; 		//reset unicastIP for generic IP
		this.multicastIP = "224.16.32.0"; 	//reset multicastIP for generic IP
	}

	void logWorldstate(String teamWorldstate, int ageMs){
		if(logFileOut == null)
		return;

		if(firstWorldState) {
			logFileOut.println("[");    // Start of JSON array
			firstWorldState = false;
		}else{
			logFileOut.println(",");    // Separator for the new JSON object
		}

		logFileOut.print("{");
		logFileOut.print("\"teamName\": \"" + shortName + "\",");
		logFileOut.print("\"timestamp\": " + (System.currentTimeMillis() - ageMs) + ",");
		logFileOut.print("\"gametimeMs\": " + mainWatch.getTimeMs() + ",");
		logFileOut.print("\"worldstate\": " + teamWorldstate);
		logFileOut.print("}");

	}

	void reset() {
		if(logFileOut != null) {
			logFileOut.println("]");    // End JSON array
			logFileOut.close();
		}

		logFileOut = null;
		logFile = null;

		this.resetname();
		this.worldstate_json = null;
		this.wsBuffer = "";
		this.Score=0; 
		this.RepairCount=0;
		this.nOfRepairs = 1;
		this.RedCardCount=0;
		this.YellowCardCount=0;
		this.DoubleYellowCardCount=0;
		this.PenaltyCount=0;
		this.nOfSubstitutions = 0;
		this.newYellowCard=false;
		this.newRedCard=false;
		this.newRepair=false;
		this.newSubstitution=false;
		this.newDoubleYellow=false;
		this.newPenaltyKick=false;
		for (int i=0; i<5; i++)
		r[i].reset();

		if(this.connectedClient != null && this.connectedClient.active())
		this.connectedClient.stop();
		this.connectedClient = null;
		this.firstWorldState = true;
	}

	// Function called when team connects and is accepted
	void teamConnected(TableRow teamselect){
		shortName=teamselect.getString("shortname8");
		longName=teamselect.getString("longame24");
		team=teamselect.getString("Team");
		unicastIP = teamselect.getString("UnicastAddr");
		multicastIP = teamselect.getString("MulticastAddr");

		String teamID = isLeft ? "A" : "B";

		// support same team connecting twice: newest team gets adapted ids
		if(teamA.team == teamB.team)
		{
			team 	 += " " + teamID;
			longName += " " + teamID;
		}
		if(teamA.multicastIP == teamB.multicastIP)
		{
			multicastIP += ":1";
		}

		if(connectedClient != null)
			BaseStationServer.disconnect(connectedClient);

		connectedClient = connectingClient;
		send_event_v2(COMM_WELCOME,COMM_WELCOME, this ,-1);
		connectingClient = null;

		if(this.logFile == null || this.logFileOut == null)
		{
			this.logFile = new File(mainApplet.dataPath("tmp/" + Log.getTimedName() + "." + (teamID) + ".msl"));
			try{
				this.logFileOut = new PrintWriter(new BufferedWriter(new FileWriter(logFile, true)));
			}catch(IOException e){ }
		}
	}


	//*******************************************************************
	//*******************************************************************
	void repair_timer_start(int rpCount) { 
		r[rpCount].RepairTimer.startTimer(Config.repairPenalty_ms);

		if (isLeft)
		println("Repair Left "+(rpCount+1)+" started!");
		else
		println("Repair Right "+(rpCount+1)+" started!");
	}

	//*******************************************************************
	//*******************************************************************
	void repair_timer_check(int rpCount) {
		if (r[rpCount].RepairTimer.getStatus())
		{
			if (r[rpCount].RepairTimer.getTimeMs() > 0)
			{
				if (StateMachine.isInterval()) {
					r[rpCount].RepairTimer.resetStopWatch();
					println("Repair "+(rpCount+1)+" reseted!");
				}
			}
			else
			{
				r[rpCount].RepairTimer.resetStopWatch();
				RepairCount--;
				println("Repair OUT: "+shortName+":"+(rpCount+1)+" @"+(isLeft?"left":"right"));
				r[rpCount].setState("play");
			}
		}
		else
		r[rpCount].setState("play");	
	}

	//*******************************************************************
	void substitute_timer_start(int subCount) {
		r[subCount].SubstituteTimer.startTimer(Config.substitutionMaxTime_ms);
	}

	//*******************************************************************
	public void double_yellow_timer_start(int rpCount) {
		r[rpCount].DoubleYellowTimer.startTimer(Config.doubleYellowPenalty_ms);
		if (isLeft)
		println("Double Yellow Left "+(rpCount+1)+" started!");
		else
		println("Double Yellow Right "+(rpCount+1)+" started!");
	}

	//*******************************************************************
	public void double_yellow_timer_check(int rpCount) {
		if (r[rpCount].DoubleYellowTimer.getStatus())
		{
			if (r[rpCount].DoubleYellowTimer.getTimeMs() == 0)
			{
				r[rpCount].DoubleYellowTimer.resetStopWatch();
				DoubleYellowCardCount--;
				println("Double Yellow end: "+shortName+":"+(rpCount+1)+" @"+(isLeft?"left":"right"));
				r[rpCount].setState("play");
			}
		}
		else
		r[rpCount].setState("play");
	}

	//*******************************************************************
	void checkflags() {
		int i;  
		if (this.newRepair) {
			while (this.nOfRepairs > 0) {
				for (i = 0; i < 3; i++) if (this.r[i].state == "play") break;
				//				if (i < 3) { TODO: What's the point of this?
				this.repair_timer_start(i);
				this.RepairCount++;
				this.r[i].setState("repair");	  
				// Hack: send command only on game change
				//				}
				this.nOfRepairs--;
			}
			if(this.isLeft) event_message_v2(ButtonsEnum.BTN_L_REPAIR, true);
			else event_message_v2(ButtonsEnum.BTN_R_REPAIR, true);
			this.newRepair = false;
			this.nOfRepairs = 1;
		}

		if (this.newYellowCard) {
			this.YellowCardCount = 1;
			this.r[4].setState("yellow");	  
			this.newYellowCard = false;

			// Hack: send command only on game change
			if(this.isLeft) event_message_v2(ButtonsEnum.BTN_L_YELLOW, true);
			else event_message_v2(ButtonsEnum.BTN_R_YELLOW, true);
		}

		if (this.newRedCard) {
			this.RedCardCount++;
			for (i = 3; i >= 0; i--) if (this.r[i].state == "play") break;
			if (i >= 0 ) {
				this.r[i].setState("red");	  

				// Hack: send command only on game change
				if(this.isLeft) event_message_v2(ButtonsEnum.BTN_L_RED, true);
				else event_message_v2(ButtonsEnum.BTN_R_RED, true);
			}
			this.newRedCard = false;
		}

		if (this.newDoubleYellow) {
			for (i = 3; i >= 0; i--) if (this.r[i].state == "play") break;
			if (i >= 0 ) {
				this.double_yellow_timer_start(i);
				this.r[i].setState("doubleyellow");	  
				this.r[4].setState("play");	  
				this.DoubleYellowCardCount++;
				this.YellowCardCount = 0;

				if(this.isLeft) send_event_v2(""+COMM_DOUBLE_YELLOW, "Double Yellow", this, -1);
				else send_event_v2(""+COMM_DOUBLE_YELLOW, "Double Yellow", this, -1);    // TODO: Same as line above

			}
			this.newDoubleYellow = false;
		}

		if (this.newPenaltyKick) {
			this.PenaltyCount++;
			this.newPenaltyKick=false;
		}
	}

	//*******************************************************************
	void substitute(int robotID) {    
		if (robotID > 0){
			send_event_v2(""+COMM_SUBSTITUTION, "substituting", this, robotID);
			this.nOfSubstitutions++;
			println("substituting robot " + robotID + " (on field) for robot (outside field) - " + nOfSubstitutions + " done.");
		}
/* @mbc Robot IDs are virtual [0 to 4] and corresponds to each of the circles in the interface
		for (int i = 0; i < r.length; i++) {
			if (this.r[i].state.equals("play") || this.r[i].state.equals("yellow")) {    // only robots that are in play can substitute
				send_event_v2(""+COMM_SUBSTITUTION, "substituting", this, robotID);
				this.substitute_timer_start(i);
				println("substituting robot " + i + " (on field) for robot " + robotID + " (outside field)");
				break;
			}
		}  */
	}
	
	//*******************************************************************
	public int numberOfPlayingRobots()
	{
		int i, count;
		for (i = 0, count = 0; i < 5; i++)
		if (this.r[i].state.equals("play") || this.r[i].state.equals("yellow")) count++;
		return count;
	}

	//*******************************************************************
	void updateUI() {
		if(connectedClient != null && !connectedClient.active())
		{
			println("Connection to team \"" + longName + "\" dropped.");
			Log.logMessage("Team " + shortName + " dropped");
			BaseStationServer.disconnect(connectedClient);
			resetname();
			connectedClient = null;
		}

		//team names
		String sn=shortName;
		String ln=longName;
		if (sn.length()>Config.maxShortName) sn=shortName.substring(0, Config.maxShortName);
		if (ln.length()>Config.maxLongName) ln=longName.substring(0, Config.maxLongName);
		rectMode(CENTER);
		fill(255);

		textFont(teamFont);
		textAlign(CENTER, CENTER);    
		if (isLeft) text(sn, 163, 50);
		else text(sn, 837, 50);

		textFont(panelFont);
		if (isLeft) text(ln, 163, 90);
		else text(ln, 837, 90);

		for (int i=0; i < r.length; i++) {
			r[i].RepairTimer.updateStopWatch();
			r[i].SubstituteTimer.updateStopWatch();
			r[i].DoubleYellowTimer.updateStopWatch();
		}

		for (int i=0; i < 4; i++) {
			if (r[i].state == "repair") repair_timer_check(i);
		}

		for (int i=0; i < 4; i++) {
			if (r[i].state == "doubleyellow") double_yellow_timer_check(i);
		}    

		for (int i=0; i<5; i++)
			r[i].updateUI(colorTeam,isLeft);
		
		textAlign(LEFT, BOTTOM);
		textFont(debugFont);
		fill(#ffff00);
		textLeading(20);
		String ts="Goals."+this.Score+" Penalty:"+this.PenaltyCount+"\nYellow:"+this.YellowCardCount+" Red:"+this.RedCardCount+"\nRepair:"+this.RepairCount+" 2xYellow:"+this.DoubleYellowCardCount;
		if (isLeft) text(ts, 40, height-18);
		else text(ts, width - 190, height-18);
	}

	//*******************************************************************
	boolean IPBelongs(String clientipstr){
		if(this.unicastIP == null)
		return false;

		String[] iptokens;

		if (!clientipstr.equals("0:0:0:0:0:0:0:1")) {
			iptokens=split(clientipstr,'.');
			if (iptokens!=null) clientipstr=iptokens[0]+"."+iptokens[1]+"."+iptokens[2]+".*";
		}

		return this.unicastIP.equals(clientipstr);
	}
}
