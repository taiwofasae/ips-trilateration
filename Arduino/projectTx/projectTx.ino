#include <LiquidCrystal.h>
#include <VirtualWire.h>
#include <PinChangeInt.h>
#include <Keypad.h>

// KEYPAD 
const byte ROWS = 4; //four rows
const byte COLS = 4; //three columns
char keys[ROWS][COLS] = {
  {'1','2','3','A'},
  {'4','5','6','B'},
  {'7','8','9','C'},
  {'*','0','#','D'}
};
byte rowPins[ROWS] = {35, 33, 31, 29}; //connect to the row pinouts of the keypad
byte colPins[COLS] = {47, 45, 43, 41}; //connect to the column pinouts of the keypad

Keypad keypad = Keypad( makeKeymap(keys), rowPins, colPins, ROWS, COLS );

// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(6, 7, 8, 9, 10, 11);

const int trigPin = 13;
const int trigPin1 = 2;
const int trigPin2 = 3;
const int trigPin3 = 4;
const int trigPin4 = 5;

const int echoPin1 = A8;
const int echoPin2 = A9;
const int echoPin3 = A10;
const int echoPin4 = A11;
const int tempPin = A0;

unsigned long time=0;
unsigned long time1=0;
unsigned long time2=0;
unsigned long a1=0;
unsigned long a2=0;
unsigned long b1=0;
unsigned long b2=0;
unsigned long c1=0;
unsigned long c2=0;
unsigned long d1=0;
unsigned long d2=0;
unsigned long durationa=0;
unsigned long durationb=0;
unsigned long durationc=0;
unsigned long durationd=0;

int a_range = 0;
int b_range = 0;
int c_range = 0;
int d_range = 0;

unsigned int temp=32;  // current temperature
int vel=340; // current velocity
int vel_inv_micro=29;  // current rate in us/cm
int vel_inv_inches=74;  // current rate in us/inches

int _RESTART_= true;
int _START_ = true;
int _CALIBRATE_= true;
int _RANGE_= true;
int _MENU_= false;
int _CONTROL_= false;
int _AUTO_= false;
int _POINT_= false;
int _MODE_ = true;

int A_RANGE = false;
int B_RANGE = false;
int C_RANGE = false;
int D_RANGE = false;

int TOGGLE = true;

int x_val = 0;  // present x location
int y_val = 0;  // present y location
int grid_val = 0;  // present grid
int x_ind_val = 1;  // present x index
int y_ind_val = 1;  // present y index

int max_grid_val = 0;  // maximum
long max_grid_no = 0;  // maximum number of grids for a particular environment

int x_max = 200;  // x width for the environment 
int y_max = 200;  // y width for the environment
int grid_max = 10;  // grid size for the environment
int x_ind_max = 20;  // max index for x coordinate
int y_ind_max = 20;  // max index for y coordinate

int x_point = 0;  // target x point
int y_point = 0;  // target y point
long grid_no = 0;  // target grid number
int x_ind = 0;    // target x index
int y_ind = 0;  // target y index

char S = 0x1;  //RESTART
char C = 0x2;  //CALIBRATE
char R = 0x3;  //RANGE
char M = 0x4;  //MENU
char B = 0x5;  //CONTROL
char A = 0x6;  //AUTO
char P = 0x7;  //POINT

char V = 0x8;  //VALUE
char H = 0x9;  //CHAR
char N = 0xA;  //NEXT
char D = 0xB;  //DONE



long calval=0;
int calcount=0;

int lastInput;

char tempVal[4] = "   ";

char startmessage[47] = " Current [L:500,B:500 Grid:10]cm  Calibrate?  "; 
char xmessage[35] = "Enter X-length btw 0 and 550cm    ";
char ymessage[35] = "Enter Y-length btw 0 and 550cm    ";
char gridmessage[35] = "Enter Grid size btw 10 and 50cm   ";
char menumessage[5][17]= {"Calibrate? :  A ", "Control Bot? :B ", "Restart? :    C ","PC mode?  :   D ", "Position? :   # "};
char movemessage[34] = "Use 2,4,6 & 8 to move the robot";
char pmessage[23] = {"Enter value btw 1 and "};
char gmessage[23] = {"Enter value btw 1 and "};
char movingmessage[33] = {"Moving to X:    Y:    # to stop."};


