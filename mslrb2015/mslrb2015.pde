//<>//
//<>//
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

public static final String MSG_VERSION="2.0 beta(Json)";
public static final String MSG_VERSION_MSG="(RoboCup 2020)";
public static final String MSG_WINDOWTITLE="RoboCup MSL RefBox 2015 - "+MSG_VERSION+" "+MSG_VERSION_MSG;
public static final String MSG_HALFTIME="End Current Part ?";
public static final String MSG_RESET="Reset Game ?";
public static final String MSG_REPAIR="How many robots for repair ?";
public static final String MSG_SUBS="Substitute Players";
public static final String MSG_WAIT="Please WAIT! Compressing files.";
public static final String MSG_CONFIG="Configurations";
public static String MSG_HELP="SHORT CUT KEYS:";
public static final String MSG_ISALIVE="Is Alive Proof Command";

public static final int appFrameRate = 25;

public static final int CMDID_TEAM_KICKOFF = 0;
public static final int CMDID_TEAM_FREEKICK = 1;
public static final int CMDID_TEAM_GOALKICK = 2;
public static final int CMDID_TEAM_THROWIN = 3;
public static final int CMDID_TEAM_CORNER = 4;
public static final int CMDID_TEAM_PENALTY = 5;
public static final int CMDID_TEAM_ISALIVE = 6;
public static final int CMDID_TEAM_GOAL = 7;
public static final int CMDID_TEAM_REPAIR_OUT = 8;
public static final int CMDID_TEAM_REDCARD = 9;
public static final int CMDID_TEAM_YELLOWCARD = 10;
public static final int CMDID_TEAM_LENGHT = 11;

public static final int CMDID_COMMON_START = 0;
public static final int CMDID_COMMON_STOP = 1;
public static final int CMDID_COMMON_DROP_BALL = 2;
public static final int CMDID_COMMON_PARKING = 3;
public static final int CMDID_COMMON_HALFTIME = 4;
public static final int CMDID_COMMON_RESET = 5;
public static final int CMDID_COMMON_SUBS = 6;
public static final int CMDID_COMMON_CONFIG = 7;
public static final int CMDID_COMMON_LENGHT = 8;

public static ScoreClients scoreClients = null;
//public static MSLRemote mslRemote = null;
public static MyServer BaseStationServer;
public static Client connectingClient = null;

public static Team teamA, teamB, cTeam;
public static Button[] bTeamAcmds = new Button[CMDID_TEAM_LENGHT];
public static Button[] bTeamBcmds = new Button[CMDID_TEAM_LENGHT];
public static Button[] bCommoncmds = new Button[CMDID_COMMON_LENGHT];
public static BSliders[] bSlider = new BSliders[4];
public static Textbox[] tBox = new Textbox[6];
public static Textbox tBoxIsAlive; 
public static String previousNameTeamA, previousNameTeamB;

public static Table teamstable;
public static TableRow teamselect;
public static long updateScoreClientslasttime=0;
public static long tstartTime=0, tsplitTime=0, tprevsplitTime=0;
public static boolean TESTMODE=false, stopsplittimer=true, VOICECOACH=false, REMOTECONTROLENABLE=false;
public static char LastKickOff='.';
public static String[] Last5cmds= { ".", ".", ".", ".", "." };
public static String LogFileName;
public static String gametime = "", gameruntime = "";

//GUI
public static final int popUpButtons = 11;					// Currently defined number of Pop Up Buttons
public static Button[] bPopup = new Button[popUpButtons];	// button 0 is reserved.
public static PVector offsetLeft= new PVector(230, 180);
public static PVector offsetRight= new PVector(760, 180);
public static PFont buttonFont, clockFont, panelFont, scoreFont, debugFont, teamFont, textFont;

// public static PImage backgroundImage;
public PImage backgroundImage;
public static PImage skullImage;
public static PImage skullImageOff;
public static PImage skullImageOver;
public static PImage skullImageLeft;
public static PImage skullImageRight;
public PImage rcfLogo;

// Watches as timers
public static StopWatch mainWatch;            // Main watch allways running. Reseted @end-of-parts and end-halfs
public static StopWatch playTimeWatch;        // Actual played time. Reseted @end-of-parts and end-halfs
public static StopWatch setPieceDelay;        // Timer for measuring set piece restart
public static StopWatch blinkTab;        	  // Timer for blinkking tab in textBoxes
public static boolean blinkStatus = false;	  // Defines if bertical tab should be show\

// Sounds
public static AudioChannel soundMaxTime;
public static long lastPlayMillis = 0;

