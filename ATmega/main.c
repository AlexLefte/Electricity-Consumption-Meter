/*******************************************************
This program was created by the CodeWizardAVR V3.49a 
Automatic Program Generator
© Copyright 1998-2022 Pavel Haiduc, HP InfoTech S.R.L.
http://www.hpinfotech.ro

Project : 
Version : 
Date    : 3/11/2023
Author  : 
Company : 
Comments: 


Chip type               : ATmega164A
Program type            : Application
AVR Core Clock frequency: 10.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

// I/O Registers definitions
#include <mega164a.h>
//#include <util/delay.h>

// Useful definitions
// Numar perioade necesare duratei unui 
// puls intreg (100 ms)
#define T 5

// Numar de perioade necesare
// duratei unui puls pozitiv (cu durata 20 ms)
#define DP 1   

/// CLS definitions ///
char S1 = 0; // CLS state
const long int H1 = 8;
const long int H2 = 16;

const long int Ter = 0x10000000;

long int A0[]={0x00000000+H1<<16, 1, 0x01000000+H1<<16, 1, 0x02000000+H1<<16, 1, 0x03000000+H1<<16, 1, 0x04000000+H1<<16, 1, Ter , 0};
long int A1[]={0x00000000+H2<<16, 2, 0x01000000+H2<<16, 2, 0x02000000+H2<<16, 2, 0x03000000+H2<<16, 2, 0x04000000+H2<<16, 2, Ter , 1};
long int A2[]={0x01000000       , 0, 0x02000000       , 0, 0x03000000       , 0, 0x04000000       , 0, 0x05000000       , 3, Ter , 2};
long int A3[]={0x00000000       , 0, Ter, 3};

char Tout[] = {0, 1, 2, 3};
long int *TABA[] = {A0, A1, A2, A3};
///////////////////////

/// Time variables ///
char Z = 0; //day
char H = 0; //hour
char M = 0; //minutes
char S = 0; //seconds
/////////////////////


char cnt_time = 0; //contor de timp
char T_SEC; // numar de perioade necesare pentru a acoperi 1 sec
char S2; //starea de contorizare a PS-ului
                         
////// Global variables //////// 
// PULSE
char PULSE;

// Working mode ///
// 0 -> range on 
// 1 -> range off
char MODE = 0;

// Flag (1 -> mode not set yet)
char modeFlag = 1;
///////////////////

// State variables ( Q -> consumption range, 
// S1 -> consumption counting state, 
// S3 -> display state)
char Q,Q1,S3; 

/// Consumption array
//            0 - H1   H1 - H2   H2 - 0   Sat - Sun   Total 
//              ^         ^         ^         ^         ^
int CONSUM[] = {0,        0,        0,        0,        0};

// Digits
char C4, C3, C2, C1;

// CA
char CA;

//Power Level
char PowerLevel = 0;

// Digit patterns (CLC)
const char DIGITS[] = {
   0b11000000, // 0
    0b11111001, // 1
    0b10100100, // 2
    0b10110000, // 3
    0b10011001, // 4
    0b10010010, // 5
    0b10000010, // 6
    0b11111000, // 7
    0b10000000, // 8
    0b10010000  // 9
};
///////////////////////////////


// Power Level (CLC) ///
// char CLC_LEVEL[] = {0x00, 0x10, 0x30, 0x70, 0xF0};  // 4 levels
char CLC_LEVEL[] = {0x00, 0x20, 0x60, 0xE0};           // 3 levels               
////////////////////////

// Consumption range output (CLC) //
char CLC_RANGE_OUTPUT[] = {0x01, 0x02, 0x03, 0x00};
///////////////////////////////////

// Pulses contor
char cntP = 0;

 //// Function headers ////
void Init();
void UpdateConsumption();
void DisplayConsumption();
void DisplayDigit(char currentDisplay, char digit);
void UpdateTime();
void CLS();
void DisplayPowerLevel();
void DisplayConsumptionDisplayMode();
void DisplayInfo();
/////////////////////////


/////// SCI ///////
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    // Reinitialize Timer 0 value
    TCNT0=0x3C; 
    //Update current time
    UpdateTime();
    
    // Update CA
    CA = (PORTD & 0x20) >> 5; 
    
    //DisplayInfo
    DisplayInfo();
    
    // Check for pulses coming from ADSP
    UpdateConsumption();
}
///////////////////

void main(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=(1<<CLKPCE);
CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=Out Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(1<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=1 Bit6=P Bit5=P Bit4=P Bit3=P Bit2=P Bit1=P Bit0=P 
PORTA=(1<<PORTA7) | (1<<PORTA6) | (1<<PORTA5) | (1<<PORTA4) | (1<<PORTA3) | (1<<PORTA2) | (1<<PORTA1) | (1<<PORTA0);

// Port B initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=1 Bit6=1 Bit5=1 Bit4=1 Bit3=1 Bit2=1 Bit1=1 Bit0=1 
PORTB=(1<<PORTB7) | (1<<PORTB6) | (1<<PORTB5) | (1<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);

// Port C initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
// State: Bit7=1 Bit6=1 Bit5=1 Bit4=1 Bit3=1 Bit2=1 Bit1=1 Bit0=1 
PORTC=(1<<PORTC7) | (1<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (1<<PORTC3) | (1<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRD=(0<<DDD7) | (0<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
// State: Bit7=T Bit6=T Bit5=1 Bit4=1 Bit3=1 Bit2=1 Bit1=1 Bit0=1 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (1<<PORTD5) | (1<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (1<<PORTD1) | (1<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 9.766 kHz
// Mode: Normal top=0xFF
// OC0A output: Disconnected
// OC0B output: Disconnected
// Timer Period: 20.07 ms
TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
TCCR0B=(0<<WGM02) | (1<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0x3C;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2A output: Disconnected
// OC2B output: Disconnected
ASSR=(0<<EXCLK) | (0<<AS2);
TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2A=0x00;
OCR2B=0x00;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);

// Timer/Counter 1 Interrupt(s) initialization
TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);

// Timer/Counter 2 Interrupt(s) initialization
TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
// Interrupt on any change on pins PCINT0-7: Off
// Interrupt on any change on pins PCINT8-15: Off
// Interrupt on any change on pins PCINT16-23: Off
// Interrupt on any change on pins PCINT24-31: Off
EICRA=(0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
EIMSK=(0<<INT2) | (0<<INT1) | (0<<INT0);
PCICR=(0<<PCIE3) | (0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);

// USART0 initialization
// USART0 disabled
UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);

// USART1 initialization
// USART1 disabled
UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
ADCSRB=(0<<ACME);
// Digital input buffer on AIN0: On
// Digital input buffer on AIN1: On
DIDR1=(0<<AIN0D) | (0<<AIN1D);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Globally enable interrupts
#asm("sei")

// Initialize the device
Init();

while (1)
      {
      // Display the consumption
      DisplayConsumption();
      
      // Wait for interruptions
      }
}

///// Function definitions /////
void Init()
{
    // Setting initial states = 0
    Q = Q1 = S1 = S2 = S3 = 0;    
    
    // Turn off displays
    PORTC = 0xff;
    PORTD = 0xff;
    PORTB = 0xff;
}

void UpdateConsumption()
{                
    // Identify PULSE    
    /*
    PULSE = PINA & 0x01;
    
    switch(S2) 
    {
        case 0:
        {      
            char cntP = 0;
                       
            // PD6 -> Sending request from ADSP
            // PD7 -> Reading ack from ATmega164A
                
            // Check if sending request flag is up
            // (Receiving sending request on PD6)
            if (PORTD && 0x40)
            {                
                // Send reading ack 
                // (Sending ack on PD7)  
                PORTD |= 0x80;   
                
                // Going further to reading the pulses
                S2 = 1;
            }   
            break;
        }
        case 1:
        {          
            // If PULSE is on, start counting
            if (PULSE)
            {   
                // Increment cntP          
                cntP += 1;   
                
                // Reset reading flag
                PORTD &= 0x7f;   
                
                // Go further if the pulse period has passed,
                // otherwise go back wait for sensding ack again.
                S2 = (cntP == DP) ? 2 : 1;
            }
            break;
        }
        case 2:
        {
            if (~PULSE)
            {   
                // Update current consumption range
                Q = CLS();
                
                // Increment consumption
                CONS[Q] += 1;
                
                // Wait for another pulse
                S2 = 0;
            }          
            break;  
        }   
    } */     
                      
    ///// PORT F /////////////
    // _   _ _ _ : _ _ _  _ // 
    // M   P O W   E E R PU //
    
    // Reading the power level
    PowerLevel = (PINA & 0x7E) >> 1;   
    PULSE = PINA & 0x01;
    
     switch(S2) 
    {
        case 0:
        {          
            // If PULSE is on, start counting
            if (PULSE)
            {   
                // Increment cntP          
                cntP += 1;   
                
                // Reset reading flag
                // PORTD &= 0x7f;       
                
                if (modeFlag) 
                {
                    MODE = (PINA & 0x80) >> 7; 
                    modeFlag = 0;
                }
                
                // Go further if the pulse period has passed,
                // otherwise go back wait for sensding ack again.
                S2 = (cntP == DP) ? 1 : 0;
            }
            break;
        }
        case 1:
        {
            if (~PULSE)
            {   
                // Update current consumption range
                CLS();
                
                // Increment consumption 
                if (MODE == 0)
                {
                    CONSUM[Q] += 1;    // Working range on
                }
                else
                {
                    CONSUM[4] += 1;    // Working range off   
                }
                
                // Wait for another pulse
                S2 = 0;
                cntP = 0;
            }          
            break;  
        }   
    }
}


