
class Textbox {
	float x, y, width, height;
//	String value = "0";
	String value = "";
	boolean visible;
	boolean clickedLast = false;

	Textbox(float x, float y, float width, int num_lines, boolean visible) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = num_lines * 32;
		this.visible = visible;
	}

	void update() {
		if (value.length() > 2) {
			value = value.substring(0, 2);
		}
		rectMode(CENTER);
		textAlign(LEFT, CENTER);
//		textFont(buttonFont);
		textFont(textFont);
		strokeWeight(2);
		stroke(255);
		if (clickedLast){
			fill(210);   
			rect(x, y, width, height);
			stroke(100);
			line(x - width/2, y + height/2, x - width/2, y - height/2);
			stroke(70);
			line(x - width/2, y - height/2, x + width/2, y - height/2);
			stroke(220);
			line(x + width/2, y - height/2, x + width/2, y + height/2);
			stroke(250);
			line(x + width/2, y + height/2, x - width/2, y + height/2);			
		}
		else {
			fill(120);   
			rect(x, y, width, height);	
			stroke(50);
			line(x - width/2, y + height/2, x - width/2, y - height/2);
			stroke(20);
			line(x - width/2, y - height/2, x + width/2, y - height/2);
			stroke(170);
			line(x + width/2, y - height/2, x + width/2, y + height/2);
			stroke(200);
			line(x + width/2, y + height/2, x - width/2, y + height/2);			
		}
		fill(1);
		text(value, x - width/2 + 6, y - 2);
		if (clickedLast) {
			strokeWeight(1);
			if (blinkStatus == true){
				stroke(0);
			}
			else
			{
				stroke(210);			
			}
			float a = textAscent() * 1;  // Calc ascent
			float cw = textWidth(value);
			float xOffset = x - width/2 + 6 + cw;
			line (xOffset, y + (a * 0.5), xOffset, y - (a * 0.5));			
		}
	}
	

	boolean checkInput() {
		char[] input = value.toCharArray();
		if (input.length > 2) return false;    // If input is more than 2 numbers
		for (int i = 0; i < input.length; i++) {
			if (input[i] < 48 || input[i] > 57) return false;    // ASCII values of 0 (48) and 99 (57)
		} 
		return true;
	}

	boolean mouseover() {
		if ( mouseX>(x - width/2) && mouseX<(x + width/2) && mouseY>(y - height/2) && mouseY<(y + height/2) ) return true;
		return false;
	}

	void clicked() {
		this.clickedLast = true;
	}

	void unclicked() {
		this.clickedLast = false;
	}

	void show() {
		this.visible = true;
	}

	void hide() {
		this.visible = false;    
	}
}
