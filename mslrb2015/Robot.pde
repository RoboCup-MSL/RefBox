//==============================================================================
//==============================================================================
class Robot {
	float guix, guiy;
	String state = "play"; //play , repair , yellow, doubleyellow , red
	StopWatch RepairTimer;
	StopWatch DoubleYellowTimer;

	Robot(float zx, float zy) {
		guix=zx; 
		guiy=zy;
		RepairTimer = new StopWatch(true, 0, false, false);
		DoubleYellowTimer = new StopWatch(true, 0, false, false);
	}

	//-------------------------------
	void setState(String st) {
		state = st;
	}

	//-------------------------------
	void reset() {
		this.state="play";
	}


	//-------------------------------
	void updateUI(color c, boolean UIleft) {
		stroke(c); 
		strokeWeight(3);
		color rcolor=255;
		if (this.state.equals("repair")) rcolor=Config.robotRepairColor;
		if (this.state.equals("yellow")) rcolor=Config.robotYellowCardColor;  //yellow  
		if (this.state.equals("doubleyellow")) rcolor=Config.robotDoubleYellowCardColor;  //doubleyellow  
		if (this.state.equals("play")) rcolor=Config.robotPlayColor;  //white (very light-green)
		if (this.state.equals("red")) rcolor=Config.robotRedCardColor;  //red
		fill(rcolor);
		float tx=offsetRight.x + 106 + this.guix;
		float ty=offsetLeft.y + this.guiy;
		if (UIleft) tx=offsetLeft.x - 165 + this.guix;       
		ellipse(tx, ty, 42, 42);  
		fill(255);
		
		if(RepairTimer.getStatus() )
		{
			if (RepairTimer.getTimeMs() > 0)
			text(nf(int(RepairTimer.getTimeSec()), 2), tx, ty);
			else
			RepairTimer.stopTimer();
		}
		if(DoubleYellowTimer.getStatus() )
		{
			if (DoubleYellowTimer.getTimeMs() > 0)
			text(nf(int(DoubleYellowTimer.getTimeSec()), 2), tx, ty);
			else
			DoubleYellowTimer.stopTimer();
		}
	}

}
//==============================================================================
//==============================================================================
