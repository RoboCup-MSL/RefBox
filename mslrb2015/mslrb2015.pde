/* ==================================
   MSL RefBox 2015 (Processing 2.2.1)
       LMFerreira
       RDias
       FAmaral 
       BCunha
   ================================== */
import processing.net.*;
import org.json.*;

public static final String MSG_VERSION="Beta 0.9.2";
public static final String MSG_VERSION_MSG="";
public static final String MSG_WINDOWTITLE="MSL RefBox 2015 - "+MSG_VERSION+" ("+MSG_VERSION_MSG+")";
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

public static final String[] cCommcmds= { "s", "S", "N", "L", "h", "Z" };  
public static final int CMDID_COMMON_START = 0;
public static final int CMDID_COMMON_STOP = 1;
public static final int CMDID_COMMON_DROP_BALL = 2;
public static final int CMDID_COMMON_PARKING = 3;
public static final int CMDID_COMMON_HALFTIME = 4;
public static final int CMDID_COMMON_RESET = 5;
public static final int CMDID_COMMON_ENDGAME = 6;

public static ScoreClients scoreClients = null;
public static MSLRemote mslRemote = null;
public static Server BaseStationServer;
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
public static boolean TESTMODE=false, stopsplittimer=true, BACKGROUNDon=true, VOICECOACH=false, REMOTECONTROLENABLE=false;
public static char LastKickOff='.';
public static String[] Last5cmds= { ".", ".", ".", ".", "." };
public static String LogFileName;
public static String lastaction=".";
public static String gametime = "", gameruntime = "";

//GUI
public static Button[] bPopup = new Button[2];
public static PVector offsetLeft= new PVector(180, 160);
public static PVector offsetRight= new PVector(620, 160);
public static PFont buttonFont, clockFont, panelFont, scoreFont, debugFont, teamFont, watermark;
public static PImage backgroundImage;

public static PApplet mainApplet = null;
//static long ctr = 0;

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
  
  size(800, 600);
  frame.setTitle(MSG_WINDOWTITLE); 
  /*  Crystal font — Created in 1993 by Allen R. Walden
      http://www.fontspace.com/allen-r-walden/crystal
  */
//  clockFont = createFont("fonts/Crysta.ttf", 64, false);
//  scoreFont = createFont("fonts/Crysta.ttf", 32, false);
  clockFont = createFont("fonts/LCDM.TTF", 58, false);
  scoreFont = createFont("fonts/LED.ttf", 36, false);
  buttonFont=loadFont("fonts/Futura-CondensedExtraBold-24.vlw");
  teamFont=loadFont("fonts/Futura-CondensedExtraBold-52.vlw");
  panelFont=loadFont("fonts/Futura-CondensedExtraBold-16.vlw");
  debugFont=loadFont("fonts/Monaco-12.vlw");
  watermark=createFont("Arial", 112, false);
  
  //==============================================
  //=== Modules Initialization
  Config.Load(this, "config.json");                                     // Load config file
  Log.init(this);                                                       // Init Log module
  comms_initDescriptionDictionary();                                    // Initializes the dictionary for communications with the basestations 
  
  setbackground();                                                      // Load background

  scoreClients = new ScoreClients(this, Config.scoreServerPort);        // Load score clients server
  BaseStationServer = new Server(this, Config.basestationServerPort);   // Load basestations server
  mslRemote = new MSLRemote(this, Config.remoteServerPort);             // Load module for MSL remote control
  
  println("This IP: "+Server.ip());
  teamA = new Team(Config.defaultCyanTeamColor,true);                   // Initialize Cyan team (Team A)
  teamB = new Team(Config.defaultMagentaTeamColor,false);               // Initialize Magenta team (Team B)
  teamstable = loadTable("msl_teams.csv", "header");                    // Load teams table
  
  //==============================================
  //=== GUI Initialization
  initGui();
  RefreshButonStatus1();
  resetStartTime();
  
  frameRate(appFrameRate);
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
  
  if (BACKGROUNDon) background(backgroundImage);
  else background(48);

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

