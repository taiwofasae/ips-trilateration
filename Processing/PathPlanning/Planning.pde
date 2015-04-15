

// 2D Array of objects
Cell[][] grid;

// Number of columns and rows in the grid
int cols = 0;
int rows = 0;

int gh = 580;
int gw = 580;

int gx = 20;
int gy = 620;

int x_val = 0;
int y_val = 0;

int x_ind_val=1;
int y_ind_val = 1;

int startx = 0;
int starty = 0;
int endx = 0;
int endy = 0;

int starti = 1;
int startj = 1;
int endi = 10;
int endj = 10;

int tempx;
int tempy;
int tempi;
int tempj;
int walls = 0;
int shadows = 0;
int steps = 0;
int wallmax = 500;
int shadowmax = 1000;
int[][] wallArray;
int[][] shadowArray;
ArrayList<Cost> pathArray;
ArrayList<Cost> visitedArray;
PQ agenda;
int[][] robotArray;

int pathmax = 500;

int x_max = 500;
int y_max = 500;
int grid_max = 20;

int x_ind_max = 25;
int y_ind_max = 25;
color back = color(#0CF1F7);

Button setStartB,setEndB, StartB, EndB, WallB, RobotB, WallC;

void setup() {
  size(700,700);
  background(back);  // deep grey
  createMap(gx,gy,gw,gh,x_max,y_max,grid_max);
  
  GridDisplay(gx,gy,gw,gh,x_max,y_max,grid_max);
  setStartB = new Button(30,690,100,20,true,"Set Start Position");
  setEndB = new Button(130,690,90,20,true,"Set End Position");
  StartB = new Button(230, 690, 75, 20, false, "Start");
  EndB = new Button(330, 690, 75, 20, false, "Stop");
  WallB = new Button(430, 690, 75, 20, true, "Wall");
  WallC = new Button(430, 670, 100, 20, true, "Wall Clear");
  RobotB = new Button (530, 690, 75, 20, true, "Robot");
  
  
  enableAll();
  visibleAll();
  //port = new Serial(this, portName, 9600);
  wallArray = new int[0][2];
  shadowArray = new int[0][2];
  robotArray = new int[0][2];
  pathArray = new ArrayList<Cost>();
  visitedArray = new ArrayList<Cost>();
  
  endi = x_ind_max;
  endj = y_ind_max;
}

void draw() {
  
  displayAll();  
  freshMap();
  if(setStartB.isclicked())
  {
    println("Set Start");
    
    setEndB.makeEnable(false);
    StartB.makeEnable(false);
    EndB.makeEnable(false);
    WallB.makeEnable(false);
    WallC.makeEnable(false);
    RobotB.makeEnable(true);
    
    
    if(mousePressed && overRect(gx,(height - gy),gw,gh))
    {
      println("Start Position");  
      startx = int(pointXAbs(mouseX)) ;
      starty = int(pointYAbs(mouseY));    
      starti = point_to_ind(startx);
      startj = point_to_ind(starty); 
      grid[starti-1][startj-1].fillColor = 'y';  //Yellow for start position
      grid[starti-1][startj-1].display();
    }
    
  }
  else if(setEndB.isclicked())
  {
    println("Set End");
    setStartB.makeEnable(false);
    
    StartB.makeEnable(false);
    EndB.makeEnable(false);
    WallB.makeEnable(false);
    WallC.makeEnable(false);
    RobotB.makeEnable(true);
    
    if(mousePressed && overRect(gx,(height - gy),gw,gh))
    {
      println("End Position");
      endx = int(pointXAbs(mouseX)) ;
      endy = int(pointYAbs(mouseY));    
      endi = point_to_ind(endx);
      endj = point_to_ind(endy); 
      grid[endi-1][endj-1].fillColor = 'B';  //blue for start position
      grid[endi-1][endj-1].display();
      
    }
  }
  else if(StartB.isclicked())
  {
    println("Started");
    // planning
    // robot movement
    planRoute();
    
  }
  else if(EndB.isclicked())
  {
    println("Ended");
    // stop robot movement
  }
  
  else if(WallB.isclicked())
  {
    println("Wall");
    setStartB.makeEnable(false);
    setEndB.makeEnable(false);
    StartB.makeEnable(false);
    EndB.makeEnable(false);
    WallC.makeEnable(false);
    
    RobotB.makeEnable(true);
      if(mousePressed && overRect(gx,(height - gy),gw,gh))
      {
        println("Wall selected");
        tempx = int(pointXAbs(mouseX)) ;
        tempy = int(pointYAbs(mouseY));    
        tempi = point_to_ind(tempx);
        tempj = point_to_ind(tempy); 
        if(grid[tempi-1][tempj-1].fillColor == 'b') //black for wall
        {
          //do nothing
        }
        else
        {
          println("Wall Added");
          wallArray = (int [][])append(wallArray, new int[]{tempi, tempj});
                       
          shadowArray = (int [][])append(shadowArray, new int[]{constrain(tempi-1,1,x_ind_max),constrain(tempj-1, 1, y_ind_max)});
          shadowArray = (int [][])append(shadowArray, new int[]{constrain(tempi-1, 1, x_ind_max),constrain(tempj, 1, y_ind_max)});
          shadowArray = (int [][])append(shadowArray, new int[]{constrain(tempi-1, 1, x_ind_max),constrain(tempj+1, 1, y_ind_max)});
          
          shadowArray = (int [][])append(shadowArray, new int[]{constrain(tempi, 1, x_ind_max),constrain(tempj+1, 1, y_ind_max)});
          shadowArray = (int [][])append(shadowArray, new int[]{constrain(tempi, 1, x_ind_max),constrain(tempj-1, 1, y_ind_max)});
          
          shadowArray = (int [][])append(shadowArray, new int[]{constrain(tempi+1, 1, x_ind_max),constrain(tempj-1, 1, y_ind_max)});
          shadowArray = (int [][])append(shadowArray, new int[]{constrain(tempi+1, 1, x_ind_max),constrain(tempj, 1, y_ind_max)});
          shadowArray = (int [][])append(shadowArray, new int[]{constrain(tempi+1, 1, x_ind_max),constrain(tempj+1, 1, y_ind_max)});
          
          shadows=shadows+8;
          
          walls++;
        }
      
      }
  }
  else if(WallC.isclicked())
  {
    println("Wall Clear");
    setStartB.makeEnable(false);
    setEndB.makeEnable(false);
    StartB.makeEnable(false);
    EndB.makeEnable(false);
    WallB.makeEnable(false);
    RobotB.makeEnable(true);
      if(mousePressed && overRect(gx,(height - gy),gw,gh))
      {
        println("Wall selected");
        tempx = int(pointXAbs(mouseX)) ;
        tempy = int(pointYAbs(mouseY));    
        tempi = point_to_ind(tempx);
        tempj = point_to_ind(tempy); 
        if(grid[tempi-1][tempj-1].fillColor != 'b') //black for wall
        {
          //do nothing
        }
        else
        {
          println("Wall Removed");
          
          for(int i=0;i<walls;i++)
          {
              if((tempi == wallArray[i][0]) && (tempj == wallArray[i][1]))
                {
                  
                  for(int j=i;j<walls-1;j++)
                  {
                    wallArray[j][0] = wallArray[j+1][0];
                    wallArray[j][1] = wallArray[j+1][1];
                  }
                  for(int j=i;j<walls-1;j++)
                  {
                    for(int m=0;m<8;m++)
                    {
                      shadowArray[(j*8)+m][0] = shadowArray[((j+1)*8)+m][0];
                      shadowArray[(j*8)+m][1] = shadowArray[((j+1)*8)+m][1];
                    }
                  }
         
          
                shadows=shadows-8;
          
                walls--;
                }
        }
      }
    }
  }
  
  else 
  {
    
    setStartB.makeEnable(true);
    setEndB.makeEnable(true);
    StartB.makeEnable(true);
    EndB.makeEnable(true);
    WallB.makeEnable(true);
    WallC.makeEnable(true);
    RobotB.makeEnable(true);
  }
  if(RobotB.isclicked())
  {
    println("Robot Click");
    // show robot
    setStartB.makeEnable(true);
    setEndB.makeEnable(true);
    StartB.makeEnable(true);
    EndB.makeEnable(true);
    WallB.makeEnable(true);
    WallC.makeEnable(true);
    RobotB.makeEnable(true);
  
    
  }
  
  
  
  
//  createMap(gx,gy,gw,gh,x_max,y_max,grid_max);
//  GridDisplay(gx,gy,gw,gh,x_max,y_max,grid_max);
    for(int i=0;i<pathArray.size();i++)
    {
      Cost cc = pathArray.get(i);
      for(int j=0;j<cc.xlist.length;j++)
      {
//        print(cc.xlist[j]);
//        print("||");
//        println(cc.ylist[j]);
          grid[cc.xlist[j]-1][cc.ylist[j]-1].fillColor = 'G';
          grid[cc.xlist[j]-1][cc.ylist[j]-1].display();
      }
      
    }
  
  //print("Shadows:");
  //println(shadows);
  for(int i=0;i<shadows;i++)
  {
    grid[shadowArray[i][0]-1][shadowArray[i][1]-1].fillColor = 'o';
    grid[shadowArray[i][0]-1][shadowArray[i][1]-1].display();
  }
  grid[starti-1][startj-1].fillColor = 'y';
  grid[starti-1][startj-1].display();
  grid[endi-1][endj-1].fillColor = 'B';
  grid[endi-1][endj-1].display();
  for(int i=0;i<walls;i++)
  {
    grid[wallArray[i][0]-1][wallArray[i][1]-1].fillColor = 'b';
    grid[wallArray[i][0]-1][wallArray[i][1]-1].display();
  }
  
  
   
  GridDisplay(gx,gy,gw,gh,x_max,y_max,grid_max);
}
 
      
  
int invertY(int y) { return height - y;}
 // Create Map
 
void GridDisplay(int x, int y, int w, int h, int x_max, int y_max, int grid_max) {
   for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      // Oscillate and display each object
      
      grid[i][j].display();
      grid[i][j].points();
    }
  }
  
}
void freshMap() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      // Initialize each object
      if(((i%2)==0) && ((j%2)==0))
      grid[i][j].fillColor = 'g';
      else
      grid[i][j].fillColor = 'w';
      grid[i][j].display();
    }
  }
}
void createMap(int x, int y, int w, int h, int x_max, int y_max, int grid_max) {
  
  y = invertY(y);
  
  

  
  cols = x_max/grid_max;
  rows = y_max/grid_max;
  grid = new Cell[cols][rows];
  float colSize = (grid_max * w * 1.0)/x_max; // map(grid_max, 0, x_max, 0, w);
  float rowSize = (grid_max * h * 1.0)/y_max;
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      // Initialize each object
      if(((i%2)==0) && ((j%2)==0))
      grid[i][j] = new Cell(x+(i*colSize),y+h-((j+1)*rowSize),colSize,rowSize,'g');
      else
      grid[i][j] = new Cell(x+(i*colSize),y+h-((j+1)*rowSize),colSize,rowSize,'w');
    }
  }
  
 
  
  strokeWeight(3);
  stroke(0);
  
  for (int i=0; i <= cols; i+=2) {
    line(x+(i*colSize),y-5,x+(i*colSize),y+5);
    line(x+(i*colSize),y+h-5,x+(i*colSize),y+h+5);
  }
  line(x+w,y-5,x+w,y+5);
  for (int j=0; j <= rows; j+=2) {
    line(x-5,y+(j*rowSize),x+5,y+(j*rowSize));
    line(x+w-5,y+(j*rowSize),x+w+5,y+(j*rowSize));
  }
  line(x+w,y-5,x+w,y+5);
  line(x+w,y+h-5,x+w,y+5);
  
  PFont font;
  font = loadFont("AgencyFB-Reg-12.vlw");
  textFont(font);
  fill(#B92222); // red
  
  for (int i=0; i <= cols; i+=2) {
  
    text(grid_max*i,x+(i*colSize)-4,y-12);
    text(grid_max*i,x+(i*colSize)-4,y+h+15);
  
  }
  for (int j=0; j <= rows; j+=2) {
    text(grid_max*(rows - j),x-20,y+(j*rowSize)+3);
    text(grid_max*(rows - j),x+w+7,y+(j*rowSize)+3);
  }
  
  noStroke();
  fill(back);
  rect(x+10,y+h+15,350,30);
  
  font = loadFont("AgencyFB-Reg-18.vlw");
  textFont(font);
  fill(#B92222); // red
  
  text("X : ",x+20,y+h+30);
  text(x_val,x+50,y+h+30);
  text("Y : ",x+100,y+h+30);
  text(y_val,x+130,y+h+30);
  text("Grid: [  "+x_ind_val+" , "+y_ind_val+"]",x+190,y+h+30);
  
  
  stroke(0);
  strokeWeight(2);
  noFill();
  rect(x,y,w,h);
  strokeWeight(1);
 
}

// A Cell object
class Cell {
  // A cell object knows about its location in the grid as well as its size with the variables x,y,w,h.
  float x,y;   // x,y location
  float w,h;   // width and height
  char fillColor; // angle for oscillating brightness
  float[][] allPoints;
  int num=50; //maximum number of points
  boolean over;
  
  // Cell Constructor
  Cell(float tempX, float tempY, float tempW, float tempH, char tempFill) {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    fillColor = tempFill;
    allPoints = new float[2][num];
    
  } 
  
  void display() {
    over();
    stroke(255);
    strokeWeight(1);
  
    // Color calculated using sine wave
    switch(fillColor) {
      case 'g': fill(#CAC1CB);break; // grey
      case 'w': fill(255);break; // white
      case 'G': fill(#0CF751);break; // green
      case 'y': fill(#ECFF21);break; // yellow
      case 'b': fill(0);break; // black
      case 'B': fill(#6721FF); break; // blue
      case 'p' : fill(#21F9FF); break; // pale green
      case 'o' : fill(#A74A4A); break; // orange
      default: break;
    }
    
    stroke(4);
    rect(x,y,w,h); 
  }
  void over() {
    if( overRect(int(x), int(y), int(w), int(h)) ) {
        over = true;
        fillColor = 'p';
      } else {
        over = false;
        
      }
  }
  void points() {
    stroke(#F70C14);  //red
    strokeWeight(5);
    for (int i=0; i<num; i++) {
      point(allPoints[0][i], allPoints[1][i]);
    }
  }
  void addPoint(int ix, int iy) {
    for (int i=num-1; i>0; i--) {
        allPoints[0][i] = allPoints[0][i-1];
        allPoints[1][i] = allPoints[1][i-1];
    }
    
    allPoints[0][0] = absXPoint(ix);
    allPoints[1][0] = absYPoint(iy);
  }
  
  
}

int point_to_grid(int px, int py)
{
  return ind_to_grid(point_to_ind(px), point_to_ind(py));
}
int ind_to_grid(int x, int y)
{
  return (y-1)*x_ind_max + x;
}
int point_to_ind(int pt)
{
  
  return pt/grid_max + 1;
}

int ind_to_point(int ind)
{
  return ind*grid_max + int(0.5*grid_max);
}

void calculate()
{
  x_ind_max = point_to_ind(x_max);
  y_ind_max = point_to_ind(y_max);


  x_ind_val = point_to_ind(x_val);
  y_ind_val = point_to_ind(y_val);
  
  if(x_ind_val >= x_ind_max) x_ind_val = x_ind_max-1;
  if(y_ind_val >= y_ind_max) y_ind_val = y_ind_max-1;
}
void range()
{
  calculate();
  
  
  
  grid[x_ind_val-1][y_ind_val-1].fillColor ='G';
  grid[x_ind_val-1][y_ind_val-1].addPoint(x_val, y_val);
  grid[x_ind_val-1][y_ind_val-1].display();
  grid[x_ind_val-1][y_ind_val-1].points();
  
  
}


float absXPoint (int xpoint) {
  
  return gx + map(xpoint, 0 , x_max, 0, gw);
}
float absYPoint (int ypoint) {
  gy = height - gy;
  
  return gy+gh-map(ypoint, 0, y_max, 0, gh);
}

float pointXAbs (int abs) {
  return map(abs - gx, 0, gw, 0, x_max);
}
float pointYAbs (int abs) {
  return map(gh - (abs - (height - gy)), 0, gh, 0, y_max);
}


// BUTTON
 class Button
{
  int x, y;
  int w, h;
  color disableColor;
  color highlightColor = color(#D618C0);  //indigo
  color enableColor,currentColor;
  color textColor;
  color baseColor = color(#CAC1CB);  // grey
  
  boolean over = false;
  boolean pressed = false;
  boolean enable = false;
  boolean visible = false;
  boolean toggle = true;
  String text = "";   
  
  
  
  Button(int ix, int iy, int iw, int ih, 
               
               boolean togle, String itext) 
  {
    x = ix;
    y = invertY(iy);
    w = iw;
    h = ih;
    text = itext;
    toggle = togle;
  }
  
  
  
  
  boolean isclicked() {
    return pressed;
  }
  
  boolean isenable() {
    return enable;
  }
  boolean isvisible() {
    return visible;
  }
  void makeEnable(boolean state) {
    enable = state;
    
  }
  
  void makeVisible(boolean state) {
    visible = state;
  }
  
  void clearClick() {
    pressed = false;
  }
  void update() 
  {
    over();
    pressed();
    
  }
  
  void over() 
  {
    if(enable)
    {
      if( overRect(x, y, w, h) ) {
        over = true;
      } else {
        over = false;
      }
    }
    else over=false;
  }
  
  void pressed() {
    if(toggle)
    {
      
      if(over && mousePressed) {
        if(pressed) {
          pressed = false;
          
          }
          else 
          {
            pressed = true;
          
          }
        
        
        }
    }
    else
    {
      if(over && mousePressed) {
        pressed = true;
      }
      else
      pressed = false;
    }
  }
  
  void display() 
  {
    update();
    PFont font = loadFont("AgencyFB-Reg-24.vlw");
    stroke(0);
    strokeWeight(0);
    textColor = color(#ED1F2D);  //red
    currentColor = baseColor;
    if(enable)
    {
       if(over)
       {
         currentColor = highlightColor;
       }
        if(pressed) 
        {
          strokeWeight(3);
          
          
        }
    }
    else 
    {
      if(visible)
       {
            stroke(1);
            textColor = color(255);  //white
            
          }
      else
      {
        noStroke();
        
        textColor = baseColor;
      }
    
    
      }
    fill(currentColor);
    rect(x,y,w,h);
    fill(textColor);
    text(text,x+5,y+h-5);
  }
}

boolean overRect(int x, int y, int w, int h) {
    if (mouseX >= x && mouseX <= x+w && 
      mouseY >= y && mouseY <= y + h) {
    return true;
    } else {
    return false;
    }

}
void updateAll() {
  setStartB.update();
  setEndB.update();
  StartB.update();
  EndB.update();
  WallB.update();
  WallC.update();
  RobotB.update();
}
void visibleAll() {
  setStartB.makeVisible(true);
  setEndB.makeVisible(true);
  StartB.makeVisible(true);
  EndB.makeVisible(true);
  WallB.makeVisible(true);
  RobotB.makeVisible(true);
}
void displayAll() {
  setStartB.display();
  setEndB.display();
  StartB.display();
  EndB.display();
  WallB.display();
  WallC.display();
  RobotB.display();
}
void enableAll() {
  setStartB.makeEnable(true);
  setEndB.makeEnable(true);
  StartB.makeEnable(true);
  EndB.makeEnable(true);
  WallB.makeEnable(true);
  WallC.makeEnable(true);
  RobotB.makeEnable(true);
}

Cost planRoute()
{
  Cost temp = new Cost(starti,startj,1);;
  int x = starti;
  int y = startj;
  pathArray = new ArrayList<Cost>();
  visitedArray = new ArrayList<Cost>();
  if (goalTest(x, y)) return temp;
  agenda = new PQ();
  agenda.push(new Cost(x, y, 1));
  while (!(agenda.isempty()))
  {
    Cost n = agenda.pop();
    //println("Popped:");
    //n.display();
    if (goalTest(n.x, n.y)) 
    {
      //println("Found:");
      //n.display();
      pathArray.add(n);
      return n;
    }
     
    temp = populateQueue(n);
    //println("All on the pq");
    for(int i=0;i<agenda.lists.size();i++)
    {
      
      Cost c = agenda.lists.get(i);
    //c.display();
    }
    
  }
  return temp;
}
Cost populateQueue(Cost temp)
{
  int x=temp.x;
  int y=temp.y;
  int cost = temp.cost;
  //println("All visited so far");
  for(int i=0;i<visitedArray.size();i++)
  {
    Cost c = visitedArray.get(i);
    
    //c.display();
    if (compareCost(temp,c)) 
    {
       
      return new Cost(temp);
    }
  }
  //println("Added to visited array:");
  //temp.display();
  visitedArray.add(new Cost(temp.x,temp.y,temp.cost));
  
  if(x==1)
  {
    if(y==1)
    {
      Cost temp1= new Cost(temp);
      temp1.append1(1,2);
      agenda.push(temp1);
      temp1= new Cost(temp);
      temp1.append1(2,1);
      agenda.push(temp1);
    }
    else if(y==y_ind_max)
    {
      Cost temp1= new Cost(temp);
      temp1.append1(1,y-1);
      agenda.push(temp1);
    }
    else
    {
      Cost temp1= new Cost(temp);
      temp1.append1(1,y-1);
      agenda.push(temp1);
      temp1= new Cost(temp);
      temp1.append1(1,y+1);
      agenda.push(temp1);
      
    }
  }
  else if(x==x_ind_max)
  {
    if(y==1)
    {
      Cost temp1= new Cost(temp);
      temp1.append1(x,2);
      agenda.push(temp1);
      temp1= new Cost(temp);
      temp1.append1(x-1,1);
      agenda.push(temp1);
    }
    else if(y==y_ind_max)
    {
      Cost temp1= new Cost(temp);
      temp1.append1(x,y-1);
      agenda.push(temp1);
      temp1= new Cost(temp);
      temp1.append1(x-1,y);
      agenda.push(temp1);
      
    }
    else
    {Cost temp1= new Cost(temp);
      temp1.append1(x,y+1);
      agenda.push(temp1);
      temp1= new Cost(temp);
      temp1.append1(x,y-1);
      agenda.push(temp1);
      
      
    }
  }
  else
  {
    if(y==1)
    {
      Cost temp1= new Cost(temp);
      temp1.append1(x,2);
      agenda.push(temp1);
      temp1= new Cost(temp);
      temp1.append1(x-1,1);
      agenda.push(temp1);
      temp1= new Cost(temp);
      temp1.append1(x+1,1);
      agenda.push(temp1);
      
      
    }
    else if(y==y_ind_max)
    {
      Cost temp1= new Cost(temp);
      temp1.append1(x,y-1);
      agenda.push(temp1);
      temp1= new Cost(temp);
      temp1.append1(x-1,y);
      agenda.push(temp1);
      temp1= new Cost(temp);
      temp1.append1(x+1,y);
      agenda.push(temp1);
      
      
    }
    else
    {
      Cost temp1= new Cost(temp);
      temp1.append1(x+1,y);
      agenda.push(temp1);
      temp1= new Cost(temp);
      temp1.append1(x-1,y);
      agenda.push(temp1);
      temp1= new Cost(temp);
      temp1.append1(x,y+1);
      agenda.push(temp1);
      temp1= new Cost(temp);
      temp1.append1(x,y-1);
      agenda.push(temp1);
      
      
    }
  }
  return temp;
}
boolean goalTest(int x, int y)
{
  return (x==endi)&&(y==endj);
}

class Cost {
  int x;
  int y;
  int cost;
  int[] xlist;
  int[] ylist;

  Cost(int x1, int y1, int cost1) {
    x=x1;
    y=y1;
    cost=cost1;
    xlist = new int[0];
    ylist = new int[0];
    xlist = append(xlist,x1);
    ylist = append(ylist, y1);
  }
  
  Cost(Cost d)
  {
    x=d.x;
    y=d.y;
    cost=d.cost;
    xlist = new int[0];
    ylist = new int[0];
    
    for(int i=0;i<d.xlist.length;i++)
      {
        xlist = append(xlist,d.xlist[i]);
        ylist = append(ylist,d.ylist[i]);
      }
    
  }
  
  
  
  void append1(int x1, int y1)
  {
    x=x1;
    y=y1;
    xlist = append(xlist, x1);
    ylist = append(ylist, y1);
    cost++;
    //println("Added to queue");
    //display();
  }
  void display()
  {
   
      print(x);
      print("||");
      print(y);
      print("||");
      println(cost);
      
      for(int j=0;j<xlist.length;j++)
      {
        if(!(j==xlist.length-1))
        {
            
          print(xlist[j]);
          print("||");
        }
        else        
            println(xlist[j]);
      }
      for(int j=0;j<ylist.length;j++)
      {
      if(!(j==ylist.length-1))
        {
            
          print(ylist[j]);
          print("||");
        }
        else        
            println(ylist[j]);
      }
  }
}
class PQ {
  ArrayList<Cost> lists;
  int num;
  
  PQ() {
    lists = new ArrayList<Cost>();
    num=0;
  }
  void push(Cost c)
  {
    if(possible(c.x,c.y))  // possible grid
    {
      lists.add(c);
      num++;
    }
    else
    {
    }
  }
  Cost pop()
  {
    
    int cval = 800;
    Cost cc = new Cost(0,0,1);
    int index=0;
    for(int i=0;i<lists.size();i++)
    {
      Cost temp = lists.get(i);
      if(cval == max(cval, temp.cost))
      {
        cval = temp.cost;
        
        
        index = i;
        cc = new Cost(temp);
      }
     // println("pop here:");
      //  print("cost:");
      //  print(cval);
    }
      
    lists.remove(index);
    return cc;
  }
      
      
  
  boolean isempty()
  {
    return lists.size()==0;
  }
}

boolean compareCost(Cost xc, Cost yc)
{
  return ((xc.x==yc.x)&&(xc.y==yc.y));
}
boolean possible(int x, int y)
{
  for(int i=0;i<walls;i++)
  {
    if((x==wallArray[i][0])&&(y==wallArray[i][1]))
    return false;
  }
  for(int i=0;i<shadows;i++)
  {
    if((x==shadowArray[i][0])&&(y==shadowArray[i][1]))
    return false;
    
  }
  return true;
}
