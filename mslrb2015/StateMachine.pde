static class StateMachine
{

	private static boolean needUpdate = false; 
	private static boolean btnOn = false;
	private static ButtonsEnum btnCurrent = ButtonsEnum.BTN_ILLEGAL;
	private static ButtonsEnum btnPrev = ButtonsEnum.BTN_ILLEGAL;
	public static GameStateEnum gsCurrent = GameStateEnum.GS_PREGAME;
	private static GameStateEnum gsPrev = GameStateEnum.GS_ILLEGAL;

	public static boolean setpiece = false;
	public static boolean setpiece_left = false;
	public static ButtonsEnum setpiece_button = null;

	public static boolean firstKickoffLeft = true;
	private static boolean done = true;

	public static boolean validInput = true;

	public static void Update(ButtonsEnum click_btn, boolean on) //If on==True then active
	{
		btnCurrent = click_btn;
		btnOn = on;
		needUpdate = true; 
		StateMachineRefresh();
	}

	//************************************************************************
	// Basic state machine main refresh
	//************************************************************************
	private static void StateMachineRefresh()
	{
		done = false;	// This boolean blocks access to the StateMachine by main draw() function while something is in course				
		GameStateEnum nextGS = GameStateEnum.newInstance(gsCurrent);
		GameStateEnum saveGS = GameStateEnum.newInstance(gsCurrent);
		
		// Check popup response when popup is ON
		if(Popup.hasNewResponse())
		{
			switch(Popup.getType())
			{
			case POPUP_HELP:
				{
					Popup.close();
					break;
				}

			case POPUP_ALIVE:
				{
					Popup.close();
					buttonFromEnum(ButtonsEnum.BTN_START).disable();
					setpiece = false;
					break;
				}

			case POPUP_RESET:
				{
					if(Popup.getResponse().equals("yes"))
					{
						send_event_v2(COMM_RESET, Description.get(COMM_RESET), null, -1);
						Popup.close();
						btnCurrent = ButtonsEnum.BTN_ILLEGAL;		// Clear up current button, just in case
						mainApplet.redraw();						// redraw screen to turn off Reset Popup
						
						// Show wait popup - this will be reset when a new pre-game starts
						Popup.show(PopupTypeEnum.POPUP_WAIT, MSG_WAIT, 0, 0, 0, 24, 380, 100);
						gsCurrent = GameStateEnum.GS_RESET;         // Force Reset state
						needUpdate = true;							// and enforce update of the state machine
						done = true;
						return;
					} //<>// //<>//
					Popup.close();
					break;
				}
				
			case POPUP_ENDPART:
				{
					if(Popup.getResponse().equals("yes"))
					{
						gsCurrent = SwitchGamePart();
						gsPrev = saveGS;
						mainWatch.resetStopWatch();
						playTimeWatch.resetStopWatch();
						SetPieceDelay.resetStopWatch();
						SetPieceDelay.stopTimer();

						if (COMM_HALF_TIME.equals("End Game"))
						send_event_v2(COMM_END_GAME, Description.get(COMM_END_GAME), null, -1);
						else
						send_event_v2(COMM_HALF_TIME, Description.get(COMM_HALF_TIME), null, -1);            
					}
					Popup.close();
					break;
				}
				
			case POPUP_TEAMSELECTION:
				{
					Team t = null;
					if(Popup.getResponse().equals("OK"))
					{
						if(teamA.connectedClient == null || !teamA.connectedClient.active())
						{
							Log.logMessage("Connection from " + connectingClient.ip() + " accepted - Left");
							t = teamA;
						}
						else
						{
							Log.logMessage("Connection from " + connectingClient.ip() + " accepted - Left");
							t = teamB;
						}
						
					}
					else if(Popup.getResponse().equals("Left"))
					{
						Log.logMessage("Connection from " + connectingClient.ip() + " accepted - Left");
						t = teamA;
					}else{
						Log.logMessage("Connection from " + connectingClient.ip() + " accepted - Right");
						t = teamB;
					}
					
					if(t != null)
					t.teamConnected(teamselect);

					Popup.close();          
					break;
				}
				
			case POPUP_REPAIRL:
				{
					if(Popup.getResponse().equals("1")) teamA.nOfRepairs = 1; 
					if(Popup.getResponse().equals("2")) teamA.nOfRepairs = 2;
					if(Popup.getResponse().equals("3")) teamA.nOfRepairs = 3;
					Popup.close();
					break;
				}
				
			case POPUP_REPAIRR:
				{
					if(Popup.getResponse().equals("1")) teamB.nOfRepairs = 1; 
					if(Popup.getResponse().equals("2")) teamB.nOfRepairs = 2;
					if(Popup.getResponse().equals("3")) teamB.nOfRepairs = 3;
					Popup.close();
					break;
				}

			case POPUP_SUBS:
				{
					if (Popup.getResponse().equals("Apply")) {
						for (int t = 0; t < tBox.length; t++)
						{
							if (tBox[t].checkInput() == false) {
								validInput = false;
								break;
							}
							validInput = true;
						}
						if (validInput) {
							for (int t = 0; t < tBox.length; t++)
							{
								if (tBox[t].value != "0") {
									if (t < 3) {
										if(!teamA.newSubstitution) teamA.newSubstitution = true;
										teamA.substitute(int(tBox[t].value));
									}
									else {
										if (!teamB.newSubstitution) teamB.newSubstitution = true;
										teamB.substitute(int(tBox[t].value));
									}
								}
								tBox[t].value = "0";
								tBox[t].hide();
							}
							if (teamA.newSubstitution || teamB.newSubstitution) {
								SetPieceDelay.startTimer(Config.substitutionMaxTime_ms);
								println ("Substitution timer (s): " + Config.substitutionMaxTime_ms/1000);
							}
							Popup.close();
						}            
					}
					else if (Popup.getResponse().equals("Cancel")) {
						for (int t = 0; t < tBox.length; t++)
						{
							tBox[t].value = "0";
							tBox[t].hide();
						}
						validInput = true;
						Popup.close();
					}
					break;
				}
				
			case POPUP_CONFIG:
				{
					for (int s = 0; s < bSlider.length; s++)
					{
						bSlider[s].disable();
						if(StateMachine.GetCurrentGameState() != GameStateEnum.GS_PREGAME)
						{
							//bSlider[i].disable();
						}else{
							//bSlider[i].enable();
						}
					}
					Popup.close();
					break;
				}
			}
			
			needUpdate = false;
			done = true;
			return;
		}
		
		if(needUpdate)
		{
			// Goal buttons
			int add = (btnOn ? +1 : -1);
			int i;
			
			needUpdate = false;			// Clear flag at the begining so that internal code can turn it ON again
			if(btnCurrent.isGoal())
			{
				if(btnCurrent.isLeft()) teamA.Score+=add;
				else teamB.Score+=add;
			}
			else if(btnCurrent.isReset())
			{
				Popup.show(PopupTypeEnum.POPUP_RESET, MSG_RESET, 1, 0, 2, 24, 380, 200);
				done = true;
				return;
			}
			else if(btnCurrent.isEndPart())
			{
				Popup.show(PopupTypeEnum.POPUP_ENDPART, MSG_HALFTIME, 1, 0, 2, 24, 380, 200);
				done = true;
				return;
			}
			else if(btnCurrent.isAlive())
			{
				Popup.show(PopupTypeEnum.POPUP_ALIVE, MSG_ISALIVE, 0, 8, 0, 24, 380, 200);
//				done = true;
//				return;
			}
			
			else if(btnCurrent.isRepair())
			{
				if(btnCurrent.isLeft()){
					teamA.newRepair=btnOn;
					if (btnOn) {
						i = teamA.numberOfPlayingRobots() - 2;
						println (i);
						if (i == 3)
						Popup.show(PopupTypeEnum.POPUP_REPAIRL, MSG_REPAIR, 5, 6, 7, 24, 380, 200);
						else if(i == 2)
						Popup.show(PopupTypeEnum.POPUP_REPAIRL, MSG_REPAIR, 5, 6, 0, 24, 380, 200);		  
					}
				}
				else {
					teamB.newRepair=btnOn;
					if (btnOn) {
						i = teamB.numberOfPlayingRobots() - 2;
						println (i);
						if (i == 3)
						Popup.show(PopupTypeEnum.POPUP_REPAIRR, MSG_REPAIR, 5, 6, 7, 24, 380, 200);		  
						else if(i == 2)
						Popup.show(PopupTypeEnum.POPUP_REPAIRR, MSG_REPAIR, 5, 6, 0, 24, 380, 200);		  
					}
				}
			}
			else if(btnCurrent.isRed())
			{
				if(btnCurrent.isLeft())
				teamA.newRedCard=btnOn;
				else
				teamB.newRedCard=btnOn;
			}
			else if(btnCurrent.isYellow())
			{
				Team t = teamA;
				if(!btnCurrent.isLeft())
				t = teamB;
				
				if (t.YellowCardCount==1)
				t.newDoubleYellow = btnOn;
				else
				t.newYellowCard = btnOn;
			}
			else if(btnCurrent.isStop())
			{
				SetPieceDelay.resetStopWatch();
				SetPieceDelay.stopTimer();
				forceKickoff = false; 
			}
			else if(btnCurrent.isSubs())
			{
				Popup.show(PopupTypeEnum.POPUP_SUBS, MSG_SUBS, 9, 10, 0, 24, 840, 600);
				for (int t = 0; t < tBox.length; t++)
				{
					tBox[t].show();
				}
				
			}
			else if(btnCurrent.isConfig())
			{
				Popup.show(PopupTypeEnum.POPUP_CONFIG, MSG_CONFIG, 8, 0, 0, 24, 380, 300);
				for (int s = 0; s < bSlider.length; s++)
				{
					//bSlider[s].enable();
					if(StateMachine.GetCurrentGameState() != GameStateEnum.GS_PREGAME)
					{
						bSlider[s].disable();
					}else{
						bSlider[s].enable();
					}
				}
			}
			
			println ("Current: " + gsCurrent);
			switch(gsCurrent)
			{
				
				// PRE-GAME and Half Times
			case GS_PREGAME:
			case GS_HALFTIME:
			case GS_OVERTIME:
			case GS_HALFTIME_OVERTIME:
				if(btnCurrent == ButtonsEnum.BTN_START)
				{
					mainWatch.resetStopWatch();
					playTimeWatch.resetStopWatch(); 
					SetPieceDelay.resetStopWatch();	
					SetPieceDelay.stopTimer();			
					nextGS = SwitchRunningStopped();
					switch(nextGS)
					{
					case GS_GAMEON_H1: send_event_v2(COMM_FIRST_HALF,COMM_FIRST_HALF,null,-1); break;
					case GS_GAMEON_H2: send_event_v2(COMM_SECOND_HALF,COMM_SECOND_HALF,null,-1); break;
					case GS_GAMEON_H3: send_event_v2(COMM_FIRST_HALF_OVERTIME,COMM_FIRST_HALF_OVERTIME, null,-1); break;
					case GS_GAMEON_H4: send_event_v2(COMM_SECOND_HALF_OVERTIME,COMM_SECOND_HALF_OVERTIME,null,-1); break;
					}
				}
				else if(btnCurrent == ButtonsEnum.BTN_STOP)
				{
					if(setpiece)
					ResetSetpiece();
				}
				else if(btnCurrent == ButtonsEnum.BTN_L_KICKOFF)
				{
					// Save first kickoff
					if(gsCurrent == GameStateEnum.GS_PREGAME)
					firstKickoffLeft = true;
					SetSetpiece(true, btnCurrent);
				}
				else if(btnCurrent == ButtonsEnum.BTN_R_KICKOFF)
				{
					if(gsCurrent == GameStateEnum.GS_PREGAME)
					firstKickoffLeft = false;
					SetSetpiece(false, btnCurrent);
				}
				
				break;
				
			case GS_GAMESTOP_H1:
			case GS_GAMESTOP_H2:
			case GS_GAMESTOP_H3:
			case GS_GAMESTOP_H4:
				if(btnCurrent.isSetPiece()){
					SetSetpiece(btnCurrent.isLeft(), btnCurrent);
					println("Set piece ON");
				}
				else if(btnCurrent.isStart()){
					nextGS = SwitchRunningStopped();
				}
				else if(btnCurrent.isStop()) 
				{
					ResetSetpiece();
					SetPieceDelay.resetStopWatch();
					SetPieceDelay.stopTimer();
				}
				else if(btnCurrent.isEndPart()){
					nextGS = SwitchGamePart();
				}
				else {
					println("Set piece not ON");
				}
				break;
				
			case GS_GAMEON_H1:
			case GS_GAMEON_H2:
			case GS_GAMEON_H3:
			case GS_GAMEON_H4:
				if(setpiece)
				ResetSetpiece();
				
				if(btnCurrent == ButtonsEnum.BTN_STOP)		// Button stop pressed
				{
					nextGS = SwitchRunningStopped();
				}
				break;
				
			case GS_PENALTIES:
				if(btnCurrent.isSetPiece())                       // Kick Off either, Penalty either, DropBall
				SetSetpiece(btnCurrent.isLeft(), btnCurrent);
				else if(btnCurrent.isStop()) {
					ResetSetpiece();
					SetPieceDelay.resetStopWatch();
					SetPieceDelay.stopTimer();
				}
				else if(btnCurrent.isEndPart())
				nextGS = SwitchGamePart();
				else if(btnCurrent.isStart())
				nextGS = SwitchRunningStopped();
				break;
				
			case GS_PENALTIES_ON:
				if(setpiece)
				ResetSetpiece(); //<>// //<>//
				if(btnCurrent.isStop()){
					SetPieceDelay.resetStopWatch();	
					SetPieceDelay.stopTimer();			
					nextGS = SwitchRunningStopped();
				}
				break;
				//<>//
			case GS_ENDGAME:
				break;
				
			case GS_RESET:			// Resets the game and return to force a new StateMachine Update
				reset();
				saveData();
				needUpdate = true;
				done = true;
				return;
			}
			
			if(nextGS != null)        //What to do when there is a new game state
			{
				
				gsCurrent = nextGS;
				gsPrev = saveGS;
				
				if(gsCurrent.getValue() != gsPrev.getValue())
				{
					teamA.checkflags();
					teamB.checkflags();
				}
			}		
			btnPrev = btnCurrent;      

		}
		done = true;
	}

	//************************************************************************
	// 
	//************************************************************************
	private static GameStateEnum SwitchGamePart()
	{
		switch(gsCurrent)
		{
		case GS_GAMESTOP_H1: return GameStateEnum.GS_HALFTIME;
		case GS_GAMESTOP_H2: return GameStateEnum.GS_OVERTIME;
		case GS_GAMESTOP_H3: return GameStateEnum.GS_HALFTIME_OVERTIME;
		case GS_GAMESTOP_H4: return GameStateEnum.GS_PENALTIES;
		case GS_PENALTIES: return GameStateEnum.GS_ENDGAME;
		}
		
		return null;
	}

	//************************************************************************
	// 
	//************************************************************************
	private static GameStateEnum SwitchRunningStopped()
	{
		switch(gsCurrent)
		{
		case GS_GAMEON_H1: return GameStateEnum.GS_GAMESTOP_H1;
		case GS_GAMEON_H2: return GameStateEnum.GS_GAMESTOP_H2;
		case GS_GAMEON_H3: return GameStateEnum.GS_GAMESTOP_H3;
		case GS_GAMEON_H4: return GameStateEnum.GS_GAMESTOP_H4;
			
		case GS_PREGAME:
		case GS_GAMESTOP_H1:
			return GameStateEnum.GS_GAMEON_H1;
		case GS_HALFTIME:
		case GS_GAMESTOP_H2:
			return GameStateEnum.GS_GAMEON_H2;
		case GS_OVERTIME:
		case GS_GAMESTOP_H3:
			return GameStateEnum.GS_GAMEON_H3;
		case GS_HALFTIME_OVERTIME:
		case GS_GAMESTOP_H4:
			return GameStateEnum.GS_GAMEON_H4;
			
		case GS_PENALTIES: return GameStateEnum.GS_PENALTIES_ON;
		case GS_PENALTIES_ON: return GameStateEnum.GS_PENALTIES;
		}
		
		return null;
	}

	//************************************************************************
	// 
	//************************************************************************
	private static void ResetSetpiece()
	{
		setpiece = false;
	}

	//************************************************************************
	// 
	//************************************************************************
	private static void SetSetpiece(boolean left, ButtonsEnum btn)
	{
		println("SetPiece ON");
		setpiece = true;
		setpiece_left = left;
		setpiece_button = btn;
	}

	//************************************************************************
	// 
	//************************************************************************
	public static GameStateEnum GetCurrentGameState()
	{
		return gsCurrent;
	}

	//************************************************************************
	// 
	//************************************************************************
	public static String GetCurrentGameStateString()
	{
		if(gsCurrent != null)
		return gsCurrent.getName();
		else
		return "";
	}

	//************************************************************************
	// Reset after end of game
	//************************************************************************
	public static void reset()
	{
		try {
			buttonFromEnum(ButtonsEnum.BTN_PARK).disable();
			btnCurrent = ButtonsEnum.BTN_ILLEGAL;
			btnPrev = ButtonsEnum.BTN_ILLEGAL;
			gsCurrent = GameStateEnum.GS_PREGAME;
			gsPrev = GameStateEnum.GS_ILLEGAL;
			
			teamA.reset();
			teamB.reset();        
			teamA.resetname();
			teamB.resetname();        
			mainWatch.resetStopWatch();
			playTimeWatch.resetStopWatch();
			SetPieceDelay.resetStopWatch();
			SetPieceDelay.stopTimer();
		} catch(Exception e) {}
	}

	//************************************************************************
	// Save data on reset
	//************************************************************************
	public static void saveData()
	{
		try {

			LogMerger merger = new LogMerger(Log.getTimedName());
			merger.merge();		  
			Log.createLog();
			BaseStationServer.stop();
			BaseStationServer = new MyServer(mainApplet, Config.basestationServerPort);
		} catch(Exception e) {}

	}

	//************************************************************************
	// 
	//************************************************************************

	public static boolean isHalf()
	{
		return is1stHalf() || is2ndHalf() || is3rdHalf() || is4thHalf();
	}

	public static boolean isPreGame()
	{
		return gsCurrent == GameStateEnum.GS_PREGAME;
	}

	public static boolean is1stHalf()
	{
		return gsCurrent == GameStateEnum.GS_GAMESTOP_H1 || gsCurrent == GameStateEnum.GS_GAMEON_H1;
	}

	public static boolean is2ndHalf()
	{
		return gsCurrent == GameStateEnum.GS_GAMESTOP_H2 || gsCurrent == GameStateEnum.GS_GAMEON_H2;
	}

	public static boolean is3rdHalf()
	{
		return gsCurrent == GameStateEnum.GS_GAMESTOP_H3 || gsCurrent == GameStateEnum.GS_GAMEON_H3;
	}

	public static boolean is4thHalf()
	{
		return gsCurrent == GameStateEnum.GS_GAMESTOP_H4 || gsCurrent == GameStateEnum.GS_GAMEON_H4;
	}

	public static boolean isInterval() 
	{
		return gsCurrent == GameStateEnum.GS_HALFTIME || gsCurrent == GameStateEnum.GS_OVERTIME || gsCurrent == GameStateEnum.GS_HALFTIME_OVERTIME || gsCurrent == GameStateEnum.GS_GAMESTOP_H4 || gsCurrent == GameStateEnum.GS_PENALTIES;
	}
	
	public static boolean isDone()
	{
		return done;
	}

	//************************************************************************
	// 
	//************************************************************************
}

void StateMachineCheck() {
	if (StateMachine.isDone() == true) StateMachine.StateMachineRefresh();
}
