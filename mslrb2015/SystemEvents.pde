// Processing mouse'event
void mousePressed() {

	for (int i=0; i<tBox.length; i++) {
		if (tBox[i].mouseover() && tBox[i].visible == true) {
			tBox[i].clicked();
		}
		else {
			tBox[i].unclicked();
		}
	}

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

	// TODO: only accept numbers for textbox value
	for (int i = 0; i < tBox.length; i++) {
		if (tBox[i].clickedLast && tBox[i].visible) {
			if (key == BACKSPACE) {
				if (tBox[i].value.length() > 1){
					tBox[i].value = tBox[i].value.substring(0, tBox[i].value.length() - 1);
				}
				else {
					tBox[i].value = "";
				} 
			}
			if (key == TAB){
				tBox[i].unclicked();
				do
					if (++i >= tBox.length) i = 0;
				while (tBox[i].visible == false);
				tBox[i].clicked();
				break;
			}
			else if (key >= '0' && key <= '9') {
				tBox[i].value += key;
			}
		}
	}
	if (tBoxIsAlive.visible) {
		if (key == BACKSPACE) {
			if (tBoxIsAlive.value.length() > 1){
				tBoxIsAlive.value = tBoxIsAlive.value.substring(0, tBoxIsAlive.value.length() - 1);
			}
			else {
				tBoxIsAlive.value = "";
			} 
		}
		else if (key >= '0' && key <= '9') {
			tBoxIsAlive.value += key;
		}
	}

	
	if (key == ESC){
		key = 0; 		//disable quit on ESC
		// Close popup
		if(Popup.isEnabled()) {
			for (int t = 0; t < tBox.length; t++)
			{
				tBox[t].value = "";
				tBox[t].hide();
			}
			tBoxIsAlive.hide();
			Popup.close();			
		}
			
	}
	if (key == 32){
		key = 0; 		
		buttonEvent('C', ButtonsEnum.BTN_STOP.getValue());
	}
	
	if (!Popup.isEnabled()) {  // Ignore remaining keys while PopUp is enabled
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
	}
	key = 0;

}

void keyReleased() {
	if (key == CODED) {
		if (keyCode == ALT) altK = false; 
		key = 0;
	}	
}
