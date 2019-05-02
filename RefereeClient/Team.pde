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
    r[1]=new Robot(x+138, y);
    r[2]=new Robot(x, y+138);
    r[3]=new Robot(x+138, y+138);
    r[4]=new Robot(x+69, y+276);
    
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
    this.connectedClient = null;
    this.firstWorldState = true;
  }

  void updateUI() {
    //side border
    rectMode(TOP);
    noStroke();
    fill(c);
    if (isCyan) rect(0, 0, 4, height);
    else rect(width-4, 0, width, height);

    //team names
    String sn=shortName;
    //String ln=longName;
    if (sn.length()>Config.maxShortName) sn=shortName.substring(0, Config.maxShortName);
    //if (ln.length()>Config.maxLongName) ln=longName.substring(0, Config.maxLongName);     
    rectMode(CENTER);
    fill(255);
    textFont(teamFont);
    textAlign(CENTER, CENTER);    
    if (isCyan) text(sn, 163, 70);
    else text(sn, 837, 70);
    textFont(panelFont);

    for (int i=0; i<5; i++)
      r[i].updateUI(c,isCyan);

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
