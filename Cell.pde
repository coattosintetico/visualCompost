// Cell object

class Cell {

  float x, y;
  float w;

  int state;
  int previous;

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

  void display() {
    if (previous == 0 && state == 1) fill(0,0,255);
    else if (state == 1) fill(0);
    else if (previous == 1 && state == 0) fill(255,0,0);
    else fill(255); 
    noStroke();
    rect(x, y, w, w);
  }
}