// ULTRASONIC RANGING FUNCTIONS
void echo1func() {
    if(digitalRead(echoPin1)==HIGH) a1=micros();
  if(digitalRead(echoPin1)==LOW) a2=micros()-a1;
 
}
void echo2func() {
    if(digitalRead(echoPin2)==HIGH) b1=micros();
  if(digitalRead(echoPin2)==LOW) b2=micros()-b1;
 
}
void echo3func() {
    if(digitalRead(echoPin3)==HIGH) c1=micros();
  if(digitalRead(echoPin3)==LOW) c2=micros()-c1;
 
}
void echo4func() {
    if(digitalRead(echoPin4)==HIGH) d1=micros();
  if(digitalRead(echoPin4)==LOW) d2=micros()-d1;
 
}

long microsecondsToInches(long microseconds)
{
  return microseconds / vel_inv_inches;
}

long microsecondsToCentimeters(long microseconds)
{
 return microseconds / vel_inv_micro;
}

void performRange()
{
  pinMode(trigPin1, OUTPUT);
  pinMode(trigPin2, OUTPUT);
  pinMode(trigPin3, OUTPUT);
  pinMode(trigPin4, OUTPUT);
  
  digitalWrite(trigPin1, LOW);
  digitalWrite(trigPin2, LOW);
  digitalWrite(trigPin3, LOW);
  digitalWrite(trigPin4, LOW);
  
  delayMicroseconds(2);
  digitalWrite(trigPin1, HIGH);
  digitalWrite(trigPin2, HIGH);
  digitalWrite(trigPin3, HIGH);
  digitalWrite(trigPin4, HIGH);
  
  delayMicroseconds(10);
  digitalWrite(trigPin1, LOW);
  digitalWrite(trigPin2, LOW);
  digitalWrite(trigPin3, LOW);
  digitalWrite(trigPin4, LOW);
  
  delayMicroseconds(2);
  
  pinMode(trigPin1, INPUT);
  pinMode(trigPin2, INPUT);
  pinMode(trigPin3, INPUT);
  pinMode(trigPin4, INPUT);
  
  vw_send((uint8_t *)("hello"), 6);
  
  vw_wait_tx();
   
  a1=micros(); 
  b1=micros();
  c1=micros();
  d1=micros();
  
  a2=0;
  b2=0;
  c2=0;
  d2=0;
  
  delay(100);
  durationa = a2;
  durationb = b2;
  durationc = c2;
  durationd = d2;
  
  a_range = microsecondsToCentimeters(durationa);
  b_range = microsecondsToCentimeters(durationb);  
  c_range = microsecondsToCentimeters(durationc);
  d_range = microsecondsToCentimeters(durationd);
  
  a_range = (a_range * 1.0024) - 57.6;
  b_range = (b_range * 1.0024) - 57.6;
  c_range = (c_range * 1.0024) - 57.6;
  d_range = (d_range * 1.0024) - 57.6;
//  Serial.print("a_range:");
//  Serial.print(a_range);
//  Serial.print("b_range:");
//  Serial.print(b_range);
//  Serial.print("c_range:");
//  Serial.print(c_range);
//  Serial.print("d_range:");
//  Serial.println(d_range);
  
}

void readTemp()  // read temperature and compute conversion rate
{
  //temp = (analogRead(tempPin) * 500.0) / 1024.0;
  
  vel = 331.4 + 0.6*temp;
  vel_inv_micro = 10000/vel;
  vel_inv_inches = 25400/vel;
}
// END


// SETUP
void setup() {
  lcd.begin(16, 2);
  Serial.begin(9600);
  lcd.print("  Developed by: ");
  lcd.setCursor(0,1);
  lcd.print("Fasae T D 151407");
  delay(1000);
  lcd.setCursor(0,0);
  lcd.print(" Supervised by: ");
  lcd.setCursor(0,1);
  lcd.print(" Dr. I. A. Kamil");
  delay(1000);
  
  //pinMode(trigPin, OUTPUT);
  pinMode(trigPin1, OUTPUT);
  pinMode(trigPin2, OUTPUT);
  pinMode(trigPin3, OUTPUT);
  pinMode(trigPin4, OUTPUT);

  pinMode(echoPin1, INPUT);
  pinMode(echoPin2, INPUT);
  pinMode(echoPin3, INPUT);
  pinMode(echoPin4, INPUT);  

  vw_set_ptt_inverted(true); // Required for DR3100
  vw_setup(2000);	 // Bits per sec
    
  PCintPort::attachInterrupt(echoPin1, &echo1func, CHANGE);
  PCintPort::attachInterrupt(echoPin2, &echo2func, CHANGE);
  PCintPort::attachInterrupt(echoPin3, &echo3func, CHANGE);
  PCintPort::attachInterrupt(echoPin4, &echo4func, CHANGE);
  
 
}

