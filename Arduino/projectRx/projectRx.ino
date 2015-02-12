// include the library code:

#include <VirtualWire.h>
#include <IRremote.h>
#include <IRremoteInt.h>

const int trigPin1 = 2;
const int trigLED = A4;
const int moveLED = A5;

int presstime = 100;
long time = 0;
int state = 0;
int level = 200;
int RECV_PIN = 6;
IRrecv irrecv(RECV_PIN);
decode_results results;
int delaytime = 100;

#define LEFT_ENABLE_PIN 9
#define LEFT_FOR_PIN 7
#define LEFT_BACK_PIN 8

#define RIGHT_ENABLE_PIN 5
#define RIGHT_FOR_PIN 3
#define RIGHT_BACK_PIN 4

uint8_t buf[VW_MAX_MESSAGE_LEN];

    uint8_t buflen = VW_MAX_MESSAGE_LEN;
    
void setup() {

  Serial.begin(9600);

  pinMode(trigPin1, OUTPUT);
   
   irrecv.enableIRIn();
   
   vw_set_ptt_inverted(true); // Required for DR3100
    vw_setup(2000);	 // Bits per sec
    vw_rx_start();  // Start the receiver PLL running
    
    pinMode(trigLED, OUTPUT);
    pinMode(moveLED, OUTPUT);

    pinMode(LEFT_ENABLE_PIN, OUTPUT);
    pinMode(LEFT_FOR_PIN, OUTPUT);
    pinMode(LEFT_BACK_PIN, OUTPUT);
    
    pinMode(RIGHT_ENABLE_PIN, OUTPUT);
    pinMode(RIGHT_FOR_PIN, OUTPUT);
    pinMode(RIGHT_BACK_PIN, OUTPUT);
    
    Serial.println("setup");
    
}

void loop() {
  digitalWrite(trigLED, LOW);
  digitalWrite(moveLED, LOW);
int i;
  
    
    
    if (vw_get_message(buf, &buflen)) // Non-blocking
    {
	

        for (i = 0; i < buflen; i++)
	{
	    Serial.print(buf[i], HEX);
	    Serial.print(" ");
	}
        Serial.println();
        
	if(buf[0]=='h' && buf[1]=='e')
        {
          
      
//      while(i<20)
//      {
//        digitalWrite(trigPin1, HIGH);
//        delayMicroseconds(12);
//        digitalWrite(trigPin1, LOW);
//        delayMicroseconds(12);
//        i++;
//      }
        digitalWrite(trigLED, HIGH);
        digitalWrite(trigPin1, LOW);
        delayMicroseconds(2);
        digitalWrite(trigPin1, HIGH);
        delayMicroseconds(10);
        digitalWrite(trigPin1, LOW);
        delayMicroseconds(2);
        }
        if(buf[0]=='r' && buf[1]=='i')
        {
          right();
        }
        if(buf[0]=='l' && buf[1]=='e')
        {
          left();
        }
        if(buf[0]=='f' && buf[1]=='o')
        {
          forward();
        }
        if(buf[0]=='b' && buf[1]=='a')
        {
          backward();
        }
    }
    
  if(irrecv.decode(&results)) {
    Serial.println(results.value, HEX);
    
      if(results.value == 0x10FED22D) 
      {
        forward();
        state = 2;
        time = millis();
      }
      else if(results.value == 0x10FEF00F) 
      {
        left();
        state = 4;
        time = millis();
      }
      else if(results.value == 0x10FE30CF) 
      {
        backward();
        state = 8;
        time = millis();
      }
      else if(results.value == 0x10FE708F) 
      {
        right();
        state = 6;
        time = millis();
      }
      else if(results.value == 0X10FED02E) 
      {
        level++;
        state = 7;
        time = millis();
      }
      else if(results.value == 0x10FE12ED) 
      {
        level--;
        state = 9;
        time = millis();
      }
      else if(results.value == 0xFFFFFFFF)
      {
        if((millis() - time) < presstime)
        {
        switch(state) {
          case 2: forward();break;
          case 4: left();break;
          case 6: right();break;
          case 8: backward();break;
          case 7: level++;break;
          case 9: level--;break;
        }
        time = millis();
        }
      }
      else state = 0;
      irrecv.resume();
    }
}

void right()
{
  digitalWrite(LEFT_ENABLE_PIN, HIGH);
  digitalWrite(LEFT_FOR_PIN, HIGH);
  digitalWrite(LEFT_BACK_PIN, LOW);
  delay(delaytime);
  digitalWrite(LEFT_ENABLE_PIN, LOW);
  digitalWrite(LEFT_FOR_PIN, LOW);
  digitalWrite(LEFT_BACK_PIN, LOW);
  Serial.println("RIGHT");
}
void left()
{
  digitalWrite(RIGHT_ENABLE_PIN, HIGH);
  digitalWrite(RIGHT_FOR_PIN, HIGH);
  digitalWrite(RIGHT_BACK_PIN, LOW);
  delay(delaytime);
  digitalWrite(RIGHT_ENABLE_PIN, LOW);
  digitalWrite(RIGHT_FOR_PIN, LOW);
  digitalWrite(RIGHT_BACK_PIN, LOW);
  Serial.println("LEFT");
}
void forward()
{
  digitalWrite(LEFT_ENABLE_PIN, HIGH);
  analogWrite(RIGHT_ENABLE_PIN, 128);
  digitalWrite(LEFT_FOR_PIN, HIGH);
  digitalWrite(LEFT_BACK_PIN, LOW);
  digitalWrite(RIGHT_FOR_PIN, HIGH);
  digitalWrite(RIGHT_BACK_PIN, LOW);
  delay(delaytime);
  digitalWrite(LEFT_ENABLE_PIN, LOW);
  digitalWrite(RIGHT_ENABLE_PIN, LOW);
  digitalWrite(LEFT_FOR_PIN, LOW);
  digitalWrite(LEFT_BACK_PIN, LOW);
  digitalWrite(RIGHT_FOR_PIN, LOW);
  digitalWrite(RIGHT_BACK_PIN, LOW);
  Serial.println("FORWARD");
}
void backward()
{
  digitalWrite(LEFT_ENABLE_PIN, HIGH);
  analogWrite(RIGHT_ENABLE_PIN, 128);
  digitalWrite(LEFT_FOR_PIN, LOW);
  digitalWrite(LEFT_BACK_PIN, HIGH);
  digitalWrite(RIGHT_FOR_PIN, LOW);
  digitalWrite(RIGHT_BACK_PIN, HIGH);
  delay(delaytime);
  digitalWrite(LEFT_ENABLE_PIN, LOW);
  digitalWrite(RIGHT_ENABLE_PIN, LOW);
  digitalWrite(LEFT_FOR_PIN, LOW);
  digitalWrite(LEFT_BACK_PIN, LOW);
  digitalWrite(RIGHT_FOR_PIN, LOW);
  digitalWrite(RIGHT_BACK_PIN, LOW);
  Serial.println("BACK");
}
