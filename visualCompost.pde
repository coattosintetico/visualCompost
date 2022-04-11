//
// Decompose an image using cellular automata through the Game of Life 
// rules, slightly modified.
//

// image objects
PImage img;

// CHANGE THIS TO USE ON OTHER IMAGES
// it has to be on your processing "data" sketch folder
////////////////////////////////////
String[] filenames = {"IMG_6887.jpg", "IMG_7456.jpg", "mabel.png"}; //
////////////////////////////////////

// own object that manages the Game of Life cellular
// automata, with the board and the rules
GOL gol;

// boolean variables to control the flow of the animation
boolean imageDisplayed = false;
boolean brightnessThresholdApplied = false;
boolean golCreated = false;

void setup() {
  size(1280, 720);
  frameRate(60);
  // load the image that is going to be displayed
  img = loadImage(filenames[0]);
  img.resize(600, 0);
  // initialize the GOL
  gol = new GOL();
}

void draw() {
  background(20);

  // compute and display the cellular automata
  gol.generate();
  gol.display();
  
  // display an image at the cursor position
  imageMode(CENTER);
  image(img, mouseX, mouseY);
}