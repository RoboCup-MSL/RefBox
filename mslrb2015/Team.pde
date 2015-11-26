import org.json.*;

class Team {
  String shortName;  //max 8 chars
  String longName;  //max 24 chars
  String unicastIP, multicastIP;
  color c=(#000000);
  boolean isCyan;  //default: cyan@left
  boolean newYellowCard, newRedCard, newRepair, newDoubleYellow,newPenaltyKick ; 
  int Score, RepairCount, RedCardCount, YellowCardCount, DoubleYellowCardCount, PenaltyCount;
  long RepairOut;
  int tableindex=0;
  org.json.JSONObject worldstate_json;
  String wsBuffer;
  Robot[] r=new Robot[5];
  
  File logFile;
  PrintWriter logFileOut;
      
  Team(color c, boolean uileftside) {
    this.c=c;
    this.isCyan=uileftside;
    this.resetname();
    this.worldstate_json = null;
    this.wsBuffer = "";
    logFile = new File((isCyan?"fA_":"fB_") + Log.getTimedName() + ".txt");
    try{
      logFileOut = new PrintWriter(new BufferedWriter(new FileWriter(logFile, true)));
    }catch(IOException e){
      
    }
    //robots
    float x=0, y=60; 
    r[0]=new Robot(x, y);
    r[1]=new Robot(x+40, y);
    r[2]=new Robot(x, y+40);
    r[3]=new Robot(x+40, y+40);
    r[4]=new Robot(x+20, y+80);
    
    this.reset();
  }

  //===================================
 
  void resetname(){
    if (this.isCyan) {
      this.shortName=Config.CyanTeamShortName;
      this.longName=Config.CyanTeamLongName;
    }
    else {
      this.shortName=Config.MagentaTeamShortName;
      this.longName=Config.MagentaTeamLongName;
    }
  }
  
  void logWorldstate(String teamWorldstate, int ageMs)
  {
    if(logFileOut != null)
      return;
    
    logFileOut.print("{");
    logFileOut.print("\"timestamp\": " + (System.currentTimeMillis() - ageMs) + ",");
    logFileOut.print("\"gametimeMs\": " + getGameTime() + ",");
    logFileOut.print("\"worldstate\": " + teamWorldstate);
    logFileOut.println("},");
  }
  
  void reset() {
    this.worldstate_json = null;
    this.wsBuffer = "";
    logFile = new File((isCyan?"fA_":"fB_") + Log.getTimedName() + ".txt");
    try{
      logFileOut = new PrintWriter(new BufferedWriter(new FileWriter(logFile, true)));
    }catch(IOException e){
      
    }
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
  }

  void setinfofromtable(Table tab, int id) {
    this.shortName=tab.getString(id, "shortname8");
    this.longName=tab.getString(id, "longame24");
    this.unicastIP=tab.getString(id, "UnicastAddr");
    this.multicastIP=tab.getString(id, "MulticastAddr");
  }
    
//*******************************************************************
//*******************************************************************
  void repair_timer_start() { 
    this.RepairOut=getSplitTime()+Config.REPAIRPENALTYms;
  }
  
  void repair_timer_check() {
    long remain=RepairOut-getSplitTime();
    if (remain>=0)
      for(int i=0; i<RepairCount; i++) r[i].waittime=int(remain/1000);
    else {
      for(int i=0; i<RepairCount; i++) r[i].waittime=-1;
      RepairCount=0;
      println("Repair OUT: "+shortName+" @"+(isCyan?"left":"right"));
      if (this.isCyan) send_to_basestation("" + COMM_REPAIR_IN_CYAN);
      else send_to_basestation("" + COMM_REPAIR_IN_MAGENTA);
    }
  }
  
  void double_yellow_timer_start() {
    r[5-DoubleYellowCardCount].DoubleYellowOut=getGameTime()+Config.DOUBLEYELLOWPENALTYms;  
  }
  
  void double_yellow_timer_check() {
    for (int i=(5-DoubleYellowCardCount); i<5; i++) {
      long remain=r[i].DoubleYellowOut-getGameTime();
      if (remain>=0) 
        r[i].waittime=int(remain/1000);
      else {  //shift right & reset
        r[i].reset();
        for (int j=4; j>0; j--) {
          if (!r[j].state.equals("doubleyellow") && r[j-1].state.equals("doubleyellow")){
            r[j].setRstate(r[j-1]);
            r[j-1].reset();
          }
        }
        DoubleYellowCardCount--;
        println("Double Yellow end: "+shortName+" @"+(isCyan?"left":"right"));
        if (isCyan) send_to_basestation("" + COMM_DOUBLE_YELLOW_IN_CYAN);
        else send_to_basestation("" + COMM_DOUBLE_YELLOW_IN_MAGENTA);
      }
                
    }
  }
  
  void setDoubleYellowOutRemain() {
    println("setDoubleYellowOutRemain");
    for (int j=0; j<5; j++) {
      if (r[j].state.equals("doubleyellow"))  r[j].DoubleYellowOutRemain=r[j].DoubleYellowOut-getGameTime();
      else r[j].DoubleYellowOutRemain=0;
    }
  }

  void resumeDoubleYellowOutRemain() {
    println("resumeDoubleYellowOutRemain");
    for (int j=0; j<5; j++) {
      if (r[j].state.equals("doubleyellow"))  r[j].DoubleYellowOut=r[j].DoubleYellowOutRemain;
      r[j].DoubleYellowOutRemain=0;
    }
  }
  
  void repairclear() {
    this.RepairCount=0;
    this.RepairOut=0;
    for (int i=0; i<5; i++)
      if (r[i].state.equals("repair"))  r[i].reset_to_play();
  }
  
  void checkflags() {
    if (this.newRepair) {
      this.RepairCount++; 
      this.repair_timer_start();
      this.newRepair=false;
    }
    if (this.newYellowCard) {
      this.YellowCardCount=1;
      this.newYellowCard=false;
    }
    if (this.newRedCard) {
      this.RedCardCount++;
      this.newRedCard=false;
    }
    if (this.newDoubleYellow) {
      this.DoubleYellowCardCount++;
      this.YellowCardCount=0;
      this.double_yellow_timer_start();
      this.newDoubleYellow=false;
    }
    if (this.newPenaltyKick) {
      this.PenaltyCount++;
      this.newPenaltyKick=false;
    }
   
  }
  
//*******************************************************************
//*******************************************************************
  
  void updateUI() {
    //side border
    rectMode(TOP);
    noStroke();
    fill(c);
    if (isCyan) rect(0, 0, 4, height);
    else rect(width-4, 0, width, height);

    //team names
    String sn=shortName;
    String ln=longName;
    if (sn.length()>Config.MAXSHORTNAME) sn=shortName.substring(0, Config.MAXSHORTNAME);     
    if (ln.length()>Config.MAXLONGNAME) ln=longName.substring(0, Config.MAXLONGNAME);     
    rectMode(CENTER);
    fill(255);
    textFont(teamFont);
    textAlign(CENTER, CENTER);    
    if (isCyan) text(sn, 126, 32);
    else text(sn, 674, 32);
    textFont(panelFont);
    if (isCyan) text(ln, 126, 80);
    else text(ln, 674, 80);


    // robot state 
    for (int i=0; i<5; i++) r[i].state="play";//in-game: white, default setting
    for (int i=0; i<RepairCount; i++)  r[i].state="repair";//in-repair: blue
    for (int i=RepairCount; i< min(RepairCount+YellowCardCount, 5); i++)  r[i].state="yellow"; //yellow-card: yellow
    for (int i=(RepairCount+YellowCardCount); i<min(RepairCount+YellowCardCount+RedCardCount, 5); i++)  r[i].state="red";//red
    for (int i=(5-DoubleYellowCardCount); i<5; i++)  r[i].state="doubleyellow";//doubleyellow

    if (StateMachine.is1stHalf() || StateMachine.is2ndHalf() || StateMachine.is3rdHalf() || StateMachine.is4thHalf()) {
      if (RepairCount>0)  repair_timer_check();    //repair #
      if (DoubleYellowCardCount>0) double_yellow_timer_check();    //double yellow #
    }
    
    for (int i=0; i<5; i++)
      r[i].updateUI(c,isCyan);

    textAlign(LEFT, BOTTOM);
    textFont(debugFont);
    fill(#ffff00);
    String ts="Goals."+this.Score+" Penalty:"+this.PenaltyCount+"\nYellow:"+this.YellowCardCount+" Red:"+this.RedCardCount+"\nRepair:"+this.RepairCount+" 2xYellow:"+this.DoubleYellowCardCount;
    if (isCyan) text(ts, 20, height-16);
    else text(ts, width-160, height-16);
  }
  
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

