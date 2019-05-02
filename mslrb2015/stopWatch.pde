public class StopWatch {
	
	// StopWatch fields
	private long oldTime;
	private long deltaTime;
	private boolean countOffTime;        // if true StopWatch keeps incrementing/decrementing while game is stoped
	private boolean status;              // StopWatch ON / OFF status
	private boolean isTimer;             // when true indicates that the stopWatch works as a Timer
	private long currentTimeMs;          // in ms
	private long currentTimeSec;         // in seconds (seeling of currentTimeMs / 1000)
	
	// StopWatch constructor
	// Parameters:
	//        startValue - expressed in seconds, can be greater or equal to zero
	//        coT -a boolean that determines if time counting is continuous or stops during game stoppage time
	//             see countOffTime
	//      isTimer - Bollean that, when true indicates that the stopWatch works as a Timer
	//        startUp - Boolean. If true the stopWatch starts imediatly
	public StopWatch(boolean isTimer, long startValue, boolean cOT, boolean startUp) 
	{
		oldTime = System.currentTimeMillis();  
		deltaTime = 0;
		countOffTime = cOT;
		currentTimeSec = startValue;
		currentTimeMs =  startValue * 1000;
		status = startUp;
		this.isTimer = isTimer;
	}
	
	// StopWatch Methods

	public void updateStopWatch(){                // This method should be called once every draw()
		long t = System.currentTimeMillis();
		this.deltaTime = t - oldTime;
		oldTime = t;
		adjustValues();
	}
	
	private void adjustValues()
	{
		if (isTimer)
		{
			if (currentTimeMs > 0)
			{
				if (status && (countOffTime || StateMachine.gsCurrent.isRunning()))
				{
					currentTimeMs = (deltaTime > currentTimeMs) ? 0 : currentTimeMs - deltaTime;
					currentTimeSec = (currentTimeMs > 0) ? 1 + (currentTimeMs/1000) : 0;
				}
			}
		}
		else
		{
			if (status && (countOffTime || StateMachine.gsCurrent.isRunning()))
			{
				currentTimeMs += deltaTime;
				currentTimeSec = (currentTimeMs/1000);
			}
		}
	}

	public void resetStopWatch()
	{
		currentTimeMs = 0;
		currentTimeSec = 0;
	}

	public void stopSW()
	{
		status = false;
	}

	public void stopTimer()
	{
		status = false;
	}

	public void startSW()
	{
		status = true;
	}    
	
	public void startTimer(long timeMs)
	{
		status = true;
		currentTimeMs =  timeMs;
		currentTimeSec = int(timeMs / 1000);
	}
	
	public long getTimeMs()
	{
		return currentTimeMs;
	}
	
	public long getTimeSec()
	{
		return currentTimeSec;
	}
	
	public boolean getStatus()
	{
		return status;
	}
}
