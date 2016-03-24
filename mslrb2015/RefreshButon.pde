void RefreshButonStatus1() {
  
  switch(StateMachine.GetCurrentGameState())
  {
    // PRE-GAME
    case GS_PREGAME:
    
      buttonAdisableAll();  //team A commands
      buttonBdisableAll();  //team B commands
      buttonCdisable();     //common commands
      
      if(StateMachine.setpiece)
      {
        if(StateMachine.setpiece_cyan)
        {
          buttonFromEnum(ButtonsEnum.BTN_C_KICKOFF).activate();
          buttonFromEnum(ButtonsEnum.BTN_M_KICKOFF).disable();
        }else{
          buttonFromEnum(ButtonsEnum.BTN_C_KICKOFF).disable();
          buttonFromEnum(ButtonsEnum.BTN_M_KICKOFF).activate();
        }
        
        buttonFromEnum(ButtonsEnum.BTN_START).enable();
        buttonFromEnum(ButtonsEnum.BTN_STOP).enable();
      }else{
        buttonFromEnum(ButtonsEnum.BTN_C_KICKOFF).enable();
        buttonFromEnum(ButtonsEnum.BTN_M_KICKOFF).enable();
        
        buttonFromEnum(ButtonsEnum.BTN_START).disable();
        buttonFromEnum(ButtonsEnum.BTN_STOP).activate();
      }
      
      buttonFromEnum(ButtonsEnum.BTN_RESET).enable();

      break;
      
    case GS_GAMEON_H1:
    case GS_GAMEON_H2:
    case GS_GAMEON_H3:
    case GS_GAMEON_H4:
      refreshbutton_game_on();
      break;
    
    case GS_GAMESTOP_H1:
    case GS_GAMESTOP_H2:
    case GS_GAMESTOP_H3:
    case GS_GAMESTOP_H4:
      refreshbutton_game_stopped();
      if(StateMachine.setpiece){
        buttonFromEnum(StateMachine.setpiece_button).activate();
        buttonFromEnum(ButtonsEnum.BTN_START).enable();
      }else{
        buttonFromEnum(ButtonsEnum.BTN_START).disable();
      }
      break;
        
    case GS_HALFTIME:
    case GS_OVERTIME:
    case GS_HALFTIME_OVERTIME:
      buttonAdisableAll();  //team A commands
      buttonBdisableAll();  //team B commands
      buttonCdisable();     //common commands
      
      // Alternate Kick-Offs
      boolean enableCyan = StateMachine.firstKickoffCyan;
      if(StateMachine.GetCurrentGameState() == GameStateEnum.GS_HALFTIME || StateMachine.GetCurrentGameState() == GameStateEnum.GS_HALFTIME_OVERTIME)
        enableCyan = !enableCyan;
      
      if(StateMachine.setpiece)
      {
        buttonFromEnum(StateMachine.setpiece_button).activate();
        buttonFromEnum(ButtonsEnum.BTN_START).enable();
        buttonFromEnum(ButtonsEnum.BTN_STOP).enable();
      }else{
        if(enableCyan)
        {
          buttonFromEnum(ButtonsEnum.BTN_C_KICKOFF).enable();
          buttonFromEnum(ButtonsEnum.BTN_M_KICKOFF).disable();
        }else{
          buttonFromEnum(ButtonsEnum.BTN_C_KICKOFF).disable();
          buttonFromEnum(ButtonsEnum.BTN_M_KICKOFF).enable();
        }
        
        buttonFromEnum(ButtonsEnum.BTN_START).disable();
        buttonFromEnum(ButtonsEnum.BTN_STOP).activate();
        
        if(StateMachine.GetCurrentGameState() == GameStateEnum.GS_OVERTIME)
        {
          bCommoncmds[CMDID_COMMON_RESET].enable();
        }
      }
      
      bCommoncmds[CMDID_COMMON_PARKING].enable();
      
      break;
    
    case GS_PENALTIES:
      refreshbutton_game_stopped();
      buttonAdisable();  //team A commands
      buttonBdisable();  //team B commands
      
      bTeamAcmds[CMDID_TEAM_PENALTY].enable();
      bTeamBcmds[CMDID_TEAM_PENALTY].enable();
      
      if(StateMachine.setpiece)
        buttonFromEnum(StateMachine.setpiece_button).activate();
      buttonFromEnum(ButtonsEnum.BTN_START).enable();
      buttonFromEnum(ButtonsEnum.BTN_STOP).activate();
      
      bCommoncmds[CMDID_COMMON_DROP_BALL].disable();
      bCommoncmds[CMDID_COMMON_HALFTIME].enable();
      bCommoncmds[CMDID_COMMON_PARKING].enable();
      bCommoncmds[CMDID_COMMON_RESET].disable();
      break;
      
    case GS_PENALTIES_ON:
      refreshbutton_game_on();
      break;
      
    case GS_ENDGAME:
      buttonAdisable();  //team A commands
      buttonBdisable();  //team B commands
      buttonCenable();     //common commands
      
      bCommoncmds[CMDID_COMMON_DROP_BALL].disable();
      bCommoncmds[CMDID_COMMON_HALFTIME].disable();
      buttonCSTARTdisable();
      buttonCSTOPactivate();
      break;
    
    default:
      buttonAenable();  //team A commands
      buttonBenable();  //team B commands
      buttonCenable();     //common commands 
      buttonCSTOPactivate();
      break;
      
  }
  
  // The switches are enabled only on pre-game
  if(StateMachine.GetCurrentGameState() != GameStateEnum.GS_PREGAME)
  {
    for(int i = 0; i < bSlider.length; i++)
      bSlider[i].disable();
  }else{
    for(int i = 0; i < bSlider.length; i++)
      bSlider[i].enable();
  }
  
  // Update End Part / End Game button
  String endPartOrEndGame = "End Part";
  switch(StateMachine.GetCurrentGameState())
  {
  case GS_HALFTIME:
  case GS_GAMEON_H2: 
  case GS_GAMEON_H4:
  case GS_GAMESTOP_H2:
  case GS_GAMESTOP_H4:
    endPartOrEndGame = "End Game";
  }
  bCommoncmds[CMDID_COMMON_HALFTIME].Label = endPartOrEndGame; 
}


