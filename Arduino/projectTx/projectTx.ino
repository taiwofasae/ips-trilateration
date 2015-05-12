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

const int echoPin1 = 4;
const int echoPin2 = 5;

const int tempPin = A0;

unsigned long time=0;
unsigned long time1=0;
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
int _CALIBRATE_= false;
int _RANGE_= true;
int _MENU_= false;

int x_val = 0;  // present x location
int y_val = 0;  // present y location
int grid_val = 0;  // present grid
int x_ind_val = 1;  // present x index
int y_ind_val = 1;  // present y index

int max_grid_val = 0;  // maximum
long max_grid_no = 0;  // maximum number of grids for a particular environment

int x_max = 500;  // x width for the environment 
int y_max = 500;  // y width for the environment
int grid_max = 10;  // grid size for the environment
int x_ind_max = 50;  // max index for x coordinate
int y_ind_max = 50;  // max index for y coordinate


long calval=0;
int calcount=0;


char tempVal[4] = "   ";

char startmessage[46] = "Current [L:500,B:500 Grid:10]cm  Calibrate?  "; 
char xmessage[35] = "Enter X-length btw 0 and 550cm    ";
char ymessage[35] = "Enter Y-length btw 0 and 550cm    ";
char gridmessage[35] = "Enter Grid size btw 10 and 50cm   ";
char menumessage[3][17]= {"Calibrate? :  A ", "Restart? :    B ", "Position? :   # "};


// ULTRASONIC RANGING FUNCTIONS
void echo1func() {
    if(digitalRead(echoPin1)==HIGH) a1=micros();
  if(digitalRead(echoPin1)==LOW) a2=micros()-a1;
 
}
void echo2func() {
    if(digitalRead(echoPin2)==HIGH) b1=micros();
  if(digitalRead(echoPin2)==LOW) b2=micros()-b1;
 

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
  
//  pinMode(trigPin1, OUTPUT);
//  pinMode(trigPin2, OUTPUT);

   vw_send((uint8_t *)("hello"), 6);
  
  vw_wait_tx();
  
  digitalWrite(trigPin1, LOW);
   
  delayMicroseconds(2);
  digitalWrite(trigPin1, HIGH);
  
  delayMicroseconds(10);
  digitalWrite(trigPin1, LOW);
   
    delayMicroseconds(2);
   
  
   
  a1=micros(); 
  a2=0;
  
  delay(100);
  durationa = a2;
  a_range = microsecondsToCentimeters(durationa);
  delay(100);

   vw_send((uint8_t *)("hello"), 6);
  
  vw_wait_tx();
  
  digitalWrite(trigPin2, LOW);
   
  delayMicroseconds(2);
  digitalWrite(trigPin2, HIGH);
  
  delayMicroseconds(10);
  digitalWrite(trigPin2, LOW);
   
    delayMicroseconds(2);
   
  
   
  b1=micros(); 
  b2=0;
  
  delay(100);
  durationb = b2;
  b_range = microsecondsToCentimeters(durationb);
  delay(100);
 
  
  
  Serial.print("a_range:");
  Serial.println(a_range);
  Serial.print("b_range:");
  Serial.println(b_range);
//  Serial.print("c_range:");
//  Serial.print(c_range);
//  Serial.print("d_range:");
//  Serial.println(d_range);
delay(300);
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
//  pinMode(trigPin3, OUTPUT);
//  pinMode(trigPin4, OUTPUT);

  pinMode(echoPin1, INPUT);
  pinMode(echoPin2, INPUT);

  vw_set_ptt_inverted(true); // Required for DR3100
  vw_setup(2000);	 // Bits per sec
    
  PCintPort::attachInterrupt(echoPin1, &echo1func, CHANGE);
  PCintPort::attachInterrupt(echoPin2, &echo2func, CHANGE);
  
 
}

// END

// LOOP
void loop()
{
   
//  if(_RESTART_) restart();
//  
//  if (_CALIBRATE_) calibrate();
  
  if (_RANGE_) range();
  
//  if (_MENU_) menu();
  
   
}
    
// HELPER FUNCTIONS
char * val_to_char(int value, int len)
{
  char ch;
  int value1;
  tempVal[len] = '\0';
  for(int i=0;i<len;i++)
  {
    value1 = value % 10;
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
  while(tempVal[0] == '0')
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
  
void calculate()
{
  x_ind_max = point_to_ind(x_max);
  y_ind_max = point_to_ind(y_max);
  x_val = d_range;
  y_val = b_range;
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
// END

// DISPLAY + ACCEPT KEY FUNCTIONS
void hor_lcd_roll(char* message, int len, char* value, int pos, int delay1, int delay2, void (*pf)(char, int*) )
{
  int i=0;
  char stream[17] = "JustANonentityNo";
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
    Serial.println(key);
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

void ver_lcd_roll(char message[4][17], int len, int delay1, int delay2, void (*pf)(char, int*) )
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
    Serial.println(key);
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
  Serial.println("RESTART");
  //strcat(strcat(strcat(strcat(strcat(strcat(strcat(startmessage,"Current [L:"),val_to_char(x_max,3)),",B:"),val_to_char(y_max,3))," Grid:"),val_to_char(grid_max,2)),"]cm Calibrate?  ");
  val_to_char(x_max,3);
    
  startmessage[11]=tempVal[0];
  startmessage[12]=tempVal[1];
  startmessage[13]=tempVal[2];
  val_to_char(y_max,3);
  startmessage[17]=tempVal[0];
  startmessage[18]=tempVal[1];
  startmessage[19]=tempVal[2];
  val_to_char(grid_max,2);
  startmessage[26]=tempVal[0];
  startmessage[27]=tempVal[1];

  hor_lcd_roll(startmessage, 45, "  Yes:*   No:#  ", 0, 400, 1000, getStart);
  _RESTART_ = false;
  Serial.println("RESTART END");

}
void calibrate()
{
  Serial.println("CALIBRATE");
  calval = 0;
  hor_lcd_roll(xmessage, 34, "          #:end ", 0, 400, 1000,getCalibrate);
  x_max = calval;
  while(!(x_max<=550))
  {
    calval = 0;
    hor_lcd_roll(xmessage, 34, "          #:end ", 0, 400, 1000,getCalibrate);
    x_max = calval;
  }

  calval = 0;  
  hor_lcd_roll(ymessage, 34, "          #:end ", 0, 400, 1000,getCalibrate);
  y_max = calval;
  while(!(y_max<=550))
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
  
  _CALIBRATE_ = false; 
  _RANGE_ = true;
  Serial.println("CALIBRATE END");
}

void range()
{
  Serial.println("RANGE");
  readTemp();
  performRange();
  calculate();

  lcd.setCursor(0,0);
  lcd.print("A:    B:    Temp");
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
  lcd.setCursor(13,1);
  lcd.print(val_to_char(temp,3));  
  
  char key = keypad.getKey();
  if (key != NO_KEY) Serial.println(key);
  if (key == '*') _MENU_ = true;
  
  delay(50);
  Serial.println("RANGE END");
}

void menu()
{
  Serial.println("MENU");
  ver_lcd_roll(menumessage, 3, 1000, 1000,getMenu);
  
  _MENU_ = false;
  Serial.println("MENU END");
}


// END



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
    case 'B': _RESTART_ = true;*loop_end = 1;break;
    case '#': _RANGE_ = true;*loop_end = 1;break;
    default: break;
  }
  

}


// END

