class Textbox {
  float x, y, width, height;
  String value = "0";
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
    rectMode(CENTER);
    textAlign(LEFT, CENTER);
    textFont(buttonFont);
    strokeWeight(2);
    if (clickedLast) {
      fill(100);   
      rect(x, y, width, height);
    }
    else {
      fill(255);   
      rect(x, y, width, height);
    }
    fill(1);
    if (value.charAt(0) == '0' && value.length() > 1) {
      value = value.substring(1, value.length());
    }
    text(value, x - width/2 + 8, y);
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
