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
        board[i][j].setColor(color(255));
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
          switch (mode) {
            case "distort":
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
              r /= numColors; g /= numColors; b /= numColors;
              board[x][y].setColor(color(r, g, b));
              break;
            case "eat":
              board[x][y].setColor(color(random(255), random(255), random(255)));
              break;
            case "clarify":
              color cClar = board[x][y].c;
              board[x][y].setColor(color(red(cClar)+10, green(cClar)+10, blue(cClar)+10));
              break;
            case "delete":
              color cShift = board[x][y].c;
              int shift = 50;
              board[x][y].setColor(color(red(cShift)+random(shift), green(cShift)+random(shift), blue(cShift)+random(shift)));
              break;
          }
        }
      }
    }
  }

  // Absorb the given image into the grid of cells
  void absorb(PImage imgSrc, int imgX, int imgY) {
    // Copy the image into another one
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
        // If i or j are out of bounds, use the modified modulo to "constrain" them
        int x = Math.floorMod(i, columns);
        int y = Math.floorMod(j, rows);

        int loc = (i-boardStartX) + (j-boardStartY)*img.width;
        // Average the cell's color with the image one and its current color
        color cImg = img.pixels[loc];
        color cCell = board[x][y].c;
        // average cImg and cCell if cCell is not black
        // if (cCell != color(255)) {
        //   float r = (red(cImg) + red(cCell))/2;
        //   float g = (green(cImg) + green(cCell))/2;
        //   float b = (blue(cImg) + blue(cCell))/2;
        //   board[x][y].setColor(color(r, g, b));
        // } else {
          board[x][y].setColor(cImg);
        // }
        // float r, g, b;
        // r = (red(cImg) + red(cCell))/2;
        // g = (green(cImg) + green(cCell))/2;
        // b = (blue(cImg) + blue(cCell))/2;
        // board[x][y].setColor(color(r, g, b));
        // Randomize the state of the cell
        board[x][y].setState(int(random(2)));
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

  // Revive cells in the vicinity of the given location
  void reviveCells(int screenX, int screenY) {
    // Convert the given coordinates from "pixels in the screen" to "board
    // coordinates" (scale by the cell width)
    int boardX = (int) screenX/w;
    int boardY = (int) screenY/w;
    // Iterate over the corresponding part of board
    for (int i = boardX-1; i <= boardX+1; i++) {
      for (int j = boardY-1; j <= boardY+1; j++) {
        // If i or j are out of bounds, use the modified modulo to "constrain" them
        int x = Math.floorMod(i, columns);
        int y = Math.floorMod(j, rows);
        // Randomize the state of the cell
        board[x][y].setState(1);
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