// END

// LOOP
void loop()
{
//  mode();
  
//  if(_RESTART_) restart();
  
  if (_CALIBRATE_) calibrate();
  
  if (_RANGE_) range();
  
//  if (_MENU_) menu();
  
//  if (_CONTROL_) control();
  
//  if (_AUTO_) auto1();
  
   
}
    
// HELPER FUNCTIONS
char * val_to_char(int value, int len)
{
  char ch;
  int value1;
  tempVal[len] = '\0';
  for(int i=0;i<len;i++)
  {
    value1 = value - (value/10)*10;
    switch(value1){
      case 0: ch = '0';break;
      case 1: ch = '1';break;
      case 2: ch = '2';break;
      case 3: ch = '3';break;
      case 4: ch = '4';break;
      case 5: ch = '5';break;
      case 6: ch = '6';break;
      case 7: ch = '7';break;
      case 8: ch = '8';break;
      case 9: ch = '9';break;
      default : break;
    }
    *(tempVal+len-1-i) = ch;
    value = value/10;
  }
  while(tempVal[0] == '0' && !(tempVal[1] == '\n'))
  {
    int j=0;
    while(j<len-1)
    {
      tempVal[j] = tempVal[j+1];
      j++;
    }
    tempVal[j] = ' ';
  }
  return tempVal;
}
float set(float x, float y, float S)
{
  return ((sq(x) - sq(y) + sq(S))/(2.0*S));
}

void calculate()
{
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
        float x1 = set(a_range, d_range, x_max);
        float x2 = set(b_range, c_range, x_max);
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
        x_val = ((x1*D1) + (x2*D2))/(D1+D2);
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
        x_val = set(a_range, d_range, x_max);
        y_val = y_max - sqrt((a_range *1.0 * a_range) - (x_val * 1.0 *x_val));
      }
      else if ((B_RANGE && C_RANGE))
      {
        x_val = set(b_range, c_range, x_max);
        y_val = sqrt((b_range *1.0 * b_range) - (x_val * 1.0 *x_val));
      }
      
    }
    if ((A_RANGE && B_RANGE) || (C_RANGE && D_RANGE))
    {
      if ((A_RANGE && B_RANGE) && (C_RANGE && D_RANGE))
      {
        float y1 = set(b_range, a_range, y_max);
        float y2 = set(c_range, d_range, y_max);
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
        y_val = ((y1*D1) + (y2*D2))/(D1+D2);      }
      else if((A_RANGE && B_RANGE))
      {
        y_val = set(b_range, a_range, y_max);
        if(!((A_RANGE && D_RANGE) || (B_RANGE && C_RANGE)))
        {
          x_val = sqrt((b_range *1.0 * b_range) - (y_val * 1.0 *y_val));
        }

        
      }
      else if ((C_RANGE && D_RANGE))
      {
        y_val = set(c_range, d_range, y_max);
        if(!((A_RANGE && D_RANGE) || (B_RANGE && C_RANGE)))
        {
          x_val = x_max - sqrt((c_range *1.0 * c_range) - (y_val * 1.0 *y_val));
        }
      }
    }
  }
//  Serial.print(x_val);
//  Serial.print("||");
//  Serial.println(y_val);
  A_RANGE = B_RANGE = C_RANGE = D_RANGE = false;
  

  x_ind_max = point_to_ind(x_max);
  y_ind_max = point_to_ind(y_max);

  grid_val = point_to_grid(x_val, y_val);
  x_ind_val = point_to_ind(x_val);
  y_ind_val = point_to_ind(y_val);
  
  max_grid_no = x_max * y_max/(grid_max * grid_max);


}

int ind_to_grid(int x, int y)
{
  return (y-1)*x_ind_max + x;
}
  
int point_to_grid(int px, int py)
{
  return ind_to_grid(point_to_ind(px), point_to_ind(py));
}
void grid_to_point(int grid_no, int *x, int *y)
{
  int x_temp = (grid_val - 1) % x_ind_max;
  int y_temp = (grid_val / x_ind_max);
  *x = (x_temp * grid_max) + grid_max/2;
  *y = (y_temp * grid_max) + grid_max/2;
}
int point_to_ind(int pt)
{
  return pt/grid_max + 1;
}
int ind_to_point(int ind)
{
  return ind*grid_max + (0.5*grid_max);
}

