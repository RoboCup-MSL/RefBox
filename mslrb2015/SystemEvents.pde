// Processing mouse'event
void mousePressed() {
	if (!Popup.isEnabled()) {
		//sliders
		boolean refreshslider = false;
		int pos = -1;
		
		for (int i=0; i<4; i++)
		if (bSlider[i].mouseover()) { bSlider[i].toogle(); refreshslider=true; pos=i; break;}
		if (refreshslider) {    
			setbooleansfrombsliders();
			//if (pos==0) screenlog("Testmode "+(TESTMODE?"enabled":"disabled"));
			if (pos==1) Log.screenlog("Log "+(Log.enable?"enabled":"disabled"));
			if (pos==2) Log.screenlog("Remote "+(REMOTECONTROLENABLE?"enabled":"disabled"));
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
	else {  				//check popup
		Popup.check(false);
	}
}

// Processing key'event
void keyPressed() {

	if (key == ESC){
		key = 0; 		//disable quit on ESC
		// Close popup
		if(Popup.isEnabled()) 
		Popup.close();
	}
	if (key == 32){
		key = 0; 		
		buttonEvent('C', ButtonsEnum.BTN_STOP.getValue());
	}
	if (key == CODED) {
		if (keyCode == ALT) altK = true;
		key = 0;
	}
	if (altK == true && (key == 'r' || key == 'R')){
		key = 0;
		buttonFromEnum(ButtonsEnum.BTN_RESET).enable();
		buttonEvent('C', ButtonsEnum.BTN_RESET.getValue());		
		buttonFromEnum(ButtonsEnum.BTN_RESET).disable();
		buttonEvent('C', ButtonsEnum.BTN_STOP.getValue()); 
	}
	if (altK == true && (key == 'k' || key == 'K')){
		key = 0;
		forceKickoff = true;
	}
	if (key == 'H') {
		key = 0;
		Popup.show(PopupTypeEnum.POPUP_HELP, MSG_HELP, 8, 0, 0, 20, 440, 240);
	}
	key = 0;

}

void keyReleased() {
	if (key == CODED) {
		if (keyCode == ALT) altK = false; 
		key = 0;
	}	
}
