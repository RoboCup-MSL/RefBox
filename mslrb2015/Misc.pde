
public static void resumeSplitTimer() {				 // Used in StateMachine
	if(stopsplittimer)
	{
		tsplitTime = System.currentTimeMillis();
		stopsplittimer=false;
	}
}

// --------------------------------------------------

void setbackground() {
	rectMode(CENTER);
	textAlign(CENTER, CENTER);

	background(48);

	//center rect
	fill(0, 32);
	stroke(255, 32);
	//rect(400, 288, 256, 208, 16);
	fill(0,16);
	rect(width/2, height/2+28, 256, 300, 16);

	// dividers
	int ramp=34;
	float offsetx=0.35*width-ramp;
	float offsety=112;
	float m=0.3;

	//top cyan
	strokeWeight(2);
	fill(Config.defaultCyanTeamColor); 
	stroke(0);
	beginShape();
	vertex(0, 0);
	vertex(0, offsety);
	vertex(offsetx, offsety);
	vertex(offsetx, 0);
	endShape();

	//top magenta
	strokeWeight(2);
	fill(Config.defaultMagentaTeamColor); 
	stroke(0);
	beginShape();
	vertex(width, 0);
	vertex(width, offsety);
	vertex(width-offsetx, offsety);
	vertex(width-offsetx, 0);
	endShape();


	//top fill
	fill(96);
	beginShape();
	vertex(offsetx+2, 0);
	vertex(offsetx+2, offsety);
	vertex(offsetx+m*ramp+2, offsety+ramp-1);
	vertex(width-1-offsetx-m*ramp-1, offsety+ramp-1);
	vertex(width-1-offsetx-1, offsety);
	vertex(width-1-offsetx-1, 0);
	endShape();


	//bottom
	strokeWeight(2);
	fill(96);
	stroke(0);
	offsety=height-1-128+48;
	beginShape();
	vertex(1, height-2);
	vertex(1, offsety);
	vertex(offsetx, offsety);
	vertex(offsetx+m*ramp, offsety-ramp);
	vertex(width-1-offsetx-m*ramp, offsety-ramp);
	vertex(width-1-offsetx, offsety);
	vertex(width-2, offsety);
	vertex(width-2, height-2);
	vertex(1, height-2);
	endShape();

	//bottom fill
	fill(96);
	beginShape();
	vertex(offsetx+2,height);
	vertex(offsetx+2,offsety+1);
	vertex(offsetx+m*ramp+2,offsety-ramp+2);
	vertex(width-1-offsetx-m*ramp-1,offsety-ramp+2);
	vertex(width-1-offsetx-1,offsety+1);
	vertex(width-1-offsetx-1,height);
	endShape();

	//carbon
	stroke(0,128);
	for(int i=0; i<width*2; i+=4)
	line(0,i,i,0);

	backgroundImage=get();
}

public static color string2color(String hex_string)
{
	color col = 0;
	if (trim(hex_string).charAt(0)=='#')	col=unhex("FF"+trim(hex_string).substring(1));
	return col;
}

public static String color2string(color col)
{
	String ret;
	ret = "" + hex(col);
	ret = "#" + ret.substring(2);
	return ret;
}