float hypotenus(float x1, float x2, float y1, float y2)
{
  return sqrt((sq(x2 - x1) + sq(y2 - y1)));
}
// END

// DISPLAY + ACCEPT KEY FUNCTIONS
void hor_lcd_roll(char message[50], int len, char* value, int pos, int delay1, int delay2, void (*pf)(char, int*) )
{
  int i=1;
  char stream[17];
  lcd.setCursor(0,1);
  lcd.print(value);
  int loop_end=0;
  time = millis();
  char key;
  while(!loop_end)
  {
    lcd.setCursor(0,0);
    strncpy(stream,(message+i),16);


  lcd.print(stream);
  
  char key = keypad.getKey();

  if (key != NO_KEY) 
  {
//    Serial.println(key);
    pf(key,&loop_end);
  }
  
  if(((millis()-time)>delay1)&&i!=0&&i!=(len-17))
  {
    time=millis();
    i++;
  }
  if(((millis()-time)>delay2)&&(i==0||i==(len-17)))
  {
	time=millis();
      if(i==(len-17))
      {
        i=0;
      }
      else
      {
        i++;
      }
      
  }
   
  
  }
}

void ver_lcd_roll(char message[5][17], int len, int delay1, int delay2, void (*pf)(char, int*) )
{
  int i=0;
  int loop_end=0;
  time = millis();
  while(!loop_end)
  {
  lcd.setCursor(0,0);
  lcd.print(message[i]);
  lcd.setCursor(0,1);
  lcd.print(message[(i+1)%len]);

  char key = keypad.getKey();
  
  if (key != NO_KEY) 
  {
//    Serial.println(key);
    pf(key,&loop_end);
  }
  
  if(((millis()-time)>delay1)&&i!=0)
  {
    time=millis();
    i++;
  }
  if(((millis()-time)>delay2)&&i==0)
  {
    time=millis();
	i++;
  }
   
  if(i==(len))i=0;
  }
}
// END


// MODULAR FUNCTIONS
void restart()
{
  if(_MODE_ == false)
  {
    while(!(readByte() == S)) continue;
    sendByte(S);
    while(!(readByte() == H)) continue;
    char key = readByte();
    getStart(key, NULL);
    _RESTART_ = false;
    return;
    
  }

//  Serial.println("RESTART");
  //strcat(strcat(strcat(strcat(strcat(strcat(strcat(startmessage,"Current [L:"),val_to_char(x_max,3)),",B:"),val_to_char(y_max,3))," Grid:"),val_to_char(grid_max,2)),"]cm Calibrate?  ");
  val_to_char(x_max,3);
    
  startmessage[12]=tempVal[0];
  startmessage[13]=tempVal[1];
  startmessage[14]=tempVal[2];
  val_to_char(y_max,3);
  startmessage[18]=tempVal[0];
  startmessage[19]=tempVal[1];
  startmessage[20]=tempVal[2];
  val_to_char(grid_max,2);
  startmessage[27]=tempVal[0];
  startmessage[28]=tempVal[1];

  hor_lcd_roll(startmessage, 46, "  Yes:*   No:#  ", 0, 400, 1000, getStart);
  
  sendByte(C);
  sendNum(x_max);
  sendNum(y_max);
  sendNum(grid_max);
  
  _RESTART_ = false;
//  Serial.println("RESTART END");

}
void calibrate()
{
//  lcd.setCursor(0,0);
//  lcd.print("CALIBRATE");
//  if(_MODE_ == false)
//  {
//    while(!(readByte() == C)) continue;
//    sendByte(V);
//    sendNum(x_max);
//    sendNum(y_max);
//    sendNum(grid_max);
//    while(!(readByte() == V)) continue;
//    x_max = readNum();
//    y_max = readNum();
//    grid_max = readNum();
//    
//    _CALIBRATE_ = false; 
//  _RANGE_ = true;
//    return;
//  }

  
//  Serial.println("CALIBRATE");
  calval = 0;
  hor_lcd_roll(xmessage, 34, "          #:end ", 0, 400, 1000,getCalibrate);
  x_max = calval;
  while(!((x_max >0) && (x_max<=550)))
  {
    calval = 0;
    hor_lcd_roll(xmessage, 34, "          #:end ", 0, 400, 1000,getCalibrate);
    x_max = calval;
  }

  calval = 0;  
  hor_lcd_roll(ymessage, 34, "          #:end ", 0, 400, 1000,getCalibrate);
  y_max = calval;
  while(!((y_max >0) && (y_max<=550)))
  {
    calval = 0;
    hor_lcd_roll(ymessage, 34, "          #:end ", 0, 400, 1000,getCalibrate);
    y_max = calval;
  }
  
  calval = 0;  
  hor_lcd_roll(gridmessage, 33, "          #:end ", 0, 400, 1000,getCalibrate);
  grid_max = calval;
  while(!(grid_max>=10 && grid_max<=50))
  {
    calval = 0;
    hor_lcd_roll(gridmessage, 33, "          #:end ", 0, 400, 1000,getCalibrate);
    grid_max = calval;
  }
  
  sendByte(C);
  sendNum(x_max);
  sendNum(y_max);
  sendNum(grid_max);
  
  _CALIBRATE_ = false; 
  _RANGE_ = true;
//  Serial.println("CALIBRATE END");
}

