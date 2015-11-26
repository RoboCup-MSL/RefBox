static class Popup
{
  private static boolean enabled = false;
  private static PopupTypeEnum type;
  private static boolean newResponse = false;
  private static String lastResponse = "";
  
  private static String message = "";
  private static String btnLeft = "";
  private static String btnRight = "";

  // Methods
  public static boolean isEnabled() { return enabled; }
  public static boolean hasNewResponse() {
    boolean resp = newResponse;
    newResponse = false;  
    return resp;
  }
  public static String getResponse() { return lastResponse; }
  public static PopupTypeEnum getType() { return type; }
  
  public static void show(PopupTypeEnum type, String message, String btnLeft, String btnRight) {
    Popup.type = type;
    Popup.message = message;
    Popup.btnLeft = btnLeft;
    Popup.btnRight = btnRight;
    
    bPopup[0].Label = btnLeft;
    bPopup[1].Label = btnRight;
    bPopup[0].enable();
    bPopup[1].enable();
    enabled = true;
    mainApplet.redraw();
  }
  
  public static void close()
  {
    bPopup[0].disable();
    bPopup[1].disable();
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
    bPopup[0].checkhover();
    bPopup[1].checkhover();
    
    if(mousePress)
    {
      if (bPopup[0].HOVER == true) bPopup[0].activate(); //yes
      if (bPopup[1].HOVER == true) bPopup[1].activate(); //no
      if (bPopup[0].isActive()) {
        lastResponse = btnLeft;
        newResponse = true;
      }
      if (bPopup[1].isActive()) {
        lastResponse = btnRight;
        newResponse = true;
      }
    }
  }
  
  public static void draw() {
    mainApplet.rectMode(CENTER);
    bPopup[0].setxy(mainApplet.width/2-90, mainApplet.height/2+40);
    bPopup[1].setxy(mainApplet.width/2+90, mainApplet.height/2+40);
    mainApplet.fill(0, 160); mainApplet.noStroke();//,224
    mainApplet.rect(mainApplet.width/2, mainApplet.height/2, mainApplet.width, mainApplet.height);
    mainApplet.fill(208); mainApplet.stroke(255);
    mainApplet.rect(mainApplet.width/2, mainApplet.height/2, 400, 200, 8);
    
    mainApplet.fill(64);
    mainApplet.textFont(panelFont);
    mainApplet.textAlign(CENTER, CENTER);
    mainApplet.text( message, mainApplet.width/2, mainApplet.height/2-50);
    bPopup[0].checkhover();
    bPopup[1].checkhover();
    bPopup[0].update();
    bPopup[1].update();
  }
}
