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

int a_range = 200;
int b_range = 200;
int c_range = 250;
int d_range = 250;

int a_actual = 0;
int b_actual = 0;
int c_actual = 0;
int d_actual = 0;

int x_actual = 0;
int y_actual = 0;

double a,b;
int XYsum,Xsum,Ysum,Xsumsq,n;

String filename = ""; 

int calcount = 0;
int rancount = -2;

int x_meth_1,x_meth_2,x_meth_3;
int y_meth_1,y_meth_2,y_meth_3;

int x_val = 0;
int y_val = 0;

int x_ind_val=1;
int y_ind_val = 1;

int x_max = 200;
int y_max = 200;
int grid_max = 10;

int x_ind_max = 0;
int y_ind_max = 0;

// beacon positions
int x1=0;
int y1=y_max;
int x2=0;
int y2=0;
int x3 = x_max;
int y3 = 0;
int x4 = x_max;
int y4 = y_max;

// method 2 variables
int X21,X31,X41,Y21,Y31,Y41;
float B1,B2,B3,W,Z,M,N,J,K,P,Q,R,S,DET;

color back = color(158, 178, 122);

int[][] data;
int[][] completed;

PrintWriter output,output1;

boolean _RESTART_= true;
boolean _START_ = true;
boolean _CALIBRATE_= false;
boolean _RANGE_= true;
boolean _MENU_= false;
boolean _CONTROL_= false;
boolean _AUTO_= false;
boolean _POINT_= false;
boolean _MODE_ = true;

boolean A_RANGE = false;
boolean B_RANGE = false;
boolean C_RANGE = false;
boolean D_RANGE = false;

//int S = 0x1;  //RESTART
int C = 0x2;  //CALIBRATE
//int R = 0x3;  //RANGE
//int M = 0x4;  //MENU
int B = 0x5;  //CONTROL
int A = 0x6;  //AUTO
//int P = 0x7;  //POINT

int V = 0x8;  //VALUE
int H = 0x9;  //CHAR
//int N = 0xA;  //NEXT
int D = 0xB;  //DONE

boolean ready = false;

Button ResetB, ActualB, exitB, text1, text2;
int mode = 0;  //button modes 1: calibrate 2:exit
int show = 0;
void setup() {
  size(800,700);
  background(back);  // deep grey
  createMap(gx,gy,gw,gh,x_max,y_max,grid_max);
  
  smooth();
  color gray = color(204);
  color white = color(255);
  color black = color(0);
  ActualB = new Button(650,400,55,20,false,"Actual");
  ResetB = new Button(650,350,55,20,false,"Reset");
  exitB = new Button(650,300,30,20,false,"Exit");
  
  text1 = new Button(130,690,250,20,false,"Welcome");
  text2 = new Button(430, 690, 75, 20, false, "\\(*_*)/");
  
  visibleText();
  
  text1.text = "Initializing...";
  text1.display();
  text2.display();
  frameRate(10);
    
  x_ind_max = point_to_ind(x_max);
  y_ind_max = point_to_ind(y_max);
  
  data = new int[20][6];
  completed = new int[20][20];
  // reset all to zero
  for(int i=0;i<20;i++)
  {
    for(int j=0;j<20;j++)
    {
      completed[i][j]=0;
      
    }
  }
  // display loading data
  text1.text = "Loading Data...";
  text1.display();
   // read all performed indices
   String[] lines = loadStrings("Performed.dat");
   
   for(int i=0;i < lines.length; i++) {
     String[] pieces = split(lines[i], ',');
     if(pieces.length == 20) {
       for(int j=0;j< 20; j++) {
         completed[i][j]=int(pieces[j]);
         if(completed[i][j] == 1)
         {
           grid[i][j].fillColor = 'p';  // Mark as completed
         }
       }
     }
   }
   
  // display data loaded
  text1.text = "Data Loaded";
  text1.display();
  
  GridDisplay(gx,gy,gw,gh,x_max,y_max,grid_max);
  enableButtons();
  displayButtons();
}

void draw() 
{
  updateButtons();
  if(mode==4) // Reset environment
  {
    println("Mode 4");
    background(back);
    enableButtons();
    displayButtons();
    GridDisplay(gx,gy,gw,gh,x_max,y_max,grid_max);
    mode = 0;
    
  }
  if( mode == 1) // Actual button pressed
  {
    if(show == 1)
    {
    // display arcs of actual ranges
    //in black
    //calculate actual ranges
    x_actual = ind_to_point(x_ind_val);
    y_actual = ind_to_point(y_ind_val);
    a_actual = round(getA(x_actual, y_actual));
    b_actual = round(getB(x_actual, y_actual));
    c_actual = round(getC(x_actual, y_actual));
    d_actual = round(getD(x_actual, y_actual));
    
    strokeWeight(2);
    stroke(0);  //black
    noFill();
    arc(float(gx),float(invertY(gy)),2*(absXPoint(a_actual) - gx),2*((height - gy)+gh-absYPoint(a_actual)),0,HALF_PI);
    
    // B
    
    arc(float(gx),float(invertY(gy-gh)),2*(absXPoint(b_actual) - gx),2*((height - gy)+gh-absYPoint(b_actual)),TWO_PI - HALF_PI, TWO_PI);
    
    // C
    
    arc(float(gx+gw),float(invertY(gy-gh)),2*(absXPoint(c_actual) - gx),2*((height - gy)+gh-absYPoint(c_actual)),PI,TWO_PI - HALF_PI);
    
    // D
    
    arc(float(gx+gw),float(invertY(gy)),2*(absXPoint(d_actual) - gx),2*((height - gy)+gh-absYPoint(d_actual)),HALF_PI, PI);
    mode = 0;
    }
    else
      mode = 3;
  }  
    
  if(mode == 3)  // Point on Grid clicked
  {
    GridDisplay(gx,gy,gw,gh,x_max,y_max,grid_max);            
    // display cell indices
    text1.text = "Getting Data for ["+x_ind_val + ", " + y_ind_val + "]";
    //println(text1.text);
    text1.display();
    
    // load data from specific grid file
    filename = nf(x_ind_val,2) + nf(y_ind_val,2) + ".dat";
    String[] lines = loadStrings(filename);
    // Create new storage
    output = createWriter("NW"+filename);
    for (int m=0;m < lines.length;m++)
    {
      String values = "";
      
      // create header
      //
      
      //calculate actual ranges
      x_actual = ind_to_point(x_ind_val);
      y_actual = ind_to_point(y_ind_val);
      a_actual = round(getA(x_actual, y_actual));
      b_actual = round(getB(x_actual, y_actual));
      c_actual = round(getC(x_actual, y_actual));
      d_actual = round(getD(x_actual, y_actual));
    
      values += "" + a_actual + "," + b_actual + "," + c_actual + "," + d_actual;
      String[] pieces = split(lines[m], ',');
      // If line exist
      if (pieces.length == 6)
      {  
        
        // retrieve values
        a_range = int(pieces[0]);
        b_range = int(pieces[1]);
        c_range = int(pieces[2]);
        d_range = int(pieces[3]);
        x_val = int(pieces[4]);
        y_val = int(pieces[5]);
        
//        println("New");
//        println(a_range);
//        println(b_range);
//        println(c_range);
//        println(d_range);
        
        
        // Draw arcs
        strokeWeight(2);
        stroke(#FF1769);  //pink
        noFill();
        arc(float(gx),float(invertY(gy)),2*(absXPoint(a_range) - gx),2*((height - gy)+gh-absYPoint(a_range)),0,HALF_PI);
        
        // B
        strokeWeight(2);
        stroke(#B0ABF5);  //pale blue
        noFill();
        arc(float(gx),float(invertY(gy-gh)),2*(absXPoint(b_range) - gx),2*((height - gy)+gh-absYPoint(b_range)),TWO_PI - HALF_PI, TWO_PI);
        
        // C
        strokeWeight(2);
        stroke(#ABF5BC);  //pale green
        noFill();
        arc(float(gx+gw),float(invertY(gy-gh)),2*(absXPoint(c_range) - gx),2*((height - gy)+gh-absYPoint(c_range)),PI,TWO_PI - HALF_PI);
        
        // D
        strokeWeight(2);
        stroke(#F5C3AB);  //pale brown
        noFill();
        arc(float(gx+gw),float(invertY(gy)),2*(absXPoint(d_range) - gx),2*((height - gy)+gh-absYPoint(d_range)),HALF_PI, PI);
    
        calculate();
        
        for(int n=0;n<4;n++) 
        {
          // for every piece in the line
          values += "," + pieces[n];
        }
        
        values += "," + x_actual + "," + y_actual;
        
        // Draw points
        strokeWeight(5);
        stroke(#F70C14);  //red
        point(absXPoint(x_meth_1),absYPoint(y_meth_1));
        
        stroke(#631EFA);  //blue
        point(absXPoint(x_meth_2),absYPoint(y_meth_2));
        
    //      stroke(#0CED2F);  //green
    //      point(absXPoint(x_meth_3),absYPoint(y_meth_3));
    
//        stroke(#F4FC0A);  //yellow
//        point(absXPoint(x_val),absYPoint(y_val));
        
        stroke(color(0));  //black for centre of grid
        point(absXPoint(ind_to_point(x_ind_val)), absYPoint(ind_to_point(y_ind_val)));
        
        values += "," + x_meth_1 + "," + y_meth_1 + "," + x_meth_2 + "," + y_meth_2 + "," + x_val + "," + y_val;
        output.println(values);
        // make grid cell darkened to show success
        grid[x_ind_val-1][y_ind_val-1].fillColor = 'p';
        completed[x_ind_val-1][y_ind_val-1] = 1;
      }
  }
   output.flush();
   output.close();
  text2.text = "Done!";
  text2.display();
  
 
  mode = 0;
}
 
    
  if(mode == 2)
  {
    // display exiting 
     text1.text = "Exiting...";
     println("Exiting...");
     
    wrapup();
    exit();
  }

}
void wrapup() {
      
      // store completed logical variable
      output1 = createWriter("data/Performed.dat");
      
        
      String values = "";
      for(int i=0;i<20;i++)
      {
        values = "";
        values += completed[i][0];
        for(int j=1;j<20;j++)
        {
          values += "," + completed[i][j];
        }
        output1.println(values);
      } 
      output1.flush();
      output1.close();
      
      values = "";
      
      
      // store all data
      output = createWriter("AllData.csv");
      output1 = createWriter("FinalData.csv");
      // create header
      output.println("R,C,A,B,C,D,x,y,Readings");
      output1.println("R,C,A_exact,B_exact,C_exact,D_exact,A_meas,B_meas,C_meas,D_meas,Exact_x,Exact_y,M1_x,M1_y,M2_x,M2_y,H_x,H_y");
      
      
      
      values = "";
        
      for(int i=0;i<20;i++)
      {
        
        
        for(int j=0;j<20;j++)
        {
          
          if(completed[i][j] == 1)
          {
            values = "";
            // load data from specific index file
            filename = nf(i+1,2) + nf(j+1,2) + ".dat";
            String[] lines = loadStrings(filename);
            String[] lines1 = loadStrings("NW"+filename);
                        
            for (int m=0;m < lines.length; m++) 
            {
              // for each line in the file
              values = "" + (i+1) + "," + (j+1);
              String[] pieces = split(lines[m], ',');
              // If line exist
              if (pieces.length == 6) 
              {
                for(int n=0;n<6;n++) 
                {
                  // for every piece in the line
                  values += "," + pieces[n];
                }
                // append reading number
                values += "," + (m+1);
              }
              else
              {
                for(int n=0;n<pieces.length;n++) 
                {
                  // for every piece in the line
                  values += "," + pieces[n];
                }
                // append reading number
                values += "," + (m+1);
              }
              // printout for every line
              output.println(values);
            }
            
            for (int m=0;m < lines1.length; m++) 
            {
              // for each line in the file
              values = "" + (i+1) + "," + (j+1);
              String[] pieces = split(lines1[m], ',');
              // If line exist
            
              if (pieces.length == 16) 
              {
                for(int n=0;n<pieces.length;n++) 
                {
                  // for every piece in the line
                  values += "," + pieces[n];
                }
              }
              output1.println(values);
            }
            
          }
          else 
          {
              for (int m=0;m < 20; m++) 
              {
                values = "" + (i+1) + "," + (j+1);
                  for(int n=0;n<6;n++) 
                  {
                    values += "," + 0;
                  }
                  values += "," + (m+1);
                  // printout for every line
                  output.println(values);
              }
            
           }
         
         
         
            
        }                 
            
        }
       
      output.flush();
      output.close();
      output1.flush();
      output1.close();
         
}

void enableButtons() {
  ActualB.makeEnable(true);
  ResetB.makeEnable(true);
  exitB.makeEnable(true);
}
void visibleButtons() {
  ActualB.makeVisible(true);
  ResetB.makeVisible(true);
  exitB.makeVisible(true);
}
void displayButtons() {
  ActualB.display();
  ResetB.display();
  exitB.display();
}
void visibleText() {
  text1.makeVisible(true);
  text2.makeVisible(true);
}
void updateText() {
  text1.update();
  text2.update();
}
void updateButtons() {
  ActualB.update();
  ResetB.update();
  exitB.update();
}

void mousePressed() {
  mode = 0;
  if (ActualB.press() == true) 
  { 
    mode = 1;
    show = (1 - show);
    calcount = 0;
    println("Now Mode 1"); 
  }
  if (ResetB.press() == true)
  {
    mode = 4;
    println("Now Mode 4");
  }
  if (exitB.press() == true) 
  { 
    mode = 2; 
    println("Now Mode 2");
  }
  if (overRect(gx,invertY(gy),gw,gh)) 
  { 
    x_ind_val = point_to_ind(round(pointXAbs(mouseX)));
    y_ind_val = point_to_ind(round(pointYAbs(mouseY)));
    mode = 3;
    rancount = 0;  
    println("Now Mode 3");
  }
  println("Mouse pressed");
  
}

void mouseReleased() {
  ActualB.release();
  ResetB.release();
  exitB.release();
}
    
float getA(int x, int y)
{
  return sqrt(sq(y_max - y)+sq(x));
}
float getB(int x, int y)
{
  return sqrt(sq(y)+sq(x));
}

float getC(int x, int y)
{
  return sqrt(sq(x_max - x)+sq(y));
}

float getD(int x, int y)
{
  return sqrt(sq(y_max - y)+sq(x_max - x));
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
  return ind*grid_max - int(0.5*grid_max);
}

float set1(float x, float y, float S)
{
  return ((sq(x) - sq(y) + sq(S))/(2.0*S));
}

void calculate()
{

  // Method 1
    if((a_range > 5) && (a_range < 800)) A_RANGE = true;
  if((b_range > 5) && (b_range < 800)) B_RANGE = true;
  if((c_range > 5) && (c_range < 800)) C_RANGE = true;
  if((d_range > 5) && (d_range < 800)) D_RANGE = true;
  
  if(((A_RANGE && D_RANGE) || (B_RANGE && C_RANGE)) || ((A_RANGE && B_RANGE) || (C_RANGE && D_RANGE)))
  {
    if((A_RANGE && D_RANGE) || (B_RANGE && C_RANGE))
    {
      if(((A_RANGE && D_RANGE) && (B_RANGE && C_RANGE)))
      {
        float x1 = set1(a_range, d_range, x_max);
        float x2 = set1(b_range, c_range, x_max);
        float D1 = 1;
        if(a_range <= x1)
        {
          
        }
        else
        {
          D1 = sqrt((a_range + x1)*(a_range - x1));
        }
        float D2 = 1;
        if(b_range <= x2)
        {
       
        }
        else
        {
          D2 = sqrt((b_range + x2)*(b_range - x2));
        }
        
        
//        
        x_meth_1 = round(((x1*D1) + (x2*D2))/(D1+D2));
//        Serial.print(x1);
//        Serial.print("||");
//        Serial.print(x2);
//        Serial.print("||");
//        Serial.print(D1);
//        Serial.print("||");
//        Serial.print(D2);
//        Serial.print("||");
//        Serial.print(A1);
//        Serial.print("||");
//        Serial.println(A2);
        
      }
      else if((A_RANGE && D_RANGE))
      {
        x_meth_1 = round(set1(a_range, d_range, x_max));
        y_meth_1 = round(y_max - sqrt((a_range *1.0 * a_range) - (x_meth_1 * 1.0 *x_meth_1)));
      }
      else if ((B_RANGE && C_RANGE))
      {
        x_meth_1 = round(set1(b_range, c_range, x_max));
        y_meth_1 = round(sqrt((b_range *1.0 * b_range) - (x_meth_1 * 1.0 *x_meth_1)));
      }
      
    }
    if ((A_RANGE && B_RANGE) || (C_RANGE && D_RANGE))
    {
      if ((A_RANGE && B_RANGE) && (C_RANGE && D_RANGE))
      {
        float y1 = set1(b_range, a_range, y_max);
        float y2 = set1(c_range, d_range, y_max);
        float D1 = 1;
        if(c_range <= y1)
        {
          
        }
        else
        {
          D1 = sqrt((c_range + y1)*(c_range - y1));
        }
        
        float D2 = 1;
        if(b_range <= y2)
        {
          
        }
        else
        {
          D2 = sqrt((b_range + y2)*(b_range - y2));
        }
        
        
//        
        y_meth_1 = round(((y1*D1) + (y2*D2))/(D1+D2));      
      }
      else if((A_RANGE && B_RANGE))
      {
        y_meth_1 = round(set1(b_range, a_range, y_max));
        if(!((A_RANGE && D_RANGE) || (B_RANGE && C_RANGE)))
        {
          x_meth_1 = round(sqrt((b_range *1.0 * b_range) - (x_meth_1 * 1.0 *y_meth_1)));
        }

        
      }
      else if ((C_RANGE && D_RANGE))
      {
        y_meth_1 = round(set1(c_range, d_range, y_max));
        if(!((A_RANGE && D_RANGE) || (B_RANGE && C_RANGE)))
        {
          x_meth_1 = round(x_max - sqrt((c_range *1.0 * c_range) - (y_meth_1 * 1.0 *y_meth_1)));
        }
      }
    }
  }
  A_RANGE = B_RANGE = C_RANGE = D_RANGE = false;
  
  // Method 2
  X21 = x2-x1;
  X31 = x3-x1;
  X41 = x4-x1;
  Y21 = y2 - y1;
  Y31 = y3 - y1;
  Y41 = y4 - y1;
  //println("X21:"+X21+"X31:"+X31+"X41:"+X41+"Y21:"+Y21+"Y31:"+Y31+"Y41:"+Y41);
  B1 = (0.5 *(sq(a_range) - sq(b_range) + sq(x_max)));
  B2 = (0.5 *(sq(a_range) - sq(c_range) + sq(x_max) + sq(y_max)));
  B3 = (0.5 *(sq(a_range) - sq(d_range) + sq(y_max)));
  //println("B1:"+B1+" B2:"+B2+" B3:"+B3);
  M = (sq(X21) + sq(X31) + sq(X41));
  N = X21*Y21 + X31*Y31 + X41*Y41;
  J = N;
  K = (sq(Y21) + sq(Y31) + sq(Y41));
  DET = M*K - J*N;
  P = K/DET;
  Q = -N/DET;
  R = -J/DET;
  S = M/DET;
  W = X21*B1 + X31*B2 + X41*B3;
  Z = Y21*B1 + Y31*B2 + Y41*B3;
  x_meth_2 = round(P*W + Q*Z + x1);
  y_meth_2 = round(R*W + S*Z + y1);
  
  
  // Method 3
  
  
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

int invertY(int y) { return height - y;}
 // Create Map
 
void GridDisplay(int x, int y, int w, int h, int x_max, int y_max, int grid_max) {
   for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      // Oscillate and display each object
      
      grid[i][j].display();
     // grid[i][j].points();  not needed
    }
  }
  
  y = invertY(y);
  
  

  
  cols = x_max/grid_max;
  rows = y_max/grid_max;
  
  float colSize = (grid_max * w * 1.0)/x_max; // map(grid_max, 0, x_max, 0, w);
  float rowSize = (grid_max * h * 1.0)/y_max;
  
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
      case 'p': fill(#83F1FA);break; // pale green
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
   if( overRect(x, y, w, h) ) {
        over = true;
      } else {
        over = false;
      } 
  }
  void release() {
    if(toggle && enable)
    {
    } 
     else
    {
     pressed = false; // Set to false when the mouse is released
    }
  }
  
  
  // makes the button pressed if its over
  // this function must be placed in the mousePressed() function
  boolean press() {
    if(!(enable))
    {
      pressed = false;
      return false;
    }
    if(toggle)
    {
      
      if(over) {
          pressed = !(pressed);
          return pressed;
          }
          else 
          {
            return pressed;
          }
     }
    
    else
    {
      if(over) {
        pressed = true;
        return true;
      }
      else
      pressed = false;
      return false;
    }
  }
  
  void display() 
  {
    
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
            textColor = color(0);  //cyan
            
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

