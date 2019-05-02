import java.io.File;
import java.util.zip.*;

/**
* Log Merger
*   Ricardo Dias <ricardodias@ua.pt>
*
* This class is responsible for merging worldstate information 
* that come from the teams during the match into a single file.
* 
* Based on the timedName, it will search files from both teams
* on the "data" directory.
*/

static class LogMerger
{

	// ---
	// Atributes
	private org.json.JSONArray tA = null;
	private org.json.JSONArray tB = null;
	private org.json.JSONArray merged = null;
	private String timedName;
	private String teamAName;
	private String teamBName;
	static final int BUFFER = 2048;
	// ---


	// ---
	// Constructor
	public LogMerger(String timedName)
	{
		this.timedName = timedName;
		
		File tAFile = new File(mainApplet.dataPath("tmp/" + timedName + ".A.msl"));
		File tBFile = new File(mainApplet.dataPath("tmp/" + timedName + ".B.msl"));
		
		tA = parseFile(tAFile);
		tB = parseFile(tBFile);
		merged = new org.json.JSONArray();
	}
	// ---


	// ---
	// Parses a File object into a JSONArray
	private org.json.JSONArray parseFile(File file)
	{
		org.json.JSONArray ret = null;
		try
		{
			BufferedReader br = new BufferedReader(new FileReader(file));
			ret = new org.json.JSONArray(new org.json.JSONTokener(br));
		} catch(Exception e) {
			println("ERROR: Problem with file " + file.getAbsolutePath());
		}
		return ret;
	}
	// ---


	// ---
	// Merges the two arrays into one
	public void merge()
	{
		merged = new org.json.JSONArray();
		try
		{
			if(tA == null && tB != null)          // problem with file from team A, merge = teamB
			merged = tB;
			else if(tB == null && tA != null)     // problem with file from team A, merge = teamB
			merged = tA;
			else if(tA != null && tB != null) {   // normal merge
				println("Merging log files...");  
				
				int sizeA = tA.length();
				int sizeB = tB.length();
				
				int iA = 0;
				int iB = 0;
				int nFrames = 0;
				while(nFrames < sizeA + sizeB)
				{
					org.json.JSONObject selected = null;
					if(iA == sizeA) {                   // no more samples from team A
						selected = tB.getJSONObject(iB);
						iB++;
						teamBName = selected.optString("teamName", teamBName);
					} else if(iB == sizeB) {            // no more samples from team B
						selected = tA.getJSONObject(iA);
						iA++;
						teamAName = selected.optString("teamName", teamAName);
					} else {
						org.json.JSONObject oA = tA.getJSONObject(iA);
						org.json.JSONObject oB = tB.getJSONObject(iB);
						if(oA.getInt("timestamp") < oB.getInt("timestamp"))
						{
							selected = tA.getJSONObject(iA);
							iA++;
							teamAName = selected.optString("teamName", teamAName);
						}else{
							selected = tB.getJSONObject(iB);
							iB++;
							teamBName = selected.optString("teamName", teamBName);
						}
					}
					if(selected != null)
					merged.put(selected);
					
					nFrames++;
					println("Merging log files... ["+ nFrames*100.0/(sizeA+sizeB) +"%]");
				}
			}
		}catch(Exception e) {
			e.printStackTrace();
			return;
		}
		
		writeMergedFile();
		zipAllFiles();
	}
	// ---


	// ---
	// Write merged file into folder
	private boolean writeMergedFile()
	{
		try
		{
			println("Writing merge to file...");
			FileWriter writer = new FileWriter(new File(mainApplet.dataPath("tmp/" + timedName + ".merged.msl")));
			writer.write(merged.toString());
			writer.close();
			println("DONE!");
		} catch(Exception e) {
			println("ERROR Writing merged log file");
			e.printStackTrace();
			return false;
		}
		return true;
	}
	// ---


	// ---
	// Zip all
	public boolean zipAllFiles()
	{    
		try
		{
			println("Zipping game log files...");
			BufferedInputStream origin = null;
			FileOutputStream dest = new FileOutputStream(mainApplet.dataPath("logs/" + timedName + "." + teamAName + "-" + teamBName + ".zip"));
			ZipOutputStream out = new ZipOutputStream(new BufferedOutputStream(dest));
			out.setMethod(ZipOutputStream.DEFLATED);
			byte data[] = new byte[BUFFER];
			
			//String[] files = {".msl", ".A.msl", ".B.msl", ".merged.msl"};
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
			println("DONE! \"" + timedName + "." + teamAName + "-" + teamBName + ".zip\" created");
			
		} catch(Exception e) {
			println("ERROR Zipping log files");
			e.printStackTrace();
			return false;
		}
		return true;
	}
	// ---

}
