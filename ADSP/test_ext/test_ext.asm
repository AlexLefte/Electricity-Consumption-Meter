/*	

	Acest program initializeaza placa de dezvoltare EZ_LITE 2181
	 - procesorul ADSP2181 ( mod de lucru)
	 - codecul AD1847
	- testeaza extensia IO pentru EZ-KIT_LITE
	- porul de intrare ( citire SW) - la adresa 0x1FF
	- portul de iesire ( afisare ) - la adresa 0xFF
	- testeaza PF ports
*/


#include    "def2181.h"    

// Output port
#define PORT_OUT 0xFF

// Input port
#define PORT_IN 0x1FF

// DP and T
#define DP 1
#define T 5

.SECTION/DM		buf_var1;
.var    rx_buf[3];      /* Status + L data + R data */

.SECTION/DM		buf_var2;
.var    	tx_buf[3] = 0xc000, 0x0000, 0x0000;      /* Cmd + L data + R data    */

.SECTION/DM		buf_var3;
.var    init_cmds[13] = 0xc002,     /*
                        				Left input control reg
                        				b7-6: 0=left line 1
                              			1=left aux 1
                              			2=left line 2
                              			3=left line 1 post-mixed loopback
                        			b5-4: res
                        			b3-0: left input gain x 1.5 dB
                    				*/
        				0xc102,     /*
                        				Right input control reg
                        				b7-6: 0=right line 1
                              				1=right aux 1
                              				2=right line 2
                              				3=right line 1 post-mixed loopback
                        				b5-4: res
                        				b3-0: right input gain x 1.5 dB
                    				*/
        				0xc288,     /*
                        				left aux 1 control reg
                        				b7  : 1=left aux 1 mute
                        				b6-5: res
                        				b4-0: gain/atten x 1.5, 08= 0dB, 00= 12dB
                    				*/
        				0xc388,     /*
                        				right aux 1 control reg
                        				b7  : 1=right aux 1 mute
                        				b6-5: res
                        				b4-0: gain/atten x 1.5, 08= 0dB, 00= 12dB
                    				*/
        				0xc488,     /*
                        				left aux 2 control reg
                        				b7  : 1=left aux 2 mute
                        				b6-5: res
                        				b4-0: gain/atten x 1.5, 08= 0dB, 00= 12dB
                    				*/
        				0xc588,     /*
                        				right aux 2 control reg
                        				b7  : 1=right aux 2 mute
                        				b6-5: res
                        				b4-0: gain/atten x 1.5, 08= 0dB, 00= 12dB
                    				*/
        				0xc680,     /*
                        				left DAC control reg
                        				b7  : 1=left DAC mute
                        				b6  : res
                        				b5-0: attenuation x 1.5 dB
                    				*/
        				0xc780,     /*
                        				right DAC control reg
                        				b7  : 1=right DAC mute
                        				b6  : res
                        				b5-0: attenuation x 1.5 dB
                    				*/
        				0xc85c,     /*
                        				data format register
                        				b7  : res
                        				b5-6: 0=8-bit unsigned linear PCM
                              				1=8-bit u-law companded
                              				2=16-bit signed linear PCM
                              				3=8-bit A-law companded
                        				b4  : 0=mono, 1=stereo
                        				b0-3: 0=  8.
                              				1=  5.5125
                              				2= 16.
                              				3= 11.025
                              				4= 27.42857
                              				5= 18.9
                              				6= 32.
                              				7= 22.05
                              				8=   .
                              				9= 37.8
                              				a=   .
                              				b= 44.1
                              				c= 48.
                              				d= 33.075
                              				e=  9.6
                              				f=  6.615
                       				(b0) : 0=XTAL1 24.576 MHz; 1=XTAL2 16.9344 MHz
                    				*/
        				0xc909,     /*
                        				interface configuration reg
                        				b7-4: res
                        				b3  : 1=autocalibrate
                        				b2-1: res
                        				b0  : 1=playback enabled
                    				*/
        				0xca00,     /*
                        				pin control reg
                        				b7  : logic state of pin XCTL1
                       					b6  : logic state of pin XCTL0
                        				b5  : master - 1=tri-state CLKOUT
                              				slave  - x=tri-state CLKOUT
                        				b4-0: res
                    				*/
        				0xcc40,     /*
	THIS PROGRAM USES 16 SLOTS PER FRAME
                        				miscellaneous information reg
                        				b7  : 1=16 slots per frame, 0=32 slots per frame
                        				b6  : 1=2-wire system, 0=1-wire system
                        				b5-0: res
                    				*/
        				0xcd00;     /*
                        				digital mix control reg
                        				b7-2: attenuation x 1.5 dB
                        				b1  : res
                        				b0  : 1=digital mix enabled
                    				*/