void range()
{

//  lcd.setCursor(0,0);
//  lcd.print("RANGE");
//  Serial.println("RANGE");
  readTemp();
  performRange();
  calculate();
  
  if((millis() - time1) > 1000)
  {
//    if(TOGGLE == true)
//    {
//      lcd.setCursor(0,0);
//      lcd.print("A:    B:    TEMP");
//      lcd.setCursor(0,1);
//      lcd.print("C:    D:        ");
//      lcd.setCursor(2,0);
//      lcd.print(val_to_char(a_range,4));
//      lcd.setCursor(8,0);
//      lcd.print(val_to_char(b_range,4));
//      lcd.setCursor(2,1);
//      lcd.print(val_to_char(c_range,4));
//      lcd.setCursor(8,1);
//      lcd.print(val_to_char(d_range,4));
//      lcd.setCursor(13,1);
//      lcd.print(val_to_char(temp,3));
//      
//      TOGGLE = false;
//    }
//    else
//    {
      lcd.setCursor(0,0);
      lcd.print("  2-D POSITION  ");
      lcd.setCursor(0,1);
      lcd.print("X:   Y:   [  ,  ");
      
//      Serial.print(a_range);
//      Serial.print("||");
//      Serial.print(b_range);
//      Serial.print("||");
//      Serial.print(c_range);
//      Serial.print("||");
//      Serial.println(d_range);
//    //  
//      Serial.print(x_val);
//      Serial.print("||");
//      Serial.print(y_val);
//      Serial.print("||");
//      Serial.println(grid_val);
//      Serial.println();
      
      lcd.setCursor(2,1);
      lcd.print(val_to_char(x_val,3));
      lcd.setCursor(7,1);
      lcd.print(val_to_char(y_val,3));
      lcd.setCursor(11,1);
      lcd.print(val_to_char(x_ind_val,2));
      lcd.setCursor(14,1);
      lcd.print(val_to_char(y_ind_val,2));  
      
      sendByte(V);
      sendNum(x_val);
      sendNum(y_val);
//      TOGGLE = true;
//    }
    time1 = millis();
  }
  
    
    
//  if((Serial.available() > 0))
//  {
//    lastInput = readByte();
//    if((lastInput == C))
//    {
//    sendByte(C);
//    x_max = readNum();
//    y_max = readNum();
//    grid_max = readNum();
//    }
//    if((lastInput == V))
//    {
      
//    }
//  }
  
    
   
  char key = keypad.getKey();
//  if (key != NO_KEY) Serial.println(key);
  if (key == 'A') 
  {
      lcd.setCursor(0,0);
      lcd.print("A:    B:    TEMP");
      lcd.setCursor(0,1);
      lcd.print("C:    D:        ");
      lcd.setCursor(2,0);
      lcd.print(val_to_char(a_range,4));
      lcd.setCursor(8,0);
      lcd.print(val_to_char(b_range,4));
      lcd.setCursor(2,1);
      lcd.print(val_to_char(c_range,4));
      lcd.setCursor(8,1);
      lcd.print(val_to_char(d_range,4));
  }
  
  if(key=='C') {
    sendByte(C);
      sendNum(x_max);
      sendNum(y_max);
      sendNum(grid_max);
  }
  if(key=='D') {
    sendByte(V);
      sendNum(x_val);
      sendNum(y_val);
  }
  
//  Serial.println("RANGE END");
}

