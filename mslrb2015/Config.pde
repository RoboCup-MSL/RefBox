static class Config
{
  private static String configfile[] = null;
  
  public static int REPAIRPENALTYms = 30000;
  public static int DOUBLEYELLOWPENALTYms = 120000;
  public static int SCORESERVERPORT = 12345;
  public static int REMOTECONTROLPORT = 54321;
  public static int BASESTATIONSERVERPORT = 28097;
  public static int ScoreClientsUpdate_frequency_ms = 1000;
  public static int MAXSHORTNAME=8;
  public static int MAXLONGNAME=24;
  public static color RobotPlayColor = #E8FFD8;  //white (very light-green)
  public static color RobotRepairColor = #24287B;  //blue
  public static color RobotYellowCardColor = #FEFF0F;  //yellow  
  public static color RobotDoubleYellowCardColor = #707000;  //doubleyellow
  public static color RobotRedCardColor = #FF0000;  //red
  public static String CyanTeamShortName = "Team";
  public static String CyanTeamLongName = "Cyan";
  public static color CyanTeamColor = #00ffff;
  public static String MagentaTeamShortName = "Team";
  public static String MagentaTeamLongName = "Magenta";
  public static color MagentaTeamColor  = #ff00ff;
  
  public static void Load(PApplet parent, String filename)
  {
    configfile = parent.loadStrings(filename);
    if (configfile==null) {
      println("Config not found");
      Log.screenlog(filename + " not found");
    } else {
      Log.screenlog("Loading config");
      for (int i = 0; i < configfile.length; i++) {
        //println(configfile[i]);
        String[] element=split(configfile[i], '=');
        if (element.length==2) {
          String id=trim(element[0]);
          int val=int(trim(element[1]));
          color col=0;
          if (trim(element[1]).charAt(0)=='#')  col=unhex("FF"+trim(element[1]).substring(1));
          
          if (id.equals("REPAIRPENALTYms")) REPAIRPENALTYms=val;
          if (id.equals("DOUBLEYELLOWPENALTYms")) DOUBLEYELLOWPENALTYms=val;
          if (id.equals("SCORESERVERPORT")) SCORESERVERPORT=val;
          if (id.equals("REMOTECONTROLPORT")) REMOTECONTROLPORT=val;
          if (id.equals("BASESTATIONSERVERPORT")) BASESTATIONSERVERPORT=val;
          if (id.equals("ScoreClientsUpdate_frequency_ms")) ScoreClientsUpdate_frequency_ms=val;
          if (id.equals("robotplaycolor")) RobotPlayColor=col;
          if (id.equals("robotrepaircolor")) RobotRepairColor=col;
          if (id.equals("robotyellowcardcolor")) RobotYellowCardColor=col;
          if (id.equals("robotdoubleyellowcardcolor")) RobotDoubleYellowCardColor=col;
          if (id.equals("robotredcardcolor")) RobotRedCardColor=col;
          if (id.equals("DefaultCyanTeamShortName")) CyanTeamShortName = trim(element[1]);
          if (id.equals("DefaultCyanTeamLongName")) CyanTeamLongName = trim(element[1]);
          if (id.equals("DefaultCyanTeamColor")) CyanTeamColor = col;
          if (id.equals("DefaultMagentaTeamShortName")) MagentaTeamShortName = trim(element[1]);
          if (id.equals("DefaultMagentaTeamLongName")) MagentaTeamLongName = trim(element[1]);
          if (id.equals("DefaultMagentaTeamColor")) MagentaTeamColor = col;
          if (id.equals("ENABLEREMOTE")) 
            ENABLEREMOTE=(trim(element[1]).equals("true"))?true:false;
            
          if (ScoreClientsUpdate_frequency_ms<50) ScoreClientsUpdate_frequency_ms=50;
        }
      }
    }
    /* //print config
    println("REPAIRPENALTYms "+REPAIRPENALTYms);
    println("DOUBLEYELLOWPENALTYms "+DOUBLEYELLOWPENALTYms);
    println("SCORESERVERPORT "+SCORESERVERPORT);
    println("REMOTECONTROLPORT "+REMOTECONTROLPORT);
    println("BASESTATIONSERVERPORT "+BASESTATIONSERVERPORT);
    println("ScoreClientsUpdate_frequency_ms "+ScoreClientsUpdate_frequency_ms);
    println("WorldStateRequest_frequency_ms "+WorldStateRequest_frequency_ms);
    println("robotplaycolor #"+hex(RobotPlayColor));
    println("robotrepaircolor #"+hex(RobotRepairColor));
    println("robotyellowcardcolor #"+hex(RobotYellowCardColor));
    println("robotdoubleyellowcardcolor #"+hex(RobotDoubleYellowCardColor));
    println("robotredcardcolor #"+hex(RobotRedCardColor));
    */
  }
}
