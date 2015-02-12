// include the library code:
#include <LiquidCrystal.h>
#include <VirtualWire.h>
#include <PinChangeInt.h>

// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(6, 7, 8, 9, 10, 11);

const int trigPin1 = 3;
const int echoPin1 = 2;
const int trigPin2 = 4;
const int echoPin2 = 5;

unsigned long time=0;
unsigned long time1=0;
unsigned long a1=0;
unsigned long a2=0;
unsigned long b1=0;
unsigned long b2=0;

int temp = 0;
char *msg = "hello";
const int buttonPin = 2; 
int buttonState = 0; 

void echo2func() {
    if(digitalRead(echoPin2)==HIGH) a1=micros();
  if(digitalRead(echoPin2)==LOW) a2=micros()-a1;
 
}
void echo1func() {
      if(digitalRead(echoPin1)==HIGH) b1=micros();
    if(digitalRead(echoPin1)==LOW) b2=micros()-b1;
}

void setup() {
  lcd.begin(16, 2);
  Serial.begin(9600);
  lcd.print("Distance:");
  pinMode(buttonPin, INPUT);
//  pinMode(trigPin1, OUTPUT);
  pinMode(trigPin2, OUTPUT);
   pinMode(echoPin2, INPUT);
  pinMode(echoPin1, INPUT);   
   vw_set_ptt_inverted(true); // Required for DR3100
    vw_setup(2000);	 // Bits per sec
    
  PCintPort::attachInterrupt(echoPin2, &echo2func, CHANGE);
  PCintPort::attachInterrupt(echoPin1, &echo1func, CHANGE);
}

void loop() {
  long duration, inches, cm, duration1, inches1, cm1;
  lcd.setCursor(0, 1);

  temp = msg[4];
  msg[4]=++temp;
  if(msg[4] == 255) msg[4]=150;  
  
   vw_send((uint8_t *)msg, strlen(msg));
  
  vw_wait_tx();


//  int i=0;
//  while(i<20)
//      {
//        digitalWrite(trigPin1, HIGH);
//        delayMicroseconds(12);
//        digitalWrite(trigPin1, LOW);
//        delayMicroseconds(12);
//        i++;
//      }
  digitalWrite(trigPin2, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin2, HIGH);

  delayMicroseconds(10);
  digitalWrite(trigPin2, LOW);
  delayMicroseconds(2);
  a1=micros(); 
  b1=micros();
  delay(100);
  duration = a2;//pulseIn(echoPin2, HIGH);
  duration1 = b2;//pulseIn(echoPin2, HIGH);
  
  inches = microsecondsToInches(duration);
  cm = microsecondsToCentimeters(duration);
  inches1 = microsecondsToInches(duration1);
  cm1 = microsecondsToCentimeters(duration1);
  
  Serial.print(inches);
  Serial.print("in, ");
  Serial.print(cm);
  Serial.print("cm");
  Serial.println();
  

  lcd.print(cm);
  lcd.print("cm");
  lcd.print(cm1);
  lcd.print("cm");
//  buttonState = digitalRead(buttonPin);
//while(buttonState == LOW)
//{
//  buttonState = digitalRead(buttonPin);
//  Serial.println("LOW");
//}
delay(300);
}
long microsecondsToInches(long microseconds)
{
  // According to Parallax's datasheet for the PING))), there are
  // 73.746 microseconds per inch (i.e. sound travels at 1130 feet per
  // second).  This gives the distance travelled by the ping, outbound
  // and return, so we divide by 2 to get the distance of the obstacle.
  // See: http://www.parallax.com/dl/docs/prod/acc/28015-PING-v1.3.pdf
  return microseconds / 74;
}

long microsecondsToCentimeters(long microseconds)
{
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the
  // object we take half of the distance travelled.
  return microseconds / 29;
}
