import java.io.*;

static class Config
{
	// Networking
	public static int scoreClientsUpdatePeriod_ms = 1000;
	public static StringList scoreClientHosts = new StringList();
	public static IntList scoreClientPorts = new IntList();
	public static int remoteServerPort = 12345;
	public static int basestationServerPort = 28097;
	public static boolean remoteControlEnable = false;

	// Rules
	public static int repairPenalty_ms = 20000;                      //@mbc default value reajusted according to rules
	public static int doubleYellowPenalty_ms = 90000;                //@mbc default value reajusted according to rules
	public static int setPieceMaxTime_ms = 7000;

	// Appearance
	public static int maxShortName = 8;
	public static int maxLongName = 24;
	public static color robotPlayColor = #E8FFD8;  //white (very light-green)
	public static color robotRepairColor = #24287B;  //blue
	public static color robotYellowCardColor = #FEFF0F;  //yellow  
	public static color robotDoubleYellowCardColor = #707000;  //doubleyellow
	public static color robotRedCardColor = #E03030;  //red
	public static String defaultCyanTeamShortName = "Team";
	public static String defaultCyanTeamLongName = "Cyan";
	public static color defaultCyanTeamColor = #00ffff;
	public static String defaultMagentaTeamShortName = "Team";
	public static String defaultMagentaTeamLongName = "Magenta";
	public static color defaultMagentaTeamColor  = #ff00ff;

	// Sounds
	public static String sounds_maxTime = "";

	public static void Load(PApplet parent, String filename)
	{
		// file should be inside the "data" folder
		filename = parent.dataPath(filename);
		
		// Read json_string from file
		String json_string = null;
		try{
			BufferedReader reader = new BufferedReader(new FileReader(filename));
			String         line = null;
			StringBuilder  stringBuilder = new StringBuilder();
			String         ls = System.getProperty("line.separator");
			
			try {
				while( ( line = reader.readLine() ) != null ) {
					stringBuilder.append( line );
					stringBuilder.append( ls );
				}

				json_string = stringBuilder.toString();
			} finally {
				reader.close();
			}
		}catch(IOException e) {
			println("ERROR accessing file: " + e.getMessage());
			json_string = null;
		}
		
		// If json_string could be read correctly
		if(json_string != null)
		{
			org.json.JSONObject json_root = null;
			try // Check for malformed JSON
			{
				json_root = new org.json.JSONObject(json_string);
			} catch(JSONException e) {
				String errorMsg = "ERROR reading config file : malformed JSON";
				println(errorMsg);
				json_root = null;
			}
			
			// If JSON was correctly parsed
			if(json_root != null)
			{
				try // Get settings
				{
					org.json.JSONObject networking = json_root.getJSONObject("networking");
					org.json.JSONObject rules = json_root.getJSONObject("rules");
					org.json.JSONObject appearance = json_root.getJSONObject("appearance");
					org.json.JSONObject sounds = json_root.getJSONObject("sounds");
					
					// ----
					// Networking
					
					if(networking.has("scoreClientsUpdatePeriod_ms"))
					scoreClientsUpdatePeriod_ms = networking.getInt("scoreClientsUpdatePeriod_ms");
					
					if(networking.has("scoreClientsList"))
					{
						org.json.JSONArray listOfClients = networking.getJSONArray("scoreClientsList");
						for(int i = 0; i < listOfClients.length(); i++)
						{
							org.json.JSONObject client = listOfClients.getJSONObject(i);
							if(client.has("ip") && client.has("port"))
							{
								scoreClientHosts.append(client.getString("ip"));
								scoreClientPorts.append(client.getInt("port"));
							}
						}
					}
					
					if(networking.has("remoteServerPort"))
					remoteServerPort = networking.getInt("remoteServerPort");
					
					if(networking.has("basestationServerPort"))
					basestationServerPort = networking.getInt("basestationServerPort");
					

					
					if(networking.has("remoteControlEnable"))
					remoteControlEnable = networking.getBoolean("remoteControlEnable");
					
					// ----
					// Rules
					if(rules.has("repairPenalty_ms"))
					repairPenalty_ms = rules.getInt("repairPenalty_ms");
					
					if(rules.has("doubleYellowPenalty_ms"))
					doubleYellowPenalty_ms = rules.getInt("doubleYellowPenalty_ms");
					
					if(rules.has("setPieceMaxTime_ms"))
					setPieceMaxTime_ms = rules.getInt("setPieceMaxTime_ms");
					
					// ----
					// Appearance
					if(appearance.has("maxShortName"))
					maxShortName = appearance.getInt("maxShortName");
					
					if(appearance.has("maxLongName"))
					maxLongName = appearance.getInt("maxLongName");
					
					if(appearance.has("robotPlayColor"))
					robotPlayColor = string2color(appearance.getString("robotPlayColor"));
					
					if(appearance.has("robotRepairColor"))
					robotRepairColor = string2color(appearance.getString("robotRepairColor"));
					
					if(appearance.has("robotYellowCardColor"))
					robotYellowCardColor = string2color(appearance.getString("robotYellowCardColor"));
					
					if(appearance.has("robotDoubleYellowCardColor"))
					robotDoubleYellowCardColor = string2color(appearance.getString("robotDoubleYellowCardColor"));
					
					if(appearance.has("robotRedCardColor"))
					robotRedCardColor = string2color(appearance.getString("robotRedCardColor"));
					
					if(appearance.has("defaultCyanTeamShortName"))
					defaultCyanTeamShortName = appearance.getString("defaultCyanTeamShortName");

					if(appearance.has("defaultCyanTeamLongName"))
					defaultCyanTeamLongName = appearance.getString("defaultCyanTeamLongName");
					
					if(appearance.has("defaultCyanTeamColor"))
					defaultCyanTeamColor = string2color(appearance.getString("defaultCyanTeamColor"));

					
					if(appearance.has("defaultMagentaTeamShortName"))
					defaultMagentaTeamShortName = appearance.getString("defaultMagentaTeamShortName");

					if(appearance.has("defaultMagentaTeamLongName"))
					defaultMagentaTeamLongName = appearance.getString("defaultMagentaTeamLongName");
					
					if(appearance.has("defaultMagentaTeamColor"))
					defaultMagentaTeamColor = string2color(appearance.getString("defaultMagentaTeamColor"));
					
					// ----
					// Sounds
					if(sounds.has("maxSetPieceTime"))
					sounds_maxTime = sounds.getString("maxSetPieceTime");
					
				} catch(JSONException e) {
					String errorMsg = "ERROR reading config file...";
					println(errorMsg);
				}
				
			}
		}
		
		if (scoreClientsUpdatePeriod_ms<50) scoreClientsUpdatePeriod_ms=50;
		
		printConfig();
	}

