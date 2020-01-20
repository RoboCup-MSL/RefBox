static class StateMachine
{

	private static boolean needUpdate = false; 
	private static boolean btnOn = false;
	private static ButtonsEnum btnCurrent = ButtonsEnum.BTN_ILLEGAL;
	private static ButtonsEnum btnPrev = ButtonsEnum.BTN_ILLEGAL;
	public static GameStateEnum gsCurrent = GameStateEnum.GS_PREGAME;
	private static GameStateEnum gsPrev = GameStateEnum.GS_ILLEGAL;

	public static boolean setpiece = false;
	public static boolean setpiece_cyan = false;
	public static ButtonsEnum setpiece_button = null;

	public static boolean firstKickoffCyan = true;

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
		GameStateEnum nextGS = GameStateEnum.newInstance(gsCurrent);
		GameStateEnum saveGS = GameStateEnum.newInstance(gsCurrent);
		
		// Check popup response when popup is ON
		if(Popup.hasNewResponse())
		{
			switch(Popup.getType())
			{
			case POPUP_RESET:
				{
					if(Popup.getResponse().equals("yes"))
					{
						send_event_v2(cCommcmds[CMDID_COMMON_RESET], Commcmds[CMDID_COMMON_RESET], null);
						Popup.close();
						gsCurrent = GameStateEnum.GS_RESET;            // Game over
						needUpdate = true;						
						reset();
						//Popup.show(PopupTypeEnum.POPUP_WAIT, MSG_WAIT, 0, 0, 0, 24, 380, 100);
						return;
					} //<>// //<>//
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

						if (bCommoncmds[CMDID_COMMON_HALFTIME].Label.equals("End Game"))
						send_event_v2(cCommcmds[CMDID_COMMON_ENDGAME], Commcmds[CMDID_COMMON_ENDGAME], null);
						else
						send_event_v2(cCommcmds[CMDID_COMMON_HALFTIME], Commcmds[CMDID_COMMON_HALFTIME], null);            
					}
					break;
				}
				
			case POPUP_TEAMSELECTION:
				{
					Team t = null;
					if(Popup.getResponse().equals("Left"))
					{
						Log.logMessage("Connection from " + connectingClient.ip() + " accepted - Left");
						t = teamA;
					}else{
						Log.logMessage("Connection from " + connectingClient.ip() + " accepted - Right");
						t = teamB;
					}
					
					if(t != null)
						t.teamConnected(teamselect);          
					break;
				}
				
			case POPUP_REPAIRL:
				{
					if(Popup.getResponse().equals("1")) teamA.nOfRepairs = 1; 
					if(Popup.getResponse().equals("2")) teamA.nOfRepairs = 2;
					if(Popup.getResponse().equals("3")) teamA.nOfRepairs = 3;
					break;
				}
				
			case POPUP_REPAIRR:
				{
					if(Popup.getResponse().equals("1")) teamB.nOfRepairs = 1; 
					if(Popup.getResponse().equals("2")) teamB.nOfRepairs = 2;
					if(Popup.getResponse().equals("3")) teamB.nOfRepairs = 3;
					break;
				}
			}      
			needUpdate = false;
			Popup.close();
			return;
		}
		
		if(needUpdate)
		{
			// Goal buttons
			int add = (btnOn ? +1 : -1);
			int i;
			
			if(btnCurrent.isGoal())
			{
				if(btnCurrent.isLeft()) teamA.Score+=add;
				else teamB.Score+=add;
			}
			else if(btnCurrent.isReset())
			{
				Popup.show(PopupTypeEnum.POPUP_RESET, MSG_RESET, 1, 0, 2, 24, 380, 200);
				needUpdate = false;
				return;
			}
			else if(btnCurrent.isEndPart())
			{
				Popup.show(PopupTypeEnum.POPUP_ENDPART, MSG_HALFTIME, 1, 0, 2, 24, 380, 200);
				needUpdate = false;
				return;
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
					case GS_GAMEON_H1: send_to_basestation(COMM_FIRST_HALF + "","",-1); break;
					case GS_GAMEON_H2: send_to_basestation(COMM_SECOND_HALF + "","",-1); break;
					case GS_GAMEON_H3: send_to_basestation(COMM_FIRST_HALF_OVERTIME + "","",-1); break;
					case GS_GAMEON_H4: send_to_basestation(COMM_SECOND_HALF_OVERTIME + "","",-1); break;
					}
				}
				else if(btnCurrent == ButtonsEnum.BTN_STOP)
				{
					if(setpiece)
					ResetSetpiece();
				}
				else if(btnCurrent == ButtonsEnum.BTN_C_KICKOFF)
				{
					// Save first kickoff
					if(gsCurrent == GameStateEnum.GS_PREGAME)
					firstKickoffCyan = true;
					SetSetpiece(true, btnCurrent);
				}
				else if(btnCurrent == ButtonsEnum.BTN_M_KICKOFF)
				{
					if(gsCurrent == GameStateEnum.GS_PREGAME)
					firstKickoffCyan = false;
					SetSetpiece(false, btnCurrent);
				}
				
				break;
				
			case GS_GAMESTOP_H1:
			case GS_GAMESTOP_H2:
			case GS_GAMESTOP_H3:
			case GS_GAMESTOP_H4:
				if(btnCurrent.isSetPiece())
				SetSetpiece(btnCurrent.isLeft(), btnCurrent);
				else if(btnCurrent.isStart()){
					nextGS = SwitchRunningStopped();
				}
				else if(btnCurrent.isStop()) 
				{
					ResetSetpiece();
					SetPieceDelay.resetStopWatch();
					SetPieceDelay.stopTimer();
				}
				else if(btnCurrent.isEndPart())
				nextGS = SwitchGamePart();
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
				
			case GS_RESET:
				saveData();
				break;
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
			needUpdate = false;
		}
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
	private static void SetSetpiece(boolean cyan, ButtonsEnum btn)
	{
		setpiece = true;
		setpiece_cyan = cyan;
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
			send_to_basestation("" + COMM_RESET,"",-1);
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

}

//************************************************************************
// 
//************************************************************************
void StateMachineCheck() {
	StateMachine.StateMachineRefresh();
}