.SECTION/DM		data1;
.var        stat_flag;

// PF port
.var 	PF_input;
.var 	PF_output;

.var cntP = 0; 		// period counter
.var dT;  			// Sampling period
.var cntDT; 		// Sampling period counter
.var MODE = 0;		// Working mode (0 -> with working ranges)
.var U;				// Voltage
.var I;				// Current
.var E[2] = {0, 0};	// Energy (Ws)
.var n;				// Number of pulses to send
.var Q;  			// PS state
.var cntG;          // Pulse generator counter
.var P;				// Power
.var Threshold[2] = {0, 0};		// Power threshold to generate a pulse 
.var PulsesNumber;	// Pulses number / KWh
.var PulsesNumberIndex;
.var dTIndex;
.var noInterr = 80;  // No of interrupts to cover the sampling rate
.var cntInterr = 0;  // Interr counter 
.var SUB_MSB;
.var SUB_LSB;

.var TAB_PULSES[4] = {1, 2, 4, 8};	// Number of pulses/kWh -> 1/2/4/8;
.var TAB_THRESHOLDS[8] = {0, 0x5A, 0, 0x5A, 0x3, 0x6EE8, 0x1, 0xB774};
.var TAB_SAMPLING_PERIODS_INT[4] = {50, 3000, 30000, 60000}; // Necessary interrupts to cover: 1s/1m/5m/10m
.var TAB_SAMPLING_PERIODS[4] = {1, 60, 300, 600}; // Time in seconds
.SECTION/PM		pm_da;


/*** Interrupt Vector Table ***/
.SECTION/PM     interrupts;
		jump start;  rti; rti; rti;     /*00: reset */
      
		jump sci;    rti; rti; rti;	/*04: IRQ2 */
		
        rti;         rti; rti; rti;     /*08: IRQL1 */
        rti;         rti; rti; rti;     /*0c: IRQL0 */
        ar = dm(stat_flag);             /*10: SPORT0 tx */
        ar = pass ar;
        if eq rti;
        jump next_cmd;
        jump sci;             /*14: SPORT0 rx */
                     rti; rti; rti;
        rti;         rti; rti; rti;     /*18: IRQE */
        rti;         rti; rti; rti;     /*1c: BDMA */
        rti;         rti; rti; rti;     /*20: SPORT1 tx or IRQ1 */
        rti;         rti; rti; rti;     /*24: SPORT1 rx or IRQ0 */
        nop;         rti; rti; rti;     /*28: timer */
        rti;         rti; rti; rti;     /*2c: power down */


.SECTION/PM		seg_code;
/*******************************************************************************
 *
 *  ADSP 2181 intialization
 *
 *******************************************************************************/
start:
        /*   shut down sport 0 */
        ax0 = b#0000100000000000;   
		dm (Sys_Ctrl_Reg) = ax0;
		ena timer;

        i5 = rx_buf;
        l5 = LENGTH(rx_buf);
        i6 = tx_buf;
        l6 = LENGTH(tx_buf);
        i3 = init_cmds;
        l3 = LENGTH(init_cmds);

        m1 = 1;
        m5 = 1;


