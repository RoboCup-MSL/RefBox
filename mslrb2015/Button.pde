class Button {
	float x; 
	float y;
	String bStatus;  // normal, active, disabled
	Boolean HOVER;
	String Label;
	int bwidth=116; 
	int bheight=48;
	int hbwidth=bwidth/2; 
	int hbheight=bheight/2;
	int ccm = 0;
	color cstroke, cfill, cstrokeactive, cfillactive;

	public String msg = null; // long name for the command
	public String msg_off = null;
	public String cmd = null; // command (usually a char)
	public String cmd_off = null;

	// c1 > stroke color (-1 > no stroke)
	// c2 > fill collor (-1 > no fill)
	// c3 > stroke color when active (-1 > no stroke)
	// c4 > fill collor when active (-1 > no fill)
	Button(float x, float y, String Label, color c1, color c2, color c3, color c4) { 
		this.x=x;
		this.y=y;
		this.Label=Label;
		this.bStatus="disabled";
		this.HOVER=false;
		this.cstroke=c1;
		this.cfill=c2;
		this.cstrokeactive=c3;
		this.cfillactive=c4;
	}

	void update() {
		rectMode(CENTER);
		textAlign(CENTER, CENTER);
		textFont(buttonFont);
		strokeWeight(2);

		int offset = 4;
		int cround = 8;
		if (this.isEnabled()) {
			if (this.isActive()) {
				noStroke();
				if (HOVER && cfillactive != -1) {
					fill(cfillactive, 100);
					rect(x+offset, y+offset, bwidth, bheight, cround);
				}
				if (cfillactive==-1) noFill(); 
				else fill(cfillactive);

			} else {  //not active, no hover
				if (HOVER && cfill != -1) {
					noStroke();
					if (cstroke!= -1) {
						offset += 3;  
						cround += 2;
					}
					fill(cfill, 130);
					rect(x+offset, y+offset, bwidth, bheight, cround);
				}

				if (cstroke==-1) noStroke(); 
				else stroke(cstroke);

				if (cfill==-1) noFill(); 
				else fill(cfill);
			}	
		} else { //disabled
			fill(0, 8);
			stroke(96);
		} 
		rect(x, y, bwidth, bheight, 8);
		if (HOVER) {
			ccm++;
		}

		//  Text

		if (this.isEnabled()) {
			if (this.isActive()) {
				if (cstrokeactive == -1) fill(255); 
				else fill(cstrokeactive);
			} 
			else {  //not active, no hover
				if (HOVER && cstroke != -1 && cfill == -1) {
					fill(cstroke, 100);
					text(Label, x+4, y+2);			
				}
				if (cstroke==-1) noFill(); 
				else fill(cstroke);
			}
		} else fill(96); //disabled  

		text(Label, x, y-2);//-4  , y-2
	}

	void checkhover() {
		if ( mouseX>(x-hbwidth-2) && mouseX<(x+hbwidth+2) && mouseY>(y-hbheight-2) && mouseY<(y+hbheight+2) ) this.HOVER=true;
		else this.HOVER=false;
	}

	boolean isDisabled() {
		if (bStatus.equals("disabled")) return true;
		else return false;
	}

	boolean isEnabled() {
		if (bStatus.equals("disabled")) return false;
		else return true;
	}

	boolean isActive() {
		if ( this.bStatus.equals("active") ) return true;
		else return false;
	}

	void activate() {
		this.bStatus="active";
	}

	void enable() {
		this.bStatus="normal";
	}

	void disable() {
		this.bStatus="disabled";
		this.HOVER=false;
	}

	public void toggle() {
		if (this.isEnabled()) {
			if ( this.isActive() ){
				this.bStatus="normal";
				if(StateMachine.setpiece && this.Label == Teamcmds[6]) {
					StateMachine.ResetSetpiece();
					send_to_basestation(cCommcmds[1]);
				}
			}
			else this.bStatus="active";
		}
	}


	void setcolor(color c1, color c2, color c3, color c4) {
		this.cstroke=c1;
		this.cfill=c2;
		this.cstrokeactive=c3;
		this.cfillactive=c4;
	}

	void setdim(int w, int h) {
		bwidth=w; 
		bheight=h;
		hbwidth=bwidth/2; 
		hbheight=bheight/2;
	}

	void setxy(float x, float y){    
		this.x=x;
		this.y=y;
	}

}

//***********************************************************************
//
public static Button buttonFromEnum(ButtonsEnum btn)
{
	if(btn.getValue() <= ButtonsEnum.BTN_RESET.getValue())
	return bCommoncmds[btn.getValue()];

	if(btn.getValue() <= ButtonsEnum.BTN_C_YELLOW.getValue())
	return bTeamAcmds[btn.getValue() - ButtonsEnum.BTN_C_KICKOFF.getValue()];

	if(btn.getValue() <= ButtonsEnum.BTN_M_YELLOW.getValue())
	return bTeamBcmds[btn.getValue() - ButtonsEnum.BTN_M_KICKOFF.getValue()];

	return null;
}

//***********************************************************************
//
void buttonEvent(char group, int pos) {

	ButtonsEnum clickedButton = null;
	Button clickBtn = null;

	if (group=='C')
	{
		clickedButton = ButtonsEnum.items[pos];
		clickBtn = buttonFromEnum(clickedButton);
		if(clickBtn.isEnabled())
		clickBtn.toggle();
		else
		clickedButton = null;
	}
	else if (group=='A')
	{
		clickedButton = ButtonsEnum.items[pos + ButtonsEnum.BTN_C_KICKOFF.getValue()];
		clickBtn = buttonFromEnum(clickedButton);
		if(clickBtn.isEnabled())
		clickBtn.toggle();
		else
		clickedButton = null;
	}
	else if (group=='B')
	{
		clickedButton = ButtonsEnum.items[pos + ButtonsEnum.BTN_M_KICKOFF.getValue()];
		clickBtn = buttonFromEnum(clickedButton);
		if(clickBtn.isEnabled())
		clickBtn.toggle();
		else
		clickedButton = null;
	}

	if(clickedButton != null)        // A button has been clicked
	{
		boolean btnOn = buttonFromEnum(clickedButton).isActive();
		
		StateMachine.Update(clickedButton, btnOn);
		
		if(soundMaxTime != null && clickedButton.isStart()) {
			SetPieceDelay.startTimer(Config.setPieceMaxTime_ms);
			println ("Millis: " + Config.setPieceMaxTime_ms); 
		}
		
		// Special cases, that send only event message on game change (flags)
		if( clickedButton.isYellow() || clickedButton.isRed() || clickedButton.isRepair() )
		{
			// Do literally nothing...
		}else{
			if(clickedButton.isCommon())
			{
				event_message_v2(clickedButton, true);
			}else{
				event_message_v2(clickedButton, buttonFromEnum(clickedButton).isActive());
			}
		}
	}
}
