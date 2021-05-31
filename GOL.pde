//
// Game of Life class that manages the board where the
// black and white pixels are going to be displayed, and
// the rules applied to them. Also has a blackSpot method,
// to create a black circle that grows incrementally, 
// based on the generation it's in
//

class GOL {

  // width of each cell in pixels
  int w = 2;
  int columns, rows;
  int generation = 0;

  // matrix where the 1's or 0's are going to be stored
  int[][] board;

  // get one PImage object as argument. For the moment, it
  // has to be pre-processed to be only B&W and small sized
  GOL(PImage img) {
    img.resize(img.width/w, 0);
    // set columns and rows
    columns = width/w;
    rows = height/w;
    board = new int[columns][rows];
    // fill the board with the same pixels as the img
    init(img);
  }

  void init(PImage img) {
    int xOffset = int(columns/2 - img.width/2);
    int yOffset = int(rows/2 - img.height/2);
    img.loadPixels();
    for (int x = 0; x < img.width; x++) {
      for (int y = 0; y < img.height; y++) {
        // get pixel array location equivalent
        int location = x + y*img.width;
        // and assign it to the board
        if (img.pixels[location] == color(255)) {
          board[x+xOffset][y+yOffset] = 0;
        }
        else {
          board[x+xOffset][y+yOffset] = 1;
        }
      }
    }
  }

  // compute the new generation and store it in a new matrix. 
  // After computing, set board as this new one.
  void generate() {
    // next board
    int[][] next = new int[columns][rows];

    // loop through every spot in our 2D array and check spots neighbors
    for (int x = 1; x < columns-1; x++) { // he's avoiding the edges
      for (int y = 1; y < rows-1; y++) {
        // add up all the states in a 3x3 surrounding grid
        int neighbors = 0;
        for (int i = -1; i <= 1; i++) {
          for (int j = -1; j <= 1; j++) {
            neighbors += board[x+i][y+j];
          }
        }

        // a little trick to subtract the current cell's state since
        // we added it in the above loop
        neighbors -= board[x][y];

        // rules of Life
        if ((board[x][y] == 1) && (neighbors < 2)) {
          next[x][y] = 0; // Loneliness
        } else if ((board[x][y] == 1) && (neighbors > 3) && (neighbors < 6)) {
          next[x][y] = 0; // overpopulation
        } else if ((board[x][y] == 1) && (neighbors >= 6)) {
          // if it's completely surrounded by 1's, leave it be,
          // so only the "edges" are modified. Otherwise, the
          // big bunches of black were deleted instantly
          next[x][y] = 1; // survive in the overpopulation
        } else if ((board[x][y] == 0) && (neighbors == 3)) {
          next[x][y] = 1; // reproduction
        } else {
          next[x][y] = board[x][y]; // stasis
        }
      }
    }

    // this next matrix is now our board
    board = next;
    generation++;
  }

  // a function to create a black spot in the center of the board, after processing
  // the next generation, and make it larger with each generation. The spot is going
  // to be added "by force" after processing the generation, so it is permanent, so to speak.
  void blackSpot() {
    // radius of the circle (scaled with a factor to control the growth)
    float scaling = 1.0;
    int radius = int(generation*scaling);
    // iterate through a centered square of side as radius:
    for (int i = (columns-radius)/2; i < (columns+radius)/2; i++) {
      for (int j = (rows-radius)/2; j < (rows+radius)/2; j++) {
        // get coordinates relative to the center of the board:
        int x = i - (columns)/2;
        int y = j - (rows)/2;
        float r = sqrt(sq(x)+sq(y));
        if (r <= radius/2) {
          // could be optimized, check if there's an operation that eludes me from doing all this ifs
          if ((0 <= i) && (i < board.length) && (0 <= j) && (j < board[0].length)) {
            board[i][j] = 1;
          }
        }
      }
    }
  }

  // just draw the cells. Draw only the 1's; the background is
  // white, so the empty ones don't have to be drawn
  void display() {
    // eluding this makes it look like a ink spot expanding
    background(255);
    // black color
    fill(0);
    // and to avoid squaring (drawing the edges of the rectangles)
    noStroke(); 
    for (int i = 0; i < columns; i++) {
      for (int j = 0; j < rows; j++) {
        if (board[i][j] == 1) {
          rect(i*w, j*w, w, w);
        }
      }
    }
  }
}
