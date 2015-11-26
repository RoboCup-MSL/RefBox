static class StateMachine
{
  
  private static boolean needUpdate = false; 
  private static boolean btnOn = false;
  private static ButtonsEnum btnCurrent = ButtonsEnum.BTN_ILLEGAL;
  private static ButtonsEnum btnPrev = ButtonsEnum.BTN_ILLEGAL;
  
  private static GameStateEnum gsCurrent = GameStateEnum.GS_PREGAME;
  private static GameStateEnum gsPrev = GameStateEnum.GS_ILLEGAL;
  
  public static boolean setpiece = false;
  public static boolean setpiece_cyan = false;
  public static ButtonsEnum setpiece_button = null;
  
  public static boolean firstKickoffCyan = true;
  
  
  public static void Update(ButtonsEnum click_btn, boolean on)
  {
    //println("Updating clicked button: " + click_btn.getValue());
    btnCurrent = click_btn;
    btnOn = on;
    needUpdate = true;
    
    StateMachineRefresh();
  }
  
  private static void StateMachineRefresh()
  {
    GameStateEnum nextGS = GameStateEnum.newInstance(gsCurrent);
    GameStateEnum saveGS = GameStateEnum.newInstance(gsCurrent);
    
    // Check popup response
    if(Popup.hasNewResponse())
    {
      switch(Popup.getType())
      {
        case POPUP_RESET:
        {
          if(Popup.getResponse().equals("yes"))
          {
            send_event_v2(cCommcmds[CMDID_COMMON_RESET], Commcmds[CMDID_COMMON_RESET], null);
            reset();
          }
          break;
        }
        
        case POPUP_ENDPART:
        {
          if(Popup.getResponse().equals("yes"))
          {
            gsCurrent = SwitchGamePart();
            gsPrev = saveGS;
            
            send_event_v2(cCommcmds[CMDID_COMMON_HALFTIME], Commcmds[CMDID_COMMON_HALFTIME], null);
          }
          break;
        }
        
        case POPUP_TEAMSELECTION:
        {
          Team t = null;
          if(Popup.getResponse().equals("cyan"))
          {
            println("cyan - " + teamselect.getString("shortname8"));
            t = teamA;
          }else{
            println("magenta - " + teamselect.getString("shortname8"));
            t = teamB;
          }
          
          if(t != null)
          {
            t.shortName=teamselect.getString("shortname8");
            t.longName=teamselect.getString("longame24");
            t.unicastIP = teamselect.getString("UnicastAddr");
            t.multicastIP = teamselect.getString("MulticastAddr");
            connectingClient.write(COMM_WELCOME);
            connectingClient = null;
          }
          break;
        }
      }
      
      needUpdate = false;
      Popup.close();
      return;
    }
    
    if(needUpdate)
    {
      //println("Updating state machine: btn " + btnCurrent.getValue());
      
      
      // Goal buttons
      int add = (btnOn ? +1 : -1);
      if(btnCurrent.isGoal())
      {
        if(btnCurrent.isCyan())
          teamA.Score+=add;
        else
          teamB.Score+=add;
      }else if(btnCurrent.isReset())
      {
        Popup.show(PopupTypeEnum.POPUP_RESET, MSG_RESET, "yes", "no");
        needUpdate = false;
        return;
      }else if(btnCurrent.isEndPart())
      {
        Popup.show(PopupTypeEnum.POPUP_ENDPART, MSG_HALFTIME, "yes", "no");
        needUpdate = false;
        return;
      }
      else if(btnCurrent.isRepair())
      {
        if(btnCurrent.isCyan())
          teamA.newRepair=btnOn;
        else
          teamB.newRepair=btnOn;
      }
      else if(btnCurrent.isRed())
      {
        if(btnCurrent.isCyan())
          teamA.newRedCard=btnOn;
        else
          teamB.newRedCard=btnOn;
      }
      else if(btnCurrent.isYellow())
      {
        Team t = teamA;
        if(!btnCurrent.isCyan())
          t = teamB;
        
        if (t.YellowCardCount==1)
          t.newDoubleYellow = btnOn;
        else
          t.newYellowCard = btnOn;
      }
      
      switch(gsCurrent)
      {
        // PRE-GAME and Half Times
        case GS_PREGAME:
        case GS_HALFTIME:
        case GS_OVERTIME:
        case GS_HALFTIME_OVERTIME:
          if(btnCurrent == ButtonsEnum.BTN_START)
          {
            resetStartTime();
            nextGS = SwitchRunningStopped();
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
          }else if(btnCurrent == ButtonsEnum.BTN_M_KICKOFF){
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
            SetSetpiece(btnCurrent.isCyan(), btnCurrent);
          else if(btnCurrent.isStart()){
            nextGS = SwitchRunningStopped();
          }
          else if(btnCurrent.isStop())
            ResetSetpiece();
          else if(btnCurrent.isEndPart())
            nextGS = SwitchGamePart();
          
          break;
        
        case GS_GAMEON_H1:
        case GS_GAMEON_H2:
        case GS_GAMEON_H3:
        case GS_GAMEON_H4:
          if(setpiece)
            ResetSetpiece();
            
          if(btnCurrent == ButtonsEnum.BTN_STOP)
          {
            nextGS = SwitchRunningStopped();
          }
            
          break;
          
        case GS_PENALTIES:
          if(btnCurrent.isSetPiece())
            SetSetpiece(btnCurrent.isCyan(), btnCurrent);
          else if(btnCurrent.isStop())
            ResetSetpiece();
          else if(btnCurrent.isEndPart())
            nextGS = SwitchGamePart();
          else if(btnCurrent.isStart())
            nextGS = SwitchRunningStopped();
            
          break;
        
        case GS_PENALTIES_ON:
          if(setpiece)
            ResetSetpiece();
          if(btnCurrent.isStop())
            nextGS = SwitchRunningStopped();
          break;
      }
      
      if(nextGS != null)
      {
        // Update split time
        if(nextGS.isRunning())
          resumeSplitTimer();
        else
          stopSplitTimer();
        
        gsCurrent = nextGS;
        gsPrev = saveGS;
        
        println("gs: " + gsPrev.getValue() + " -> " + nextGS.getValue());
        
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
  
  private static void ResetSetpiece()
  {
    setpiece = false;
  }
  
  private static void SetSetpiece(boolean cyan, ButtonsEnum btn)
  {
      setpiece = true;
      setpiece_cyan = cyan;
      setpiece_button = btn;
  }
  
  public static GameStateEnum GetCurrentGameState()
  {
    return gsCurrent;
  }
  
  public static String GetCurrentGameStateString()
  {
    return gsCurrent.getName();
  }
  
  public static void reset()
  {
      needUpdate = false; 
      btnCurrent = ButtonsEnum.BTN_ILLEGAL;
      btnPrev = ButtonsEnum.BTN_ILLEGAL;
      gsCurrent = GameStateEnum.GS_PREGAME;
      gsPrev = GameStateEnum.GS_ILLEGAL;
      resetStartTime();
      
      teamA.reset();
      teamB.reset();        
      teamA.resetname();
      teamB.resetname();        
      resetStartTime();
      Log.createLog();
      
      send_to_basestation("" + COMM_RESET);
      
      BaseStationServer.stop();
      BaseStationServer = new Server(mainApplet, Config.BASESTATIONSERVERPORT);
  }
  
  public static boolean is1stHalf()
  {
    return gsCurrent == GameStateEnum.GS_GAMESTOP_H1 || gsCurrent == GameStateEnum.GS_GAMEON_H1;
  }
  
  public static boolean is2ndHalf()
  {
    return gsCurrent == GameStateEnum.GS_GAMESTOP_H2 || gsCurrent == GameStateEnum.GS_GAMEON_H1;
  }
  
  public static boolean is3rdHalf()
  {
    return gsCurrent == GameStateEnum.GS_GAMESTOP_H3 || gsCurrent == GameStateEnum.GS_GAMEON_H3;
  }
  
  public static boolean is4thHalf()
  {
    return gsCurrent == GameStateEnum.GS_GAMESTOP_H4 || gsCurrent == GameStateEnum.GS_GAMEON_H4;
  }
}










void StateMachineCheck() {
  //println("state machine check..."+CurrentGameState);
  //if (Popup.isEnabled()) Popup.check();
  
  StateMachine.StateMachineRefresh();
  
/*
  if (CurrentGameState==0) {  //"Pre-Game"
    bSlider[0].enable();
    if (bTeamAcmds[0].isActive() || bTeamBcmds[0].isActive()) {  //kickoff
      CurrentGameState=1;
      bSlider[0].disable();
      teamA.reset();
      teamB.reset();
      LastKickOff=(bTeamAcmds[0].isActive()?'a':'b');
      resetStartTime();
      send_to_basestation(COMM_FIRST_HALF);
    }
  } else if (CurrentGameState==1) {  //"Game - 1st Half"
      checkflags();
  } else if (CurrentGameState==2) {  //"Game - Halftime"
    if (bTeamAcmds[0].isActive() || bTeamBcmds[0].isActive()) { //kickoff
      CurrentGameState=3;
      LastKickOff=(bTeamAcmds[0].isActive()?'a':'b');
      resetStartTime();
      doubleyellowtimercheckresume();
      send_to_basestation(COMM_SECOND_HALF);
    }
  } else if (CurrentGameState==3) {  //"Game - 2nd Half"
      checkflags();
  } else if (CurrentGameState==4) {  //"EndGame"
    if (bTeamAcmds[0].isActive() || bTeamBcmds[0].isActive()) {  //kickoff
      CurrentGameState=5;
      LastKickOff=(bTeamAcmds[0].isActive()?'a':'b');
      resetStartTime();
      doubleyellowtimercheckresume();
      send_to_basestation(COMM_FIRST_HALF_OVERTIME);
    }
  } else if (CurrentGameState==5) {  //"Overtime - 1st"
      checkflags();
  } else if (CurrentGameState==6) {  //"Overtime - Switch"
    if (bTeamAcmds[0].isActive() || bTeamBcmds[0].isActive()) { //kickoff
      CurrentGameState=7;
      resetStartTime();
      doubleyellowtimercheckresume();
      send_to_basestation(COMM_SECOND_HALF_OVERTIME);
    }
  } else if (CurrentGameState==7) {  //"Overtime - 2nd"
      checkflags();
  } else if (CurrentGameState==8) {  //"Penalty"
  } else if (CurrentGameState==9) {  //"GameOver"
    send_to_basestation(COMM_GAMEOVER);
    //resetgame();
  }
*/
}

//==============
void checkpopup() {
  /*if (bCommoncmds[5].isActive()) checkresetpopup();  //"RESET"
  else if (bCommoncmds[4].isActive()) checkendhalfpopup(); //"ENDHALF"
  else if (StateMachine.GetCurrentGameState() == GameStateEnum.GS_PREGAME) checkteampopup();*/
}

void checkresetpopup() {  //RESET
    //if (bPopup[0].isActive())  resetgame();  //popup yes
    if (bPopup[0].isActive() || bPopup[1].isActive())  {
      bCommoncmds[5].enable();  //reset
      Popup.close();
    }
    //else println("outside click...");
}

void checkteampopup(){
  if (bPopup[0].isActive()) {
    println("cyan - " + teamselect.getString("shortname8"));
    teamA.shortName=teamselect.getString("shortname8");
    teamA.longName=teamselect.getString("longame24");
    teamA.unicastIP = teamselect.getString("UnicastAddr");
    teamA.multicastIP = teamselect.getString("MulticastAddr");
    Popup.close();
  } 
  else if (bPopup[1].isActive()) {
    println("magenta - " + teamselect.getString("shortname8"));
    teamB.shortName=teamselect.getString("shortname8");
    teamB.longName=teamselect.getString("longame24");
    teamB.unicastIP = teamselect.getString("UnicastAddr");
    teamB.multicastIP = teamselect.getString("MulticastAddr");
    Popup.close();
  }
  //else println("outside click...");
}

void checkflags() {
  teamA.checkflags();
  teamB.checkflags();
}

void doubleyellowtimercheck() {
  if (teamA.DoubleYellowCardCount>0)  teamA.setDoubleYellowOutRemain();
  if (teamB.DoubleYellowCardCount>0)  teamB.setDoubleYellowOutRemain();
}

void doubleyellowtimercheckresume() {
  if (teamA.DoubleYellowCardCount>0)  teamA.resumeDoubleYellowOutRemain();
  if (teamB.DoubleYellowCardCount>0)  teamB.resumeDoubleYellowOutRemain();
}
