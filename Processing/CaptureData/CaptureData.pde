// Version 2
// Removed rebuilding of map grid during refresh time
// Object points is just drawn on the map grid

import processing.serial.*;

Serial port;
String portName = "COM13";
  
String myPort = Serial.list()[0];

int lastInput = 0;


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

int prevx_val = 0;
int prevy_val = 0;

int x_ind_val=1;
int y_ind_val = 1;

int x_max = 200;
int y_max = 200;
int grid_max = 10;

int x_ind_max = 0;
int y_ind_max = 0;
color back = color(#0CF1F7);

boolean _RESTART_= true;
boolean _START_ = true;
boolean _CALIBRATE_= false;
boolean _RANGE_= true;
boolean _MENU_= false;
boolean _CONTROL_= false;
boolean _AUTO_= false;
boolean _POINT_= false;
boolean _MODE_ = true;

int S = 0x1;  //RESTART
int C = 0x2;  //CALIBRATE
int R = 0x3;  //RANGE
int M = 0x4;  //MENU
int B = 0x5;  //CONTROL
int A = 0x6;  //AUTO
int P = 0x7;  //POINT

int V = 0x8;  //VALUE
int H = 0x9;  //CHAR
int N = 0xA;  //NEXT
int D = 0xB;  //DONE

boolean ready = false;
void setup() {
  size(700,700);
  background(back);  // deep grey
  createMap(gx,gy,gw,gh,x_max,y_max,grid_max);
  PFont font = loadFont("AgencyFB-Bold-48.vlw");
  textFont(font);
  fill(#37D86E); // RED
  text("FASAE TAIWO [151407] TEL 599 FEB '15",gx+20,invertY(gy)-30);
  
  GridDisplay(gx,gy,gw,gh,x_max,y_max,grid_max);
  frameRate(2);
  port = new Serial(this, myPort, 9600);
  println(myPort);
}

void draw() {

//      background(back);
//      createMap(gx,gy,gw,gh,x_max,y_max,grid_max);
//      GridDisplay(gx,gy,gw,gh,x_max,y_max,grid_max);
  
//    if(mousePressed && overRect(gx,gy,gw,gh))
//    {
//      stroke(#F70C14);  //red
//      strokeWeight(5);
//       point(pointXAbs(mouseX);

  while(port.available() > 0)
  {
      lastInput = readByte();
      println(lastInput);
   
     if(lastInput == C)
    {
      println("cal");
      x_max = readNum();
      y_max = readNum();
      grid_max = readNum();

      background(back);
      createMap(gx,gy,gw,gh,x_max,y_max,grid_max);
      PFont font = loadFont("AgencyFB-Bold-48.vlw");
      textFont(font);
      fill(#37D86E); // RED
      text("FASAE TAIWO [151407] TEL 599 FEB '15",gx+20,invertY(gy)-30);
      GridDisplay(gx,gy,gw,gh,x_max,y_max,grid_max);

      println(C);
    }
    if(lastInput == V)
    {
      
      stroke(#F70C14);  //red
      strokeWeight(10);
      point(absXPoint(prevx_val),absYPoint(prevy_val));
      
      println("val");
      x_val = readNum();
      y_val = readNum();
      println(V);
      println(x_val);
      println(y_val);
      
      calculate();
      noStroke();
      fill(back);
      rect(gx+10,invertY(gy)+gh+15,350,30);
      PFont font = loadFont("AgencyFB-Reg-18.vlw");
      textFont(font);
      fill(#B92222); // red
      text("X : ",gx+20,invertY(gy)+gh+30);
      text(x_val,gx+50,invertY(gy)+gh+30);
      text("Y : ",gx+100,invertY(gy)+gh+30);
      text(y_val,gx+130,invertY(gy)+gh+30);
      text("Grid: [  "+x_ind_val+" , "+y_ind_val+"]",gx+190,invertY(gy)+gh+30);
      stroke(#0F18F5);  //blue
      strokeWeight(10);
      point(absXPoint(x_val),absYPoint(y_val));
      
      prevx_val = x_val;
      prevy_val = y_val;
    }
//    sendByte(V);
    println("here");
//    range();

    
  }  
    
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
      if(((i%2)==0) && ((j%2)==1))
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
    stroke(255);
    strokeWeight(1);
  
    // Color calculated using sine wave
    switch(fillColor) {
      case 'g': fill(#CAC1CB);break; // grey
      case 'w': fill(255);break; // white
      case 'G': fill(#0CF751);break; // green
      default: break;
    }
    stroke(4);
    rect(x,y,w,h); 
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
}
void range()
{
  calculate();
  
  if(x_ind_val >= x_ind_max) x_ind_val = x_ind_max-1;
  if(y_ind_val >= y_ind_max) y_ind_val = y_ind_max-1;
  
  grid[x_ind_val-1][y_ind_val-1].fillColor ='G';
  grid[x_ind_val-1][y_ind_val-1].addPoint(x_val, y_val);
  grid[x_ind_val-1][y_ind_val-1].display();
  grid[x_ind_val-1][y_ind_val-1].points();
  
  
}

int readByte() {
  while(!(port.available()>0)) continue;
  int get = port.read();
  return get;
}


void sendByte(int x)
{
   if(port != null)  port.write(x);
}

int readNum()
{
  int num1 = readByte();
  println(num1);
  int num2 = readByte();
  println(num2);
  return num1 + (num2 << 8);
}
void sendNum(int num)
{
  sendByte(num & 255);
  sendByte((num >> 8) & 255);
}
  
void serialEvent(Serial p)
{
  ready = true;
}

float absXPoint (int xpoint) {
  
  return gx + map(xpoint, 0 , x_max, 0, gw);
}
float absYPoint (int ypoint) {
  
  
  return (height - gy)+gh-map(ypoint, 0, y_max, 0, gh);
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

boolean overRect(int x, int y, int width, int height) {
    if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
    } else {
    return false;
    }

}

