int w = 200;  //number of cells along one side of the grid
float cellSize;  //side length of one cell
boolean[][] grid = new boolean[w][w];  //grid of w x w cells
boolean[][] next = new boolean[w][w];  //grid of w x w cells one iteration after 'grid'
int near_w = 3;  //view distance of one cell
boolean newGrid = false;  //true when a delay is needed before creating a new grid
int noChange = 0;  //number of consecutive frames with no changes

void setup(){
  size(1000, 1000);
  background(255);
  noStroke();
  for(int col = 0; col < w; col++){
    for(int row = 0; row < w; row++){
      next[col][row] = (int)random(2) == 0;
      grid[col][row] = false;
    }
  }
  cellSize = width / w;
}

void draw(){
  for(int col = 0; col < w; col++){
    for(int row = 0; row < w; row++){
      if(grid[col][row] != next[col][row]){  //check for cell changes to imporove performance
        if(next[col][row]){
          fill(0, 255);
        } else {
          fill(255, 255);
        }
        rect(col * cellSize, row * cellSize, cellSize, cellSize);
        grid[col][row] = next[col][row];
      }
    }
  }
  if(newGrid){
    delay(1000);
    newGrid = false;
  }
  next = step();
}

boolean[][] step(){
 int changed = 0;
 boolean[][] temp = new boolean[w][w];
 for(int col = 0; col < w; col++){
  for(int row = 0; row < w; row++){
    boolean val = checkNearby(col, row);
    if(grid[col][row] != val){
      changed++;
    }
    temp[col][row] = val;
  }
 }
 //increase cells' view distance when changes decrease
 if(changed / float(w * w) < 0.001 && near_w < w / 2){
   near_w += 2;
 }
 
 if(changed == 0){
   noChange++;
 } else {
  noChange = 0; 
 }
 
 if(noChange == 2){
   for(int col = 0; col < w; col++){
    for(int row = 0; row < w; row++){
      temp[col][row] = (int)random(2) == 0;
    }
  }
  near_w = 3;
  newGrid = true;
 }
 return temp;
}

boolean checkNearby(int grid_x, int grid_y){
  int nearby = 0;
  for(int col = -near_w / 2; col <= near_w / 2; col++){
   for(int row = -near_w / 2; row <= near_w / 2; row++){
     int cur_x = grid_x + col;
     int cur_y = grid_y + row;
     if(grid[(cur_x + w) % w][(cur_y + w) % w]){
        nearby++;
     }
   }
  }
  return nearby >= float(near_w * near_w) / 2;
}