void DisplayConsumption()
{
    // We assume:
    // PORTC: PC0 - PC6 -> 7 segments (A-G)
    // PORTD: PD0 - PD3 -> select the common cathode for each digit (multiplexing)
              // PD3 - C4, PD2 - C3, PD1 - C2, PD0 - C1  
    // Q - consumption range:
        // 0 -> 00:00 - H1:00
        // 1 -> H1:00 - H2:00               (MON - FRI)
        // 2 -> H2:00 - 00:00 (next day)
        // 3 -> SAT - SUN
    
    // The actual approach:
    // Each main loop iteration we multiplex the digits and display one at a time
      
    // If MODE = 1 -> display total consumption,
    // else -> display consumption based on current range.    
    int cons = (MODE) ?  CONSUM[4] : CONSUM[Q1];    
     
    // Compute and display C4
    C4 = cons / 1000;  
    cons %= 1000;
    DisplayDigit(4, C4); 
    
    // Compute and display C3  
    C3 = cons / 100; 
    cons %= 100;   
    DisplayDigit(3, C3);
    
    // Compute and display C2
    C2 = cons / 10;
    DisplayDigit(2, C2); 
    
    // Compute and display C1
    C1 = cons % 10;
    DisplayDigit(1, C1);
}

void DisplayDigit(char currentDisplay, char digit)
{
    // Set PORTC pins to the corresponding digit
   // PORTC = DIGITS[digit];
    
    // Select the desired display (turn on the pin
    // corresponding to the desired digit (C4/C3/C2/C1) 
    char output = 0xff;
         
    switch (currentDisplay)
    {
        case 4:       
            // Turn PD3 on 
            //output &= 0b00000111;  
            output = 0x08;  
            break;
        case 3:       
            // Turn PD2 on
            // output &= 0b00001011; 
            output = 0x04;    
            break;  
        case 2:       
            // Turn PD1 on
            output = 0x02;     
            break; 
        case 1:       
            // Turn PD0 on
            output = 0x01;     
            break;
    }
            
    // Assign output to PORTC in order to select the desired display;
    PORTD = output;  
    
    // Set PORTC pins to the corresponding digit
    PORTC = DIGITS[digit]; 
    
    // Add delay (10 us)
    //_display_us(10); 
}


