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
  color cstroke, cfill, cstrokeactive, cfillactive;
  
  public String msg = null; // long name for the command
  public String msg_off = null;
  public String cmd = null; // command (usually a char)
  public String cmd_off = null;
  
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

    if (this.isEnabled() && HOVER) {  //shadow
      noFill();
      strokeWeight(4);
      stroke(0);
      rect(x+2, y+2, bwidth-2, bheight-2, 8);
    }
    strokeWeight(2);
    if (this.isEnabled()) {
      if (this.isActive()) {
        noStroke();
        if (cfillactive==-1) noFill(); 
        else fill(cfillactive);
      } else {  //not active, no hover
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

    textFont(buttonFont);
    if (this.isEnabled()) {
      fill(0);//shadow
      text(Label, x+2, y-2);
      if (this.isActive()) {
        if (cstrokeactive==-1) fill(255); 
        else fill(cstrokeactive);
      } else {  //not active, no hover
        if (cstroke==-1) noFill(); 
        else fill(cstroke);
      }
    } else fill(96); //disabled  
    text(Label, x, y-2);//-4
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

void buttonEvent(char group, int pos) {
  
  ButtonsEnum clickedButton = null;
  Button clickBtn = null;
   
  if (group=='C')
  {
    clickedButton = ButtonsEnum.items[pos];
    clickBtn = buttonFromEnum(clickedButton);
    if(!clickBtn.isDisabled())
      clickBtn.toggle();
    else
      clickedButton = null;
  }
  else if (group=='A')
  {
    clickedButton = ButtonsEnum.items[pos + ButtonsEnum.BTN_C_KICKOFF.getValue()];
    clickBtn = buttonFromEnum(clickedButton);
    if(!clickBtn.isDisabled())
      clickBtn.toggle();
    else
      clickedButton = null;
  }
  else if (group=='B')
  {
    clickedButton = ButtonsEnum.items[pos + ButtonsEnum.BTN_M_KICKOFF.getValue()];
    clickBtn = buttonFromEnum(clickedButton);
    if(!clickBtn.isDisabled())
      clickBtn.toggle();
    else
      clickedButton = null;
  }
  
  if(clickedButton != null)
  {
    boolean btnOn = buttonFromEnum(clickedButton).isActive();
    
    StateMachine.Update(clickedButton, btnOn);
    
    if(soundMaxTime != null && clickedButton.isStart())
      lastPlayMillis = mainApplet.millis();
    else
      lastPlayMillis = 0;
    
    if(clickedButton.isStop())
    {
      lastPlayMillis = 0;
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