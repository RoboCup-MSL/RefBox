//==============================================================================
//==============================================================================
class Robot {
  float guix, guiy;
  String state="play"; //play , repair , yellow, doubleyellow , red
  long outTime = 0; // Time at which this robot left the field

  Robot(float zx, float zy) {
    guix=zx; 
    guiy=zy;
  }

//-------------------------------
  void reset() {
    state="play";
    outTime=0;
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
    
    /* Repair */
    int waitTime = (int)(this.outTime+Config.repairPenalty_ms - getSplitTime())/1000;
    if (waitTime >= 0 && state.equals("repair")) text(nf(waitTime+1, 2), tx, ty);
    
    /* Double Yellow */
    waitTime = (int)(this.outTime + Config.doubleYellowPenalty_ms - getSplitTime())/1000;
    if (waitTime >= 0 && state.equals("doubleyellow")) text(nf(waitTime+1, 2), tx, ty);
  }
  
}
//==============================================================================
//==============================================================================
