import java.io.BufferedWriter;
import java.io.FileWriter;

static class Log
{
  public static boolean enable = true;
  private static PApplet parent = null;
  private static String currentTimedName = "";
  
  public static void init(PApplet p)
  {
    Log.parent = p;
    createLog();
  }
  
  private static String getTimedName()
  {
    return currentTimedName;
  }
  
  private static String createTimedName()
  {
    return nf(year(),4)+nf(month(),2)+nf(day(),2)+"_"+nf(hour(),2)+nf(minute(),2)+nf(second(),2);
  }
  
  public static void createLog() {
    currentTimedName = createTimedName();
  }
  
  // Log to screen only
  public static void screenlog(String s){
    for (int i=4; i>0; i--)
      Last5cmds[i]=Last5cmds[i-1];
      
    String newLog = nf(hour(),2)+":"+nf(minute(),2)+":"+nf(second(),2)+" "+s;
    if(newLog.length() > 41)
      newLog = newLog.substring(0,40);
    Last5cmds[0]=newLog;
  }
  
  // Log action to both screen and logfile
  public static void logactions(String c) {
    //year()+month()+hour()+minute()+second()+millis()
    String s1="" + Description.get(c+"");
    String s2=System.currentTimeMillis()+","+gametime+"("+gameruntime+"),"+currentGameStateString+","+c+","+Description.get(c+"");
    lastaction=c;
    
    screenlog(s1);
    
  }
  
  // Log message to both screen and logfile
  // This function is never used
  public static void logMessage(String s)
  {
    screenlog(s);
  }
  
}