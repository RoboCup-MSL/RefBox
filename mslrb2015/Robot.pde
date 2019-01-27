//==============================================================================
//==============================================================================
class Robot {
  float guix, guiy;
  String state="play"; //play , repair , yellow, doubleyellow , red
  int waittime=-1;
  int DYwaittime=-1;
  long RepairOut=0;
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
    RepairOut=0;
}

//-------------------------------
  void reset_double_yellow() {
    state="play";
    DYwaittime=-1;
    RepairOut=0;
}

//-------------------------------
  void reset() {
    this.state="play";
    this.waittime=-1;
    this.DYwaittime=-1;
    this.RepairOut=0;
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
    if (this.waittime>=0)  text(nf(this.waittime+1, 2), tx, ty);
    if (this.DYwaittime>=0)  text(nf(this.DYwaittime+1, 2), tx, ty);
  }
  
}
//==============================================================================
//==============================================================================
