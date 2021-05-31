//
// Display an image centered in screen, resized to fit if it's enabled
//

void displayCentered(PImage img, boolean resize) {
  
  if (resize) {
    img.resize(width, 0);
    if (img.height > height) {
      println("image had to be resized to height");
      img.resize(0, height);
    }
  }

  float x = (width - img.width)/2;
  float y = (height - img.height)/2;
  background(255);
  image(img, x, y);
  
}
