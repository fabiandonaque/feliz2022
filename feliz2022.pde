import com.hamoid.*;

VideoExport videoExport;

int[][] chart = {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,1,1,1,1,1,0,1,1,1,1,1,0,1,0,0,0,0,0,1,0,1,1,1,1,1,0,0},
{0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0},
{0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0,0,0},
{0,0,1,1,1,0,0,0,1,1,1,0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0},
{0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0},
{0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,1,0,0,0,0,0,0},
{0,0,1,0,0,0,0,0,1,1,1,1,1,0,1,1,1,1,1,0,1,0,1,1,1,1,1,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,0,0,0},
{0,0,0,0,0,0,0,1,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0},
{0,0,0,0,0,0,0,1,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0},
{0,0,0,1,1,1,1,1,0,1,0,0,0,1,0,1,1,1,1,1,0,1,1,1,1,1,0,0,0},
{0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0},
{0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0},
{0,0,0,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}};

int cols,rows;
int w = 20;
Cell[][] grid;
Cell current;
Cell[] historic = {};
boolean stopper = true;

void setup(){
  size(581,401);
  cols = floor(width/w);
  rows = floor(height/w);
  grid = new Cell[rows][cols];
  for(int j = 0; j<rows; j++){
    for(int i = 0; i<cols; i++){
      grid[j][i] = new Cell(i,j);
    }
  }
  current = grid[0][0];
  current.current = true;
  videoExport = new VideoExport(this, "greetings.mp4");
  videoExport.setFrameRate(30);  
  videoExport.startMovie();
}

void draw(){
  // show all
  background(128);
  for(int j = 0; j<rows; j++){
    for(int i = 0; i<cols; i++){
      grid[j][i].show();
    }
  }
  videoExport.saveFrame();
  if(chart[current.j][current.i] == 1){
    current.greetings = true;
  }
  // check next
  Cell[] around = {};
  if(current.j-1 >= 0){
    //println("top");
    Cell cell = grid[current.j-1][current.i];
    if(!cell.visited) around = (Cell[])append(around,cell);
  }
  if(current.j+1 < rows){
    //println("bottom");
    Cell cell = grid[current.j+1][current.i];
    if(!cell.visited) around = (Cell[])append(around,cell);
  }
  if(current.i-1 >= 0){
    //println("left");
    Cell cell = grid[current.j][current.i-1];
    if(!cell.visited) around = (Cell[])append(around,cell);
  }
  if(current.i+1 < cols){
    //println("right");
    Cell cell = grid[current.j][current.i+1];
    if(!cell.visited) around = (Cell[])append(around,cell);
  }

  // if all visited get back
  if(around.length > 0){
    //println("hay alrededor");
    current.visited = true;
    int index = int(random(around.length));
    historic = (Cell[])append(historic,current);
    Cell next = around[index];
    int n_i = next.i;
    int n_j = next.j;
    int c_i = current.i;
    int c_j = current.j;
    //println("current: [",current.i,",",current.j,"], next: [",next.i,",",next.j,"]");
    // check walls
    if(c_j - n_j == -1){
      //println("remove bottom");
      next.top = false;
      current.bottom = false;
    } else if(c_j - n_j == 1){
      //println("remove top");
      next.bottom = false;
      current.top = false;
    } else if(c_i - n_i == -1){
      //println("remove right");
      next.left = false;
      current.right = false;
    } else if(c_i - n_i == 1){
      //println("remove left");
      next.right = false;
      current.left = false;
    }
    current.current = false;
    next.current = true;
    next.visited = true;
    current = next;
    
  } else {
    if(historic.length > 0){
      current.current = false;
      current = historic[historic.length-1];
      current.current = true;
      historic = (Cell[])subset(historic,0,historic.length-1);
    } else {
      if(current.current){
        current.current = false;
        redraw();
      } else {  
        delay(2000);
        videoExport.endMovie();
        exit();
      }
    }
  }
  //delay(10);
}

void keyPressed(){
  stopper = false;
}

class Cell {
  int i,j;
  boolean top = true;
  boolean bottom = true;
  boolean right = true;
  boolean left = true;
  boolean visited = false;
  boolean current = false;
  boolean greetings = false;
  
  Cell(int i, int j){
    this.i = i;
    this.j = j;
  }
  
  void show(){
    int x = this.i*w;
    int y = this.j*w;
    noStroke();
    if(this.visited) {
      fill(255,127,0);
      rect(x,y,w,w);
    }
    if(this.greetings) {
      fill(43,43,43);
      rect(x,y,w,w);
    }
    if(this.current) {
      fill(255,0,255);
      rect(x,y,w,w);
    }
    noFill();
    stroke(255);
    if(this.top){
      //println("top [",this.i,",",this.j,"]");
      line(x,y,x+w,y);
    }
    if(this.right){
      //println("right [",this.i,",",this.j,"]");
      line(x+w,y,x+w,y+w);
    }
    if(this.bottom){
      //println("bottom [",this.i,",",this.j,"]");
      line(x+w,y+w,x,y+w);
    }
    if(this.left){
      //println("left [",this.i,",",this.j,"]");
      line(x,y+w,x,y);
    }
    
  }
}
