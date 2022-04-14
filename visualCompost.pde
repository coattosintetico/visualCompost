/*
  Decompose an image using cellular automata through the Game of Life rules,
  slightly modified.
*/

// Image objects
PImage[] imgs;
int imgIndex;
String[] filenames;

boolean displayCells = true;
boolean eat = false;
String mode;
String imgMode;
// Board object
GOL gol;

float countdown = 10.0;
float tDisplayed;

void setup() {
  size(1280, 720);
  frameRate(30);
  // Load the images that are going to be displayed
  filenames = listFileNames("data/");
  imgs = new PImage[filenames.length];
  for (int i = 0; i < filenames.length; i++) {
    imgs[i] = loadImage(filenames[i]);
    if (imgs[i].width > imgs[i].height) {
      imgs[i].resize((int) random(500, 700), 0);
    } else {
      imgs[i].resize(0 , (int) random(200, 400));
    }
  }
  imgIndex = 0;
  // initialize the GOL
  mode = "distort";
  imgMode = "placer";
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
  if ((millis() - tDisplayed > countdown) && (imgMode == "placer")) {
    imageMode(CENTER);
    image(imgs[imgIndex], mouseX, mouseY);
  }
  saveFrame("testfps/testfps-####.png");
}

// add image to the GOL board on click
void mousePressed() {
  switch (imgMode) {
    case "placer":
      int x = (int) mouseX - imgs[imgIndex].width/2;
      int y = (int) mouseY - imgs[imgIndex].height/2;
      gol.absorb(imgs[imgIndex], x, y);
      imgIndex = (imgIndex + 1) % imgs.length;
      tDisplayed = millis();
      break;
    case "creator":
      gol.reviveCells(mouseX, mouseY);
      break;
  }
}

void keyPressed() {
  if (key == ' ') gol.randomize();
  if (key == CODED) {
    if (keyCode == DOWN) {
    imgs[imgIndex].resize(int(imgs[imgIndex].width*0.9), 0);
    } else if (keyCode == UP) {
    imgs[imgIndex].resize(int(imgs[imgIndex].width*1.1), 0);
    }
  }
  if (key == 'b') displayCells = !displayCells;
  if (key == '1') mode = "distort";
  if (key == '2') mode = "eat";
  if (key == '3') mode = "clarify";
  if (key == '4') mode = "shift";
  if (key == 'z') imgMode = "placer";
  if (key == 'x') imgMode = "creator";
}

String[] listFileNames(String dir) {
  File f = new File(dir);
  String[] files = f.list();
  return files;
}

int secondsToFrame(float seconds) {
  return (int) (30 * seconds);
}