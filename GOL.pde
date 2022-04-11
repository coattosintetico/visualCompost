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
        if      ((board[x][y].state == 1) && (neighbors >  7)) board[x][y].setState(1); // Avoid huge spot removal
        else if ((board[x][y].state == 1) && (neighbors <  2)) board[x][y].setState(0); // Loneliness
        else if ((board[x][y].state == 1) && (neighbors >  3)) board[x][y].setState(0); // Overpopulation
        else if ((board[x][y].state == 0) && (neighbors == 3)) board[x][y].setState(1); // Reproduction
        // else do nothing!
      }
    }
  }

  // absorb the given image into the grid of cells
  // overrides the current state of the cell
  void absorb(PImage img, int imgX, int imgY) {

    img.resize(img.width/w, img.height/w);
    PImage newImg = brightnessThreshold(img, 125);
    newImg.loadPixels();
    // Convert the given coordinates from "pixels in the screen" to "board
    // coordinates" (scale by the cell width)
    int boardStartX = (int) imgX/w;
    int boardStartY = (int) imgY/w;
    int widthScaled  = (int) img.width;
    int heightScaled = (int) img.height;
    int cellsUpdated = 0;
    // Iterate over the corresponding part of board
    for (int i = boardStartX; i < boardStartX+widthScaled; i++) {
      for (int j = boardStartY; j < boardStartY+heightScaled; j++) {
        int loc = (i-boardStartX) + (j-boardStartY)*newImg.width;
        // NOTE: there should be a better way to check this. Maybe design a
        // specific function from brightnessThreshold
        int s;
        if (newImg.pixels[loc] == color(255)) {
          s = 0;
        } else {
          s = 1;
          cellsUpdated++;
        }
        // Set every cell to the state given by the image
        board[i][j].setState(s);
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
