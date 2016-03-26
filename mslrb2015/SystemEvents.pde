// Processing mouse'event
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
          buttonEvent('C', i); 
          break;
        }
      }
    }
    
    //team commands
    for (int i=0; i<bTeamAcmds.length; i++) {
      if (bTeamAcmds[i].isEnabled()) {
        bTeamAcmds[i].checkhover();
        if (bTeamAcmds[i].HOVER==true) { 
          buttonEvent('A', i); 
          break;
        }
      }
      if (bTeamBcmds[i].isEnabled()) {
        bTeamBcmds[i].checkhover();
        if (bTeamBcmds[i].HOVER==true) { 
          buttonEvent('B', i); 
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

// Processing mouse'event
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

// Processing key'event
void keyPressed() {
  if (key == ESC){
    key = 0; //disable quit on ESC
    
    // Close popup
    if(Popup.isEnabled()) 
      Popup.close();
  }

}