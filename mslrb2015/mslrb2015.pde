/* ==================================
   MSL RefBox 2015 (Processing 3)
       LMFerreira
       RDias
       FAmaral 
       BCunha
   ================================== */
import processing.net.*;
import krister.Ess.*;
import org.json.*;

public static final String MSG_VERSION="1.4.0";
public static final String MSG_VERSION_MSG="(Portuguese Open 2016)";
public static final String MSG_WINDOWTITLE="RoboCup MSL RefBox 2015 - "+MSG_VERSION+" "+MSG_VERSION_MSG;
public static final String MSG_HALFTIME="End Current Part ?";
public static final String MSG_RESET="Reset Game ?";
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

public static final String[] cCommcmds= { "s", "S", "N", "L", "h", "Z", "e" };  
public static final int CMDID_COMMON_START = 0;
public static final int CMDID_COMMON_STOP = 1;
public static final int CMDID_COMMON_DROP_BALL = 2;
public static final int CMDID_COMMON_PARKING = 3;
public static final int CMDID_COMMON_HALFTIME = 4;
public static final int CMDID_COMMON_RESET = 5;
public static final int CMDID_COMMON_ENDGAME = 6;

public static ScoreClients scoreClients = null;
public static MSLRemote mslRemote = null;
public static MyServer BaseStationServer;
public static Client connectingClient = null;

public static Team teamA,teamB;
public static Button[] bTeamAcmds = new Button[CMDID_TEAM_YELLOWCARD + 1];
public static Button[] bTeamBcmds = new Button[CMDID_TEAM_YELLOWCARD + 1];
public static Button[] bCommoncmds = new Button[CMDID_COMMON_RESET + 1];
public static BSliders[] bSlider = new BSliders[4];

public static Table teamstable;
public static TableRow teamselect;
public static long updateScoreClientslasttime=0;
public static long tstartTime=0, tsplitTime=0, tprevsplitTime=0;
public static boolean TESTMODE=false, stopsplittimer=true, VOICECOACH=false, REMOTECONTROLENABLE=false;
public static char LastKickOff='.';
public static String[] Last5cmds= { ".", ".", ".", ".", "." };
public static String LogFileName;
public static String lastaction=".";
public static String gametime = "", gameruntime = "";

//GUI
public static Button[] bPopup = new Button[2];
public static PVector offsetLeft= new PVector(230, 180);
public static PVector offsetRight= new PVector(760, 180);
public static PFont buttonFont, clockFont, panelFont, scoreFont, debugFont, teamFont, watermark;
// public static PImage backgroundImage;
public PImage backgroundImage;
public PImage rcfLogo;

// Sounds
public static AudioChannel soundMaxTime;
public static long lastPlayMillis = 0;

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
  
  backgroundImage = loadImage("img/bg_normal.png");
  size(1000, 680);
  surface.setTitle(MSG_WINDOWTITLE); 
  clockFont = createFont("fonts/LCDM.TTF", 64, false);
  scoreFont = createFont("fonts/LED.ttf", 40, false);
  buttonFont=loadFont("fonts/Futura-CondensedExtraBold-24.vlw");
  teamFont=loadFont("fonts/Futura-CondensedExtraBold-52.vlw");
  panelFont=loadFont("fonts/Futura-CondensedExtraBold-20.vlw");
  debugFont=loadFont("fonts/Monaco-14.vlw");
  watermark=createFont("Arial", 112, false);
  
  createDir(mainApplet.dataPath("tmp/"));
  createDir(mainApplet.dataPath("logs/"));
  
  //==============================================
  //=== Modules Initialization
  Config.Load(this, "config.json");                                     // Load config file
  Log.init(this);                                                       // Init Log module
  comms_initDescriptionDictionary();                                    // Initializes the dictionary for communications with the basestations 

  scoreClients = new ScoreClients(this);        // Load score clients server
  BaseStationServer = new MyServer(this, Config.basestationServerPort); // Load basestations server
  mslRemote = new MSLRemote(this, Config.remoteServerPort);             // Load module for MSL remote control
  
  teamA = new Team(Config.defaultCyanTeamColor,true);                   // Initialize Cyan team (Team A)
  teamB = new Team(Config.defaultMagentaTeamColor,false);               // Initialize Magenta team (Team B)
  teamstable = loadTable("msl_teams.csv", "header");                    // Load teams table
  
  //==============================================
  //=== GUI Initialization
  initGui();
  RefreshButonStatus1();
  resetStartTime(true);
  frameRate(appFrameRate);
  
  // Sounds initialization
  Ess.start(this); // start up Ess
  if(Config.sounds_maxTime.length() > 0) {
    soundMaxTime = new AudioChannel(dataPath("sounds/" + Config.sounds_maxTime));
  }else{
    soundMaxTime = null;
  }
}