	public static void printConfig()
	{
		// Networking
		println( "### Networking ###" );
		println( "scoreClientsUpdatePeriod_ms  : " + scoreClientsUpdatePeriod_ms);
		println( "scoreClients                 : " + scoreClientHosts.size());
		for(int i = 0; i < scoreClientHosts.size(); i++)
		println( "    " + scoreClientHosts.get(i) + ":" + scoreClientPorts.get(i));
		
		println( "remoteServerPort             : " + remoteServerPort);
		println( "basestationServerPort        : " + basestationServerPort);
		println( "remoteControlEnable          : " + remoteControlEnable); 
		println();
		// Rules
		println( "### Rules ###" );
		println( "repairPenalty_ms             : " + repairPenalty_ms);
		println( "doubleYellowPenalty_ms       : " + doubleYellowPenalty_ms);
		println();
		// Appearance
		println( "### Appearance ###" );
		println( "maxShortName                 : " + maxShortName);
		println( "maxLongName                  : " + maxLongName);
		println( "robotPlayColor               : " + color2string(robotPlayColor));
		println( "robotRepairColor             : " + color2string(robotRepairColor));
		println( "robotYellowCardColor         : " + color2string(robotYellowCardColor));  
		println( "robotDoubleYellowCardColor   : " + color2string(robotDoubleYellowCardColor));
		println( "robotRedCardColor            : " + color2string(robotRedCardColor));
		println( "defaultCyanTeamShortName     : " + defaultCyanTeamShortName);
		println( "defaultCyanTeamLongName      : " + defaultCyanTeamLongName);
		println( "defaultCyanTeamColor         : " + color2string( defaultCyanTeamColor));
		println( "defaultMagentaTeamShortName  : " + defaultMagentaTeamShortName );
		println( "defaultMagentaTeamLongName   : " + defaultMagentaTeamLongName );
		println( "defaultMagentaTeamColor      : " + color2string( defaultMagentaTeamColor ));
		// Sounds
		println( "### Sounds ###" );
		println( "sounds_maxTime                 : " + sounds_maxTime);
		
	}
}
