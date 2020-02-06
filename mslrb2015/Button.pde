//import processing.net.*;

class Button {
	float x; 
	float y;
	String bStatus;  			// can be enabled, active, disabled
	PImage butImageOff = null;	// If there is an image to display when button OFF 
	PImage butImageON = null;	// If there is an image to display when button ON 
	PImage butImageOver = null;	// If there is an image to display when button ON and cursor is over 
	PImage butImageAtive = null;	// If there is an image to display when button Active 
	Boolean HOVER;				// true when pointer is hover button
	Boolean isCircle = false;	// true is button is circle
	String Label;				// string to be writen in the button
	int bwidth=116; 			// default button width
	int bheight=48;				// default button height
	int hbwidth=bwidth/2; 		// half printof bwidth
	int hbheight=bheight/2;		// half of bheight
	color cstroke, cfill;		// stroke and fill default colors when button is in ON state
	color cstrokeactive, cfillactive;	// stroke and fill default colors when button is in active state

	String cmd = null; 		// long name for the command 
	String msg = null; 		// description of the command
	String cmd_off = null;	// ID used in toogle buttons - applied when button is reset to passive state
	String msg_off = null;	// description of the cmd_off - applied when button is reset to passive state

/*
	Button constructor
	Parameters:
		x > horizontal ccordinate of button in window
		z > vertical ccordinate of button in window
		Label > string to be writen in the button
		c1 > stroke (outline) color (-1 > no stroke)
		c2 > fill collor (-1 > no fill)
		c3 > stroke (outline) color when active (-1 > no stroke)
		c4 > fill collor when active (-1 > no fill)
		cmd > string ID of the command (defined in Comms)
		msg > string description of the command (defined in Comms)
		cmd_off > string ID used in toogle buttons - applied when button is reset to passive state
		msg_off > string description of cmd_off
*/
	Button(float x, float y, String Label, color c1, color c2, color c3, color c4, String cmd, String msg,String cmd_off, String msg_off) { 
		this.x = x;
		this.y = y;
		this.Label = Label;
		this.bStatus = "disabled";
		this.HOVER = false;
		this.cstroke = c1;
		this.cfill = c2;
		this.cstrokeactive = c3;
		this.cfillactive = c4;
		this.cmd = cmd;
		this.msg = msg;
		this.cmd_off = cmd_off;
		this.msg_off = msg_off;
	}

	void update() {
		rectMode(CENTER);
		textAlign(CENTER, CENTER);
		textFont(buttonFont);
		strokeWeight(2);

		if (isCircle == false) {	
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
		else{

			if (this.isActive()) {
				stroke(cstrokeactive); 
				strokeWeight(3);
				if (cfillactive==-1) noFill(); 
				else fill(cfillactive);
				ellipse(this.x, this.y, 42, 42);  
				imageMode(CENTER);
				image(butImageAtive, this.x, this.y, 26, 26);
			}
			else if (this.isEnabled()){
				if ((HOVER) && butImageOver != null) {
					stroke(cstroke); 
					strokeWeight(3);
					if (cfill==-1) noFill(); 
					else fill(cfill);
					ellipse(this.x, this.y, 42, 42);  
					imageMode(CENTER);
					image(butImageOver, this.x, this.y, 26, 26);					
				} else {
					stroke(cstroke); 
					strokeWeight(3);
					if (cfill==-1) noFill(); 
					else fill(cfill);
					ellipse(this.x, this.y, 42, 42);  
					imageMode(CENTER);
					image(butImageON, this.x, this.y, 26, 26);
				}
			}
			else {
				stroke(96);
				strokeWeight(3);
				if (cfill==-1) noFill(); 
				else fill(cfill);
				ellipse(this.x, this.y, 42, 42);  
				imageMode(CENTER);
				image(butImageOff, this.x, this.y, 26, 26);
			}
		}
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
		this.bStatus="enabled";
	}

	void disable() {
		this.bStatus="disabled";
		this.HOVER=false;
	}

	public void toggle() {
		if (this.isEnabled()) {
			if ( this.isActive() ){
				this.bStatus="enabled";
				if(StateMachine.setpiece && this.Label == COMM_GOAL) {
					StateMachine.ResetSetpiece();
					send_event_v2(COMM_STOP, COMM_STOP, null,-1);
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

	void setIsCircle(boolean vv){    
		isCircle = vv;
	}
	
	void setImages(PImage im1, PImage im2, PImage im3, PImage im4){
		butImageOff = im1;
		butImageON = im2;
		butImageOver = im3;
		butImageAtive = im4;		
	}
}

//***********************************************************************
//
public static Button buttonFromEnum(ButtonsEnum btn)
{
	if(btn.getValue() <= ButtonsEnum.BTN_CONFIG.getValue())
	return bCommoncmds[btn.getValue()];

	if(btn.getValue() <= ButtonsEnum.BTN_L_YELLOW.getValue())
	return bTeamAcmds[btn.getValue() - ButtonsEnum.BTN_L_KICKOFF.getValue()];

	if(btn.getValue() <= ButtonsEnum.BTN_R_YELLOW.getValue())
	return bTeamBcmds[btn.getValue() - ButtonsEnum.BTN_R_KICKOFF.getValue()];

//	if(btn.getValue() <= ButtonsEnum.BTN_CONFIG.getValue())
//	return bCommoncmds[btn.getValue()];

	return null;
}

//***********************************************************************
//
void buttonEvent(char group, int pos) {
	
	System.out.println("group = " + group + " pos = " + pos);
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
		clickedButton = ButtonsEnum.items[pos + ButtonsEnum.BTN_L_KICKOFF.getValue()];
		clickBtn = buttonFromEnum(clickedButton);
		if(clickBtn.isEnabled())
			clickBtn.toggle();
		else
			clickedButton = null;
	}
	else if (group=='B')
	{
		clickedButton = ButtonsEnum.items[pos + ButtonsEnum.BTN_R_KICKOFF.getValue()];
		clickBtn = buttonFromEnum(clickedButton);
		if(clickBtn.isEnabled())
			clickBtn.toggle();
		else
			clickedButton = null;
	}

	System.out.println("..." + clickedButton);

	if(clickedButton != null)        // A button has been clicked
	{
		boolean btnOn = buttonFromEnum(clickedButton).isActive();
		
		StateMachine.Update(clickedButton, btnOn);
		
		if(soundMaxTime != null && clickedButton.isStart()) {
			SetPieceDelay.startTimer(Config.setPieceMaxTime_ms);
			println ("Millis: " + Config.setPieceMaxTime_ms); 
		}
		
		// Special cases, that send only event message on game change (flags)
		if( clickedButton.isYellow() || clickedButton.isRed() || clickedButton.isRepair() || clickedButton.isConfig() || 
			clickedButton.isEndPart() || clickedButton.isReset() || clickedButton.isAlive() || clickedButton.isSubs())
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