void refreshbutton_game_on()
{
  buttonAdisableAll();  //team A commands
  buttonBdisableAll();  //team B commands
  buttonCdisable();     //common commands 
  buttonCSTARTdisable();
  buttonCSTOPactivate();
}

void refreshbutton_game_stopped()
{

 if(bTeamAcmds[CMDID_TEAM_GOAL].isActive()) {
//    println("Goal Cyan is ON");
    buttonAdisable();
    buttonBdisable();
    buttonCdisable();    
    bTeamBcmds[CMDID_TEAM_KICKOFF].enable();
    bTeamBcmds[CMDID_TEAM_KICKOFF].enable();
    bTeamBcmds[CMDID_TEAM_GOAL].disable();  
    bCommoncmds[CMDID_COMMON_HALFTIME].enable(); 
  }
  else if(bTeamBcmds[CMDID_TEAM_GOAL].isActive()) {
//    println("Goal Magenta is ON");
    buttonAdisable();
    buttonBdisable();
    buttonCdisable();    
    bTeamAcmds[CMDID_TEAM_KICKOFF].enable();    
    bTeamAcmds[CMDID_TEAM_GOAL].disable();    
    bCommoncmds[CMDID_COMMON_HALFTIME].enable();
  }
  else {
    buttonA_setpieces_en();  //team A commands
    buttonB_setpieces_en();  //team B commands

    bCommoncmds[CMDID_COMMON_DROP_BALL].enable();
    bCommoncmds[CMDID_COMMON_HALFTIME].enable(); 
    bCommoncmds[CMDID_COMMON_PARKING].disable();
    bCommoncmds[CMDID_COMMON_RESET].disable();  

    for(int i = CMDID_TEAM_GOAL; i <= CMDID_TEAM_YELLOWCARD; i++)
    {
      if(!bTeamAcmds[i].isActive())
        bTeamAcmds[i].enable();
  
      if(!bTeamBcmds[i].isActive())
        bTeamBcmds[i].enable();
    }  
  }
  buttonCSTOPactivate();
  buttonCSTARTdisable();  
}



// ============================

void buttonA_setpieces_en()
{
  for (int i=CMDID_TEAM_KICKOFF; i <= CMDID_TEAM_PENALTY; i++)
    bTeamAcmds[i].enable();
}

void buttonB_setpieces_en()
{
  for (int i=CMDID_TEAM_KICKOFF; i <= CMDID_TEAM_PENALTY; i++)
    bTeamBcmds[i].enable();
}

void buttonAenable() {
  for (int i=0; i<bTeamAcmds.length; i++) {
    if (i>6 && bTeamAcmds[i].isActive()) ; //maintains goals+repair+cards
    else bTeamAcmds[i].enable();
  }
}
void buttonBenable() {
  for (int i=0; i<bTeamBcmds.length; i++) {
    if (i>6 && bTeamBcmds[i].isActive()) ; //maintains repair+cards
    else bTeamBcmds[i].enable();
  }
}
void buttonCenable() {
  for (int i=2; i<bCommoncmds.length; i++)
    bCommoncmds[i].enable();
}
void buttonAdisable() {
  for (int i=0; i <= CMDID_TEAM_PENALTY; i++)
    bTeamAcmds[i].disable();
}
void buttonBdisable() {
  for (int i=0; i <= CMDID_TEAM_PENALTY; i++)
    bTeamBcmds[i].disable();
}
void buttonAdisableAll() {
  for (int i=0; i<bTeamAcmds.length; i++)
    bTeamAcmds[i].disable();
}
void buttonBdisableAll() {
  for (int i=0; i<bTeamBcmds.length; i++)
    bTeamBcmds[i].disable();
}
void buttonCdisable() {
  for (int i=2; i<bCommoncmds.length; i++)
    bCommoncmds[i].disable();
}
void buttonABdisableinactive() {
  for (int i=0; i<bTeamAcmds.length; i++) {
    if (!bTeamAcmds[i].isActive()) bTeamAcmds[i].disable();
    if (!bTeamBcmds[i].isActive()) bTeamBcmds[i].disable();
  }
}
void buttonABdisablemain() {
  for (int i=0; i < CMDID_TEAM_PENALTY; i++) {
    bTeamAcmds[i].disable();
    bTeamBcmds[i].disable();
  }
}
void buttonCSTARTenable() {
  bCommoncmds[0].enable();
}
void buttonCSTARTdisable() {
  bCommoncmds[0].disable();
}
void buttonCSTOPenable() {
  bCommoncmds[1].enable();
}
void buttonCSTOPactivate() {
  bCommoncmds[1].activate();
}
boolean isCSTOPactive() {
  return bCommoncmds[1].isActive();
}
boolean isCSTARTenabled() {
  return bCommoncmds[0].isEnabled();
}