/*================== S E R I A L   P O R T   #0   S T U F F ==================*/
        ax0 = b#0000110011010111;   dm (Sport0_Autobuf_Ctrl) = ax0;
            /*  |||!|-/!/|-/|/|+- receive autobuffering 0=off, 1=on
                |||!|  ! |  | +-- transmit autobuffering 0=off, 1=on
                |||!|  ! |  +---- | receive m?
                |||!|  ! |        | m5
                |||!|  ! +------- ! receive i?
                |||!|  !          ! i5
                |||!|  !          !
                |||!|  +========= | transmit m?
                |||!|             | m5
                |||!+------------ ! transmit i?
                |||!              ! i6
                |||!              !
                |||+============= | BIASRND MAC biased rounding control bit
                ||+-------------- 0
                |+--------------- | CLKODIS CLKOUT disable control bit
                +---------------- 0
            */

        ax0 = 0;    dm (Sport0_Rfsdiv) = ax0;
            /*   RFSDIV = SCLK Hz/RFS Hz - 1 */
        ax0 = 0;    dm (Sport0_Sclkdiv) = ax0;
            /*   SCLK = CLKOUT / (2  (SCLKDIV + 1) */
        ax0 = b#1000011000001111;   dm (Sport0_Ctrl_Reg) = ax0;
            /*  multichannel
                ||+--/|!||+/+---/ | number of bit per word - 1
                |||   |!|||       | = 15
                |||   |!|||       |
                |||   |!|||       |
                |||   |!||+====== ! 0=right just, 0-fill; 1=right just, signed
                |||   |!||        ! 2=compand u-law; 3=compand A-law
                |||   |!|+------- receive framing logic 0=pos, 1=neg
                |||   |!+-------- transmit data valid logic 0=pos, 1=neg
                |||   |+========= RFS 0=ext, 1=int
                |||   +---------- multichannel length 0=24, 1=32 words
                ||+-------------- | frame sync to occur this number of clock
                ||                | cycle before first bit
                ||                |
                ||                |
                |+--------------- ISCLK 0=ext, 1=int
                +---------------- multichannel 0=disable, 1=enable
            */
            /*  non-multichannel
                |||!|||!|||!+---/ | number of bit per word - 1
                |||!|||!|||!      | = 15
                |||!|||!|||!      |
                |||!|||!|||!      |
                |||!|||!|||+===== ! 0=right just, 0-fill; 1=right just, signed
                |||!|||!||+------ ! 2=compand u-law; 3=compand A-law
                |||!|||!|+------- receive framing logic 0=pos, 1=neg
                |||!|||!+-------- transmit framing logic 0=pos, 1=neg
                |||!|||+========= RFS 0=ext, 1=int
                |||!||+---------- TFS 0=ext, 1=int
                |||!|+----------- TFS width 0=FS before data, 1=FS in sync
                |||!+------------ TFS 0=no, 1=required
                |||+============= RFS width 0=FS before data, 1=FS in sync
                ||+-------------- RFS 0=no, 1=required
                |+--------------- ISCLK 0=ext, 1=int
                +---------------- multichannel 0=disable, 1=enable
            */


        ax0 = b#0000000000000111;   dm (Sport0_Tx_Words0) = ax0;
            /*  ^15          00^   transmit word enables: channel # == bit # */
        ax0 = b#0000000000000111;   dm (Sport0_Tx_Words1) = ax0;
            /*  ^31          16^   transmit word enables: channel # == bit # */
        ax0 = b#0000000000000111;   dm (Sport0_Rx_Words0) = ax0;
            /*  ^15          00^   receive word enables: channel # == bit # */
        ax0 = b#0000000000000111;   dm (Sport0_Rx_Words1) = ax0;
            /*  ^31          16^   receive word enables: channel # == bit # */


/*============== S Y S T E M   A N D   M E M O R Y   S T U F F ==============*/
        ax0 = b#0001100000000000;   dm (Sys_Ctrl_Reg) = ax0;
            /*  +-/!||+-----/+-/- | program memory wait states
                |  !|||           | 0
                |  !|||           |
                |  !||+---------- 0
                |  !||            0
                |  !||            0
                |  !||            0
                |  !||            0
                |  !||            0
                |  !||            0
                |  !|+----------- SPORT1 1=serial port, 0=FI, FO, IRQ0, IRQ1,..
                |  !+------------ SPORT1 1=enabled, 0=disabled
                |  +============= SPORT0 1=enabled, 0=disabled
                +---------------- 0
                                  0
                                  0
            */



        ifc = b#00000011111110;         /* clear pending interrupt */
        nop;


        icntl = b#00010;
            /*    ||||+- | IRQ0: 0=level, 1=edge
                  |||+-- | IRQ1: 0=level, 1=edge
                  ||+--- | IRQ2: 0=level, 1=edge
                  |+---- 0
                  |----- | IRQ nesting: 0=disabled, 1=enabled
            */


        mstat = b#1100000;
            /*    ||||||+- | Data register bank select
                  |||||+-- | FFT bit reverse mode (DAG1)
                  ||||+--- | ALU overflow latch mode, 1=sticky
                  |||+---- | AR saturation mode, 1=saturate, 0=wrap
                  ||+----- | MAC result, 0=fractional, 1=integer
                  |+------ | timer enable
                  +------- | GO MODE
            */


//

// si = IO(PORT_IN);

// Read the working mode
// AR = si;
// AY0 = 0x0001;
// AR = AR AND AY0;
// dm(MODE) = AR;

// Read the sampling rate
// AR = si;
// AY0 = 0x0002;
// AR = AR AND AY0;
// dm(dT) = AR;

jump skip;

//

/*******************************************************************************
 *
 *  ADSP 1847 Codec intialization
 *
 *******************************************************************************/

        /*   clear flag */
        ax0 = 1;
        dm(stat_flag) = ax0;

        /*   enable transmit interrupt */
        ena ints;
        imask = b#0001000001;
            /*    |||||||||+ | timer
                  ||||||||+- | SPORT1 rec or IRQ0
                  |||||||+-- | SPORT1 trx or IRQ1
                  ||||||+--- | BDMA
                  |||||+---- | IRQE
                  ||||+----- | SPORT0 rec
                  |||+------ | SPORT0 trx
                  ||+------- | IRQL0
                  |+-------- | IRQL1
                  +--------- | IRQ2
            */


        ax0 = dm (i6, m5);          /* start interrupt */
        tx0 = ax0;

check_init:
        ax0 = dm (stat_flag);       /* wait for entire init */
        af = pass ax0;              /* buffer to be sent to */
        if ne jump check_init;      /* the codec            */

        ay0 = 2;
check_aci1:
        ax0 = dm (rx_buf);          /* once initialized, wait for codec */
        ar = ax0 and ay0;           /* to come out of autocalibration */
        if eq jump check_aci1;      /* wait for bit set */

check_aci2:
        ax0 = dm (rx_buf);          /* wait for bit clear */
        ar = ax0 and ay0;
        if ne jump check_aci2;
        idle;

        ay0 = 0xbf3f;               /* unmute left DAC */
        ax0 = dm (init_cmds + 6);
        ar = ax0 AND ay0;
        dm (tx_buf) = ar;
        idle;

        ax0 = dm (init_cmds + 7);   /* unmute right DAC */
        ar = ax0 AND ay0;
        dm (tx_buf) = ar;
        idle;


        ifc = b#00000011111110;     /* clear any pending interrupt */
        nop;

		imask = b#0001110001;       /* enable rx0 interrupt */
            /*    |||||||||+ | timer
                  ||||||||+- | SPORT1 rec or IRQ0
                  |||||||+-- | SPORT1 trx or IRQ1
                  ||||||+--- | BDMA
                  |||||+---- | IRQE
                  ||||+----- | SPORT0 rec
                  |||+------ | SPORT0 trx
                  ||+------- | IRQL0
                  |+-------- | IRQL1
                  +--------- | IRQ2
            */

/*   end codec initialization, begin filter demo initialization */

skip: imask = 0x200;

// wait states

si=0xFFFF;
dm(Dm_Wait_Reg)=si;

// call init;

// PF ports
si = 0x007f;
dm(Prog_Flag_Comp_Sel_Ctrl) = si; // PF7 - Input && PF0-6 outputs 

ena m_mode;
ax0 = 0;
dm(MODE) = ax0;		// Mode 0 => working range on
ax0 = 50;
dm(cntDT) = ax0; 	// Interr -> every 20ms => cntDT = 50
ax0 = 1;
dm(dT) = ax0; 
ax0 = 4;
dm(PulsesNumber) = ax0;	// Pulses / kWh

	/*
	// Get input data
    ay0 = IO(PORT_IN);
	ax0 = 0x0003;
	ar = ax0 and ay0;
	dm(PulsesNumberIndex) = ar;
	ax0 = 0x000a;
	ar = ax0 and ay0;
	sr = LSHIFT ar BY (-2) (LO); 
	dm(dTIndex) = sr;
	ax0 = 0x0010;
	ar = ax0 and ayo;
	sr = LSHIFT ar BY (-4) (LO);
	dm(MODE) = sr;
	
	// Get Pulses number & Sampling rate
	i3 = TAB_PULSES;
	l3 = 4;
	m3 = dm(PulsesNumberIndex)
	ar = dm(i3, m3);
	dm(PulsesNumber) = ar;
	
	i3 = TAB_SAMPLING_PERIODS_INT;
	l3 = 4;
	m3 = dm(dTIndex)
	ar = dm(i3, m3);
	dm(dT) = ar;	
	*/

// COMPUTE_THRESHOLD:
ena m_mode;
i4 = TAB_THRESHOLDS;
m4 = 2;
l4 = 0;
ax0 = 1;					// PulseIndex
dm(PulsesNumberIndex) = ax0;

cntr = dm(PulsesNumberIndex);
do sop until ce;
sop: modify(i4, m4);

m4 = 1;
mr0 = dm(i4, m4);
dm(Threshold) = mr0;
mr0 = dm(i4, m4);
dm(Threshold + 1) = mr0;

/* // Computing the hard way
ax1 = dm(PulsesNumber);
ay0 = 3600;				// ay0 = 1kWh = 3600 kWs
ay1 = 0;

DIVS ay1, ax1; 
DIVQ ax1; DIVQ ax1; 
DIVQ ax1; DIVQ ax1; 
DIVQ ax1; DIVQ ax1; 
DIVQ ax1; DIVQ ax1; 
DIVQ ax1; DIVQ ax1; 
DIVQ ax1; DIVQ ax1; 
DIVQ ax1; DIVQ ax1; 
DIVQ ax1; DIVQ ax1;

mx0 = ay0;
my0 = 1000;				// Get the result in Ws
mr = mx0 * my0 (uu);
	
dm(Threshold) = mr0;
dm(Threshold + 1) = mr1; */


/* wait for char to go out */
wt:

		nop;
        jump wt;


/*------------------------------------------------------------------------------
 -
 -  SPORT0 interrupt handler
 -
 ------------------------------------------------------------------------------*/
 
sci:
        ena sec_reg;                /* use shadow register bank */      
        
        // Implementing a counter in order to sync with ATmega 
        // (which has timing interrupts at every 20ms;
        ay0 = dm(cntP);		// Read current interrupts counter
        ar = ay0 + 1;		// Increment the interrupts counter
        dm(cntP) = ar;		// Save the result
        
        ay0 = dm(Q);		// Read current state
        ar = PASS ay0;		// ar = 0 + Q
        if eq jump Q0;		// If ar = Q = 0 => jump towards Q0
        
        ar = ay0 - 1;		// ar = Q - 1
        if eq jump Q1;		// If ar = 0 => jump towards Q1
        
        ax0 = 2;		
        ar = ay0 - ax0;		// ar = Q - 2
        if eq jump Q2;		// If ar = 0 => jump towards Q2
        
        ax0 = 3;
        ar = ay0 - ax0;		// ar = Q - 3
        if eq jump Q3;	// If ar = 0 => jump towards Q3
        
        ax0 = 4;
        ar = ay0 - ax0;		// ar = Q - 4
        if eq jump Q4;	// If ar = 0 => jump towards Q4
        
        ax0 = 5;
        ar = ay0 - ax0;		// ar = Q - 5
        if eq jump Q5;	// If ar = 0 => jump towards Q5
        rti;
        
