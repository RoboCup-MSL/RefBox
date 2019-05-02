static class Popup
{
	private static boolean enabled = false;
	private static PopupTypeEnum type;
	private static boolean newResponse = false;
	private static String lastResponse = "";
	private static int numOfButtons;

	private static String message = "";
	private static String btnLeft = "";
	private static String btnCenter = "";
	private static String btnRight = "";

	private static int b1;
	private static int b2;
	private static int b3;
	private static int bw1;
	private static int bw2;
	private static int bw3;

	private static int fontSize;

	private static int popUpWidth = 380;
	private static int popUpHeight = 200;

	// Methods
	public static boolean isEnabled() { return enabled; }

	public static boolean hasNewResponse() {
		boolean resp = newResponse;
		newResponse = false;  
		return resp;
	}
	public static String getResponse() { return lastResponse; }

	public static PopupTypeEnum getType() { return type; }

	public static void show(PopupTypeEnum type, String message, int bt1, int bt2, int bt3, int fs, int ww, int hh) {
		Popup.type = type;
		Popup.message = message;
		Popup.btnLeft = btnLeft;
		Popup.btnCenter = btnCenter;
		Popup.btnRight = btnRight;
		numOfButtons = 0;
		fontSize = fs;
		popUpWidth = ww;
		popUpHeight = hh;
		
		b1 = bt1; bw1 = 0;
		b2 = bt2; bw2 = 0;
		b3 = bt3; bw3 = 0;
		
		if (bt1 > 0) {bPopup[bt1].enable(); bw1 = bPopup[bt1].bwidth; numOfButtons++;}
		if (bt2 > 0) {bPopup[bt2].enable(); bw2 = bPopup[bt2].bwidth; numOfButtons++;} 
		if (bt3 > 0) {bPopup[bt3].enable(); bw3 = bPopup[bt3].bwidth; numOfButtons++;}
		enabled = true;
		mainApplet.redraw();
	}

	public static void close()
	{
		for (int n = 0; n < popUpButtons; n++)
		bPopup[n].disable();
		enabled = false;
		mainApplet.redraw();
		
		// If connectingClient is still referencing a client when closing popup, we have to close the connection
		if(connectingClient != null){
			connectingClient.stop();
			connectingClient = null;
		}
	}

	public static void check(boolean mousePress) {
		// check mouse over
		if (bPopup[b1].isEnabled()) bPopup[b1].checkhover();
		if (bPopup[b2].isEnabled()) bPopup[b2].checkhover();
		if (bPopup[b3].isEnabled()) bPopup[b3].checkhover();
		
		if(mousePress)
		{
			if (bPopup[b1].HOVER == true) bPopup[b1].activate();
			if (bPopup[b2].HOVER == true) bPopup[b2].activate();
			if (bPopup[b3].HOVER == true) bPopup[b3].activate();
			if (bPopup[b1].isActive()) {
				lastResponse = bPopup[b1].Label;
				newResponse = true;
			}
			if (bPopup[b2].isActive()) {
				lastResponse = bPopup[b2].Label;
				newResponse = true;
			}
			if (bPopup[b3].isActive()) {
				lastResponse = bPopup[b3].Label;
				newResponse = true;
			}
		}
	}

	public static void draw() {
		
		mainApplet.rectMode(CENTER);

		mainApplet.noStroke();
		mainApplet.fill(255, 80); //,224
		mainApplet.rect(mainApplet.width/2 + 6, mainApplet.height/2 + 6,  popUpWidth, popUpHeight, 12);		

		mainApplet.strokeWeight(2);
		mainApplet.fill(63, 72, 204); mainApplet.stroke(220, 220, 220);
		mainApplet.rect(mainApplet.width/2, mainApplet.height/2, popUpWidth, popUpHeight, 12);		
		
		int hw = 0;
		if (bw1 > 0) hw = bw1 / 2;
		else if (bw2 > 0) hw = bw2 / 2;
		else hw = bw3 / 2;
		
		int delta = (popUpWidth - bw1 - bw2 - bw3) / (numOfButtons + 1);
		int leftOffset = (mainApplet.width / 2 - popUpWidth / 2) + delta + hw;
		if (bPopup[b1].isEnabled()) {
			if (type == PopupTypeEnum.POPUP_HELP) {
				bPopup[b1].setxy(leftOffset, mainApplet.height/2+78);
			}
			else {
				bPopup[b1].setxy(leftOffset, mainApplet.height/2+40);
			}
			leftOffset += (delta + bw1);  
		}
		if (bPopup[b2].isEnabled()) {
			bPopup[b2].setxy(leftOffset, mainApplet.height/2+40);
			leftOffset += (delta + bw2);  
		}
		if (bPopup[b3].isEnabled()) {
			bPopup[b3].setxy(leftOffset, mainApplet.height/2+40);
		}
		
		mainApplet.fill(220);
		mainApplet.textFont(panelFont);
		mainApplet.textAlign(CENTER, CENTER);
		mainApplet.textSize(fontSize);
		
		if (type == PopupTypeEnum.POPUP_HELP) {
			mainApplet.textAlign(LEFT, CENTER);
			mainApplet.text( message, mainApplet.width/2 - 205 , mainApplet.height/2 - 35);
		}
		else if (type == PopupTypeEnum.POPUP_WAIT){
			mainApplet.text( message, mainApplet.width/2, mainApplet.height/2);
		}
		else {
			mainApplet.text( message, mainApplet.width/2, mainApplet.height/2 - 50);
		}
		
		if (bPopup[b1].isEnabled()) bPopup[b1].checkhover();
		if (bPopup[b2].isEnabled()) bPopup[b2].checkhover();
		if (bPopup[b3].isEnabled()) bPopup[b3].checkhover();

		if (bPopup[b1].isEnabled()) bPopup[b1].update();
		if (bPopup[b2].isEnabled()) bPopup[b2].update();
		if (bPopup[b3].isEnabled()) bPopup[b3].update();
	}

}
