import java.io.File;
import java.util.zip.*;

/**
  * Exporter
  *   Ricardo Dias <ricardodias@ua.pt>
  *
  * This class is responsible for exporting team world state data
  * and refbox data. It saves all files as a zip archive.
  * 
  * Based on the timedName, it will search files from both teams
  * on the "data" directory.
  */

static class Exporter
{
  
// ---
// Atributes
  private String timedName;
  static final int BUFFER = 2048;
// ---


// ---
// Constructor
  public Exporter(String timedName)
  {
    this.timedName = timedName;
    
    File tAFile = new File(mainApplet.dataPath("tmp/" + timedName + ".A.msl"));
    File tBFile = new File(mainApplet.dataPath("tmp/" + timedName + ".B.msl"));
  }
// --- //<>//


// ---
// Zip all
  public boolean zipAllFiles()
  {    
    try
    {
      println("Zipping game log files...");
      BufferedInputStream origin = null;
      FileOutputStream dest = new FileOutputStream(mainApplet.dataPath("logs/" + timedName + "." + teamA.shortName + "-" + teamB.shortName + ".zip"));
      ZipOutputStream out = new ZipOutputStream(new BufferedOutputStream(dest));
      out.setMethod(ZipOutputStream.DEFLATED);
      byte data[] = new byte[BUFFER];
      
      String[] files = {".msl", ".A.msl", ".B.msl"};
      for(int i = 0; i < files.length; i++)
      {
        String fileName = mainApplet.dataPath("tmp/" + timedName + files[i]);
        File f = new File(fileName);
        if(!f.exists() || !f.isFile())
          continue;
        
        println("Adding file " + files[i]);
        FileInputStream fi = new FileInputStream(fileName);
        origin = new BufferedInputStream(fi, BUFFER);
        ZipEntry entry = new ZipEntry(timedName + files[i]);
        out.putNextEntry(entry);
        int count;
        while((count = origin.read(data, 0, BUFFER)) != -1) {
          out.write(data, 0, count);
        }
        origin.close();
      }
      out.close();
      println("DONE! \"" + timedName + "." + teamA.shortName + "-" + teamB.shortName + ".zip\" created");
      
    } catch(Exception e) {
      println("ERROR Zipping log files");
      e.printStackTrace();
      return false;
    }
    return true;
  }
// ---
  
}