void mode()
{
  lcd.setCursor(0,0);
  lcd.print("MODE");
  if(_MODE_ == false)
  {
    lcd.setCursor(0,0);
    lcd.print("     PC MODE    ");
    lcd.setCursor(0,1);
    lcd.print("STANDALONE  :  D");
    
    

  }
}
void menu()
{
  lcd.setCursor(0,0);
  lcd.print("MENU");
  if(_MODE_ == false)
  {
    
    while(!(readByte() == M)) continue;
    sendByte(M);
    while(!(readByte() == H)) continue;
    char key = readByte();
    getMenu(key, NULL);
    _MENU_ = false;
    return;
  }
  
//  Serial.println("MENU");
  ver_lcd_roll(menumessage, 5, 1000, 1000,getMenu);
  
  _MENU_ = false;
//  Serial.println("MENU END");
}

void control()
{
  lcd.setCursor(0,0);
  lcd.print("CONTROL");
  if(_MODE_ == false)
  {
    _RANGE_ = false;
    while(!(readByte() == B)) continue;
    sendByte(B);
    while(!(readByte() == H)) continue;
    
    while ((_RANGE_ == false) && (_AUTO_ == false))
    {
      char key = readByte();
      getControl(key, NULL);
    }
    _CONTROL_ = false;
    return;
  }
//  Serial.println("CONTROL");
  hor_lcd_roll(movemessage, 33, "Auto?:A  END?: #", 0, 400, 1000,getControl);
  
  _CONTROL_ = false;
//  Serial.println("CONTROL END");
}

void auto1()
{
  lcd.setCursor(0,0);
  lcd.print("AUTO");
  if(_MODE_ == false)
  {
    while(!(readByte() == A)) continue;
    sendByte(A);
    
    _POINT_ = true;

  }
  else
  {
    
    
  //  Serial.println("AUTO");
    lcd.setCursor(0,0);  
    lcd.print("Use Point? :  A ");
    lcd.setCursor(0,1);
    lcd.print("Use Grid?  :  B ");
    char key = keypad.waitForKey();
    while(!(key=='A'||key=='B'))
    {
      char key = keypad.waitForKey();
    }
      switch(key){
        case 'A': _POINT_ = true;break;
        case 'B': _POINT_ = false; break;
        default : break;
      }
    
  }
     if(_POINT_)
    {
      point();
    }
    else grid();
  
  
    val_to_char(x_point,3);
    movingmessage[12] = tempVal[0];
    movingmessage[13] = tempVal[1];
    movingmessage[14] = tempVal[2];
    val_to_char(y_point,3);
    movingmessage[18] = tempVal[0];
    movingmessage[19] = tempVal[1];
    movingmessage[20] = tempVal[2];
    moving(movingmessage, 34, 400,1000);

  
  
  _AUTO_ = false;
  _RANGE_ = true;
//  Serial.println("AUTO END");
  
}

void point()
{
  lcd.setCursor(0,0);
  lcd.print("POINT");
  if(_MODE_ == false)
  {
    while(!(readByte() == P)) continue;
    sendByte(P);
    
    while(!(readByte() == V)) continue;
    x_point = readNum();
    y_point = readNum();
    
    return;
  }
  
//  Serial.println("POINT");
  calval = 0;
  hor_lcd_roll(strcat(strcat(pmessage,val_to_char(x_max,3))," # to end"), 35, "Goal_X:         ", 0, 400, 1000,getPoint);
  x_point = calval;
  
  while(!((x_point > 0) && (x_point<=x_max)))
  {
    calval = 0;
    hor_lcd_roll(pmessage, 35, "Goal_X:         ", 0, 400, 1000,getPoint);
    x_point = calval;
  }
  
  val_to_char(y_max,3);
  pmessage[22]=tempVal[0];
  pmessage[23]=tempVal[1];
  pmessage[24]=tempVal[2];
  
  calval = 0;
  hor_lcd_roll(pmessage, 35, "Goal_Y:         ", 0, 400, 1000,getPoint);
  y_point = calval;
  while(!((y_point > 0) && (y_point<=y_max)))
  {
    calval = 0;
    hor_lcd_roll(pmessage, 35, "Goal_Y:         ", 0, 400, 1000,getPoint);
    y_point = calval;
  }
  grid_no = point_to_grid(x_point, y_point);
  x_ind = point_to_ind(x_point);
  y_ind = point_to_ind(y_point);
//  Serial.println("POINT END");
}

