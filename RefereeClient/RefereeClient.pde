/* ==================================
   MSL RefereeClient (Processing 3)
       Ricardo Dias <ricardodias@ua.pt>
       Bernardo Cunha <mbc@det.ua.pt>
   ================================== */
import processing.net.*;
import org.json.*;

public static final String MSG_VERSION="1.1.0";
public static final String MSG_VERSION_MSG="";
public static final String MSG_WINDOWTITLE="RoboCup MSL Referee Client - "+MSG_VERSION+" "+MSG_VERSION_MSG;

public static final int appFrameRate = 15;

public static String[] Teamcmds= { "KickOff", "FreeKick", "GoalKick", "Throw In", "Corner", "Penalty", "Goal", "Repair", "Red", "Yellow" };
public static String[] Commcmds= { "START", "STOP", "DropBall", "Park", "End Part",  "RESET", "EndGame" };

public static final String[] cCTeamcmds= { "K", "F", "G", "T", "C", "P", "A", "O", "R", "Y" };
public static final String[] cMTeamcmds= { "k", "f", "g", "t", "c", "p", "a", "o", "r", "y" };
public static final int CMDID_TEAM_KICKOFF = 0;
public static final int CMDID_TEAM_FREEKICK = 1;
public static final int CMDID_TEAM_GOALKICK = 2;
public static final int CMDID_TEAM_THROWIN = 3;
public static final int CMDID_TEAM_CORNER = 4;
public static final int CMDID_TEAM_PENALTY = 5;
public static final int CMDID_TEAM_GOAL = 6;
public static final int CMDID_TEAM_REPAIR_OUT = 7;
public static final int CMDID_TEAM_REDCARD = 8;
public static final int CMDID_TEAM_YELLOWCARD = 9;

public static final String[] cCommcmds= { "s", "S", "N", "L", "h", "Z" };  
public static final int CMDID_COMMON_START = 0;
public static final int CMDID_COMMON_STOP = 1;
public static final int CMDID_COMMON_DROP_BALL = 2;
public static final int CMDID_COMMON_PARKING = 3;
public static final int CMDID_COMMON_HALFTIME = 4;
public static final int CMDID_COMMON_RESET = 5;
public static final int CMDID_COMMON_ENDGAME = 6;

public static Team teamA,teamB;
Client myClient;
String msgBuffer = "";

public static String[] Last5cmds= { ".", ".", ".", ".", "." };
public static String LogFileName;
public static String lastaction=".";
public static String gametime = "", gameruntime = "";

public static String currentGameStateString = "Stop";
public static String lastCommandCode = "";
public static String lastCommandDescription = "";
public static int lastConnectionAttempt = 0;
public static int nConnAttempts = 0;
public static int gameState = 0;

//GUI
public static PVector offsetLeft= new PVector(250, 160);
public static PVector offsetRight= new PVector(610, 160);
public static PFont buttonFont, clockFont, panelFont, scoreFont, debugFont, teamFont, watermark;
public static PImage backgroundImage;

public static PApplet mainApplet = null;

/**************************************************************************************************************************
 * This the Processing setup() function
 * The setup() function is called once when the program starts.
 * It's used to define initial enviroment properties such as screen size and background color and to load media
  such as images and fonts as the program starts.
 * There can only be one setup() function for each program and it shouldn't be called again after its initial execution.
 * Note: Variables declared within setup() are not accessible within other functions, including draw().
**************************************************************************************************************************/
void setup() {
  mainApplet = this;
  
  size(1000, 680);
  
 backgroundImage = loadImage("img/bg_wood.png");

  frame.setTitle(MSG_WINDOWTITLE); 
  clockFont = createFont("fonts/LCDM.TTF", 64, false);
  scoreFont = createFont("fonts/LED.ttf", 40, false);
  buttonFont=loadFont("fonts/Futura-CondensedExtraBold-24.vlw");
  teamFont=loadFont("fonts/Futura-CondensedExtraBold-52.vlw");
  panelFont=loadFont("fonts/Futura-CondensedExtraBold-20.vlw");
  debugFont=loadFont("fonts/Monaco-14.vlw");
  watermark=createFont("Arial", 112, false);
  
  //==============================================
  //=== Modules Initialization
  Config.Load(this, "config.json");                                     // Load config file
  Log.init(this);                                                       // Init Log module
  comms_initDescriptionDictionary();                                    // Initializes the dictionary for communications with the basestations 
  
//  setbackground();                                                      // Load background

  println("This IP: "+Server.ip());
  teamA = new Team(Config.defaultCyanTeamColor,true);                   // Initialize Cyan team (Team A)
  teamB = new Team(Config.defaultMagentaTeamColor,false);               // Initialize Magenta team (Team B)
  //myClient = new Client(this, Config.scoreServerHost, Config.scoreServerPort);
  lastConnectionAttempt = millis();
  nConnAttempts = 0;
  
  frameRate(appFrameRate);
}