public static PApplet mainApplet = null;
public static boolean altK = false;
public static boolean forceKickoff = false;


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
	//PrintWriter output;
	
	//// Get system fonts list and write it to fonts.txt
	//String[] fontList = PFont.list();
	//int n = fontList.length;
	//output = createWriter("fonts.txt");
	//for (int i = 0; i < n; i++) //<>//
	//{
	//	output.println(fontList[i]);	
	//}
	//output.flush(); // Writes the remaining data to the file
	//output.close(); // Finishes the file

	backgroundImage = loadImage("img/bg_normal.png");
	skullImage = loadImage("img/Skullsmall.png");
	skullImageOff = loadImage("img/smallSkullOff.png");
	skullImageOver = loadImage("img/SkullsmallOver.png");;
	skullImageLeft = loadImage("img/smallSkullLeft.png");;
	skullImageRight = loadImage("img/smallSkullRight.png");;
	size(1000, 680);

	surface.setTitle(MSG_WINDOWTITLE); 
	clockFont = createFont("fonts/LCDM.TTF", 64, false);
	scoreFont = createFont("fonts/LED.ttf", 40, false);
	buttonFont=loadFont("fonts/Futura-CondensedExtraBold-24.vlw");
	teamFont=loadFont("fonts/Futura-CondensedExtraBold-52.vlw");
	panelFont=loadFont("fonts/Futura-CondensedExtraBold-20.vlw");
	debugFont=loadFont("fonts/Monaco-14.vlw");
	textFont=createFont("Arial", 22, true);

	createDir(mainApplet.dataPath("tmp/"));
	createDir(mainApplet.dataPath("logs/"));

	//==============================================
	//=== Modules Initialization
	Config.Load(this, "config.json");                                     // Load config file
	Log.init(this);                                                       // Init Log module
	comms_initDescriptionDictionary();                                    // Initializes the dictionary for communications with the basestations 

	scoreClients = new ScoreClients(this);        // Load score clients server
	BaseStationServer = new MyServer(this, Config.basestationServerPort); // Load basestations server
	//	mslRemote = new MSLRemote(this, Config.remoteServerPort);             // Load module for MSL remote control

	teamA = new Team(Config.defaultLeftTeamColor,true);                   // Initialize Left team (Team A)
	teamB = new Team(Config.defaultRightTeamColor,false);               // Initialize Right team (Team B)
	teamstable = new TeamTableBuilder("msl_teams.json").build();          // Load teams table

	//==============================================
	//=== GUI Initialization
	initGui();
	RefreshButonStatus1();

	mainWatch = new StopWatch(false, 0, true, false);
	mainWatch.resetStopWatch();
	mainWatch.startSW();

	playTimeWatch = new StopWatch(false, 0, false, false);
	playTimeWatch.resetStopWatch();
	playTimeWatch.startSW();

	setPieceDelay = new StopWatch(true, 0, true, false);
	
	blinkTab = new StopWatch(true, 0, true, false);
	blinkTab.startTimer(Config.blinkTime_ms);

	frameRate(appFrameRate);

	MSG_HELP += "\nSpaceTab > Force STOP action";
	MSG_HELP += "\nAlt + K    > Enable KickOff buttons";
	MSG_HELP += "\nAlt + R    > Force RESET of game at any time";
	MSG_HELP += "\nESC        > Exit PopUp window";
	MSG_HELP += "\nH           > Show this pop up";
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

	// Update Timers and Watches
	mainWatch.updateStopWatch();
	playTimeWatch.updateStopWatch();
	setPieceDelay.updateStopWatch();
	blinkTab.updateStopWatch();

	long t1 = mainWatch.getTimeSec();
	long t2 = playTimeWatch.getTimeSec();
	long t3 = blinkTab.getTimeMs();	
	if (t3 == 0){
		blinkTab.startTimer(Config.blinkTime_ms);
		blinkStatus = !blinkStatus;
	}

	gametime = nf(int(t1/60), 2)+":"+nf(int(t1%60), 2);
	gameruntime = nf(int(t2/60), 2)+":"+nf(int(t2%60), 2);

	//update basestations data   
	long t=System.currentTimeMillis();
	if ( (t-updateScoreClientslasttime) >= Config.scoreClientsUpdatePeriod_ms ) scoreClients.update_tTeams(gametime,gameruntime);

	//verifyremotecontrol();
	//mslRemote.checkMessages();
	
	checkBasestationsMessages();

	for (int i = 0; i < bCommoncmds.length; i++)
	bCommoncmds[i].update();

	for (int i = 0; i < bTeamAcmds.length; i++) {
		bTeamAcmds[i].update();
		bTeamBcmds[i].update();
	}

	teamA.updateUI();
	teamB.updateUI();

	fill(255);
	textAlign(CENTER, CENTER);

	//dispay score
	textFont(scoreFont);
	text("[  "+teamA.Score+"  -  "+teamB.Score+"  ]", 500, 25);

	//display main running clock
	textFont(clockFont);
	fill(255);
	text( gametime, 500, 85);

	//display effective game clock  
	textFont(panelFont);
	text(StateMachine.GetCurrentGameStateString()+" ["+gameruntime+"]", 500, 140);

	//debug msgs  
	textFont(debugFont);
	textAlign(LEFT, BOTTOM);
	fill(#00ff00);
	for (int i=0; i<5; i++)	{
		text( Last5cmds[i], 340, height-4-i*18);
		fill(#007700);
	}
	fill(255);
	textAlign(CENTER, BOTTOM);
	text("Press H for a short help!", 500, 530);

	//server info
	textAlign(CENTER, BOTTOM);

	text(scoreClients.clientCount()+" score clients :: "+BaseStationServer.clientCount+" basestations", width/2, 578);  

	//==========================================

	if(setPieceDelay.getStatus() && setPieceDelay.getTimeMs() == 0)
	{
		setPieceDelay.stopTimer();
		soundMaxTime.cue(0);
		soundMaxTime.play();
	}

	StateMachineCheck(); // Check scheduled state change


	if (Popup.isEnabled()) {
		Popup.draw();
	}

	for (int i = 0; i < bSlider.length; i++) {
		if(bSlider[i].enabled){
			//  println("slider" + i);
			bSlider[i].update();
		}
	}  

	for (int i=0; i<tBox.length; i++) {
		if (tBox[i].visible) {
			tBox[i].update();
		}
	}
	
	if (tBoxIsAlive.visible) tBoxIsAlive.update();

	RefreshButonStatus1(); // Refresh buttons

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

	LogMerger merger = new LogMerger(Log.getTimedName());
	merger.zipAllFiles();

	// Stop all servers
	scoreClients.stopServer();
	BaseStationServer.stop();
	//mslRemote.stopServer();

	super.exit();
}

void initGui()
{

	//common commands
	bCommoncmds[0] = new Button(435+130*(0%2), 275+0*35-35*(0%2), "START",#12FF03, -1, -1, #12FF03,COMM_START,Description.get(COMM_START),"",""); //Start  / green
	bCommoncmds[1] = new Button(435+130*(1%2), 275+1*35-35*(1%2), "STOP", #E03020, -1, -1, #E03030,COMM_STOP,Description.get(COMM_STOP),"",""); //Stop  /red  #FC0303 
	bCommoncmds[2] = new Button(435+130*(2%2), 275+2*35-35*(2%2), "DropBall", #C0C000, -1, 255, #C0C000,COMM_DROP_BALL,Description.get(COMM_DROP_BALL),"","");
	bCommoncmds[3] = new Button(435+130*(3%2), 275+3*35-35*(3%2),"Park", #C0C000, -1, 255, #C0C000,COMM_PARK,Description.get(COMM_PARK),"","");
	bCommoncmds[4] = new Button(435+130*(4%2), 275+4*35-35*(4%2), "End Part", #C0C000, -1, 255, #C0C000,COMM_END_PART,Description.get(COMM_END_PART),"","");
	bCommoncmds[5] = new Button(435+130*(5%2), 275+5*35-35*(5%2), "RESET", #C0C000, -1, 255, #C0C000,COMM_RESET,Description.get(COMM_RESET),"","");
	bCommoncmds[6] = new Button(435+130*(6%2), 275+6*35-35*(6%2), "Substitute", #C0C000, -1, 255, #C0C000,COMM_SUBSTITUTION,Description.get(COMM_SUBSTITUTION),"","");
	bCommoncmds[7] = new Button(435+130*(7%2), 275+7*35-35*(7%2),  "CONFIG", #C0C000, -1, 255, #C0C000,"","","","");


	//TEAM commands

	bTeamAcmds[0] = new Button(offsetLeft.x, offsetLeft.y+70*0, "KickOff" , 255, -1, 255, Config.defaultLeftTeamColor,COMM_KICKOFF,Description.get(COMM_KICKOFF),"","");
	bTeamAcmds[1] = new Button(offsetLeft.x, offsetLeft.y+70*1, "FreeKick", 255, -1, 255, Config.defaultLeftTeamColor,COMM_FREEKICK,Description.get(COMM_FREEKICK),"","");
	bTeamAcmds[2] = new Button(offsetLeft.x, offsetLeft.y+70*2, "GoalKick", 255, -1, 255, Config.defaultLeftTeamColor,COMM_GOALKICK,Description.get(COMM_GOALKICK),"","");
	bTeamAcmds[3] = new Button(offsetLeft.x, offsetLeft.y+70*3, "Throw In", 255, -1, 255, Config.defaultLeftTeamColor,COMM_THROWIN,Description.get(COMM_THROWIN),"","");
	bTeamAcmds[4] = new Button(offsetLeft.x, offsetLeft.y+70*4, "Corner"  , 255, -1, 255, Config.defaultLeftTeamColor,COMM_CORNER,Description.get(COMM_CORNER),"","");
	bTeamAcmds[5] = new Button(offsetLeft.x, offsetLeft.y+70*5, "Penalty" , 255, -1, 255, Config.defaultLeftTeamColor,COMM_PENALTY,Description.get(COMM_PENALTY),"","");
	bTeamAcmds[6] = new Button(offsetLeft.x-137, offsetLeft.y+218,  "", 255, -1, 255, Config.defaultLeftTeamColor,COMM_ISALIVE,Description.get(COMM_ISALIVE),"",""); //Is alive A
	bTeamAcmds[7] = new Button(offsetLeft.x-135, offsetLeft.y, "GOAL", Config.defaultLeftTeamColor, -1, 255, Config.defaultLeftTeamColor,COMM_GOAL, Description.get(COMM_GOAL), COMM_SUBGOAL,Description.get(COMM_SUBGOAL));   // Goal A
	bTeamAcmds[8] = new Button(offsetLeft.x-135, offsetLeft.y+70*4,  "REPAIR", Config.defaultLeftTeamColor, -1, 255, Config.defaultLeftTeamColor,COMM_REPAIR,Description.get(COMM_REPAIR),"",""); // Repair A
	bTeamAcmds[9] = new Button(offsetLeft.x-162, offsetLeft.y+70*5, "", #FC0303, #810303, 255, #FC0303, COMM_RED_CARD, Description.get(COMM_RED_CARD), "","");  //red card A
	bTeamAcmds[10] = new Button(offsetLeft.x-105, offsetLeft.y+70*5, "", #FEFF00, #808100, 255, #FEFF00, COMM_YELLOW_CARD, Description.get(COMM_YELLOW_CARD), "","");  //yellow card A

	//resize button card
	bTeamAcmds[9].setdim(32, 48); //red card resize
	bTeamAcmds[10].setdim(32, 48); //yellow card resize

	// Set Is Alive button
	bTeamAcmds[6].setdim(42, 42); //is alive resize
	bTeamAcmds[6].setIsCircle(true);
	bTeamAcmds[6].setImages(skullImageOff, skullImage, skullImageOver, skullImageLeft);

	bTeamBcmds[0] = new Button(offsetRight.x, offsetRight.y+70*0, "KickOff" , 255, -1, 255, Config.defaultRightTeamColor, COMM_KICKOFF,Description.get(COMM_KICKOFF),"","");
	bTeamBcmds[1] = new Button(offsetRight.x, offsetRight.y+70*1, "FreeKick", 255, -1, 255, Config.defaultRightTeamColor, COMM_FREEKICK,Description.get(COMM_FREEKICK),"","");
	bTeamBcmds[2] = new Button(offsetRight.x, offsetRight.y+70*2, "GoalKick", 255, -1, 255, Config.defaultRightTeamColor, COMM_GOALKICK,Description.get(COMM_GOALKICK),"","");
	bTeamBcmds[3] = new Button(offsetRight.x, offsetRight.y+70*3, "Throw In", 255, -1, 255, Config.defaultRightTeamColor, COMM_THROWIN,Description.get(COMM_THROWIN),"","");
	bTeamBcmds[4] = new Button(offsetRight.x, offsetRight.y+70*4, "Corner"  , 255, -1, 255, Config.defaultRightTeamColor, COMM_CORNER,Description.get(COMM_CORNER),"","");
	bTeamBcmds[5] = new Button(offsetRight.x, offsetRight.y+70*5, "Penalty" , 255, -1, 255, Config.defaultRightTeamColor, COMM_PENALTY,Description.get(COMM_PENALTY),"","");
	bTeamBcmds[6] = new Button(offsetRight.x+134, offsetRight.y+218, "", 255, -1, 255, Config.defaultRightTeamColor, COMM_ISALIVE,Description.get(COMM_ISALIVE),"","");//Is alive B
	bTeamBcmds[7] = new Button(offsetRight.x+135, offsetRight.y, "GOAL", Config.defaultRightTeamColor, -1, 255, Config.defaultRightTeamColor, COMM_GOAL, Description.get(COMM_GOAL), COMM_SUBGOAL,Description.get(COMM_SUBGOAL) );  //Goal B
	bTeamBcmds[8] = new Button(offsetRight.x+135, offsetRight.y+70*4, "REPAIR", Config.defaultRightTeamColor, -1, 255, Config.defaultRightTeamColor,COMM_REPAIR,Description.get(COMM_REPAIR),"","");//Repair B
	bTeamBcmds[9] = new Button(offsetRight.x+162, offsetRight.y+70*5, "", #FC0303, #810303, 255, #FC0303, COMM_RED_CARD, Description.get(COMM_RED_CARD), "","");  //red card B
	bTeamBcmds[10] = new Button(offsetRight.x+105, offsetRight.y+70*5, "", #FEFF00, #808100, 255, #FEFF00, COMM_YELLOW_CARD, Description.get(COMM_YELLOW_CARD), "","");  //yellow card B

	//resize button card
	bTeamBcmds[9].setdim(32, 48);  //red card resize
	bTeamBcmds[10].setdim(32, 48);  //yellow card resize
	
	// Set Is Alive button
	bTeamBcmds[6].setdim(42, 42); //is alive resize
	bTeamBcmds[6].setIsCircle(true);
	bTeamBcmds[6].setImages(skullImageOff, skullImage, skullImageOver, skullImageRight);

	bPopup[0] = new Button(0, 0, "", 0, 0, 0, 0,"","","","");
	bPopup[1] = new Button(0, 0, "yes", 220, #129003, 0, #129003,"","","","");
	bPopup[2] = new Button(0, 0, "no", 220, #D03030, 0, #D03030,"","","","");//
	bPopup[3] = new Button(0, 0, "Left", 220, #008000, 0, #000090,"","","","");
	bPopup[4] = new Button(0, 0, "Right", 220, #008000, 0, #900000,"","","","");
	bPopup[5] = new Button(0, 0, "1", 220, #6D9C75, 0, #6D9C75,"","","",""); 
	bPopup[5].setdim(80, 48);
	bPopup[6] = new Button(0, 0, "2", 220, #6D9C75, 0, #6D9C75,"","","",""); 
	bPopup[6].setdim(80, 48);
	bPopup[7] = new Button(0, 0, "3", 220, #6D9C75, 0, #6D9C75,"","","",""); 
	bPopup[7].setdim(80, 48);
	bPopup[8] = new Button(0, 0, "OK", 220, #6D9C75, 0, #6D9C75,"","","",""); 
	bPopup[8].setdim(80, 48);
	bPopup[9] = new Button(0, 0, "Apply", 220, #6D9C75, 0, #6D9C75,"","","",""); 
	bPopup[9].setdim(90, 48);
	bPopup[10] = new Button(0, 0, "Cancel", 220, #6D9C75, 0, #6D9C75,"","","",""); 
	bPopup[10].setdim(90, 48);

	for (int n = 0; n < popUpButtons; n++)
	bPopup[n].disable();
	//bSlider[0]=new BSliders("Testmode",420,460,true, TESTMODE);
	//bSlider[1]=new BSliders("Log",420+132,460,true, Log.enable);
	//bSlider[2]=new BSliders("Remote",420,460+32,Config.remoteControlEnable, REMOTECONTROLENABLE);
	//bSlider[3]=new BSliders("Coach",420+132,460+32,false, VOICECOACH);
	bSlider[0]=new BSliders("Testmode",420,460-120,false, TESTMODE);
	bSlider[1]=new BSliders("Log",420+132,460-120,false, Log.enable);
	bSlider[2]=new BSliders("Remote",420,460+32-120,false, REMOTECONTROLENABLE);
	bSlider[3]=new BSliders("Coach",420+132,460+32-120,false, VOICECOACH);

	tBox[0] = new Textbox(width/4 +24, height/2 + 5, 100, 1, false);
	tBox[1] = new Textbox(width/4*3 -24, height/2 + 5, 100, 1, false);
	tBox[2] = new Textbox(width/4 + 24, height/2 + 55, 100, 1, false);
	tBox[3] = new Textbox(width/4*3 - 24, height/2 + 55, 100, 1, false);
	tBox[4] = new Textbox(width/4 + 24, height/2 + 105, 100, 1, false);
	tBox[5] = new Textbox(width/4*3 - 24, height/2 + 105, 100, 1, false);
	tBoxIsAlive = new Textbox(width / 2 + 80, height/2 + 8, 100, 1, false);

	textFont(debugFont);
	fill(#ffffff);
	textAlign(CENTER, BOTTOM);
	text("Press H for a short help!", 500, 460+60);
	
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
