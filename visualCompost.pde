//
// Decompose an image using cellular automata through the Game of Life 
// rules, slightly modified.
//

// library to export directly a video
// EDITED: currently not working with Processing 4
// import com.hamoid.*;
// VideoExport videoExport;

// image objects
PImage source;
PImage img;

// CHANGE THIS TO USE ON OTHER IMAGES
// it has to be on your processing "data" sketch folder
////////////////////////////////////
String filename = "IMG_6887.jpg"; //
////////////////////////////////////

// own object that manages the Game of Life cellular
// automata, with the board and the rules
GOL gol;

// boolean variables to control the flow of the animation
boolean imageDisplayed = false;
boolean imageResized = false;
boolean brightnessThresholdApplied = false;
boolean golCreated = false;

void setup() {
  size(1024, 576);
  // load the image that is going to be displayed
  source = loadImage(filename);
  background(255);
  frameRate(12);

  // to record sketch as a video
  // EDITED: currently not working with Processing 4
  // videoExport = new VideoExport(this, "visualCompost.mp4");
  // videoExport.setFrameRate(12);
  // videoExport.startMovie();
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
    // Method to generate a growing black spot in the middle of the image:
    // gol.blackSpot();
    gol.display();
  }

  // EDITED: currently not working with Processing 4
  // videoExport.saveFrame();

  if (millis() > 50000) {
    // EDITED: currently not working with Processing 4
    // videoExport.endMovie();
    exit();
  }

}

void keyPressed() {
  if (key == 'q') {
    // EDITED: currently not working with Processing 4
    // videoExport.endMovie();
    exit();
  }
}

// include a possibility to only modify the 0's, and if it's 1 (AKA black) leave it be. 
// like an ink spot expanding.