void grid()
{
//  Serial.println("GRID");
  calval = 0;
  hor_lcd_roll(strcat(strcat(gmessage,val_to_char(x_ind_max,2))," # to end"), 34, "X_index:       ", 0, 400, 1000,getGrid);
  x_ind = calval;
  while(!(x_ind>=0 && x_ind<=x_ind_max))
  {
    calval = 0;
    hor_lcd_roll(gmessage, 34, "X_index:        ", 0, 400, 1000,getGrid);
    x_ind = calval;
  }

  val_to_char(y_ind_max,2);
  gmessage[22]=tempVal[0];
  gmessage[23]=tempVal[1];
  
  calval = 0;
  hor_lcd_roll(gmessage, 35, "Y_index:        ", 0, 400, 1000,getGrid);
  y_ind = calval;
  while(!(y_ind>=0 && y_ind<=y_ind_max))
  {
    calval = 0;
    hor_lcd_roll(gmessage, 35, "Y_index:        ", 0, 400, 1000,getGrid);
    y_ind = calval;
  }  
	
  x_point = ind_to_point(x_ind);
  y_point = ind_to_point(y_ind);
  
//  Serial.println("GRID END");
}

void moving(char* message, int len, int delay1, int delay2)
{
  lcd.setCursor(0,0);
  lcd.print("MOVING");
  float theta = 1;
  
  int x1, y1;
  float a,b,c;
  
  int i=0;
  char stream[17] = "JustANonentityNo";
  lcd.setCursor(0,1);
  lcd.print("                ");
  int loop_end=0;
  time = millis();
  char key;
  if(_MODE_ == false)
  {
    while(!(readByte() == V)) continue;
  }
  while(!loop_end)
  {
    lcd.setCursor(0,0);
    strncpy(stream,(message+i),16);
  lcd.print(stream);
  
  char key = keypad.getKey();
  
  if (key == '#') loop_end = 1;
  
  
  if(((millis()-time)>delay1)&&i!=0&&i!=(len-17))
  {
    time=millis();
    i++;
  }
  if(((millis()-time)>delay2)&&(i==0||i==(len-17)))
  {
	time=millis();
      if(i==(len-17))
      {
        i=0;
      }
      else
      {
        i++;
      }
      
  }
  
  forward(5);
  x1 = x_val;
  y1 = y_val;
  performRange();
  calculate();
  
  if(_MODE_ == false)
  {
    if((Serial.available() > 0)) if((readByte() == D)) loop_end = 1;
    sendByte(V);
    sendNum(x_val);
    sendNum(y_val);

    
  }
  
  b = hypotenus(x_val, x_point, y_val, y_point);
  
  if(Serial.available() > 0)
   {
     if(readByte() == D) 
     {
       loop_end = 1;
       _MODE_ = true;
     }
   }
   
   if(theta > 0.08)
   { 
      a = hypotenus(x1, x_val, y1, y_val);
      c = hypotenus(x1, x_point, y1, y_point);
      
      theta = acos(((sq(a) + sq(b) - sq(c))/(2.0 * a * b)));
      theta = PI - theta;
      if(x_val > x1) turn_right(5);//theta*5/HALF_PI);
      else turn_left(5);
      forward(5);
   }
   else if(b > 5)
   {
     forward(5);//b*5);
   }
   else 
   {
     loop_end = 1;
     if(_MODE_ == false)
    {
      sendByte(H);
      sendByte(D);
      
    }
   }
  }
	
  
}
// END

int readByte()
{
  while(true){
    if(Serial.available() > 0) {
      return Serial.read();
    }
  }
}

void sendByte(int x)
{

  Serial.write(x);
}

int readNum()
{
  int num1 = readByte();
  return num1 + (readByte() << 8);
}
void sendNum(int num)
{
  sendByte(num & 255);
  sendByte((num >> 8) & 255);
}

// PARSING PRESSED KEY FUNCTIONS
void getStart(char ch, int *loop_end)
{
  switch(ch){
    case '*': _CALIBRATE_ = true;*loop_end = 1;break;  // Terminate the while loop affecting display in calling function
    case '#': _RANGE_ = true;*loop_end = 1; break;
  }
   
}

