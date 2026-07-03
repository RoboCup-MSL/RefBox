//****************************************************************************************************** 

//Enumerated value for button status

//******************************************************************************************************

enum ButtonsEnum
{
	BTN_START(0),
	BTN_STOP(1),
	BTN_DROPBALL(2),
	BTN_PARK(3),
	BTN_ENDPART(4),
	BTN_RESET(5),
	BTN_SUBS(6),
	BTN_CONFIG(7),

	BTN_L_KICKOFF(8),
	BTN_L_FREEKICK(9),
	BTN_L_GOALKICK(10),
	BTN_L_THROWIN(11),
	BTN_L_CORNER(12),
	BTN_L_PENALTY(13),
	BTN_L_ISALIVE(14),
	
	BTN_L_GOAL(15),
	BTN_L_REPAIR(16),
	BTN_L_RED(17),
	BTN_L_YELLOW(18),

	BTN_R_KICKOFF(19),
	BTN_R_FREEKICK(20),
	BTN_R_GOALKICK(21),
	BTN_R_THROWIN(22),
	BTN_R_CORNER(23),
	BTN_R_PENALTY(24),
	BTN_R_ISALIVE(25),
	
	BTN_R_GOAL(26),
	BTN_R_REPAIR(27),
	BTN_R_RED(28),
	BTN_R_YELLOW(29),

	BTN_ILLEGAL(99);

	private final int value;

	//******************************************************************************************************  Assigns value to buttons enum
	private ButtonsEnum(int value) {
		this.value = value;
	}

	//******************************************************************************************************
	public int getValue() {
		return value;
	}

	//******************************************************************************************************
	public boolean isSetPiece()
	{
		return (value >= BTN_L_KICKOFF.value && value <= BTN_L_ISALIVE.value) || 
				(value >= BTN_R_KICKOFF.value && value <= BTN_R_ISALIVE.value) || value == BTN_DROPBALL.value;
	}

	//******************************************************************************************************
	public boolean isCommon()
	{
		return value >= BTN_START.value && value <= BTN_RESET.value;
	}

	//******************************************************************************************************
	public boolean isLeft()
	{
		return value >= BTN_L_KICKOFF.value && value <= BTN_L_YELLOW.value;
	}

	//******************************************************************************************************
	public boolean isRight()
	{
		return value >= BTN_R_KICKOFF.value && value <= BTN_R_YELLOW.value;
	}

	//******************************************************************************************************
	public boolean isStop()
	{
		return value == BTN_STOP.value;
	}

	//******************************************************************************************************
	public boolean isStart()
	{
		return value == BTN_START.value;
	}

	//******************************************************************************************************
	public boolean isGoal()
	{
		return value == BTN_L_GOAL.value || value == BTN_R_GOAL.value;
	}

	//******************************************************************************************************
	public boolean isRepair()
	{
		return value == BTN_L_REPAIR.value || value == BTN_R_REPAIR.value;
	}

	//******************************************************************************************************
	public boolean isEndPart()
	{
		return value == BTN_ENDPART.value;
	}

	//******************************************************************************************************
	public boolean isReset()
	{
		return value == BTN_RESET.value;
	}

	//******************************************************************************************************
	public boolean isYellow()
	{
		return value == BTN_L_YELLOW.value || value == BTN_R_YELLOW.value;
	}

	//******************************************************************************************************
	public boolean isRed()
	{
		return value == BTN_L_RED.value || value == BTN_R_RED.value;
	}

	//******************************************************************************************************
	public boolean isSubs()
	{
		return value == BTN_SUBS.value;
	}

	//******************************************************************************************************
	public boolean isAlive()
	{
		return value == BTN_L_ISALIVE.value || value == BTN_R_ISALIVE.value;
	}

	//******************************************************************************************************
	public boolean isConfig()
	{
		return value == BTN_CONFIG.value;
	}

	public static final ButtonsEnum[] items = ButtonsEnum.values();
};

//****************************************************************************************************** 
//
//Enumerated value for game status
//
//******************************************************************************************************

enum GameStateEnum
{
	GS_PREGAME(0),            	// Period from start until first Kickoff Start 

	GS_GAMESTOP_H1(1),        	// Game stopped during first half
	GS_GAMEON_H1(2),          	// Game on during first half

	GS_HALFTIME(3),            	// First half time

	GS_GAMESTOP_H2(4),        	// Game stopped during second half
	GS_GAMEON_H2(5),          	// Game on during second half

	GS_OVERTIME(6),            	// Game end (ready for overtime)

	GS_GAMESTOP_H3(7),        	// Game stopped during first half of overtime
	GS_GAMEON_H3(8),			// Game on during first half of overtime

	GS_HALFTIME_OVERTIME(9),	// First half time of overtime

	GS_GAMESTOP_H4(10),        	// Game stopped during second half of overtime
	GS_GAMEON_H4(11),          	// Game on during second half of overtime

	GS_PENALTIES(12),          	// Penalties shoot out period on - setpiece OFF
	GS_PENALTIES_ON(13),       	// Penalties shoot out period on - setpiece ON
	GS_ENDGAME(14),            	// Game over
	GS_FORCE_ENDGAME(15),      	// Game over
	GS_RESET(16),              	// Reset Game

	GS_ILLEGAL(99);

	private final int value;
	//******************************************************************************************************  Assigns value to game status enum
	private GameStateEnum(int value) {
		this.value = value;
	}

	//******************************************************************************************************
	public int getValue() {
		return value;
	}

	//******************************************************************************************************
	public boolean isRunning() {
		return value == GS_GAMEON_H1.value || value == GS_GAMEON_H2.value || value == GS_GAMEON_H3.value || value == GS_GAMEON_H4.value;
	}

	//******************************************************************************************************
	public boolean isStopped() {
		return value == GS_GAMESTOP_H1.value || value == GS_GAMESTOP_H2.value || value == GS_GAMESTOP_H3.value || value == GS_GAMESTOP_H4.value;
	}

	//******************************************************************************************************
	public static GameStateEnum newInstance(GameStateEnum symbol) {
		return GameStateEnum.values()[symbol.ordinal()];
	}

	//******************************************************************************************************
	private static String[] GameStatusNames = 
	{ 
		"Pre-Game", 
		"1st Half - STOP",
		"1st Half", 
		"Halftime",
		"2nd Half - STOP",
		"2nd Half",
		"Pre-Overtime",
		"Overtime - 1st Half - STOP",
		"Overtime - 1st Half", 
		"Overtime - Halftime",
		"Overtime - 2nd Half - STOP",
		"Overtime - 2nd Half",
		"Penalties/STOP",
		"Penalties",
		"End Game" };

	public String getName() {
		if(value < GameStatusNames.length)
		{
			return GameStatusNames[value];
		}else{
			return "--";
		}
	}
};


//****************************************************************************************************** 
//
//Enumerated value for pop up values
//
//******************************************************************************************************
enum PopupTypeEnum
{
	POPUP_RESET(0),
	POPUP_TEAMSELECTION(1),
	POPUP_ENDPART(2),
	POPUP_REPAIRL(3),
	POPUP_REPAIRR(4),
	POPUP_HELP(5),
	POPUP_WAIT(6),
	POPUP_SUBS(7),
	POPUP_CONFIG(8),
	POPUP_ALIVE(9),
	
	POPUP_ILLEGAL(99);

	private final int value;
	private PopupTypeEnum(int value) {
		this.value = value;
	}

	public int getValue() {
		return value;
	}
};
