        // if (board[x][y] == 1) {
        //   if (neighbors < 2) {
        //     next[x][y] = 0; // Loneliness
        //   } else if ((neighbors > 3) && (neighbors < 8)) {
        //     next[x][y] = 0; // overpopulation
        //   } else if (neighbors == 8) {
        //   // if it's completely surrounded by 1's, leave it be,
        //   // so only the "edges" are modified. Otherwise, the
        //   // big bunches of black were deleted instantly
        //     next[x][y] = 1; // survive in the overpopulation
        //   } 
        // } else if (board[x][y] == 0) {
        //   if (neighbors == 2 || neighbors == 3) {
        //     next[x][y] = 1; // reproduction
        //   } else if (neighbors == 2) {
        //     if (random(1) > 0.75) {
        //       next[x][y] = 1;
        //     } else {
        //       next[x][y] = 0;
        //     }
        //   }
        // } else {
        //     next[x][y] = board[x][y]; // stasis
        //   }

                // rules of Life
        // if ((board[x][y] == 1) && (neighbors < 2)) {
        //   next[x][y] = 0; // Loneliness
        // } else if ((board[x][y] == 1) && (neighbors > 3) && (neighbors < 6)) {
        //   next[x][y] = 0; // overpopulation
        // } else if ((board[x][y] == 1) && (neighbors >= 6)) {
        //   // if it's completely surrounded by 1's, leave it be,
        //   // so only the "edges" are modified. Otherwise, the
        //   // big bunches of black were deleted instantly
        //   next[x][y] = 1; // survive in the overpopulation
        // } else if ((board[x][y] == 0) && (neighbors == 3)) {
        //   next[x][y] = 1; // reproduction
        // } else {
        //   next[x][y] = board[x][y]; // stasis
        // }