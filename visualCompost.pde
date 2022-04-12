/*
  Decompose an image using cellular automata through the Game of Life rules,
  slightly modified.
*/

// Image objects
PImage[] imgs;
int imgIndex;
String[] filenames = {"IMG_6887.jpg", "IMG_7456.jpg", "mabel.png"};

// Board object
GOL gol;

float countdown = 2000.0;
float tDisplayed;

void setup() {
  size(1280, 720);
  frameRate(60);
  // Load the images that are going to be displayed
  imgs = new PImage[filenames.length];
  for (int i = 0; i < filenames.length; i++) {
    imgs[i] = loadImage(filenames[i]);
    imgs[i].resize(600, 0);
  }
  imgIndex = 0;
  // initialize the GOL
  gol = new GOL();
}

void draw() {
  // background(20);

  // compute and display the cellular automata only each 5 frames
  // if (frameCount % 5 == 0) {
    gol.generate();
    gol.display();
  // }

  // display an image at the cursor position if countdown is over
  if (millis() - tDisplayed > countdown) {
    imageMode(CENTER);
    image(imgs[imgIndex], mouseX, mouseY);
  }
}

// add image to the GOL board on click
void mousePressed() {
  int x = (int) mouseX - imgs[imgIndex].width/2;
  int y = (int) mouseY - imgs[imgIndex].height/2;
  gol.absorb(imgs[imgIndex], x, y);
  imgIndex = (imgIndex + 1) % imgs.length;
  tDisplayed = millis();
}