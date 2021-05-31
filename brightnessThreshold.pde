//
// A function that takes a PImage object and returns another
// that is converted into only pure black and white pixels.
//

PImage brightnessThreshold(PImage source, float threshold) {
  // create a destination PImage object
  PImage destination = createImage(source.width, source.height, RGB);
  // load pixels from both source and destination
  source.loadPixels();
  destination.loadPixels();
  // iterate through the pixels array as a 2-dimensional matrix:
  for (int x = 0; x < source.width; x++) {
    for (int y = 0; y < source.height; y++) {
      int loc = x + y*source.width;
      // test brightness against threshold:
      if (brightness(source.pixels[loc]) < threshold) {
        destination.pixels[loc] = color(0); // black
      } else {
        destination.pixels[loc] = color(255); // white
      }
    }
  }
  // the destination image is the only one needed to be updapted:
  destination.updatePixels();
  // and return it as a PImage object
  return destination;
}
