import org.json.*;

class Team {
  String shortName;  //max 8 chars
  String longName;  //max 24 chars
  String unicastIP, multicastIP;
  color c=(#000000);
  boolean isCyan;  //default: cyan@left
  boolean newYellowCard, newRedCard, newRepair, newDoubleYellow, newPenaltyKick, newGoal; // Pending commands, effective only on gamestate change
  int Score, RepairCount, RedCardCount, YellowCardCount, DoubleYellowCardCount, PenaltyCount;
  long RepairOut;
  int tableindex=0;
  org.json.JSONObject worldstate_json;
  String wsBuffer;
  Robot[] r=new Robot[5];
  
  File logFile;
  PrintWriter logFileOut;
  Client connectedClient;
  boolean firstWorldState;
      
  Team(color c, boolean uileftside) {
    this.c=c;
    this.isCyan=uileftside;
    
    //robots
    float x=0, y=64; 
    r[0]=new Robot(x, y);
    r[1]=new Robot(x+56, y);
    r[2]=new Robot(x, y + 56);
    r[3]=new Robot(x+56, y + 56);
    r[4]=new Robot(x+28, y + 112);
    
    this.reset();
  }

  //===================================
 
  void resetname(){
    if (this.isCyan) {
      this.shortName=Config.defaultCyanTeamShortName;
      this.longName=Config.defaultCyanTeamLongName;
    }
    else {
      this.shortName=Config.defaultMagentaTeamShortName;
      this.longName=Config.defaultMagentaTeamLongName;
    }
  }
  
  void logWorldstate(String teamWorldstate, int ageMs)
  {
    if(logFileOut == null)
      return;
    
    if(firstWorldState) {
      logFileOut.println("[");    // Start of JSON array
      firstWorldState = false;
    }else{
      logFileOut.println(",");    // Separator for the new JSON object
    }
    
    logFileOut.print("{");
    logFileOut.print("\"teamName\": \"" + shortName + "\",");
    logFileOut.print("\"timestamp\": " + (System.currentTimeMillis() - ageMs) + ",");
    logFileOut.print("\"gametimeMs\": " + getGameTime() + ",");
    logFileOut.print("\"worldstate\": " + teamWorldstate);
    logFileOut.print("}");
    
  }
  
  void reset() {
    if(logFileOut != null) {
      logFileOut.println("]");    // End JSON array
      logFileOut.close();
    }
    
    logFileOut = null;
    logFile = null;

    this.resetname();
    
    this.worldstate_json = null;
    this.wsBuffer = "";
    
    this.Score=0; 
    this.RepairCount=0;
    this.RedCardCount=0;
    this.YellowCardCount=0;
    this.DoubleYellowCardCount=0;
    this.PenaltyCount=0;
    this.RepairOut=0;
    this.newYellowCard=false;
    this.newRedCard=false;
    this.newRepair=false;
    this.newDoubleYellow=false;
    this.newPenaltyKick=false;
    for (int i=0; i<5; i++)
      r[i].reset();
    
    if(this.connectedClient != null && this.connectedClient.active())
      this.connectedClient.stop();
    this.connectedClient = null;
    
    this.firstWorldState = true;
  }

  // Function called when team connects and is accepted
  void teamConnected(TableRow teamselect)
  {
    shortName=teamselect.getString("shortname8");
    longName=teamselect.getString("longame24");
    unicastIP = teamselect.getString("UnicastAddr");
    multicastIP = teamselect.getString("MulticastAddr");
    
    
    if(connectedClient != null)
      BaseStationServer.disconnect(connectedClient);
    
    connectedClient = connectingClient;
    connectingClient.write(COMM_WELCOME);
    connectingClient = null;
    
    if(this.logFile == null || this.logFileOut == null)
    {
      this.logFile = new File(mainApplet.dataPath("tmp/" + Log.getTimedName() + "." + (isCyan?"A":"B") + ".msl"));
      try{
        this.logFileOut = new PrintWriter(new BufferedWriter(new FileWriter(logFile, true)));
      }catch(IOException e){ }
    }
  }
    
//*******************************************************************
//*******************************************************************
  void repair_timer_start() { 
    this.RepairOut=getSplitTime()+Config.repairPenalty_ms;
  }
  
//*******************************************************************
  void repair_timer_check() {
    long remain=RepairOut-getSplitTime();
    if (StateMachine.isInterval()) {
        remain = -1;
        println("Repair reseted!");
    }
    if (remain>=0)
      for(int i=0; i<RepairCount; i++) r[i].waittime=int(remain/1000);
    else {
      for(int i=0; i<RepairCount; i++) r[i].waittime=-1;
      RepairCount=0;
      println("Repair OUT: "+shortName+" @"+(isCyan?"left":"right"));
    }
  }
  
//*******************************************************************
  public void double_yellow_timer_start() {
    r[5-DoubleYellowCardCount].DoubleYellowOut=getAbsoluteTime()+Config.doubleYellowPenalty_ms;
  }

  public void double_yellow_timer_check() {
    for (int i=(5-DoubleYellowCardCount); i<5; i++)
    {
      long remain;
      if (StateMachine.isHalf() && StateMachine.gsCurrent.isRunning()) {
        remain=r[i].DoubleYellowOut-getAbsoluteTime();
      } else {
        remain = r[i].waittime * 1000;
        r[i].DoubleYellowOut = remain + getAbsoluteTime();
      }
          
      if (remain>=0)
        r[i].waittime=PApplet.parseInt(remain/1000);
      else {  //shift right & reset
        r[i].reset();
        for (int j=4; j>0; j--) {
          if (!r[j].state.equals("doubleyellow") && r[j-1].state.equals("doubleyellow")){
            r[j].setRstate(r[j-1]);
            r[j-1].reset();
          }
        }
        DoubleYellowCardCount--;
        println("Double Yellow end: "+shortName+" @"+(isCyan?"left":"right"));
      }
                  
    }
  }
//*******************************************************************
  void setDoubleYellowOutRemain() {
    println("setDoubleYellowOutRemain");
    for (int j=0; j<5; j++) {
      if (r[j].state.equals("doubleyellow"))  r[j].DoubleYellowOutRemain=r[j].DoubleYellowOut-getGameTime();
      else r[j].DoubleYellowOutRemain=0;
    }
  }

//*******************************************************************
  void resumeDoubleYellowOutRemain() {
    println("resumeDoubleYellowOutRemain");
    for (int j=0; j<5; j++) {
      if (r[j].state.equals("doubleyellow"))  r[j].DoubleYellowOut=r[j].DoubleYellowOutRemain;
      r[j].DoubleYellowOutRemain=0;
    }
  }
  
//*******************************************************************
  void repairclear() {
    this.RepairCount=0;
    this.RepairOut=0;
    for (int i=0; i<5; i++)
      if (r[i].state.equals("repair"))  r[i].reset_to_play();
  }
  
//*******************************************************************
  void checkflags() {
    if (this.newRepair) {
      this.RepairCount++; 
      this.repair_timer_start();
      this.newRepair=false;

      // Hack: send command only on game change
      if(this.isCyan) event_message_v2(ButtonsEnum.BTN_C_REPAIR, true);
      else event_message_v2(ButtonsEnum.BTN_M_REPAIR, true);
    }
    if (this.newYellowCard) {
      this.YellowCardCount=1;
      this.newYellowCard=false;

      // Hack: send command only on game change
      if(this.isCyan) event_message_v2(ButtonsEnum.BTN_C_YELLOW, true);
      else event_message_v2(ButtonsEnum.BTN_M_YELLOW, true);
    }
    if (this.newRedCard) {
      this.RedCardCount++;
      this.newRedCard=false;

      // Hack: send command only on game change
      if(this.isCyan) event_message_v2(ButtonsEnum.BTN_C_RED, true);
      else event_message_v2(ButtonsEnum.BTN_M_RED, true);
    }
    if (this.newDoubleYellow) {
      this.DoubleYellowCardCount++;
      this.YellowCardCount=0;
      this.double_yellow_timer_start();
      this.newDoubleYellow=false;

      if(this.isCyan) send_event_v2(""+COMM_DOUBLE_YELLOW_CYAN, "Double Yellow", this);
      else send_event_v2(""+COMM_DOUBLE_YELLOW_MAGENTA, "Double Yellow", this);
    }
    if (this.newPenaltyKick) {
      this.PenaltyCount++;
      this.newPenaltyKick=false;
    }
  
  }
  
//*******************************************************************
//*******************************************************************
  
  void updateUI() {
    if(connectedClient != null && !connectedClient.active())
    {
      println("Connection to team \"" + longName + "\" dropped.");
      Log.logMessage("Team " + shortName + " dropped");
      BaseStationServer.disconnect(connectedClient);
      resetname();
      connectedClient = null;
    }
    
    //team names
    String sn=shortName;
    String ln=longName;
    if (sn.length()>Config.maxShortName) sn=shortName.substring(0, Config.maxShortName);
    if (ln.length()>Config.maxLongName) ln=longName.substring(0, Config.maxLongName);
    rectMode(CENTER);
    fill(255);
    textFont(teamFont);
    textAlign(CENTER, CENTER);    
    if (isCyan) text(sn, 163, 50);
    else text(sn, 837, 50);
    textFont(panelFont);
    if (isCyan) text(ln, 163, 90);
    else text(ln, 837, 90);


    // robot state 
    for (int i=0; i<5; i++) r[i].state="play";//in-game: white, default setting
    for (int i=0; i<RepairCount; i++)  r[i].state="repair";//in-repair: blue
    for (int i=RepairCount; i< min(RepairCount+YellowCardCount, 5); i++)  r[i].state="yellow"; //yellow-card: yellow
    for (int i=(RepairCount+YellowCardCount); i<min(RepairCount+YellowCardCount+RedCardCount, 5); i++)  r[i].state="red";//red
    for (int i=(5-DoubleYellowCardCount); i<5; i++)  r[i].state="doubleyellow";//doubleyellow

    if (RepairCount > 0)            //repair #
      repair_timer_check();
    if (DoubleYellowCardCount > 0)  //double yellow #
      double_yellow_timer_check();
    
    for (int i=0; i<5; i++)
      r[i].updateUI(c,isCyan);

    textAlign(LEFT, BOTTOM);
    textFont(debugFont);
    fill(#ffff00);
    textLeading(20);
    String ts="Goals."+this.Score+" Penalty:"+this.PenaltyCount+"\nYellow:"+this.YellowCardCount+" Red:"+this.RedCardCount+"\nRepair:"+this.RepairCount+" 2xYellow:"+this.DoubleYellowCardCount;
    if (isCyan) text(ts, 40, height-18);
    else text(ts, width - 190, height-18);
  }
  
//*******************************************************************
  boolean IPBelongs(String clientipstr)
  {
    if(this.unicastIP == null)
      return false;
    
    String[] iptokens;
    
    if (!clientipstr.equals("0:0:0:0:0:0:0:1")) {
      iptokens=split(clientipstr,'.');
      if (iptokens!=null) clientipstr=iptokens[0]+"."+iptokens[1]+"."+iptokens[2]+".*";
    }
    
    return this.unicastIP.equals(clientipstr);
  }
}