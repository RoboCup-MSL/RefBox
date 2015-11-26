void mousePressed() {
  if (!Popup.isEnabled()) {
    //sliders
    boolean refreshslider = false;
    int pos = -1;
    
    for (int i=0; i<4; i++)
      if (bSlider[i].mouseover()) { bSlider[i].toogle(); refreshslider=true; pos=i; break;}    
    if (refreshslider) {
      
    setbooleansfrombsliders();
    //if (pos==0) screenlog("Testmode "+(TESTMODE?"enabled":"disabled"));
    if (pos==1) Log.screenlog("Log "+(Log.enable?"enabled":"disabled"));
    if (pos==2) Log.screenlog("Remote "+(REMOTECONTROLENABLE?"enabled":"disabled"));
    
      
//    RefreshButonStatus();
    }
    
    //common commands
    for (int i=0; i<bCommoncmds.length; i++) {
      if (bCommoncmds[i].isEnabled()) {
        bCommoncmds[i].checkhover();
        if (bCommoncmds[i].HOVER==true) { 
          bevent('C', i); 
          break;
        }
      }
    }
    
    //team commands
    for (int i=0; i<bTeamAcmds.length; i++) {
      if (bTeamAcmds[i].isEnabled()) {
        bTeamAcmds[i].checkhover();
        if (bTeamAcmds[i].HOVER==true) { 
          bevent('A', i); 
          break;
        }
      }
      if (bTeamBcmds[i].isEnabled()) {
        bTeamBcmds[i].checkhover();
        if (bTeamBcmds[i].HOVER==true) { 
          bevent('B', i); 
          break;
        }
      }
    }
      
  }
  else {//POPUP
    Popup.check(true);
  }

  //frameRate(appFrameRate);
  //redraw();
}


void mouseMoved() {
  if (!Popup.isEnabled()) {
    for (int i=0; i<bTeamAcmds.length; i++) {
      if (bTeamAcmds[i].isEnabled()) bTeamAcmds[i].checkhover();
      if (bTeamBcmds[i].isEnabled()) bTeamBcmds[i].checkhover();
    }  
    for (int i=0; i<bCommoncmds.length; i++)
      if (bCommoncmds[i].isEnabled()) bCommoncmds[i].checkhover();  
  } 
  else {  //check popup
    Popup.check(false);
  }

  //frameRate(appFrameRate);
  //redraw();
}


void keyPressed() {
  if (key == ESC){
    key = 0; //disable quit on ESC
    
    // Close popup
    if(Popup.isEnabled()) 
      Popup.close();
  }
  
  /*
  if (CurrentGameState==0 && key=='t') {
    TESTMODE=!TESTMODE;
    bSlider[0].on=TESTMODE;
    if (TESTMODE) send_to_basestation(COMM_TESTMODE_ON);
    else send_to_basestation(COMM_TESTMODE_OFF);
    RefreshButonStatus();
  }
  if (key=='a') {
    teamA.tableindex--;
    if (teamA.tableindex<0) teamA.tableindex=0;
    teamA.setinfofromtable(teamstable,teamA.tableindex);
  }
  if (key=='s') {
    teamA.tableindex++;
    if (teamA.tableindex>=teamstable.getRowCount()) teamA.tableindex=teamstable.getRowCount()-1;
    teamA.setinfofromtable(teamstable,teamA.tableindex);
  }
  if (key=='d') {
    teamB.tableindex--;
    if (teamB.tableindex<0) teamB.tableindex=0;
    teamB.setinfofromtable(teamstable,teamB.tableindex);
  }
  if (key=='f') {
    teamB.tableindex++;
    if (teamB.tableindex>=teamstable.getRowCount()) teamB.tableindex=teamstable.getRowCount()-1;
    teamB.setinfofromtable(teamstable,teamB.tableindex);
  }
  if (key=='j')  saveFrame(); 
*/
  //frameRate(appFrameRate);
  //redraw();
}
