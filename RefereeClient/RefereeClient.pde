/* ==================================
MSL RefereeClient (Processing 3)
	Ricardo Dias <ricardodias@ua.pt>
	Bernardo Cunha <mbc@det.ua.pt>
================================== */
import processing.net.*;
import org.json.*;

public static final String MSG_VERSION="1.4.0";
public static final String MSG_VERSION_MSG="Beta";
public static final String MSG_WINDOWTITLE="RoboCup MSL Referee Client - "+MSG_VERSION+" "+MSG_VERSION_MSG;

public static final int appFrameRate = 15;

public static String[] Teamcmds= { "KickOff", "FreeKick", "GoalKick", "Throw In", "Corner", "Penalty", "Goal", "Repair", "Red", "Yellow" };
public static String[] Commcmds= { "START", "STOP", "DropBall", "Park", "End Part",  "RESET", "EndGame" };

public static final String[] cTeamcmds= { "KICKOFF", "FREEKICK", "GOALKICK", "THROWIN", "CORNER", "PENALTY", "GOAL", "REPAIR", "RED_CARD", "YELLOW_CARD" };

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

public static String[] cCommcmds= { "START", "STOP", "DROP_BALL", "PARK", "END_PART", "RESET", "END_GAME" };
public static final int CMDID_COMMON_START = 0;
public static final int CMDID_COMMON_STOP = 1;
public static final int CMDID_COMMON_DROP_BALL = 2;
public static final int CMDID_COMMON_PARKING = 3;
public static final int CMDID_COMMON_HALFTIME = 4;
public static final int CMDID_COMMON_RESET = 5;
public static final int CMDID_COMMON_ENDGAME = 6;

public static Team teamA,teamB;
UDP myUDPClient;
String msgBuffer = "";

public static String[] Last5cmds= { ".", ".", ".", ".", "." };
public static String LogFileName;
public static String lastaction=".";
public static String gametime = "", gameruntime = "";

public static String currentGameStateString = "Stop";
public static String lastCommandCode = "";
public static String lastCommandDescription = "";
public static String lastCommandTeam = "";
public static int lastRobotID = -1;
public static int lastConnectionAttempt = 0;
public static int nConnAttempts = 0;
public static int gameState = 0;

//GUI
public static PVector offsetLeft= new PVector(250, 160);
public static PVector offsetRight= new PVector(610, 160);
public static PFont buttonFont, clockFont, panelFont, scoreFont, debugFont, teamFont, watermark;
public static PImage backgroundImage;
public static PImage stop;
public static PImage playOn;
public static PImage preGame;
public static PImage halfTime;
public static PImage gameOver;
public static PImage substitution;
public static PImage kickOffLeft;
public static PImage goalKickLeft;
public static PImage throwInLeft;
public static PImage freeKickLeft;
public static PImage cornerKickLeft;
public static PImage penaltyKickLeft;
public static PImage kickOffRight;
public static PImage throwInRight;
public static PImage goalKickRight;
public static PImage freeKickRight;
public static PImage cornerKickRight;
public static PImage penaltyKickRight;
public static PImage dropBall;


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

	backgroundImage = loadImage("img/bg_normal.png");
	stop = loadImage("img/stop.png");
	playOn = loadImage("img/PlayOn.png");
	preGame = loadImage("img/PreGame.png");
	halfTime = loadImage("img/HalfTime.png");
	gameOver = loadImage("img/GameOver.png");
	substitution = loadImage("img/Substitution.png");
	kickOffLeft = loadImage("img/KickOffLeft.png");
	goalKickLeft = loadImage("img/GoalKickLeft.png");
	throwInLeft = loadImage("img/ThrowInLeft.png");
	freeKickLeft = loadImage("img/FreeKickLeft.png");
	cornerKickLeft = loadImage("img/CornerKickLeft.png");
	penaltyKickLeft = loadImage("img/PenaltyLeft.png");
	kickOffRight = loadImage("img/KickOffRight.png");
	throwInRight = loadImage("img/ThrowInRight.png");
	goalKickRight = loadImage("img/GoalKickRight.png");
	freeKickRight = loadImage("img/FreeKickRight.png");
	cornerKickRight = loadImage("img/CornerKickRight.png");
	penaltyKickRight = loadImage("img/PenaltyRight.png");
	dropBall = loadImage("img/DropBall.png");

	surface.setTitle(MSG_WINDOWTITLE); 
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

	myUDPClient = new UDP(this, Config.port);
	myUDPClient.listen(true);

	frameRate(appFrameRate);
}

