# Game: Of Life
GOL (Game Of Life) is a cellular automata algorithm thought by John Conway, it follows strict rules over how cells may decay, live or grow and is pretty straight forward.

## Implementation
This project works with a matrix to keep track of cell states and process the cells faster, the output is transfered to a copy matrix so that the first one isn't contaminated by the results of itself. At the end of it all, the result is transferred to a tilemap to be drawn in the screen.

Some commented code worked for the user to make the input of what to draw.

The camera is stuck to show the entire board.

The implementation as it is now is pretty slow at a bigger map, but bearable at lower resolutions, more research may be needed to optimize and make it bearable to watch a bigger resolution (perhaps draw pixel-per-pixel, cell-to-pixel, 1:1).
