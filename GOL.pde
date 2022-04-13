/*
Game of Life class that manages the board where the black and white pixels are
going to be displayed, and the rules applied to them.
*/

class GOL {

  // width of each cell in pixels
  int w = 5;
  int columns, rows;

  // matrix where the cell objects are going to be stored
  Cell[][] board;

  // Initialize columns, rows and board
  GOL() {
    columns = width/w;
    rows = height/w;
    board = new Cell[columns][rows];
    init();
  }

  // Initialize all Cell objects
  void init() {
    for (int i = 0; i < columns; i++) {
      for (int j = 0; j < rows; j++) {
        board[i][j] = new Cell(i*w, j*w, w);
      }
    }
  }

  // The process of creating the new generation
  void generate() {
    // Save previous state for all cells
    for (int i = 0; i < columns;i++) {
      for (int j = 0; j < rows;j++) {
        board[i][j].savePrevious();
      }
    }

    // Loop through every spot in our 2D array
    for (int x = 0; x < columns; x++) {
      for (int y = 0; y < rows; y++) {

        // 1. GET NEIGHBORS
        int neighbors = 0;
        for (int i = -1; i <= 1; i++) {
          for (int j = -1; j <= 1; j++) {
            neighbors += board[(x+i+columns)%columns][(y+j+rows)%rows].previous;
          }
        }
        // Subtract the current cell's state since we added it in the above loop
        neighbors -= board[x][y].previous;

        // 2. RULES OF LIFE
        if      ((board[x][y].state == 1) && (neighbors <  2)) board[x][y].setState(0); // Loneliness
        else if ((board[x][y].state == 1) && (neighbors >  3)) board[x][y].setState(0); // Overpopulation
        else if ((board[x][y].state == 0) && (neighbors == 3)) board[x][y].setState(1); // Reproduction
        // else do nothing!

        // 3. COLOR UPDATE
        int r = 0, g = 0, b = 0;
        int numColors = 0;
        // if it was dead but is now alive
        if ((board[x][y].previous == 0) && (board[x][y].state == 1)) {
          // get color of alive neighbors
          for (int i = -1; i <= 1; i++) {
            for (int j = -1; j <= 1; j++) {
              if (board[(x+i+columns)%columns][(y+j+rows)%rows].state == 1) {
                color c = board[(x+i+columns)%columns][(y+j+rows)%rows].c;
                r += red(c);
                g += green(c);
                b += blue(c);
                numColors++;
              }
            }
          }
          float prob = random(1);
          // if (prob < 0.01) {
          //   r /= numColors; g /= numColors; b = b % 255;
          // } else if (prob > 0.99) {
          //   r /= numColors; g = g % 255; b /= numColors;
          // } else if ((prob > 0.495) && (prob < 0.505)) {
          //   r = r % 255; g /= numColors; b /= numColors;
          // } else {
          //   r /= numColors; g /= numColors; b /= numColors;
          // }
          r /= numColors; g /= numColors; b /= numColors;
          if (prob < 0.001) {
            board[x][y].setColor(color(map(int(random(2)), 0, 1, 0, 255)));
          } else {
            board[x][y].setColor(color(r, g, b));
          }
        }
      }
    }
  }

  // Absorb the given image into the grid of cells
  void absorb(PImage imgSrc, int imgX, int imgY) {
    // copy the image into another one
    PImage img = createImage(imgSrc.width, imgSrc.height, RGB);
    img.copy(imgSrc, 0, 0, imgSrc.width, imgSrc.height, 0, 0, imgSrc.width, imgSrc.height);
    img.resize(img.width/w, img.height/w);
    img.loadPixels();
    // Convert the given coordinates from "pixels in the screen" to "board
    // coordinates" (scale by the cell width)
    int boardStartX = (int) imgX/w;
    int boardStartY = (int) imgY/w;
    // Iterate over the corresponding part of board
    for (int i = boardStartX; i < boardStartX+img.width; i++) {
      for (int j = boardStartY; j < boardStartY+img.height; j++) {
        int loc = (i-boardStartX) + (j-boardStartY)*img.width;
        // Set the color of the cell according to the image
        color c = img.pixels[loc];
        board[i][j].setColor(c);
      }
    }
  }

  // Set a random state in each cell
  void randomize() {
    for (int i = 0; i < columns; i++) {
      for (int j = 0; j < rows; j++) {
        board[i][j].setState(int(random(2)));
      }
    }
  }

  // Draw the cells with the inner rules that they have
  void display() {
    for (int i = 0; i < columns;i++) {
      for (int j = 0; j < rows;j++) {
        board[i][j].display();
      }
    }
  }
}
