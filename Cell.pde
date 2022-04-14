// Cell object

class Cell {

  float x, y;
  float w;

  int state;
  int previous;
  color c;

  Cell(float x_, float y_, float w_) {
    x = x_;
    y = y_;
    w = w_;
    
    state = 0;
    previous = state;
  }
  
  void savePrevious() {
    previous = state; 
  }

  void setState(int s) {
    state = s;
  }

  void setColor(color c_) {
    c = c_;
  }

  void display() {
    // if the cell was dead and is now alive, draw a white circle
    if ((state == 1 && previous == 0) && (displayCells)) {
      fill(0);
      noStroke();
      rectMode(CORNER);
      rect(x, y, w, w);
    } else {
      fill(c);
      noStroke();
      rect(x, y, w, w);
    }
  }
}
