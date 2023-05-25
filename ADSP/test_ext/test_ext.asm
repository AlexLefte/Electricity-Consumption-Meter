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
#define DP 2
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
.var out;
.var init;
.var firstPulse = 0;


// Testing section
.var testMode = 1;
.var testPower;
.var cntTest = 0;
//////////////////

.var TAB_PULSES[4] = {10000, 5000, 2500, 1250};	// Number of pulses/kWh -> 1/2/4/8;
.var TAB_THRESHOLDS[8] = {0, 0x168, 0, 0x2D0, 0, 0x5A0, 0, 0xB40};
.var TAB_SAMPLING_PERIODS_INTER[4] = {50, 3000, 30000, 60000}; // Necessary interrupts to cover: 1s/1m/5m/10m
.var TAB_SAMPLING_PERIODS[4] = {1, 60, 300, 600}; // Time in seconds
.var TAB_U[6] = {200 ,210, 220, 230, 240, 250}; // Voltages
.var TAB_I[29] = {0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6, 7}; 
.var EXP_1[29] = {0, -2, -1, -2, 0, -2, -1, -2, 0, -2, -1, -2, 0, -2, -1, -2, 0, -2, -1, -2, 0, -2, -1, -2, 0, -2, -1, -2, 0};
.var EXP_2[29] = {1, 1, 1, 3, 1, 1, 1, 3, 1, 1, 1, 3, 1, 1, 1, 3, 1, 1, 1, 3, 1, 1, 1, 3, 1, 1, 1, 3, 1};
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
// Set init flag false
ax0 = 0;
dm(init) = ax0;

// PF ports
si = 0x007f;
dm(Prog_Flag_Comp_Sel_Ctrl) = si; // PF7 - Input && PF0-6 outputs 

ena m_mode;

ax0 = dm(testMode);
ar = ax0 - 1;
if eq jump TEST_MODE;

// Get input data
ax0 = 0x00;				
IO(PORT_IN) = ax0;
ay0 = IO(PORT_IN);
ax0 = 0x03;
ar = ax0 and ay0;
dm(dTIndex) = ar;
ax0 = 0x0c;
ar = ax0 and ay0;
sr = LSHIFT ar BY (-2) (LO); 
dm(PulsesNumberIndex) = sr0;
ax0 = 0x10;
ar = ax0 and ay0;
sr = LSHIFT ar BY (-4) (LO);
dm(MODE) = sr0;
	
// Get Pulses number & Sampling rate
i3 = TAB_PULSES;
// l4 = 1;
m3 = dm(PulsesNumberIndex);
modify(i3, m3);
mx0 = dm(i3, m3);
dm(PulsesNumber) = mx0;	

i3 = TAB_SAMPLING_PERIODS_INTER;
m3 = dm(dTIndex);
modify(i3, m3);
ax0 = dm(i3, m3);
dm(cntDT) = ax0;

i3 = TAB_SAMPLING_PERIODS;
m3 = dm(dTIndex);
modify(i3, m3);
ax0 = dm(i3, m3);
dm(dT) = ax0;	


// COMPUTE_THRESHOLD:
ena m_mode;
mx0 = 2;
my0 = dm(PulsesNumberIndex);
mr = mx0 * my0 (uu);
i3 = TAB_THRESHOLDS;
m3 = mr0;
l3 = 0;
modify(i3, m3);
m3 = 1;
mr0 = dm(i3, m3);
dm(Threshold) = mr0;
mr0 = dm(i3, m3);
dm(Threshold + 1) = mr0;

ax0 = 1;
dm(init) = ax0;
jump wt;

TEST_MODE:
// 100,000 pulses/kWh => Threshold 360Ws
ax0 = 0; 
dm(Threshold) = ax0;
ax0 = 0x168;
dm(Threshold + 1) = ax0;

// Ts = 1s
ax0 = 1;
dm(dT) = ax0;

// dT cnt
ax0 = 50;
dm(cntDT) = ax0;

// Case 1
ax0 = 90;
dm(testPower) = ax0;
ax0 = 0;
dm(MODE) = ax0;