void UpdateTime(){ 
    cnt_time += 1; //incrementare contor de timp
    if(cnt_time != T_SEC) return; 
    
    cnt_time = 0; // se reseteaza contorul 
    S+=1;  //incrementeaza contor secunde
    
    if(S!=60) return; 
    S = 0;//se reseteaza nr de secunde
    M += 1; //incrementeaza contor minute
    
    if(M!=60) return;
    M = 0;
    H += 1;
    
    if(H!=24) return;
    H = 0;
    Z += 1;
    
    if (Z == 7) Z = 0;
    return;
}

 

void CLS()
{
    //exemplu
    // Ziua 3, ora 8, min 6, sec 3
    //0x03080603
    long int now = (Z<<24) | (H<<16) | (M<<8) | S;

    long int *adr = TABA[Q];
    char ready = 0;
    int i = 0;
    long int out = 0; 
    
    while (!ready)
    {
        if (now == adr[i]) {
            S1 = adr[i + 1];
            ready = 1;  // Stop iterating through while
        }
        else if (adr[i] == T) ready = 1;
        else i = i+2;
    }
}

void DisplayInfo()
{
    DisplayConsumptionDisplayMode();
    DisplayPowerLevel();
}

void DisplayPowerLevel()
{
   char out;
   
//   if (!PowerLevel)          PowerLevel = 0 kW
//   {
//        out = CLC_LEVEL[0];
//   }                       
//   else if (PowerLevel < 2.5)    0 < PowerLevel < 2.5 kW
//   {
//        out = CLC_LEVEL[1];
//   }  
//   else if (PowerLevel < 5)      2.5 <= PowerLevel < 5 kW
//   {
//        out = CLC_LEVEL[2];
//   }  
//   else if (PowerLevel < 7.5)    5 <= PowerLevel < 7.5 kW
//   {
//        out = CLC_LEVEL[3];
//   }
//   else                          PowerLvel >= 7.5 kW
//   {
//        out = CLC_LEVEL[4];
//   }    
   
   if (!PowerLevel)         // PowerLevel = 0 kW
   {
        out = CLC_LEVEL[0];
   }                       
   else if (PowerLevel < 3)   // 0 < PowerLevel < 3 kW
   {
        out = CLC_LEVEL[1];
   }  
   else if (PowerLevel < 6)     // 3 <= PowerLevel < 6 kW
   {
        out = CLC_LEVEL[2];
   }  
   else                         // PowerLvel >= 6 kW
   {
        out = CLC_LEVEL[3];
   }  
                   
   // Delete PB7-PB5
   PORTB &= 0x1f;       
   
   // Display out on PB7-PB5
   PORTB |= out;  
}

void DisplayConsumptionDisplayMode()
{
    char out;
    
    if (MODE == 1)  // Working without ranges
    {            
        // Clear PB4-0
        PORTB &= 0xE0;
        
        // Display on PB4-0
        PORTB |= 0x10; 
        
        return;
    }
          
    switch(S3)
    {
        case 0:                 
        {
            if (CA == 0)            // Pressed CA
            {
                S3 = 1;  
            }
            break;
        }
        case 1:                 // Released CA
        {
            if (CA) 
            {
                S3 = 2;  
                Q1 = 1;
            }
            break;
        }
        case 2:                //  Pressed CA
        {
            if (CA == 0) 
            {
                S3 = 3;  
            }
            break;
        }
        case 3:                // Released CA
        {
            if (CA) 
            {
                S3 = 4;  
                Q1 = 2;
            }
            break;
        }
        case 4:
        {
            if (CA == 0) 
            {
                S3 = 5;  
            }
            break;
        }
        case 5:
        {
            if (CA) 
            {
                S3 = 6; 
                Q1 = 3; 
            }
            break;
        }    
        case 6:
        {
            if (CA == 0) 
            {
                S3 = 7;  
            }
            break;
        }
        case 7:
        {
            if (CA) 
            {
                S3 = 0; 
                Q1 = 0; 
            }
            break;
        }      
    } 
      
    out = CLC_RANGE_OUTPUT[Q1] | (CLC_RANGE_OUTPUT[Q] << 2);
    
    // Delete PB4-PB0
    PORTB &= 0xE0;   
   
    // Display out on PB3-PB0
    PORTB |= out; 
}
////////////////////////////////////////