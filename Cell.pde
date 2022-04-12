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
    
    // set a random state which is 0 or 1
    state = (int) random(2);
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
    fill(c);
    noStroke();
    rect(x, y, w, w);
  }
}