/**************************************************************************************************************************
  This the Processing draw() function 
 **************************************************************************************************************************/
void draw() {
  
  if(myClient == null || !myClient.active()) {
    if(myClient == null || millis() - lastConnectionAttempt > 1000)
    {
      myClient = new Client(this, Config.scoreServerHost, Config.scoreServerPort);
      lastConnectionAttempt = millis();
      nConnAttempts++;
      for(int i = 0; i < 5; i++)
        Last5cmds[i] = ".";
      teamA.reset();
      teamB.reset();
      lastCommandCode = ".";
      lastCommandDescription = "";
    }
  }else{
    if (myClient.available() > 0) { 
      String whatClientSaid = new String(myClient.readBytes());
      if(whatClientSaid != null)
        while(whatClientSaid.length() != 0)
        {
          nConnAttempts = 0;
          
          int idx = whatClientSaid.indexOf('\0');
          if(idx == -1) { // Terminator not found
            msgBuffer += whatClientSaid;
            break;
          }else{ // Terminator found
            if(idx != 0)
            {
              msgBuffer += whatClientSaid.substring(0,idx);
              if(idx < whatClientSaid.length())
                whatClientSaid = whatClientSaid.substring(idx+1);
              else
                whatClientSaid = "";
            }else{
              if(whatClientSaid.length() == 1)
                whatClientSaid = "";
              else
                whatClientSaid = whatClientSaid.substring(1);
            }
            
            // Validate message
            boolean ok = true;
            org.json.JSONObject root = null;
            org.json.JSONObject jsonA = null;
            org.json.JSONObject jsonB = null;
            
            try // Check for malformed JSON
            {
              root = new org.json.JSONObject(msgBuffer);
            } catch(JSONException e) {
              String errorMsg = "ERROR malformed JSON : " + msgBuffer;
              println(errorMsg);
              ok = false;
            }
            
            if(ok && root.has("type") && root.optString("type","").equals("event")) // event type messages
            {
              String eventCode = root.optString("eventCode","");
              if(Description.hasKey(eventCode))
              {
                String desc = Description.get(eventCode);
                Log.logactions(eventCode);
                lastCommandCode = eventCode;
                lastCommandDescription = desc;
              }
            }else if(ok && root.has("type") && root.optString("type","").equals("teams")){
            
              if(ok)
              {
                try // Check for worldstate
                {
                  jsonA = root.getJSONObject("teamA");
                  jsonB = root.getJSONObject("teamB");
                } catch(JSONException e) {
                  String errorMsg = "ERROR No worldstate from teams : " + msgBuffer;
                  println(errorMsg);
                  ok = false;
                }
              }
              
              if(ok && root != null && jsonA != null && jsonB != null)
              {
                // Global
                currentGameStateString = root.optString("gameStateString");
                gametime = root.optString("gameTime", gametime);
                gameruntime = root.optString("gameRunTime", gameruntime);
                gameState = root.optInt("gameState", gameState);
                
                // Team A
                teamA.shortName = jsonA.optString("shortName", teamA.shortName);
                teamA.longName = jsonA.optString("longName", teamA.longName);
                teamA.Score = jsonA.optInt("score", teamA.Score);
                if(jsonA.has("robotState")) {
                  for(int i = 0; i < 5; i++) {
                    org.json.JSONArray state = jsonA.getJSONArray("robotState");
                    teamA.r[i].state = state.optString(i, teamA.r[i].state);
                    
                    org.json.JSONArray waitTime = jsonA.getJSONArray("robotWaitTime");
                    teamA.r[i].waittime = waitTime.optInt(i, teamA.r[i].waittime);
                  }
                }
                
                // Team B
                teamB.shortName = jsonB.optString("shortName", teamB.shortName);
                teamB.longName = jsonB.optString("longName", teamB.longName);
                teamB.Score = jsonB.optInt("score", teamB.Score);
                if(jsonB.has("robotState")) {
                  for(int i = 0; i < 5; i++) {
                    org.json.JSONArray state = jsonB.getJSONArray("robotState");
                    teamB.r[i].state = state.optString(i, teamB.r[i].state);
                    org.json.JSONArray waitTime = jsonB.getJSONArray("robotWaitTime");
                    teamB.r[i].waittime = waitTime.optInt(i, teamB.r[i].waittime);
                  }
                }
              }
            
            } // end "teams" type
            msgBuffer = ""; // Clean buffer
          }
        }
    }
  }
  
  
  background(backgroundImage);
  
//    ctr ++;
//    println ("Update : ", ctr);
  teamA.updateUI();
  teamB.updateUI();
  
  if(myClient != null && myClient.active())
  {
    fill(255);
    textAlign(CENTER, CENTER);
    //score
    textFont(scoreFont);
    text("[  "+teamA.Score+"  -  "+teamB.Score+"  ]", 500, 25);
    //main clock
    textFont(clockFont);
    fill(255);
    text( gametime, 500, 85);
    //run clock  
    textFont(panelFont);
    text("["+gameruntime+"]", 500, 140);
    //debug msgs  
    textFont(debugFont);
    textAlign(LEFT, BOTTOM);
    fill(#00ff00);
    for (int i=0; i<5; i++)
      text( Last5cmds[i], 340, height-4-i*18);
    fill(255);
    //server info
    textAlign(CENTER, BOTTOM);
    String time=nf(hour(),2)+":"+nf(minute(),2)+":"+nf(second(),2);
    //text("[ "+time+" ]     "+Server.ip()+" ["+scoreClients.clientCount()+"/"+BaseStationServer.clientCount+"]", width/2, 578);   
  }
  
  // Show current situation in the middle
  if(myClient == null || !myClient.active()) {
    fill(255);
    textFont(teamFont);
    textSize(36);
    textAlign(CENTER, CENTER);
    text("Connecting to\n"+Config.scoreServerHost+"\n(" + nConnAttempts + ")", width/2, height/2 + 30);
  }else{
    PImage img = null;
    String imageName = "";
    if(lastCommandCode.equals("S")) imageName = "stop";
    if(imageName.length() > 0 && new File(dataPath("img/"+imageName+".png")).exists() && (img = loadImage("img/"+imageName+".png")) != null)
    {
      imageMode(CENTER);
      image(img, width/2, height/2 + 45, 230, 230);
    }else{
      fill(255);
      String description = lastCommandDescription;
      if(description.contains("START"))
        fill(#28C700);
      else if(description.contains("MAGENTA"))
      {
        fill(teamB.c);
        description = description.replace(" MAGENTA","\nMAGENTA");
      }else if(description.contains("CYAN"))
      {
        fill(teamA.c);
        description = description.replace(" CYAN","\nCYAN");
      }
      textFont(teamFont);
      textAlign(CENTER, CENTER);
      text(description, width/2, height/2 + 45);
    }
  }
}

/**************************************************************************************************************************
 *   This the Processing exit() function 
/**************************************************************************************************************************/
void exit() {
  println("Program is stopped !!!");
  
  // Reset teams to close log files
  if(teamA != null) teamA.reset();
  if(teamB != null) teamB.reset();
  
  super.exit();
}