/**************************************************************************************************************************
  This the Processing draw() function 
  Called directly after setup(), the draw() function continuously executes the lines of code contained inside its block
  until the program is stopped or noLoop() is called. draw() is called automatically and should never be called explicitly.
  It should always be controlled with noLoop(), redraw() and loop(). If noLoop() is used to stop the code in draw() from executing, 
  then redraw() will cause the code inside draw() to be executed a single time, and loop() will cause the code inside draw() 
  to resume executing continuously.
  The number of times draw() executes in each second may be controlled with the frameRate() function
  It is common to call background() near the beginning of the draw() loop to clear the contents of the window, as shown in the first 
  example above. Since pixels drawn to the window are cumulative, omitting background() may result in unintended results, especially 
  when drawing anti-aliased shapes or text.
  There can only be one draw() function for each sketch, and draw() must exist if you want the code to run continuously, or to process 
  events such as mousePressed(). Sometimes, you might have an empty call to draw() in your program, as shown in the second example above.  
 **************************************************************************************************************************/
void draw() {
  
  background(backgroundImage);
  
  long t1=getGameTime();
  long t2=getSplitTime();
  gametime=nf(int((t1/1000)/60), 2)+":"+nf(int((t1/1000)%60), 2);
  gameruntime=nf(int(t2/1000/60), 2)+":"+nf(int((t2/1000)%60), 2);

  //update basestations data   
  long t=System.currentTimeMillis();
  if ( (t-updateScoreClientslasttime) >= Config.scoreClientsUpdatePeriod_ms ) scoreClients.update_tTeams(gametime,gameruntime);
  //verifyremotecontrol();
  mslRemote.checkMessages();
  checkBasestationsMessages();

  for (int i = 0; i < bCommoncmds.length; i++)
    bCommoncmds[i].update();
  
  for (int i = 0; i < bTeamAcmds.length; i++) {
    bTeamAcmds[i].update();
    bTeamBcmds[i].update();
  }

  teamA.updateUI();
  teamB.updateUI();
  
  for (int i = 0; i < bSlider.length; i++)
    bSlider[i].update();

  StateMachineCheck(); // Check scheduled state change
  RefreshButonStatus1(); // Refresh buttons

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
  text(StateMachine.GetCurrentGameStateString()+" ["+gameruntime+"]", 500, 140);
  //debug msgs  
  textFont(debugFont);
  textAlign(LEFT, BOTTOM);
  fill(#00ff00);
  for (int i=0; i<5; i++)
  {
    text( Last5cmds[i], 340, height-4-i*18);
    fill(#007700);
  }
  fill(255);
  //server info
  textAlign(CENTER, BOTTOM);
  //String time=nf(hour(),2)+":"+nf(minute(),2)+":"+nf(second(),2);
  text(scoreClients.clientCount()+" score clients :: "+BaseStationServer.clientCount+" basestations", width/2, 578);  
  
  //println(StateMachine.GetCurrentGameState().getValue());


  //==========================================

  if (Popup.isEnabled()) {
    Popup.draw();
  }

  //==========================================
  
  if(lastPlayMillis != 0 && millis() - lastPlayMillis > Config.setPieceMaxTime_ms)
  {
    //Log.logMessage("7 seconds rule!");
    lastPlayMillis = 0;
    soundMaxTime.cue(0);
    soundMaxTime.play();
  }
}

/**************************************************************************************************************************
 *   This the Processing exit() function 
 * Quits/stops/exits the program. Programs without a draw() function exit automatically after the last line has run, but programs 
 * with draw() run continuously until the program is manually stopped or exit() is run.
 * Rather than terminating immediately, exit() will cause the sketch to exit after draw() has completed (or after setup() 
 * completes if called during the setup() function).
 * For Java programmers, this is not the same as System.exit(). Further, System.exit() should not be used because closing 
 * out an application while draw() is running may cause a crash (particularly with P3D). 
/**************************************************************************************************************************/
void exit() {
  println("Program is stopped !!!");
  
  // Reset teams to close log files
  if(teamA != null) teamA.reset();
  if(teamB != null) teamB.reset();
  
  LogMerger merger = new LogMerger(Log.getTimedName());
  //merger.merge();
  merger.zipAllFiles();
  
  // Stop all servers
  scoreClients.stopServer();
  BaseStationServer.stop();
  mslRemote.stopServer();
  
  super.exit();
}

void initGui()
{
  //common commands
  for (int i=0; i < bCommoncmds.length; i++){
    bCommoncmds[i] = new Button(435+130*(i%2), 275+i*35-35*(i%2), Commcmds[i], #FEFF00, -1, 255, #FEFF00);
    
    // End part and reset need confirmation popup (don't send message right away)
    if(i <= CMDID_COMMON_PARKING) {
      bCommoncmds[i].cmd = "" + cCommcmds[i];
      bCommoncmds[i].msg = "" + Commcmds[i];
    }
  }
  bCommoncmds[0].setcolor(#12FF03, -1, -1, #12FF03);  //Start  / green
  bCommoncmds[1].setcolor(#E03020, -1, -1, #E03030);  //Stop  /red  #FC0303 

  for (int i=0; i<6; i++) {
    bTeamAcmds[i] = new Button(offsetLeft.x, offsetLeft.y+70*i, Teamcmds[i], 255, -1, 255, Config.defaultCyanTeamColor);
    bTeamAcmds[i].cmd = "" + cCTeamcmds[i];
    bTeamAcmds[i].msg = Teamcmds[i];
    
    bTeamBcmds[i] = new Button(offsetRight.x, offsetRight.y+70*i, Teamcmds[i], 255, -1, 255, Config.defaultMagentaTeamColor);
    bTeamBcmds[i].cmd = "" + cMTeamcmds[i];
    bTeamBcmds[i].msg = Teamcmds[i];
  }

  bTeamAcmds[6] = new Button(offsetLeft.x-135, offsetLeft.y, Teamcmds[6], Config.defaultCyanTeamColor, -1, 255, Config.defaultCyanTeamColor);   // Goal A
  bTeamAcmds[7] = new Button(offsetLeft.x-135, offsetLeft.y+70*4, Teamcmds[7], Config.defaultCyanTeamColor, -1, 255, Config.defaultCyanTeamColor); // Repair A
  bTeamAcmds[8] = new Button(offsetLeft.x-162, offsetLeft.y+70*5, "", #FC0303, #810303, 255, #FC0303);  //red card A
  bTeamAcmds[9] = new Button(offsetLeft.x-105, offsetLeft.y+70*5, "", #FEFF00, #808100, 255, #FEFF00);  //yellow card A
  
  bTeamBcmds[6] = new Button(offsetRight.x+135, offsetRight.y, Teamcmds[6], Config.defaultMagentaTeamColor, -1, 255, Config.defaultMagentaTeamColor);  //Goal B
  bTeamBcmds[7] = new Button(offsetRight.x+135, offsetRight.y+70*4, Teamcmds[7], Config.defaultMagentaTeamColor, -1, 255, Config.defaultMagentaTeamColor);//Repair B
  bTeamBcmds[8] = new Button(offsetRight.x+162, offsetRight.y+70*5, "", #FC0303, #810303, 255, #FC0303);  //red card B
  bTeamBcmds[9] = new Button(offsetRight.x+105, offsetRight.y+70*5, "", #FEFF00, #808100, 255, #FEFF00);  //yellow card B
  
  for (int i = 6; i < 10; i++) {
    bTeamAcmds[i].cmd = "" + cCTeamcmds[i];
    bTeamAcmds[i].msg = Teamcmds[i];
    bTeamBcmds[i].cmd = "" + cMTeamcmds[i];
    bTeamBcmds[i].msg = Teamcmds[i];
  }

  // OFF-state goal button (subtract goal)
  bTeamAcmds[6].msg_off = "Goal-";
  bTeamAcmds[6].cmd_off = "" + COMM_SUBGOAL_CYAN;
  bTeamBcmds[6].msg_off = "Goal-";
  bTeamBcmds[6].cmd_off = "" + COMM_SUBGOAL_MAGENTA;
  

  bTeamAcmds[8].setdim(32, 48); 
  bTeamAcmds[9].setdim(32, 48); 
  bTeamBcmds[8].setdim(32, 48);  //red C resize
  bTeamBcmds[9].setdim(32, 48);  //yellow C resize

  bPopup[0] = new Button(0, 0, "y", 255, Config.defaultCyanTeamColor, 0, Config.defaultCyanTeamColor);
  bPopup[1] = new Button(0, 0, "n", 255, Config.defaultMagentaTeamColor, 0, Config.defaultMagentaTeamColor);

  bSlider[0]=new BSliders("Testmode",420,480,true, TESTMODE);
  bSlider[1]=new BSliders("Log",420+132,480,true, Log.enable);
  bSlider[2]=new BSliders("Remote",420,480+32,Config.remoteControlEnable, REMOTECONTROLENABLE);
  bSlider[3]=new BSliders("Coach",420+132,480+32,false, VOICECOACH);
  
  buttonCSTOPactivate();
}

boolean createDir(String dirPath)
{
    // Create logs directory if necessary
    File logsDir = new File(dirPath);
    if(!logsDir.exists() || !logsDir.isDirectory())
    {
      if(!logsDir.mkdir()){
        println("ERROR - Could not create logs directory.");
        return false;
      }
    }
    return true;
}