/**************************************************************************************************************************
This the Processing draw() function 
**************************************************************************************************************************/
void draw() {


	background(backgroundImage);


	teamA.updateUI();
	teamB.updateUI();


	//refresh timer and score
	if(true)//myClient != null && myClient.active())
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

	//refresh command show 
	PImage img = null;
	String imageName = "";
	imageMode(CENTER);
	textFont(teamFont, 30);
	textAlign(CENTER, CENTER-5);
	if(lastCommandCode.equals(COMM_STOP)){
		image(stop, width/2, height/2 + 45, 230, 230);		
	}
	else if (lastCommandCode.equals(COMM_START)) {
		image(playOn, width/2, height/2 + 45, 230, 230);		
	}
	else if (lastCommandCode.equals(COMM_DROP_BALL)) {
		image(dropBall, width/2, height/2 + 45, 230, 230);		
	}
	else if (lastCommandCode.equals(COMM_HALF_TIME)) {
		image(halfTime, width/2, height/2 + 45, 230, 230);		
	}
	else if (lastCommandCode.equals(COMM_END_GAME)) {
		image(gameOver, width/2, height/2 + 45, 230, 230);		
	}
	else if (lastCommandCode.equals(COMM_SUBSTITUTION)) {
		image(substitution, width/2, height/2 + 45, 230, 230);		
	}
	else if (lastCommandCode.equals(COMM_RESET)) {
		image(preGame, width/2, height/2 + 45, 230, 230);		
	}
	else if (lastCommandCode.equals(COMM_KICKOFF)) {
		if (teamA.longName.equals(lastCommandTeam)){ //<>//
			image(kickOffLeft, width/2, height/2 + 25, 230, 230);		
		}
		else {
			image(kickOffRight, width/2, height/2 + 25, 230, 230);					
		}
		text(lastCommandTeam, width/2, height/2 + 175);
	}
	else if (lastCommandCode.equals(COMM_FREEKICK)) {
		if (teamA.longName.equals(lastCommandTeam)){ //<>//
			image(freeKickLeft, width/2, height/2 + 25, 230, 230);		
		}
		else {
			image(freeKickRight, width/2, height/2 + 25, 230, 230);					
		}
		text(lastCommandTeam, width/2, height/2 + 175);
	}	
	else if (lastCommandCode.equals(COMM_GOALKICK)) {
		if (teamA.longName.equals(lastCommandTeam)){ //<>//
			image(goalKickLeft, width/2, height/2 + 25, 230, 230);		
		}
		else {
			image(goalKickRight, width/2, height/2 + 25, 230, 230);					
		}
		text(lastCommandTeam, width/2, height/2 + 175);
	}	
	else if (lastCommandCode.equals(COMM_THROWIN)) {
		if (teamA.longName.equals(lastCommandTeam)){ //<>//
			image(throwInLeft, width/2, height/2 + 25, 230, 230);		
		}
		else {
			image(throwInRight, width/2, height/2 + 25, 230, 230);					
		}
		text(lastCommandTeam, width/2, height/2 + 175);
	}	
	else if (lastCommandCode.equals(COMM_CORNER)) {
		if (teamA.longName.equals(lastCommandTeam)){ //<>//
			image(cornerKickLeft, width/2, height/2 + 25, 230, 230);		
		}
		else {
			image(cornerKickRight, width/2, height/2 + 25, 230, 230);					
		}
		text(lastCommandTeam, width/2, height/2 + 175);
	}	
	else if (lastCommandCode.equals(COMM_PENALTY)) {
		if (teamA.longName.equals(lastCommandTeam)){ //<>//
			image(penaltyKickLeft, width/2, height/2 + 25, 230, 230);		
		}
		else {
			image(penaltyKickRight, width/2, height/2 + 25, 230, 230);					
		}
		text(lastCommandTeam, width/2, height/2 + 175);
	}	

/*
	Description.set(COMM_END_PART, "End Part");
	Description.set(COMM_GAMEOVER, "Game Over");
	Description.set(COMM_WELCOME, "Welcome");
	Description.set(COMM_FIRST_HALF, "1st half");
	Description.set(COMM_SECOND_HALF, "2nd half");
	Description.set(COMM_FIRST_HALF_OVERTIME, "Overtime 1st half");
	Description.set(COMM_SECOND_HALF_OVERTIME, "Overtime 2nd half");
	Description.set(COMM_PARK, "Park");
	Description.set(COMM_ISALIVE, "Is Alive");
*/	
	else{
		fill(#E0F000);
		String description = lastCommandDescription;
		if(description.contains("START"))
		{
			fill(#28C700);
		}
		
		textFont(teamFont, 60);
		
		//command
		textAlign(CENTER, CENTER);
		text(description, width/2, height/2 + 10);
		//team dest command
		textFont(teamFont, 35);
		textAlign(CENTER, CENTER-5);
		text(lastCommandTeam, width/2, height/2 + 100);
		if(lastRobotID != -1)
		{
			text("ID: "+ lastRobotID, width/2, height/2 + 150);
		}
	} 
}

//receive message and get from json important information for referee Client
void receive(byte[] data, String HOST_IP, int PORT_RX){
	String whatClientSaid = new String(data);
	//System.out.println(whatClientSaid);
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
				String eventDesc = root.optString("eventDesc","");
				String teamName = root.optString("team","");
				lastRobotID = root.optInt("robotID",-1);
				


				if(Description.hasKey(eventCode))
				{
					Log.logactions(eventCode, teamName, lastRobotID);
					lastCommandCode = eventCode;
					lastCommandDescription = eventDesc;
					lastCommandTeam = teamName;

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
