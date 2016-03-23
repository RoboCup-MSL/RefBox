//==============================================================================
//==============================================================================
class Robot {
  float guix, guiy;
  String state="play"; //play , repair , yellow, doubleyellow , red
  int waittime=-1;
  long DoubleYellowOut=0; 
  long DoubleYellowOutRemain=0; 

  Robot(float zx, float zy) {
    guix=zx; 
    guiy=zy;
  }

//-------------------------------
  void reset_to_play() {
    state="play";
    waittime=-1;
  }
  
//-------------------------------
  void reset() {
    state="play";
    waittime=-1;
    this.DoubleYellowOut=0;
    this.DoubleYellowOutRemain=0; 
  }
  
//-------------------------------
  void setRstate(Robot r) {
    this.state=r.state;
    this.waittime=r.waittime;
    this.DoubleYellowOut=r.DoubleYellowOut;
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
    if (waittime>=0)  text(nf(waittime+1, 2), tx, ty);
  }
  
}
//==============================================================================
//==============================================================================
