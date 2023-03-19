
;CodeVisionAVR C Compiler V3.49a 
;(C) Copyright 1998-2022 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega164A
;Program type           : Application
;Clock frequency        : 10.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega164A
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPMCSR=0x37
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x04FF
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.EQU __FLASH_PAGE_SIZE=0x40
	.EQU __EEPROM_PAGE_SIZE=0x04

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETW1P
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETD1P_INC
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	.ENDM

	.MACRO __GETD1P_DEC
	LD   R23,-X
	LD   R22,-X
	LD   R31,-X
	LD   R30,-X
	.ENDM

	.MACRO __PUTDP1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTDP1_DEC
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __CPD10
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	.ENDM

	.MACRO __CPD20
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	.ENDM

	.MACRO __ADDD12
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	.ENDM

	.MACRO __ADDD21
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	.ENDM

	.MACRO __SUBD12
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	.ENDM

	.MACRO __SUBD21
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	.ENDM

	.MACRO __ANDD12
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	.ENDM

	.MACRO __ORD12
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	.ENDM

	.MACRO __XORD12
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
	.ENDM

	.MACRO __XORD21
	EOR  R26,R30
	EOR  R27,R31
	EOR  R24,R22
	EOR  R25,R23
	.ENDM

	.MACRO __COMD1
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	.ENDM

	.MACRO __MULD2_2
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	.ENDM

	.MACRO __LSRD1
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	.ENDM

	.MACRO __LSLD1
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	.ENDM

	.MACRO __ASRB4
	ASR  R30
	ASR  R30
	ASR  R30
	ASR  R30
	.ENDM

	.MACRO __ASRW8
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	.ENDM

	.MACRO __LSRD16
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	.ENDM

	.MACRO __LSLD16
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	.ENDM

	.MACRO __CWD1
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	.ENDM

	.MACRO __CWD2
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	.ENDM

	.MACRO __SETMSD1
	SER  R31
	SER  R22
	SER  R23
	.ENDM

	.MACRO __ADDW1R15
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	.ENDM

	.MACRO __ADDW2R15
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	.ENDM

	.MACRO __EQB12
	CP   R30,R26
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __NEB12
	CP   R30,R26
	LDI  R30,1
	BRNE PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12
	CP   R30,R26
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12
	CP   R26,R30
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12
	CP   R26,R30
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12
	CP   R30,R26
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12U
	CP   R30,R26
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12U
	CP   R26,R30
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12U
	CP   R26,R30
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12U
	CP   R30,R26
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __CPW01
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	.ENDM

	.MACRO __CPW02
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	.ENDM

	.MACRO __CPD12
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	.ENDM

	.MACRO __CPD21
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	.ENDM

	.MACRO __BSTB1
	CLT
	TST  R30
	BREQ PC+2
	SET
	.ENDM

	.MACRO __LNEGB1
	TST  R30
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __LNEGW1
	OR   R30,R31
	LDI  R30,1
	BREQ PC+2
	LDI  R30,0
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _S1=R4
	.DEF _cnt_time=R3
	.DEF _T_SEC=R6
	.DEF _S2=R5
	.DEF _S_PULSE=R8
	.DEF _PULSE=R7
	.DEF _Q=R10
	.DEF _Q1=R9
	.DEF _S3=R12
	.DEF _TOTAL_CONS=R11
	.DEF _C4=R14
	.DEF _C3=R13

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_DIGITS:
	.DB  0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8
	.DB  0x80,0x90

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0

_0x3:
	.DB  0x0,0x0,0x8,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x8,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x8,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x8,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x8,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x10
_0x4:
	.DB  0x0,0x0,0x10,0x0,0x2,0x0,0x0,0x0
	.DB  0x0,0x0,0x10,0x0,0x2,0x0,0x0,0x0
	.DB  0x0,0x0,0x10,0x0,0x2,0x0,0x0,0x0
	.DB  0x0,0x0,0x10,0x0,0x2,0x0,0x0,0x0
	.DB  0x0,0x0,0x10,0x0,0x2,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x10,0x1
_0x5:
	.DB  0x0,0x0,0x0,0x1,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x2,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x3,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x4,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x5,0x3,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x10,0x2
_0x6:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x10,0x3
_0x7:
	.DB  0x0,0x1,0x2,0x3
_0x8:
	.DB  LOW(_A0),HIGH(_A0),LOW(_A1),HIGH(_A1),LOW(_A2),HIGH(_A2),LOW(_A3),HIGH(_A3)
_0x9:
	.DB  0xA,0x0,0x15,0x0,0x22,0x0,0x64
_0xA:
	.DB  0x0,0x10,0x30,0x70,0xF0
_0xB:
	.DB  0x1,0x2,0x3

__GLOBAL_INI_TBL:
	.DW  0x09
	.DW  0x03
	.DW  __REG_VARS*2

	.DW  0x2C
	.DW  _A0
	.DW  _0x3*2

	.DW  0x2D
	.DW  _A1
	.DW  _0x4*2

	.DW  0x2D
	.DW  _A2
	.DW  _0x5*2

	.DW  0x0D
	.DW  _A3
	.DW  _0x6*2

	.DW  0x04
	.DW  _Tout
	.DW  _0x7*2

	.DW  0x08
	.DW  _TABA
	.DW  _0x8*2

	.DW  0x07
	.DW  _CONSUM
	.DW  _0x9*2

	.DW  0x05
	.DW  _CLC_LEVEL
	.DW  _0xA*2

	.DW  0x03
	.DW  _CLC_RANGE_OUTPUT
	.DW  _0xB*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x200

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif

	.DSEG