Q0:
		// Here we check whether the sampling rate was
		// acomplished.
        ax0 = dm(cntDT);		// Get the interrupts counter value
        ay0 = dm(cntP);			// Get the necessary interrupts number
        af = ax0 - ay0;			// Compute cntInterrupts - cntInterrupts
        if le jump GO_Q1;		// If not cntDT - cntP <= 0 => read new samples
    	rti;					// Otherwise => return
        
        GO_Q1:
        ax1 = 0;
        dm(cntP) = ax1;			// Reset cntP
        ax1 = 1; 
        dm(Q) = ax1;
        rti;
///////////////////////////////////////////////////       
        
//////////////////// Q = 1 ////////////////////////
Q1:        
        // Compute consumption:      
        ax1 = 0;					// Write PULSE = 0 at 0xFF
        IO(PORT_OUT) = ax1;
        
		// Read U & I    
        mx0 = dm (rx_buf + 2); 	// Citeste senzorii de tensiune & curent
        my0 = dm (rx_buf + 1);
        
        // mx0 = 1000;         // U * I = 1000 V * 900 A = 
        // my0 = 450;			// = 900,000 Ws (not realistic) 
        
        // Compute dE
        mr = mx0 * my0 (uu);	// mr = U * I
        dm(P) = mr0;			// P (power) = U * I
        mx1 = dm(dT);			// mx1 = dT
        my1 = mr0;				// my1 = U * I
        mr1 = dm(E);			// mr = E
        mr0 = dm(E + 1);
        mr =  mr + mx1 * my1 (uu); 	// mr = E + U * I * dT = E + dE 			
        dm(E) = mr1;				// Save E = E'
        dm(E + 1) = mr0;
        
        ax1 = dm(E);
        ax0 = dm(E + 1);
        
        ay1 = dm(Threshold);
        ay0 = dm(Threshold + 1);
        
        DIS AR_SAT;
		ar = ax0 - ay0;
		ar = ax1 - ay1 + C - 1, ax0 = ar;
		ax1 = ar;
        if lt rti;			
        
        // COMPUTE_N:      
        si = 1;
        DIVIDE:
        // ax1 ax0 -> E
        // ay1 ay0 -> TH
        // Save last iteration's result:
        dm(E) = ax1;
        dm(E + 1) = ax0;
        
        DIS AR_SAT;
		ar = ax0 - ay0;
		ar = ax1 - ay1 + C - 1, ax0 = ar;
		ax1 = ar;
        if lt jump STOP;
        ar = si;
        ar = ar + 1;
        si = ar;
        jump DIVIDE;
        
        STOP:
        dm(n) = si;      
        ax1 = 2;
        dm(Q) = ax1;				// Q = 2;
        rti;
        
//////////////////////////////////////////////////////////
        
    
///////////// Q = 2 ///////////
Q2:
        // Compute consumption:      
        ax1 = 0;					// Write PULSE = 0 at 0xFF
        IO(PORT_OUT) = ax1;
		ax0 = 1;
        ax1 = 3;
        ay0 = 0;
		ay1 = dm(n);			// ay0 = n 
        af = PASS ay1;			// ar = n 
        if le ar = ax0 + ay0; 	// if n <= 0 => return to Q0
        if gt ar = ax1 + ay0;	// else => return to Q1
        dm(Q) = ar;				// Go to Q = 3
        rti;        
//////////////////////////////
        
       
//////////// Q = 3 ///////////
Q3:
        // Generating the pulse //
        /*
        ar = dm(P);				// ax0 = P
        sr = LSHIFT ar BY 1 (LO); 	// sr = P << 1
        */
        // ax1 = 1;			// Set PULSE = 1
        // ay1 = sr0;
        // ar = ax1 or ay1;		
        
        ax1 = 1;				
        // dm(Prog_Flag_Data) = ax1;	// PF = RPPP PPP1 (PULSE = 1)
        IO(PORT_OUT) = ax1;		// Write PULSE = 1 at 0xFF
        ay1 = dm(cntG);
        ar = ay1 + 1;           // Increment cnt
        dm(cntG) = ar;
        ax1 = ar;				// ax1 = cnt
        ay1 = DP;				// ay1 = DP
        af = ax1 - ay1;
        ar = 3;				// Next state => default 3
        if eq ar = ar + 1; 	// If cntG = DP => Go to Q4
        dm(Q) = ar;			// Set Q state value
		rti;
//////////////////////////////
               
//////////// Q = 4 ///////////
Q4:
        /*
		ar = dm(P);					// ax0 = P
        sr = LSHIFT ar BY 1; 		// sr = P << 1		
        dm(Prog_Flag_Data) = sr;	// PORTF = PPPP PPP0 (PULSE = 0)
        */
        ax1 = 0;					// Write PULSE = 0 at 0xFF
        IO(PORT_OUT) = ax1;
        ay1 = dm(cntG);
        ar = ay1 + 1;				// Increment cnt
        dm(cntG) = ar;
        ax1 = T;
        ay1 = ar;
        af = ax1 - ay1;				// Check whether cnt = T
        ar = 4;
        if eq ar = ar + 1;		// If so, go to Q = 5
        dm(Q) = ar;
        rti;
//////////////////////////////
 

//////////// Q = 5 ///////////
Q5:
		// Compute consumption:      
        ax1 = 0;					// Write PULSE = 0 at 0xFF
        IO(PORT_OUT) = ax1;
		ax0 = 0;
		dm(cntG) = ax0;
        ay1 = dm(n);
        ar = ay1 - 1;
        dm(n) = ar;
        if gt jump GO_TO_Q3;
        // if le jump UPDATE_INFO;
        ax0 = 0;
        dm(Q) = ax0;
        rti;
        
        GO_TO_Q3:
        ax0 = 3;
        dm(Q) = ax0;	  // Switch to Q = 3
        rti;
        
        /*
        UPDATE_INFO:
        ax1 = IO(PORT_IN);		// Read input;
        ay1 = 0x0003;
        ar = ax1 and ay1;		// Read sampling period
        dm(dT) = ar;
        ay1 = 0x000A0;
        ar = ax1 and ay1;
        sr = LSHIFT ar BY (-2) (LO);  // Shift towards right >> 2
        dm(PulsesNumber) = sr0;		  // Read pulses number / KWh
        ax0 = 0;
        dm(Q) = ax0;					  // 
        rti;
        */
//////////////////////////////

nofilt: /*sr=ashift sr1 by -1 (hi);*/   /* save the audience's ears from damage */
        mr1=sr1;
        
        // si=IO(PORT_IN);
        // IO(PORT_OUT)=si;
output:
        dm (tx_buf + 1) = mr1;      /* filtered output to SPORT (to spkr) */
        dm (tx_buf + 2) = mr1;      /* filtered output to SPORT (to spkr) */
        
        //
        
        // test PF
		// PF inputs 0-3
		ax0=dm(Prog_Flag_Data);
		ay0=0x000F;
		ar=ax0 and ay0;
		dm(PF_input)=ar;
		// PF outputs 4-7
		ar=dm(PF_output);
		sr=lshift ar by 4 (hi);
		ax0=sr1;
		dm(Prog_Flag_Data)=ax0;     
        rti;
		
/*------------------------------------------------------------------------------
 -
 -  transmit interrupt used for Codec initialization
 -
 ------------------------------------------------------------------------------*/
next_cmd:
        ena sec_reg;
        ax0 = dm (i3, m1);          /* fetch next control word and */
        dm (tx_buf) = ax0;          /* place in transmit slot 0    */
        ax0 = i3;
        ay0 = init_cmds;
        ar = ax0 - ay0;
        if gt rti;                  /* rti if more control words still waiting */
        ax0 = 0xaf00;               /* else set done flag and */
        dm (tx_buf) = ax0;          /* remove MCE if done initialization */
        ax0 = 0;
        dm (stat_flag) = ax0;       /* reset status flag */
        rti;