void getCalibrate(char ch, int *loop_end)
{
  
  lcd.setCursor(1,1);
  switch(ch){
    case '0': calval = calval*10 + 0;break;
    case '1': calval = calval*10 + 1;break;
    case '2': calval = calval*10 + 2;break;
    case '3': calval = calval*10 + 3;break;
    case '4': calval = calval*10 + 4;break;
    case '5': calval = calval*10 + 5;break;
    case '6': calval = calval*10 + 6;break;
    case '7': calval = calval*10 + 7;break;
    case '8': calval = calval*10 + 8;break;
    case '9': calval = calval*10 + 9;break;
    case '#': *loop_end = 1; // Terminate the while loop affecting display in calling function
    default: break;
  }
  lcd.print(calval);

}

void getRange(char ch, int *loop_end)
{
  
  if(ch=='*') 
  {
    _MENU_ = true;
    *loop_end = 1; // Terminate the while loop affecting display in calling function

  }
}

void getMenu(char ch, int *loop_end)
{
  
 switch(ch){
    case 'A': _CALIBRATE_ = true;*loop_end = 1;break;   // Terminate the while loop affecting display in calling function
    case 'B': _CONTROL_ = true;*loop_end = 1;break;
    case 'C': _RESTART_ = true;*loop_end = 1;break;
    case 'D': _MODE_ = false;*loop_end = 1; break;
   case '#': _RANGE_ = true;*loop_end = 1;break;
    default: break;
  }
  

}


void getControl(char ch, int *loop_end)
{
  switch(ch){
    case '2': move_forward();break;
    case '4': move_left();break;
    case '6': move_right();break;
    case '8': move_back();break;
    case 'A': _AUTO_ = true; *loop_end = 1; _CONTROL_ = false;break;
    case '#': _RANGE_ = true; *loop_end = 1; _CONTROL_ = false;break;
    default : break;
  }
}

void getAuto(char ch, int *loop_end)
{
  switch(ch){
    case 'A': _POINT_ = true;*loop_end = 1; break;
    case 'B': _POINT_ = false;*loop_end = 1; break;
    default : break;
  }
}

void getPoint(char ch, int *loop_end)
{

  lcd.setCursor(9,1);
  switch(ch){
    case '0': calval = calval*10 + 0;break;
    case '1': calval = calval*10 + 1;break;
    case '2': calval = calval*10 + 2;break;
    case '3': calval = calval*10 + 3;break;
    case '4': calval = calval*10 + 4;break;
    case '5': calval = calval*10 + 5;break;
    case '6': calval = calval*10 + 6;break;
    case '7': calval = calval*10 + 7;break;
    case '8': calval = calval*10 + 8;break;
    case '9': calval = calval*10 + 9;break;
    case '#': *loop_end = 1; // Terminate the while loop affecting display in calling function
    default: break;
  }
  lcd.print(calval);
}

void getGrid(char ch, int *loop_end)
{
    lcd.setCursor(9,1);
    switch(ch){
    case '0': calval = calval*10 + 0;break;
    case '1': calval = calval*10 + 1;break;
    case '2': calval = calval*10 + 2;break;
    case '3': calval = calval*10 + 3;break;
    case '4': calval = calval*10 + 4;break;
    case '5': calval = calval*10 + 5;break;
    case '6': calval = calval*10 + 6;break;
    case '7': calval = calval*10 + 7;break;
    case '8': calval = calval*10 + 8;break;
    case '9': calval = calval*10 + 9;break;
    case '#': *loop_end = 1; // Terminate the while loop affecting display in calling function
    default: break;
  }
  lcd.print(calval);
}

// END

// ROBOT CONTROLS
void move_forward()
{
	vw_send((uint8_t *)("forward"), 8);
  
   vw_wait_tx();
}
void move_back()
{
	vw_send((uint8_t *)("back"), 5);
  
   vw_wait_tx();
}
void move_left()
{
	vw_send((uint8_t *)("left"), 5);
  
   vw_wait_tx();
}
void move_right()
{
	vw_send((uint8_t *)("right"), 6);
  
   vw_wait_tx();
}

void forward(int num)
{
  for( int i=0;i<num;i++)
  {
    move_forward();
  }
}
void turn_right(int num)
{
  for(int i=0;i<num;i++)
  {
    move_right();
  }
}
void turn_left(int num)
{
  for(int i=0;i<num;i++)
  {
    move_left();
  }
}
void back(int num)
{
  for(int i=0;i<num;i++)
  {
    move_back();
  }
}
// END



