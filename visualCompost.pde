/*
  Decompose an image using cellular automata through the Game of Life rules,
  slightly modified.
*/

// Image objects
PImage[] imgs;
int imgIndex;
String[] filenames;

boolean eat = false;
String mode;
String imgMode;
// Board object
GOL gol;

float countdown = 10.0;
float tDisplayed;

// Variables for the animation
PVector[] positions;
boolean displayCells;
float[] appearances = {102.8, 105.7, 106.4, 106.9, 107.5, 108.8,
  111.7, 112.8, 114.8, 117.7, 118.9, 120.8, 123.8, 124.9, 126.7,
  129.8, 130.8, 132.9, 135.7, 136.8, 138.7, 141.6, 142.8, 144.7,
  147.7, 148.8, 150.8, 153.7, 154.8, 156.7, 159.7, 160.8, 162.8};

void setup() {
  size(1280, 720);
  // frameRate(24); not necessary to maintain the same framerate
  background(255);
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
  
}

void draw() {
  int fc = frameCount;
  if ((fc > stf(4.0)) && (fc < stf(5.4))) { // random imgs
    // Display all images at random locations
    for (int i = 0; i < imgs.length; i++) {
      imageMode(CENTER);
      image(imgs[i], random(width), random(height));
    }
  }
  if (fc == stf(5.4)) background(255);

  if ((fc > stf(9.7)) && (fc < stf(10.8))) { // random imgs
    // Display all images at random locations
    for (int i = 0; i < imgs.length; i++) {
      imageMode(CENTER);
      image(imgs[i], random(width), random(height));
    }
  }
  if (fc == stf(10.8)) background(255);

  if ((fc > stf(15.05)) && (fc < stf(16.15))) { // random imgs and maintain
    background(255);
    // Display all images at random locations
    for (int i = 0; i < imgs.length; i++) {
      imageMode(CENTER);
      image(imgs[i], random(width), random(height));
    }
  }

  if ((fc > stf(19.4)) && (fc < stf(31.54))) { // random imgs, noise in crescendo
    background(255);
    // Display all images at random locations
    for (int i = 0; i < imgs.length; i++) {
      tint(255, 255);
      imageMode(CENTER);
      image(imgs[i], random(width), random(height));
    }
    // draw random white and black noise on screen
    PImage noise = createImage(width, height, RGB);
    noise.loadPixels();
    for (int i = 0; i < noise.pixels.length; i++) {
      if (random(1) < 0.5) {
        noise.pixels[i] = color(255);
      } else {
        noise.pixels[i] = color(0);
      }
    }
    // display noise at half opacity
    tint(255, map(
      fc, stf(19.4), stf(30.5), 0, 255
      ));
    imageMode(CORNER);
    image(noise, 0, 0, width, height);
  }

  if ((fc > stf(31.54)) && (fc < stf(32.57))) { // random imgs
    for (int i = 0; i < imgs.length; i++) {
      imageMode(CENTER);
      image(imgs[i], random(width), random(height));
    }
  }

  // if (fc == stf(32.57)) { // show images
  //   positions = new PVector[imgs.length];
  //   for (int i = 0; i < imgs.length; i++) {
  //     int x = (int) random(0, width);
  //     int y = (int) random(0, height);
  //     positions[i] = new PVector(x, y);
  //     imageMode(CENTER);
  //     image(imgs[i], x, y);
  //   }
  // }

  if (fc == stf(32.57)) { // absorb all images
    gol = new GOL();
    for (int i = 0; i < imgs.length; i++) {
      // int imgX = (int) positions[i].x-imgs[i].width/2;
      // int imgY = (int) positions[i].y-imgs[i].height/2;
      int x = (int) random(0, width);
      int y = (int) random(0, height);
      gol.absorb(imgs[i], x, y);
    }
    displayCells = false;
    gol.display();
  }

  if ((fc > stf(35.57)) && (fc < stf(40.8))) { // run showing cells
    displayCells = true;
    gol.generate();
    gol.display();
  }

  if (fc == stf(40.8)) gol.randomize();        // randomize and
  if ((fc > stf(40.8))  && (fc < stf(50.8))) { // run hiding cells
    displayCells = false;
    gol.generate();
    gol.display();
  }

  // randomize here?
  if ((fc > stf(50.8))  && (fc < stf(80.6))) { // run showing cells
    displayCells = true;
    gol.generate();
    gol.display();
  }

  if ((fc > stf(80.6)) && (fc < stf(100.7))) { // evaporate
    displayCells = false;
    mode = "delete";
    gol.generate();
    gol.display();
  }

  if ((fc > stf(100.7)) && (fc < stf(165.9))) { // evaporate while luchando por la vida
    int index = 0;
    for (int i = 0; i < appearances.length; i++) {
      if (fc == stf(appearances[i])) {
        gol.absorb(imgs[index], int(random(0, width)-imgs[index].width), int(random(0, height)-imgs[index].height));
        index++;
        index = index % imgs.length;
      }
    }
    displayCells = false;
    mode = "delete";
    gol.generate();
    gol.display();
  }

  if (fc == stf(165.9)) gol.randomize(); // randomize
  if ((fc > stf(165.9)) && (fc < stf(256.5))) { // 
    displayCells = true;
    mode = "delete";
    gol.generate();
    gol.display();
  }


  if (fc == stf(256.5)) exit();
  // gol.generate();
  // gol.display();

  // // display an image at the cursor position if countdown is over
  // if ((millis() - tDisplayed > countdown) && (imgMode == "placer")) {
  //   imageMode(CENTER);
  //   image(imgs[imgIndex], mouseX, mouseY);
  // }
  saveFrame("animation/#####.png");
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

int stf(float seconds) { // secondsToFrame
  return (int) (24 * seconds);
}

color invert(color c) {
  return color(255-red(c), 255-green(c), 255-blue(c));
}