//    ctr ++;
//    println ("Update : ", ctr);
  teamA.updateUI();
  teamB.updateUI();
  
  for (int i = 0; i < bSlider.length; i++)
    bSlider[i].update();

  // Check scheduled state change
  StateMachineCheck();
  
  // Refresh buttons
  RefreshButonStatus1();

  fill(255);
  textAlign(CENTER, CENTER);
  //score
  textFont(scoreFont);
  text("[  "+teamA.Score+"  -  "+teamB.Score+"  ]", 400, 20);
  //main clock
  textFont(clockFont);
  fill(255);
  text( gametime, 400, 72);
  //run clock  
  textFont(panelFont);
  text(StateMachine.GetCurrentGameStateString()+" ["+gameruntime+"]", 400, 123);
  //debug msgs  
  textFont(debugFont);
  textAlign(LEFT, BOTTOM);
  fill(#00ff00);
  for (int i=0; i<5; i++)
    text( Last5cmds[i], 250, height-2-i*16);
  fill(255);
  //server info
  textAlign(CENTER, BOTTOM);
  String time=nf(hour(),2)+":"+nf(minute(),2)+":"+nf(second(),2);
  text("[ "+time+" ]     "+Server.ip()+" ["+scoreClients.clientCount()+"/"+BaseStationServer.clientCount+"]", width/2, 512);  
  
  //println(StateMachine.GetCurrentGameState().getValue());

  //==========================================

  if (Popup.isEnabled()) {
    Popup.draw();
  }

  //==========================================   
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
    bCommoncmds[i] = new Button(340+120*(i%2), 224+i*32-32*(i%2), Commcmds[i], #FEFF00, -1, 255, #FEFF00);
    
    // End part and reset need confirmation popup (don't send message right away)
    if(i <= CMDID_COMMON_PARKING) {
      bCommoncmds[i].cmd = "" + cCommcmds[i];
      bCommoncmds[i].msg = "" + Commcmds[i];
    }
  }
  bCommoncmds[0].setcolor(#12FF03, -1, -1, #12FF03);  //Start  / green
  bCommoncmds[1].setcolor(#FC0303, -1, -1, #FC0303);  //Stop  /red 

  for (int i=0; i<6; i++) {
    bTeamAcmds[i] = new Button(offsetLeft.x, offsetLeft.y+64*i, Teamcmds[i], 255, -1, 255, Config.defaultCyanTeamColor);
    bTeamAcmds[i].cmd = "" + cCTeamcmds[i];
    bTeamAcmds[i].msg = Teamcmds[i];
    
    bTeamBcmds[i] = new Button(offsetRight.x, offsetRight.y+64*i, Teamcmds[i], 255, -1, 255, Config.defaultMagentaTeamColor);
    bTeamBcmds[i].cmd = "" + cMTeamcmds[i];
    bTeamBcmds[i].msg = Teamcmds[i];
  }

  bTeamAcmds[6] = new Button(offsetLeft.x-108, offsetLeft.y, Teamcmds[6], Config.defaultCyanTeamColor, -1, 255, Config.defaultCyanTeamColor);   // Goal A
  bTeamAcmds[7] = new Button(offsetLeft.x-108, offsetLeft.y+64*4, Teamcmds[7], Config.defaultCyanTeamColor, -1, 255, Config.defaultCyanTeamColor); // Repair A
  bTeamAcmds[8] = new Button(offsetLeft.x-130, offsetLeft.y+64*5, "", #FC0303, #810303, 255, #FC0303);  //red card A
  bTeamAcmds[9] = new Button(offsetLeft.x-84, offsetLeft.y+64*5, "", #FEFF00, #808100, 255, #FEFF00);  //yellow card A
  
  bTeamBcmds[6] = new Button(offsetRight.x+108, offsetRight.y, Teamcmds[6], Config.defaultMagentaTeamColor, -1, 255, Config.defaultMagentaTeamColor);  //Goal B
  bTeamBcmds[7] = new Button(offsetRight.x+108, offsetRight.y+64*4, Teamcmds[7], Config.defaultMagentaTeamColor, -1, 255, Config.defaultMagentaTeamColor);//Repair B
  bTeamBcmds[8] = new Button(offsetRight.x+130, offsetRight.y+64*5, "", #FC0303, #810303, 255, #FC0303);  //red card B
  bTeamBcmds[9] = new Button(offsetRight.x+84, offsetRight.y+64*5, "", #FEFF00, #808100, 255, #FEFF00);  //yellow card B
  
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

  bSlider[0]=new BSliders("Testmode",310,424,true, TESTMODE);
  bSlider[1]=new BSliders("Log",310+132,424,true, Log.enable);
  bSlider[2]=new BSliders("Remote",310,424+32,Config.remoteControlEnable, REMOTECONTROLENABLE);
  bSlider[3]=new BSliders("Coach",310+132,424+32,false, VOICECOACH);
  
  buttonCSTOPactivate();
}

