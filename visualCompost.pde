//
// Decompose an image using cellular automata through the Game of Life 
// rules, slightly modified.
//

// import the library to export a video
import com.hamoid.*;
VideoExport videoExport;

PImage source;
PImage img;
GOL gol;

boolean imageDisplayed = false;
boolean imageResized = false;
boolean brightnessThresholdApplied = false;
boolean golCreated = false;

// boolean recording = false;

boolean golInitiated = false;

void setup() {
  size(1024, 576);
  source = loadImage("IMG_6887.jpg");
  // // resize image with 100 pixels width, maintaining its proportion
  // source.resize(100, 0);
  // PImage destination = brightnessThreshold(source, 170);
  // destination.loadPixels();
  // gol = new GOL(destination);
  background(255);
  frameRate(12);
  videoExport = new VideoExport(this, "visualCompost.mp4");
  videoExport.setFrameRate(12);
  videoExport.startMovie();
}

void draw() {

  if ((millis() > 2000) && (!imageDisplayed)) {
  displayCentered(source, true);
  imageDisplayed = true;
  println("initial image displayed");
  }

  if ((millis() > 5000) && (!imageResized)) {
    if (source.height > 400) {
      println("resizing...");
      int h = int(height - (millis()-5000)*0.5);
      source.resize(0, h);
      displayCentered(source, false);
    } else {
      imageResized = true;
      println("image resized");
  // BEGGINING RECORDING
      // recording = true;
    }
  }

  if ((millis() > 8000) && (!brightnessThresholdApplied)) {
    img = brightnessThreshold(source, 170);
    displayCentered(img, false);
    brightnessThresholdApplied = true;
    println("brightnessThreshold applied");
  }

  if ((millis() > 9500) && (!golCreated)) {
    gol = new GOL(img);
    gol.display();
    golCreated = true;
  }

  if (millis() > 11000) {
    gol.generate();
    gol.blackSpot();
    gol.display();
  }

  videoExport.saveFrame();

  if (millis() > 30000) {
    videoExport.endMovie();
    exit();
  }

//  if (recording) {
// saveFrame("output/blackSpot_####.png");
//  }
}

void keyPressed() {
  if (key == 'q') {
    videoExport.endMovie();
    exit();
  }
}

void mousePressed() {
}

// void initgameoflife() {
//   img = brightnessThreshold(source, 170);
//   gol = new GOL(img);
//   gol.display();
//   golInitiated = true;
// }

// include in the GOL class a method called setColumnsRowsAsWidthHeight()