;void Init();
;void UpdateConsumption();
;void DisplayConsumption();
;void DisplayDigit(char currentDisplay, char digit);
;void UpdateTime();
;void CLS();
;void DisplayInfo();
;void DisplayPowerLevel();
;void DisplayConsumptionDisplayMode();
;void MockPULSE();
;interrupt [19] void timer0_ovf_isr(void)
; 0000 0087 {

	.CSEG
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0088 // Reinitialize Timer 0 value
; 0000 0089 TCNT0=0x3C;
	LDI  R30,LOW(60)
	OUT  0x26,R30
; 0000 008A 
; 0000 008B // Update CA
; 0000 008C CA = (PORTD & 0x10) >> 4;
	IN   R30,0xB
	ANDI R30,LOW(0x10)
	LDI  R31,0
	RCALL __ASRW4
	STS  _CA,R30
; 0000 008D 
; 0000 008E // DisplayInfo
; 0000 008F DisplayInfo();
	RCALL _DisplayInfo
; 0000 0090 
; 0000 0091 // Update mock pulse
; 0000 0092 MockPULSE();
	RCALL _MockPULSE
; 0000 0093 
; 0000 0094 // Check for pulses coming from ADSP
; 0000 0095 UpdateConsumption();
	RCALL _UpdateConsumption
; 0000 0096 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;void main(void)
; 0000 009A {
_main:
; .FSTART _main
; 0000 009B // Declare your local variables here
; 0000 009C 
; 0000 009D // Crystal Oscillator division factor: 1
; 0000 009E #pragma optsize-
; 0000 009F CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 00A0 CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 00A1 #ifdef _OPTIMIZE_SIZE_
; 0000 00A2 #pragma optsize+
; 0000 00A3 #endif
; 0000 00A4 
; 0000 00A5 // Input/Output Ports initialization
; 0000 00A6 // Port A initialization
; 0000 00A7 // Function: Bit7=Out Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00A8 DDRA=(1<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(128)
	OUT  0x1,R30
; 0000 00A9 // State: Bit7=1 Bit6=P Bit5=P Bit4=P Bit3=P Bit2=P Bit1=P Bit0=P
; 0000 00AA PORTA=(1<<PORTA7) | (1<<PORTA6) | (1<<PORTA5) | (1<<PORTA4) | (1<<PORTA3) | (1<<PORTA2) | (1<<PORTA1) | (1<<PORTA0);
	LDI  R30,LOW(255)
	OUT  0x2,R30
; 0000 00AB 
; 0000 00AC // Port B initialization
; 0000 00AD // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 00AE DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	OUT  0x4,R30
; 0000 00AF // State: Bit7=1 Bit6=1 Bit5=1 Bit4=1 Bit3=1 Bit2=1 Bit1=1 Bit0=1
; 0000 00B0 PORTB=(1<<PORTB7) | (1<<PORTB6) | (1<<PORTB5) | (1<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);
	OUT  0x5,R30
; 0000 00B1 
; 0000 00B2 // Port C initialization
; 0000 00B3 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 00B4 DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	OUT  0x7,R30
; 0000 00B5 // State: Bit7=1 Bit6=1 Bit5=1 Bit4=1 Bit3=1 Bit2=1 Bit1=1 Bit0=1
; 0000 00B6 PORTC=(1<<PORTC7) | (1<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (1<<PORTC3) | (1<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);
	OUT  0x8,R30
; 0000 00B7 
; 0000 00B8 // Port D initialization
; 0000 00B9 // Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 00BA DDRD=(0<<DDD7) | (0<<DDD6) | (1<<DDD5) | (0<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(47)
	OUT  0xA,R30
; 0000 00BB // State: Bit7=T Bit6=T Bit5=1 Bit4=0 Bit3=1 Bit2=1 Bit1=1 Bit0=1
; 0000 00BC PORTD=(0<<PORTD7) | (0<<PORTD6) | (1<<PORTD5) | (0<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (1<<PORTD1) | (1<<PORTD0);
	OUT  0xB,R30
; 0000 00BD 
; 0000 00BE // Timer/Counter 0 initialization
; 0000 00BF // Clock source: System Clock
; 0000 00C0 // Clock value: 9.766 kHz
; 0000 00C1 // Mode: Normal top=0xFF
; 0000 00C2 // OC0A output: Disconnected
; 0000 00C3 // OC0B output: Disconnected
; 0000 00C4 // Timer Period: 20.07 ms
; 0000 00C5 TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 00C6 TCCR0B=(0<<WGM02) | (1<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(5)
	OUT  0x25,R30
; 0000 00C7 TCNT0=0x3C;
	LDI  R30,LOW(60)
	OUT  0x26,R30
; 0000 00C8 OCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 00C9 OCR0B=0x00;
	OUT  0x28,R30
; 0000 00CA 
; 0000 00CB // Timer/Counter 1 initialization
; 0000 00CC // Clock source: System Clock
; 0000 00CD // Clock value: Timer1 Stopped
; 0000 00CE // Mode: Normal top=0xFFFF
; 0000 00CF // OC1A output: Disconnected
; 0000 00D0 // OC1B output: Disconnected
; 0000 00D1 // Noise Canceler: Off
; 0000 00D2 // Input Capture on Falling Edge
; 0000 00D3 // Timer1 Overflow Interrupt: Off
; 0000 00D4 // Input Capture Interrupt: Off
; 0000 00D5 // Compare A Match Interrupt: Off
; 0000 00D6 // Compare B Match Interrupt: Off
; 0000 00D7 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	STS  128,R30
; 0000 00D8 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	STS  129,R30
; 0000 00D9 TCNT1H=0x00;
	STS  133,R30
; 0000 00DA TCNT1L=0x00;
	STS  132,R30
; 0000 00DB ICR1H=0x00;
	STS  135,R30
; 0000 00DC ICR1L=0x00;
	STS  134,R30
; 0000 00DD OCR1AH=0x00;
	STS  137,R30
; 0000 00DE OCR1AL=0x00;
	STS  136,R30
; 0000 00DF OCR1BH=0x00;
	STS  139,R30
; 0000 00E0 OCR1BL=0x00;
	STS  138,R30
; 0000 00E1 
; 0000 00E2 // Timer/Counter 2 initialization
; 0000 00E3 // Clock source: System Clock
; 0000 00E4 // Clock value: Timer2 Stopped
; 0000 00E5 // Mode: Normal top=0xFF
; 0000 00E6 // OC2A output: Disconnected
; 0000 00E7 // OC2B output: Disconnected
; 0000 00E8 ASSR=(0<<EXCLK) | (0<<AS2);
	STS  182,R30
; 0000 00E9 TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
	STS  176,R30
; 0000 00EA TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	STS  177,R30
; 0000 00EB TCNT2=0x00;
	STS  178,R30
; 0000 00EC OCR2A=0x00;
	STS  179,R30
; 0000 00ED OCR2B=0x00;
	STS  180,R30
; 0000 00EE 
; 0000 00EF // Timer/Counter 0 Interrupt(s) initialization
; 0000 00F0 TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);
	LDI  R30,LOW(1)
	STS  110,R30
; 0000 00F1 
; 0000 00F2 // Timer/Counter 1 Interrupt(s) initialization
; 0000 00F3 TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);
	LDI  R30,LOW(0)
	STS  111,R30
; 0000 00F4 
; 0000 00F5 // Timer/Counter 2 Interrupt(s) initialization
; 0000 00F6 TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);
	STS  112,R30
; 0000 00F7 
; 0000 00F8 // External Interrupt(s) initialization
; 0000 00F9 // INT0: Off
; 0000 00FA // INT1: Off
; 0000 00FB // INT2: Off
; 0000 00FC // Interrupt on any change on pins PCINT0-7: Off
; 0000 00FD // Interrupt on any change on pins PCINT8-15: Off
; 0000 00FE // Interrupt on any change on pins PCINT16-23: Off
; 0000 00FF // Interrupt on any change on pins PCINT24-31: Off
; 0000 0100 EICRA=(0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  105,R30
; 0000 0101 EIMSK=(0<<INT2) | (0<<INT1) | (0<<INT0);
	OUT  0x1D,R30
; 0000 0102 PCICR=(0<<PCIE3) | (0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	STS  104,R30
; 0000 0103 
; 0000 0104 // USART0 initialization
; 0000 0105 // USART0 disabled
; 0000 0106 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	STS  193,R30
; 0000 0107 
; 0000 0108 // USART1 initialization
; 0000 0109 // USART1 disabled
; 0000 010A UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	STS  201,R30
; 0000 010B 
; 0000 010C // Analog Comparator initialization
; 0000 010D // Analog Comparator: Off
; 0000 010E // The Analog Comparator's positive input is
; 0000 010F // connected to the AIN0 pin
; 0000 0110 // The Analog Comparator's negative input is
; 0000 0111 // connected to the AIN1 pin
; 0000 0112 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 0113 ADCSRB=(0<<ACME);
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 0114 // Digital input buffer on AIN0: On
; 0000 0115 // Digital input buffer on AIN1: On
; 0000 0116 DIDR1=(0<<AIN0D) | (0<<AIN1D);
	STS  127,R30
; 0000 0117 
; 0000 0118 // ADC initialization
; 0000 0119 // ADC disabled
; 0000 011A ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	STS  122,R30
; 0000 011B 
; 0000 011C // SPI initialization
; 0000 011D // SPI disabled
; 0000 011E SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0x2C,R30
; 0000 011F 
; 0000 0120 // TWI initialization
; 0000 0121 // TWI disabled
; 0000 0122 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  188,R30
; 0000 0123 
; 0000 0124 // Globally enable interrupts
; 0000 0125 #asm("sei")
	SEI
; 0000 0126 
; 0000 0127 // Initialize the device
; 0000 0128 Init();
	RCALL _Init
; 0000 0129 
; 0000 012A while (1)
_0xC:
; 0000 012B {
; 0000 012C // Display the consumption
; 0000 012D DisplayConsumption();
	RCALL _DisplayConsumption
; 0000 012E 
; 0000 012F // Wait for interruptions
; 0000 0130 // PORTB &= 0x00;
; 0000 0131 }
	RJMP _0xC
; 0000 0132 }
_0xF:
	RJMP _0xF
; .FEND
;void Init()
; 0000 0136 {
_Init:
; .FSTART _Init
; 0000 0137 // Setting initial states = 0
; 0000 0138 Q = Q1 = S1 = S2 = S3 = S_PULSE = 0;
	LDI  R30,LOW(0)
	MOV  R8,R30
	MOV  R12,R30
	MOV  R5,R30
	MOV  R4,R30
	MOV  R9,R30
	MOV  R10,R30
; 0000 0139 
; 0000 013A // Turn off displays
; 0000 013B PORTC = 0xff;
	LDI  R30,LOW(255)
	OUT  0x8,R30
; 0000 013C PORTD = 0xff;
	OUT  0xB,R30
; 0000 013D PORTB = 0xff;
	OUT  0x5,R30
; 0000 013E }
	RET
; .FEND
;void UpdateConsumption()
; 0000 0141 {
_UpdateConsumption:
; .FSTART _UpdateConsumption
; 0000 0142 // Identify PULSE
; 0000 0143 // PULSE = PINA & 0x01;
; 0000 0144 
; 0000 0145 /* switch(S2)
; 0000 0146 {
; 0000 0147 case 0:
; 0000 0148 {
; 0000 0149 char cntP = 0;
; 0000 014A 
; 0000 014B // PD6 -> Sending request from ADSP
; 0000 014C // PD7 -> Reading ack from ATmega164A
; 0000 014D 
; 0000 014E // Check if sending request flag is up
; 0000 014F // (Receiving sending request on PD6)
; 0000 0150 if (PORTD && 0x40)
; 0000 0151 {
; 0000 0152 // Send reading ack
; 0000 0153 // (Sending ack on PD7)
; 0000 0154 PORTD |= 0x80;
; 0000 0155 
; 0000 0156 // Going further to reading the pulses
; 0000 0157 S2 = 1;
; 0000 0158 }
; 0000 0159 break;
; 0000 015A }
; 0000 015B case 1:
; 0000 015C {
; 0000 015D // If PULSE is on, start counting
; 0000 015E if (PULSE)
; 0000 015F {
; 0000 0160 // Increment cntP
; 0000 0161 cntP += 1;
; 0000 0162 
; 0000 0163 // Reset reading flag
; 0000 0164 PORTD &= 0x7f;
; 0000 0165 
; 0000 0166 // Go further if the pulse period has passed,
; 0000 0167 // otherwise go back wait for sensding ack again.
; 0000 0168 S2 = (cntP == DP) ? 2 : 1;
; 0000 0169 }
; 0000 016A break;
; 0000 016B }
; 0000 016C case 2:
; 0000 016D {
; 0000 016E if (~PULSE)
; 0000 016F {
; 0000 0170 // Update current consumption range
; 0000 0171 Q = CLS();
; 0000 0172 
; 0000 0173 // Increment consumption
; 0000 0174 CONS[Q] += 1;
; 0000 0175 
; 0000 0176 // Wait for another pulse
; 0000 0177 S2 = 0;
; 0000 0178 }
; 0000 0179 break;
; 0000 017A }
; 0000 017B } */
; 0000 017C 
; 0000 017D // Read power level
; 0000 017E // PowerLevel = (PINA & 0xfe) >> 1;
; 0000 017F 
; 0000 0180 // For testing purposes, we will assume PowerLevel = 6 kW
; 0000 0181 PowerLevel = 6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	STS  _PowerLevel,R30
	STS  _PowerLevel+1,R31
; 0000 0182 
; 0000 0183 switch(S2)
	MOV  R30,R5
	LDI  R31,0
; 0000 0184 {
; 0000 0185 case 0:
	SBIW R30,0
	BRNE _0x13
; 0000 0186 {
; 0000 0187 // If PULSE is on, start counting
; 0000 0188 if (PULSE)
	TST  R7
	BREQ _0x14
; 0000 0189 {
; 0000 018A // Increment cntP
; 0000 018B cntP += 1;
	LDS  R30,_cntP
	SUBI R30,-LOW(1)
	STS  _cntP,R30
; 0000 018C 
; 0000 018D // Reset reading flag
; 0000 018E // PORTD &= 0x7f;
; 0000 018F 
; 0000 0190 // Go further if the pulse period has passed,
; 0000 0191 // otherwise go back wait for sensding ack again.
; 0000 0192 S2 = (cntP == DP) ? 1 : 0;
	LDS  R26,_cntP
	CPI  R26,LOW(0x1)
	BRNE _0x15
	LDI  R30,LOW(1)
	RJMP _0x16
_0x15:
	LDI  R30,LOW(0)
_0x16:
	MOV  R5,R30
; 0000 0193 }
; 0000 0194 break;
_0x14:
	RJMP _0x12
; 0000 0195 }
; 0000 0196 case 1:
_0x13:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x12
; 0000 0197 {
; 0000 0198 if (~PULSE)
	MOV  R30,R7
	COM  R30
	CPI  R30,0
	BREQ _0x19
; 0000 0199 {
; 0000 019A // Update current consumption range
; 0000 019B CLS();
	RCALL _CLS
; 0000 019C 
; 0000 019D // Increment consumption
; 0000 019E CONSUM[Q] += 1;
	MOV  R30,R10
	RCALL SUBOPT_0x0
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 019F 
; 0000 01A0 // Increment total consumption
; 0000 01A1 CONSUM[3] += 1;
	__GETW1MN _CONSUM,6
	ADIW R30,1
	__PUTW1MN _CONSUM,6
; 0000 01A2 
; 0000 01A3 // Wait for another pulse
; 0000 01A4 S2 = 0;
	CLR  R5
; 0000 01A5 cntP = 0;
	LDI  R30,LOW(0)
	STS  _cntP,R30
; 0000 01A6 }
; 0000 01A7 break;
_0x19:
; 0000 01A8 }
; 0000 01A9 }
_0x12:
; 0000 01AA }
	RET
; .FEND
;void MockPULSE()
; 0000 01AF {
_MockPULSE:
; .FSTART _MockPULSE
; 0000 01B0 switch(S_PULSE)
	MOV  R30,R8
	LDI  R31,0
; 0000 01B1 {
; 0000 01B2 case 0:
	SBIW R30,0
	BRNE _0x1D
; 0000 01B3 {
; 0000 01B4 cntMockPulse = 0;
	LDI  R30,LOW(0)
	STS  _cntMockPulse,R30
; 0000 01B5 PULSE = 1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 01B6 S_PULSE = 1;
	MOV  R8,R30
; 0000 01B7 break;
	RJMP _0x1C
; 0000 01B8 }
; 0000 01B9 case 1:
_0x1D:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1C
; 0000 01BA {
; 0000 01BB cntMockPulse += 1;
	LDS  R30,_cntMockPulse
	SUBI R30,-LOW(1)
	STS  _cntMockPulse,R30
; 0000 01BC PULSE = 0;
	CLR  R7
; 0000 01BD if (cntMockPulse == 49)
	LDS  R26,_cntMockPulse
	CPI  R26,LOW(0x31)
	BRNE _0x1F
; 0000 01BE S_PULSE = 0;
	CLR  R8
; 0000 01BF break;
_0x1F:
; 0000 01C0 }
; 0000 01C1 }
_0x1C:
; 0000 01C2 }
	RET
; .FEND
;void DisplayConsumption()
; 0000 01C5 {
_DisplayConsumption:
; .FSTART _DisplayConsumption
; 0000 01C6 // We assume:
; 0000 01C7 // PORTC: PC0 - PC6 -> 7 segments (A-G)
; 0000 01C8 // PORTD: PD0 - PD3 -> select the common cathode for each digit (multiplexing)
; 0000 01C9 // PD3 - C4, PD2 - C3, PD1 - C2, PD0 - C1
; 0000 01CA // Q - consumption range:
; 0000 01CB // 0 -> 00:00 - H1:00
; 0000 01CC // 1 -> H1:00 - H2:00               (MON - FRI)
; 0000 01CD // 2 -> H2:00 - 00:00 (next day)
; 0000 01CE // 3 -> SAT - SUN
; 0000 01CF 
; 0000 01D0 // The actual approach:
; 0000 01D1 // Each main loop iteration we multiplex the digits and display one at a time
; 0000 01D2 
; 0000 01D3 // If CA is pressed -> display total consumption,
; 0000 01D4 // else -> display consumption based on current range.
; 0000 01D5 char cons = CONSUM[Q1];
; 0000 01D6 
; 0000 01D7 // Compute and display C4
; 0000 01D8 C4 = cons / 1000;
	ST   -Y,R17
;	cons -> R17
	MOV  R30,R9
	RCALL SUBOPT_0x0
	LD   R30,X
	MOV  R17,R30
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __DIVW21
	MOV  R14,R30
; 0000 01D9 cons %= 1000;
	MOV  R26,R17
	CLR  R27
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __MODW21
	MOV  R17,R30
; 0000 01DA DisplayDigit(4, C4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	MOV  R26,R14
	RCALL _DisplayDigit
; 0000 01DB 
; 0000 01DC // Compute and display C3
; 0000 01DD C3 = cons / 100;
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21
	MOV  R13,R30
; 0000 01DE cons %= 100;
	MOV  R26,R17
	CLR  R27
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __MODW21
	MOV  R17,R30
; 0000 01DF DisplayDigit(3, C3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	MOV  R26,R13
	RCALL _DisplayDigit
; 0000 01E0 
; 0000 01E1 // Compute and display C2
; 0000 01E2 C2 = cons / 10;
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	STS  _C2,R30
; 0000 01E3 DisplayDigit(2, C2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDS  R26,_C2
	RCALL _DisplayDigit
; 0000 01E4 
; 0000 01E5 // Compute and display C1
; 0000 01E6 C1 = cons % 10;
	MOV  R26,R17
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	STS  _C1,R30
; 0000 01E7 DisplayDigit(1, C1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDS  R26,_C1
	RCALL _DisplayDigit
; 0000 01E8 }
	RJMP _0x2000002
; .FEND
;void DisplayDigit(char currentDisplay, char digit)
; 0000 01EB {
_DisplayDigit:
; .FSTART _DisplayDigit
; 0000 01EC // Select the desired display (turn on the pin
; 0000 01ED // corresponding to the desired digit (C4/C3/C2/C1)
; 0000 01EE char output;
; 0000 01EF 
; 0000 01F0 // Set PORTC pins to the corresponding digit
; 0000 01F1 // PORTC = DIGITS[digit];
; 0000 01F2 
; 0000 01F3 switch (currentDisplay)
	RCALL __SAVELOCR4
	MOV  R16,R26
	LDD  R19,Y+4
;	currentDisplay -> R19
;	digit -> R16
;	output -> R17
	MOV  R30,R19
	LDI  R31,0
; 0000 01F4 {
; 0000 01F5 case 4:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x23
; 0000 01F6 // Turn PD3 on
; 0000 01F7 //output &= 0b00000111;
; 0000 01F8 output = 0x08;
	LDI  R17,LOW(8)
; 0000 01F9 break;
	RJMP _0x22
; 0000 01FA case 3:
_0x23:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x24
; 0000 01FB // Turn PD2 on
; 0000 01FC // output &= 0b00001011;
; 0000 01FD output = 0x04;
	LDI  R17,LOW(4)
; 0000 01FE break;
	RJMP _0x22
; 0000 01FF case 2:
_0x24:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x25
; 0000 0200 // Turn PD1 on
; 0000 0201 output = 0x02;
	LDI  R17,LOW(2)
; 0000 0202 break;
	RJMP _0x22
; 0000 0203 case 1:
_0x25:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x22
; 0000 0204 // Turn PD0 on
; 0000 0205 output = 0x01;
	LDI  R17,LOW(1)
; 0000 0206 break;
; 0000 0207 }
_0x22:
; 0000 0208 
; 0000 0209 // Delete PD0-3
; 0000 020A PORTD &= 0xF0;
	IN   R30,0xB
	ANDI R30,LOW(0xF0)
	OUT  0xB,R30
; 0000 020B 
; 0000 020C // Assign output to PORTC in order to select the desired display;
; 0000 020D PORTD |= output;
	IN   R30,0xB
	OR   R30,R17
	OUT  0xB,R30
; 0000 020E 
; 0000 020F // Set PORTC pins to the corresponding digit
; 0000 0210 PORTC = DIGITS[digit];
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_DIGITS*2)
	SBCI R31,HIGH(-_DIGITS*2)
	LPM  R0,Z
	OUT  0x8,R0
; 0000 0211 
; 0000 0212 // Add delay (10 us)
; 0000 0213 // _display_us(10);
; 0000 0214 }
	RCALL __LOADLOCR4
	ADIW R28,5
	RET
; .FEND
;void UpdateTime(){
; 0000 0217 void UpdateTime(){
; 0000 0218 cnt_time += 1; //incrementare contor de timp
; 0000 0219 if(cnt_time != T_SEC) return;
; 0000 021A 
; 0000 021B cnt_time = 0; // se reseteaza contorul
; 0000 021C S+=1;  //incrementeaza contor secunde
; 0000 021D 
; 0000 021E if(S!=60) return;
; 0000 021F S = 0;//se reseteaza nr de secunde
; 0000 0220 M += 1; //incrementeaza contor minute
; 0000 0221 
; 0000 0222 if(M!=60) return;
; 0000 0223 M = 0;
; 0000 0224 H += 1;
; 0000 0225 
; 0000 0226 if(H!=24) return;
; 0000 0227 H = 0;
; 0000 0228 Z += 1;
; 0000 0229 
; 0000 022A if (Z == 7) Z = 0;
; 0000 022B return;
; 0000 022C }
;void CLS()
; 0000 022F {
_CLS:
; .FSTART _CLS
; 0000 0230 char out;
; 0000 0231 
; 0000 0232 //exemplu
; 0000 0233 // Ziua 3, ora 8, min 6, sec 3
; 0000 0234 // 0x03080603
; 0000 0235 long int now = (Z<<24) | (H<<16) | (M<<8) | S;
; 0000 0236 
; 0000 0237 long int *adr = TABA[Q];
; 0000 0238 char ready = 0;
; 0000 0239 int i = 0;
; 0000 023A 
; 0000 023B while (!ready)
	SBIW R28,4
	RCALL __SAVELOCR6
;	out -> R17
;	now -> Y+6
;	*adr -> R18,R19
;	ready -> R16
;	i -> R20,R21
	LDS  R26,_Z
	LDS  R27,_Z+1
	LDS  R24,_Z+2
	LDS  R25,_Z+3
	LDI  R30,LOW(24)
	RCALL __LSLD12
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_H
	LDS  R31,_H+1
	LDS  R22,_H+2
	LDS  R23,_H+3
	__LSLD16
	RCALL SUBOPT_0x1
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDS  R26,_M
	LDS  R27,_M+1
	LDS  R24,_M+2
	LDS  R25,_M+3
	LDI  R30,LOW(8)
	RCALL __LSLD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0x1
	LDS  R26,_S
	LDS  R27,_S+1
	LDS  R24,_S+2
	LDS  R25,_S+3
	RCALL SUBOPT_0x1
	__PUTD1S 6
	MOV  R30,R10
	LDI  R26,LOW(_TABA)
	LDI  R27,HIGH(_TABA)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	__GETW1P
	MOVW R18,R30
	LDI  R16,0
	__GETWRN 20,21,0
_0x2C:
	CPI  R16,0
	BRNE _0x2E
; 0000 023C {
; 0000 023D if (now == adr[i]) {
	RCALL SUBOPT_0x2
	__GETD2S 6
	__CPD12
	BRNE _0x2F
; 0000 023E Q = adr[i + 1];
	MOVW R30,R20
	ADIW R30,1
	MOVW R26,R18
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LD   R10,X
; 0000 023F ready = 1;
	LDI  R16,LOW(1)
; 0000 0240 }
; 0000 0241 else if (adr[i] == Ter) ready = 1;
	RJMP _0x30
_0x2F:
	RCALL SUBOPT_0x2
	__CPD1N 0x10000000
	BRNE _0x31
	LDI  R16,LOW(1)
; 0000 0242 else i = i+2;
	RJMP _0x32
_0x31:
	__ADDWRN 20,21,2
; 0000 0243 }
_0x32:
_0x30:
	RJMP _0x2C
_0x2E:
; 0000 0244 
; 0000 0245 out = Tout[Q];
	MOV  R30,R10
	LDI  R31,0
	SUBI R30,LOW(-_Tout)
	SBCI R31,HIGH(-_Tout)
	LD   R17,Z
; 0000 0246 }
	RCALL __LOADLOCR6
	ADIW R28,10
	RET
; .FEND
;void DisplayInfo()
; 0000 0249 {
_DisplayInfo:
; .FSTART _DisplayInfo
; 0000 024A DisplayConsumptionDisplayMode();
	RCALL _DisplayConsumptionDisplayMode
; 0000 024B DisplayPowerLevel();
	RCALL _DisplayPowerLevel
; 0000 024C }
	RET
; .FEND
;void DisplayPowerLevel()
; 0000 024F {
_DisplayPowerLevel:
; .FSTART _DisplayPowerLevel
; 0000 0250 char out;
; 0000 0251 
; 0000 0252 if (!PowerLevel)         // PowerLevel = 0 kW
	ST   -Y,R17
;	out -> R17
	RCALL SUBOPT_0x3
	SBIW R30,0
	BRNE _0x33
; 0000 0253 {
; 0000 0254 out = CLC_LEVEL[0];
	LDS  R17,_CLC_LEVEL
; 0000 0255 }
; 0000 0256 else if (PowerLevel < 2.5)   // 0 < PowerLevel < 2.5 kW
	RJMP _0x34
_0x33:
	RCALL SUBOPT_0x4
	__GETD1N 0x40200000
	RCALL __CMPF12
	BRSH _0x35
; 0000 0257 {
; 0000 0258 out = CLC_LEVEL[1];
	__GETBRMN 17,_CLC_LEVEL,1
; 0000 0259 }
; 0000 025A else if (PowerLevel < 5)     // 2.5 <= PowerLevel < 5 kW
	RJMP _0x36
_0x35:
	LDS  R26,_PowerLevel
	LDS  R27,_PowerLevel+1
	SBIW R26,5
	BRGE _0x37
; 0000 025B {
; 0000 025C out = CLC_LEVEL[2];
	__GETBRMN 17,_CLC_LEVEL,2
; 0000 025D }
; 0000 025E else if (PowerLevel < 7.5)   // 5 <= PowerLevel < 7.5 kW
	RJMP _0x38
_0x37:
	RCALL SUBOPT_0x4
	__GETD1N 0x40F00000
	RCALL __CMPF12
	BRSH _0x39
; 0000 025F {
; 0000 0260 out = CLC_LEVEL[3];
	__GETBRMN 17,_CLC_LEVEL,3
; 0000 0261 }
; 0000 0262 else                         // PowerLvel >= 7.5 kW
	RJMP _0x3A
_0x39:
; 0000 0263 {
; 0000 0264 out = CLC_LEVEL[4];
	__GETBRMN 17,_CLC_LEVEL,4
; 0000 0265 }
_0x3A:
_0x38:
_0x36:
_0x34:
; 0000 0266 
; 0000 0267 // Delete PB7-PB4
; 0000 0268 PORTB &= 0x0f;
	IN   R30,0x5
	ANDI R30,LOW(0xF)
	RJMP _0x2000001
; 0000 0269 
; 0000 026A // Display out on PB7-PB4
; 0000 026B PORTB |= out;
; 0000 026C }
; .FEND
;void DisplayConsumptionDisplayMode()
; 0000 026F {
_DisplayConsumptionDisplayMode:
; .FSTART _DisplayConsumptionDisplayMode
; 0000 0270 char out;
; 0000 0271 
; 0000 0272 switch(S3)
	ST   -Y,R17
;	out -> R17
	MOV  R30,R12
	LDI  R31,0
; 0000 0273 {
; 0000 0274 case 0:
	SBIW R30,0
	BRNE _0x3E
; 0000 0275 {
; 0000 0276 if (CA == 0)            // Pressed CA
	LDS  R30,_CA
	CPI  R30,0
	BRNE _0x3F
; 0000 0277 {
; 0000 0278 S3 = 1;
	LDI  R30,LOW(1)
	MOV  R12,R30
; 0000 0279 }
; 0000 027A break;
_0x3F:
	RJMP _0x3D
; 0000 027B }
; 0000 027C case 1:                 // Released CA
_0x3E:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x40
; 0000 027D {
; 0000 027E if (CA)
	LDS  R30,_CA
	CPI  R30,0
	BREQ _0x41
; 0000 027F {
; 0000 0280 S3 = 2;
	LDI  R30,LOW(2)
	MOV  R12,R30
; 0000 0281 Q1 = 1;
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 0282 }
; 0000 0283 break;
_0x41:
	RJMP _0x3D
; 0000 0284 }
; 0000 0285 case 2:                //  Pressed CA
_0x40:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x42
; 0000 0286 {
; 0000 0287 if (CA == 0)
	LDS  R30,_CA
	CPI  R30,0
	BRNE _0x43
; 0000 0288 {
; 0000 0289 S3 = 3;
	LDI  R30,LOW(3)
	MOV  R12,R30
; 0000 028A }
; 0000 028B break;
_0x43:
	RJMP _0x3D
; 0000 028C }
; 0000 028D case 3:                // Released CA
_0x42:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x44
; 0000 028E {
; 0000 028F if (CA)
	LDS  R30,_CA
	CPI  R30,0
	BREQ _0x45
; 0000 0290 {
; 0000 0291 S3 = 4;
	LDI  R30,LOW(4)
	MOV  R12,R30
; 0000 0292 Q1 = 2;
	LDI  R30,LOW(2)
	MOV  R9,R30
; 0000 0293 }
; 0000 0294 break;
_0x45:
	RJMP _0x3D
; 0000 0295 }
; 0000 0296 case 4:
_0x44:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x46
; 0000 0297 {
; 0000 0298 if (CA == 0)
	LDS  R30,_CA
	CPI  R30,0
	BRNE _0x47
; 0000 0299 {
; 0000 029A S3 = 5;
	LDI  R30,LOW(5)
	MOV  R12,R30
; 0000 029B }
; 0000 029C break;
_0x47:
	RJMP _0x3D
; 0000 029D }
; 0000 029E case 5:
_0x46:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x48
; 0000 029F {
; 0000 02A0 if (CA)
	LDS  R30,_CA
	CPI  R30,0
	BREQ _0x49
; 0000 02A1 {
; 0000 02A2 S3 = 6;
	LDI  R30,LOW(6)
	MOV  R12,R30
; 0000 02A3 Q1 = 3;
	LDI  R30,LOW(3)
	MOV  R9,R30
; 0000 02A4 }
; 0000 02A5 break;
_0x49:
	RJMP _0x3D
; 0000 02A6 }
; 0000 02A7 case 6:
_0x48:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x4A
; 0000 02A8 {
; 0000 02A9 if (CA == 0)
	LDS  R30,_CA
	CPI  R30,0
	BRNE _0x4B
; 0000 02AA {
; 0000 02AB S3 = 7;
	LDI  R30,LOW(7)
	MOV  R12,R30
; 0000 02AC }
; 0000 02AD break;
_0x4B:
	RJMP _0x3D
; 0000 02AE }
; 0000 02AF case 7:
_0x4A:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x3D
; 0000 02B0 {
; 0000 02B1 if (CA)
	LDS  R30,_CA
	CPI  R30,0
	BREQ _0x4D
; 0000 02B2 {
; 0000 02B3 S3 = 8;
	LDI  R30,LOW(8)
	MOV  R12,R30
; 0000 02B4 Q1 = 0;
	CLR  R9
; 0000 02B5 }
; 0000 02B6 break;
_0x4D:
; 0000 02B7 }
; 0000 02B8 }
_0x3D:
; 0000 02B9 
; 0000 02BA out = CLC_RANGE_OUTPUT[Q1] | (CLC_RANGE_OUTPUT[Q] << 2);
	MOV  R30,R9
	LDI  R31,0
	SUBI R30,LOW(-_CLC_RANGE_OUTPUT)
	SBCI R31,HIGH(-_CLC_RANGE_OUTPUT)
	LD   R26,Z
	MOV  R30,R10
	LDI  R31,0
	SUBI R30,LOW(-_CLC_RANGE_OUTPUT)
	SBCI R31,HIGH(-_CLC_RANGE_OUTPUT)
	LD   R30,Z
	LSL  R30
	LSL  R30
	OR   R30,R26
	MOV  R17,R30
; 0000 02BB 
; 0000 02BC // Delete PB3-PB0
; 0000 02BD PORTB &= 0xf0;
	IN   R30,0x5
	ANDI R30,LOW(0xF0)
_0x2000001:
	OUT  0x5,R30
; 0000 02BE 
; 0000 02BF // Display out on PB3-PB0
; 0000 02C0 PORTB |= out;
	IN   R30,0x5
	OR   R30,R17
	OUT  0x5,R30
; 0000 02C1 }
_0x2000002:
	LD   R17,Y+
	RET
; .FEND

	.DSEG
_A0:
	.BYTE 0x30
_A1:
	.BYTE 0x30
_A2:
	.BYTE 0x30
_A3:
	.BYTE 0x10
_Tout:
	.BYTE 0x4
_TABA:
	.BYTE 0x8
_Z:
	.BYTE 0x4
_H:
	.BYTE 0x4
_M:
	.BYTE 0x4
_S:
	.BYTE 0x4
_CONSUM:
	.BYTE 0x8
_C2:
	.BYTE 0x1
_C1:
	.BYTE 0x1
_CA:
	.BYTE 0x1
_PowerLevel:
	.BYTE 0x2
_CLC_LEVEL:
	.BYTE 0x5
_CLC_RANGE_OUTPUT:
	.BYTE 0x4
_cntP:
	.BYTE 0x1
_cntMockPulse:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(_CONSUM)
	LDI  R27,HIGH(_CONSUM)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	__ORD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	MOVW R30,R20
	MOVW R26,R18
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	__GETD1P_INC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	LDS  R30,_PowerLevel
	LDS  R31,_PowerLevel+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	RCALL SUBOPT_0x3
	__CWD1
	RCALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLD12:
	TST  R30
	MOV  R0,R30
	LDI  R30,8
	MOV  R1,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSLD12R
__LSLD12S8:
	CP   R0,R1
	BRLO __LSLD12L
	MOV  R23,R22
	MOV  R22,R31
	MOV  R31,R30
	LDI  R30,0
	SUB  R0,R1
	BRNE __LSLD12S8
	RET
__LSLD12L:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R0
	BRNE __LSLD12L
__LSLD12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__ASRW4:
	ASR  R31
	ROR  R30
__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	NEG  R27
	NEG  R26
	SBCI R27,0
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	NEG  R27
	NEG  R26
	SBCI R27,0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	MOVW R22,R30
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

;END OF CODE MARKER
__END_OF_CODE:
