// include the library code:

#include <VirtualWire.h>

const int trigPin1 = 2;


long time = 0;

int delaytime = 100;


uint8_t buf[VW_MAX_MESSAGE_LEN];

uint8_t buflen = VW_MAX_MESSAGE_LEN;
    
void setup() {

  Serial.begin(9600);

  pinMode(trigPin1, OUTPUT);
   

   
   vw_set_ptt_inverted(true); // Required for DR3100
    vw_setup(2000);	 // Bits per sec
    vw_rx_start();  // Start the receiver PLL running
    
    
    Serial.println("setup");
    
}

void loop() {
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
        digitalWrite(trigPin1, LOW);
        delayMicroseconds(2);
        digitalWrite(trigPin1, HIGH);
        delayMicroseconds(10);
        digitalWrite(trigPin1, LOW);
        delayMicroseconds(2);
        }
        if(buf[0]=='r' && buf[1]=='i')
        {
        
        }
        if(buf[0]=='l' && buf[1]=='e')
        {
        
        }
        if(buf[0]=='f' && buf[1]=='o')
        {
        
        }
        if(buf[0]=='b' && buf[1]=='a')
        {
        
        }
    }
}
    

