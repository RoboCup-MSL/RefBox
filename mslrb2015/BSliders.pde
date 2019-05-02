class BSliders {
	String Label;
	boolean enabled;
	Boolean on;
	float posx; 
	float posy;
	color c; 

	BSliders(String Label, float x, float y, boolean enable, boolean on ) { 
		this.Label=Label;
		this.posx=x;
		this.posy=y;
		this.on=on;
		this.enabled=enable;
		this.c=255;
	}

	void update() {
		textAlign(LEFT, BOTTOM);
		rectMode(CENTER);
		strokeWeight(1);
		if (enabled) c=192;
		else c=92;
		stroke(c); noFill(); 
		rect(posx, posy, 48, 23, 12);
		fill(c); noStroke();
		textFont(debugFont);
		if (on) {
			rect(posx-8+17, posy, 26, 17, 12);//on
			fill(92);text("on", posx+2, posy+7);
		}
		else {
			rect(posx-8, posy, 26, 17, 12);//off
			fill(92); text("off", posx-19, posy+7);
		}
		fill(c);
		text(Label, posx+30, posy+7);
	}


	boolean mouseover() {
		if ( mouseX>(posx-24-2) && mouseX<(posx+24+2) && mouseY>(posy-12-2) && mouseY<(posy+12+2) ) return true;
		return false;
	}

	void toogle() {
		if (this.enabled) this.on=!on;  
	}

	void enable() {
		this.enabled=true;
	}
	void disable() {
		this.enabled=false;
	}
}

void setbooleansfrombsliders() {
	TESTMODE=bSlider[0].on;
	Log.enable = bSlider[1].on;
	REMOTECONTROLENABLE=bSlider[2].on;
	VOICECOACH=bSlider[3].on; 
}