ax0 = 1;
dm(init) = ax0;
/*
// Case 2:
ax0 = 180;
dm(testPower) = ax0;
ax0 = 0;
dm(MODE) = ax0;
*/

/*
// Case 3:
ax0 = 360;
dm(testPower) = ax0;
ax0 = 1;
dm(MODE) = ax0;
*/

/*
// Case 4:
ax0 = 720;
dm(testPower) = ax0;
ax0 = 1;
dm(MODE) = ax0;
*/

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
        
        // Wait for init
        ax0 = dm(init);
        ar = ax0 - 0;
        if eq rti;
        
        // Implementing a counter in order to sync with ATmega 
        // (which has timing interrupts at every 20ms;
        // Incrementing the sampling period counter
        ay0 = dm(cntTest);	// Read current interrupts counter
        ar = ay0 + 1;		// Increment the interrupts counter
        dm(cntTest) = ar;	// Save the result
        ax0 = 160;		// Get the interrupts counter value
        ay0 = dm(cntTest);			// Get the necessary interrupts number
        af = ax0 - ay0;			// Compute cntInterrupts - cntInterrupts
        if gt rti;		// If not cntDT - cntP <= 0 => read new samples
			
        ax0 = 0;
        dm(cntTest) = ax0;
        
        // Incrementing the sampling period counter
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
		// For testing purposes write 0 to the
		// output port:
		ax1 = 0;
		// IO(PORT_OUT) = ax1;
		dm(Prog_Flag_Data) = ax1;
		dm(PF_output) = ax1;	

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
        // Write 0 to the output port, for testing purposes    
        ax1 = 0;					// Write PULSE = 0 at 0xFF
        // IO(PORT_OUT) = ax1;
        dm(Prog_Flag_Data) = ax1;
        dm(PF_output) = ax1;
        
        ax0 = dm(testMode);
		ar = ax0 - 0;
		if eq jump SKIP_UI;

        
        // Compute consumption:  
		// Reading the voltage (U) 
        ax0 = dm (rx_buf + 2); 	// Citeste senzorii de tensiune (U)      
        ay0 = 0.84r;
        ax1 = 0;
        ar = ax0 - ay0;
        if lt jump READ_U;
        
        ay0 = 0.87r;
        ax1 = 1;
        ar = ax0 - ay0;
        if lt jump READ_U;
        
        ay0 = 0.91r;
        ax1 = 2;
        ar = ax0 - ay0;
        if lt jump READ_U;
        
        ay0 = 0.95r;
        ax1 = 3;
        ar = ax0 - ay0;
        if lt jump READ_U;  
        
        ay0 = 0.99r;
        ax1 = 4;
        ar = ax0 - ay0;
        if lt jump READ_U;  
                       
        ax1 = 5;       
        
        READ_U:
        i4 = TAB_U;
		m4 = ax1;
        modify(i4, m4);
        mx0 = dm(i4, m4);
        
        TEST_READ_I:
       	// Reading the current (I)
        ax0 = dm (rx_buf + 1);    
        ay0 = 0.57r;
        ax1 = 0;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ay0 = 0.58r;
        ax1 = 1;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ay0 = 0.6r;
        ax1 = 2;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ay0 = 0.62r;
        ax1 = 3;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ay0 = 0.63r;
        ax1 = 4;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ay0 = 0.65r;
        ax1 = 5;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ay0 = 0.66r;
        ax1 = 6;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ay0 = 0.68r;
        ax1 = 7;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ay0 = 0.69r;
        ax1 = 8;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ay0 = 0.71r;
        ax1 = 9;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ay0 = 0.72r;
        ax1 = 10;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ay0 = 0.74r;
        ax1 = 11;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ay0 = 0.75r;
        ax1 = 12;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ay0 = 0.77r;
        ax1 = 13;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ay0 = 0.78r;
        ax1 = 14;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ay0 = 0.80r;
        ax1 = 15;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ay0 = 0.81r;
        ax1 = 16;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ay0 = 0.83r;
        ax1 = 17;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ay0 = 0.84r;
        ax1 = 18;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ay0 = 0.86r;
        ax1 = 19;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ay0 = 0.87r;
        ax1 = 20;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ay0 = 0.89r;
        ax1 = 21;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ay0 = 0.91r;
        ax1 = 22;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ay0 = 0.92r;
        ax1 = 23;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ay0 = 0.94r;
        ax1 = 24;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ay0 = 0.95r;
        ax1 = 25;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ay0 = 0.97r;
        ax1 = 26;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ay0 = 0.98r;
        ax1 = 27;
        ar = ax0 - ay0;
        if lt jump READ_I;
        
        ax1 = 28;
        
        READ_I:
        i4 = TAB_I;
		m4 = ax1;
        modify(i4, m4);
        my0 = dm(i4, m4);      
        mr = mx0 * my0 (uu);	// mr = U * [I]
        ax0 = mx0;				// ax0 = U
        i4 = EXP_1;
		m4 = ax1;
        modify(i4, m4);
        se = dm(i4, m4);		// se = exp1
        sr0 = ax0;
        sr = ashift sr0 (lo); 	// sr = U >> exp1
        mx0 = sr0;				// mx0 = U >> exp1
       	i4 = EXP_2;
		m4 = ax1;
        modify(i4, m4);
        my0 = dm(i4, m4);		// my0 = exp2
        mr = mr + mx0 * my0 (uu);	// mr = U * [I] + (U >> exp1) * exp2
        
        // Testing section //
        // Providing a hardcoded value for power:
        SKIP_UI:
        mr0 = dm(testPower);
        ////
        
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
        // IO(PORT_OUT) = ax1;
        dm(Prog_Flag_Data) = ax1;
        dm(PF_output) = ax1;
        
		ax0 = 1;
        ax1 = 3;
        ay0 = 0;
		ay1 = dm(n);			// ay0 = n 
        af = PASS ay1;			// ar = n 
        if le ar = ax0 + ay0; 	// if n <= 0 => return to Q0
        if gt ar = ax1 + ay0;	// else => return to Q1
        dm(Q) = ar;				// Go to Q = 3
        
        // Compute power level:
        ax0 = dm(P);
        ay0 = 500;
        ax1 = 1;
        ar = ax0 - ay0;
        if lt jump SAVE_POWER_LEVEL;
        
        ay0 = 1000;
        ax1 = 3;
        ar = ax0 - ay0;
        if lt jump SAVE_POWER_LEVEL;
        
        ax1 = 7;
        SAVE_POWER_LEVEL:
        sr0 = ax1;
        sr = ashift sr0 by 3 (lo);
        ax1 = sr0;
        
        // Save working mode
        sr0 = dm(MODE);
        sr = ashift sr0 by 1(lo);
        ay1 = sr0;
        ar = ax1 or ay1;
        dm(out) = ar;
        rti;       
//////////////////////////////
        
       
//////////// Q = 3 ///////////
Q3:
        // Generating the pulse //	
		ax1 = dm(out);
        ay1 = 1;
        ar = ax1 or ay1;				
        // dm(Prog_Flag_Data) = ax1;	// PF = RPPP PPP1 (PULSE = 1)
        // IO(PORT_OUT) = ax1;		// Write PULSE = 1 at 0xFF
        dm(Prog_Flag_Data) = ar;
        dm(PF_output) = ar;
        
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
        ax1 = dm(out);
        ay1 = 0xf8;
        ar = ax1 and ay1;
        ax1 = ar;
        sr0 = dm(PulsesNumberIndex);
        sr = ashift sr0 by 1(lo);
        ay1 = sr0;
        ar = ax1 or ay1;
        dm(out) = ar;
        // Append pulses number
        
        
        // IO(PORT_OUT) = ax1;
        dm(Prog_Flag_Data) = ar;
        dm(PF_output) = ar;
        
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
        ar = dm(out);
        // IO(PORT_OUT) = ax1;
		dm(Prog_Flag_Data) = ar;
		dm(PF_output) = ar;
		
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



