
;CodeVisionAVR C Compiler V3.35 Evaluation
;(C) Copyright 1998-2019 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega164A
;Program type           : Application
;Clock frequency        : 20,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': No
;'char' is unsigned     : No
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Mode 1
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
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E
	.EQU GPIOR1=0x2A
	.EQU GPIOR2=0x2B

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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
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
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
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
	.DEF _rx_wr_index0=R3
	.DEF _rx_rd_index0=R2
	.DEF _rx_counter0=R5
	.DEF _cnt=R4
	.DEF _key=R7
	.DEF _tx_wr_index0=R6
	.DEF _tx_rd_index0=R9
	.DEF _tx_counter0=R8

;GPIOR0-GPIOR2 INITIALIZATION VALUES
	.EQU __GPIOR0_INIT=0x00
	.EQU __GPIOR1_INIT=0x00
	.EQU __GPIOR2_INIT=0x00

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
	JMP  _timer1_compa_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart0_rx_isr
	JMP  0x00
	JMP  _usart0_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0xD,0xA,0x53,0x77,0x56,0x65,0x72,0x73
	.DB  0x69,0x6F,0x6E,0x3A,0x25,0x64,0x2E,0x25
	.DB  0x64,0xD,0xA,0x0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

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

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	STS  WDTCSR,R31
	STS  WDTCSR,R30

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

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30
	;__GPIOR1_INIT = __GPIOR0_INIT
	OUT  GPIOR1,R30
	;__GPIOR2_INIT = __GPIOR0_INIT
	OUT  GPIOR2,R30

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
	.ORG 0x01

	.DSEG
	.ORG 0x200

	.CSEG
;/*********************************************
;Project : Test software
;**********************************************
;Chip type: ATmega164A
;Clock frequency: 20 MHz
;Compilers:  CVAVR 2.x
;*********************************************/
;
;#include <mega164a.h>
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
;
;#include <stdio.h>
;#include <delay.h>
;#include <string.h>
;#include <stdlib.h>
;#include "defs.h"
;
;//*************************************************************************************************
;//*********** BEGIN SERIAL STUFF (interrupt-driven, generated by Code Wizard) *********************
;//*************************************************************************************************
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART0 Receiver buffer
;#define RX_BUFFER_SIZE0 8
;char rx_buffer0[RX_BUFFER_SIZE0];
;
;#if RX_BUFFER_SIZE0 <= 256
;unsigned char rx_wr_index0,rx_rd_index0,rx_counter0;
;#else
;unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;
;#endif
;
;// This flag is set on USART0 Receiver buffer overflow
;bit rx_buffer_overflow0;
;
;//
;unsigned char cnt;  // interrupts count
;char key;           // key pressed
;char read_keyboard(void);
;void write_LED(char a);
;void write_PF(char a);
;
;//
;
;
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0000 0050 {

	.CSEG
_usart0_rx_isr:
; .FSTART _usart0_rx_isr
	RCALL SUBOPT_0x0
; 0000 0051 char status,data;
; 0000 0052 status=UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDS  R17,192
; 0000 0053 data=UDR0;
	LDS  R16,198
; 0000 0054 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 0055    {
; 0000 0056    rx_buffer0[rx_wr_index0++]=data;
	MOV  R30,R3
	INC  R3
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 0057 #if RX_BUFFER_SIZE0 == 256
; 0000 0058    // special case for receiver buffer size=256
; 0000 0059    if (++rx_counter0 == 0) rx_buffer_overflow0=1;
; 0000 005A #else
; 0000 005B    if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R3
	BRNE _0x4
	CLR  R3
; 0000 005C    if (++rx_counter0 == RX_BUFFER_SIZE0)
_0x4:
	INC  R5
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x5
; 0000 005D       {
; 0000 005E       rx_counter0=0;
	CLR  R5
; 0000 005F       rx_buffer_overflow0=1;
	SBI  0x1E,0
; 0000 0060       }
; 0000 0061 #endif
; 0000 0062    }
_0x5:
; 0000 0063 }
_0x3:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x3A
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART0 Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 006A {
_getchar:
; .FSTART _getchar
; 0000 006B char data;
; 0000 006C while (rx_counter0==0);
	ST   -Y,R17
;	data -> R17
_0x8:
	TST  R5
	BREQ _0x8
; 0000 006D data=rx_buffer0[rx_rd_index0++];
	MOV  R30,R2
	INC  R2
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R17,Z
; 0000 006E #if RX_BUFFER_SIZE0 != 256
; 0000 006F if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R2
	BRNE _0xB
	CLR  R2
; 0000 0070 #endif
; 0000 0071 #asm("cli")
_0xB:
	CLI
; 0000 0072 --rx_counter0;
	DEC  R5
; 0000 0073 #asm("sei")
	SEI
; 0000 0074 return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 0075 }
; .FEND
;#pragma used-
;#endif
;
;// USART0 Transmitter buffer
;#define TX_BUFFER_SIZE0 8
;char tx_buffer0[TX_BUFFER_SIZE0];
;
;#if TX_BUFFER_SIZE0 <= 256
;unsigned char tx_wr_index0,tx_rd_index0,tx_counter0;
;#else
;unsigned int tx_wr_index0,tx_rd_index0,tx_counter0;
;#endif
;
;// USART0 Transmitter interrupt service routine
;interrupt [USART0_TXC] void usart0_tx_isr(void)
; 0000 0085 {
_usart0_tx_isr:
; .FSTART _usart0_tx_isr
	RCALL SUBOPT_0x0
; 0000 0086 if (tx_counter0)
	TST  R8
	BREQ _0xC
; 0000 0087    {
; 0000 0088    --tx_counter0;
	DEC  R8
; 0000 0089    UDR0=tx_buffer0[tx_rd_index0++];
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	STS  198,R30
; 0000 008A #if TX_BUFFER_SIZE0 != 256
; 0000 008B    if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R9
	BRNE _0xD
	CLR  R9
; 0000 008C #endif
; 0000 008D    }
_0xD:
; 0000 008E }
_0xC:
_0x3A:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART0 Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 0095 {
_putchar:
; .FSTART _putchar
; 0000 0096 while (tx_counter0 == TX_BUFFER_SIZE0);
	ST   -Y,R26
;	c -> Y+0
_0xE:
	LDI  R30,LOW(8)
	CP   R30,R8
	BREQ _0xE
; 0000 0097 #asm("cli")
	CLI
; 0000 0098 if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
	TST  R8
	BRNE _0x12
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BRNE _0x11
_0x12:
; 0000 0099    {
; 0000 009A    tx_buffer0[tx_wr_index0++]=c;
	MOV  R30,R6
	INC  R6
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R26,Y
	STD  Z+0,R26
; 0000 009B #if TX_BUFFER_SIZE0 != 256
; 0000 009C    if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R6
	BRNE _0x14
	CLR  R6
; 0000 009D #endif
; 0000 009E    ++tx_counter0;
_0x14:
	INC  R8
; 0000 009F    }
; 0000 00A0 else
	RJMP _0x15
_0x11:
; 0000 00A1    UDR0=c;
	LD   R30,Y
	STS  198,R30
; 0000 00A2 #asm("sei")
_0x15:
	SEI
; 0000 00A3 }
	ADIW R28,1
	RET
; .FEND
;#pragma used-
;#endif
;//*************************************************************************************************
;//********************END SERIAL STUFF (USART0)  **************************************************
;//*************************************************************************************************
;//*******   if you need USART1, enable it in Code Wizard and copy coresponding code here  *********
;//*************************************************************************************************
;
;/*
; * Timer 1 Output Compare A interrupt is used to blink LED
; */
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 00B0 {
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
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
; 0000 00B1 //char a,b,c,d;
; 0000 00B2 cnt=(cnt+1)%50;
	MOV  R26,R4
	SUBI R26,-LOW(1)
	LDI  R30,LOW(50)
	RCALL __MODB21U
	MOV  R4,R30
; 0000 00B3 if (cnt==0) LED1 = ~LED1; // invert LED
	TST  R4
	BRNE _0x16
	SBIS 0xB,6
	RJMP _0x17
	CBI  0xB,6
	RJMP _0x18
_0x17:
	SBI  0xB,6
_0x18:
; 0000 00B4 //
; 0000 00B5 key=read_keyboard();
_0x16:
	RCALL _read_keyboard
	MOV  R7,R30
; 0000 00B6 if (key!=-1)
	LDI  R30,LOW(255)
	CP   R30,R7
	BREQ _0x19
; 0000 00B7     {
; 0000 00B8     write_LED(key);
	MOV  R26,R7
	RCALL _write_LED
; 0000 00B9     write_PF(key);
	MOV  R26,R7
	RCALL _write_PF
; 0000 00BA     }
; 0000 00BB }
_0x19:
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
;
;/*
; * main function of program
; */
;void main (void)
; 0000 00C1 {
_main:
; .FSTART _main
; 0000 00C2 unsigned char temp,i;
; 0000 00C3 
; 0000 00C4 	Init_initController();  // this must be the first "init" action/call!
;	temp -> R17
;	i -> R16
	RCALL _Init_initController
; 0000 00C5 	#asm("sei")             // enable interrupts
	SEI
; 0000 00C6 	LED1 = 1;           	// initial state, will be changed by timer 1
	SBI  0xB,6
; 0000 00C7 
; 0000 00C8 	while(TRUE)
_0x1C:
; 0000 00C9 	{
; 0000 00CA    // }
; 0000 00CB 	///*
; 0000 00CC     	wdogtrig();	        // call often else processor will reset
	WDR
; 0000 00CD 		if(rx_counter0)     // if a character is available on serial port USART0
	TST  R5
	BREQ _0x1F
; 0000 00CE 		{
; 0000 00CF 			temp = getchar();
	RCALL _getchar
	MOV  R17,R30
; 0000 00D0 			if(temp == '?')
	CPI  R17,63
	BRNE _0x20
; 0000 00D1 				printf("\r\nSwVersion:%d.%d\r\n", SW_VERSION/10, SW_VERSION%10);
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x1
	RCALL __PUTPARD1
	__GETD1N 0x3
	RCALL __PUTPARD1
	LDI  R24,8
	RCALL _printf
	ADIW R28,10
; 0000 00D2 			else
	RJMP _0x21
_0x20:
; 0000 00D3 				putchar(temp+1);		// echo back the character + 1 ("a" becomes "b", etc)
	MOV  R26,R17
	SUBI R26,-LOW(1)
	RCALL _putchar
; 0000 00D4 		}
_0x21:
; 0000 00D5 
; 0000 00D6         if(SW1 == 0)        // pressed
_0x1F:
	SBIC 0x9,5
	RJMP _0x22
; 0000 00D7         {
; 0000 00D8             delay_ms(30);   // debounce switch
	LDI  R26,LOW(30)
	LDI  R27,0
	RCALL _delay_ms
; 0000 00D9             if(SW1 == 0)
	SBIC 0x9,5
	RJMP _0x23
; 0000 00DA             {                // LED will blink slow or fast
; 0000 00DB                 while(SW1==0)
_0x24:
	SBIC 0x9,5
	RJMP _0x26
; 0000 00DC                     wdogtrig();    // wait for release
	WDR
; 0000 00DD                 // alternate between values and values/4 for OCR1A register
; 0000 00DE                 // 0186 H / 4 = 0061 H
; 0000 00DF                 // new frequency = old frequency * 4
; 0000 00E0                 if(OCR1AH == 0x01)
	RJMP _0x24
_0x26:
	LDS  R26,137
	CPI  R26,LOW(0x1)
	BRNE _0x27
; 0000 00E1                     {TCNT1H=0; TCNT1L=0; OCR1AH = 0x00; OCR1AL = 0x61;}
	RCALL SUBOPT_0x1
	LDI  R30,LOW(0)
	STS  137,R30
	LDI  R30,LOW(97)
	RJMP _0x39
; 0000 00E2                 else
_0x27:
; 0000 00E3                     {TCNT1H=0; TCNT1L=0; OCR1AH = 0x01; OCR1AL = 0x86;}
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
_0x39:
	STS  136,R30
; 0000 00E4             }
; 0000 00E5         }
_0x23:
; 0000 00E6 
; 0000 00E7         // measure time intervals on oscilloscope connected to pin TESTP
; 0000 00E8         for(i=0; i<3; i++) {
_0x22:
	LDI  R16,LOW(0)
_0x2A:
	CPI  R16,3
	BRSH _0x2B
; 0000 00E9             TESTP = 1;
	SBI  0xB,4
; 0000 00EA             delay_us(1);
	__DELAY_USB 7
; 0000 00EB             TESTP = 0;   // may check accuracy of 1us interval on oscilloscope
	CBI  0xB,4
; 0000 00EC         }
	SUBI R16,-1
	RJMP _0x2A
_0x2B:
; 0000 00ED     }
	RJMP _0x1C
; 0000 00EE     //*/
; 0000 00EF 
; 0000 00F0 }// end main loop
_0x30:
	RJMP _0x30
; .FEND
;
;char read_keyboard(void)
; 0000 00F3 {
_read_keyboard:
; .FSTART _read_keyboard
; 0000 00F4 // line 0 - PA0,  line 1 - PA1,  line 2 - PA2,  line 3 - PA3 - outputs
; 0000 00F5 char scan[4]={0xFE,0xFD,0xFB, 0xF7};
; 0000 00F6 char row,col;
; 0000 00F7 char cod=0xFF;
; 0000 00F8 
; 0000 00F9 for (row=0; row<4; row++)
	SBIW R28,4
	LDI  R30,LOW(254)
	ST   Y,R30
	LDI  R30,LOW(253)
	STD  Y+1,R30
	LDI  R30,LOW(251)
	STD  Y+2,R30
	LDI  R30,LOW(247)
	STD  Y+3,R30
	RCALL __SAVELOCR4
;	scan -> Y+4
;	row -> R17
;	col -> R16
;	cod -> R19
	LDI  R19,255
	LDI  R17,LOW(0)
_0x32:
	CPI  R17,4
	BRGE _0x33
; 0000 00FA {
; 0000 00FB PORTA=scan[row];
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	OUT  0x2,R30
; 0000 00FC delay_us(1);
	__DELAY_USB 7
; 0000 00FD // col 0 - PA4,  col 1 - PA5,  col 2 - PA6,  col 3 - PA7 - inputs
; 0000 00FE col=PINA>>4;
	IN   R30,0x0
	SWAP R30
	ANDI R30,0xF
	MOV  R16,R30
; 0000 00FF if (col!=0x0F)
	CPI  R16,15
	BREQ _0x34
; 0000 0100     {
; 0000 0101     if (col==0x0E) col=0;
	CPI  R16,14
	BRNE _0x35
	LDI  R16,LOW(0)
; 0000 0102     if (col==0x0D) col=1;
_0x35:
	CPI  R16,13
	BRNE _0x36
	LDI  R16,LOW(1)
; 0000 0103     if (col==0x0B) col=2;
_0x36:
	CPI  R16,11
	BRNE _0x37
	LDI  R16,LOW(2)
; 0000 0104     if (col==0x07) col=3;
_0x37:
	CPI  R16,7
	BRNE _0x38
	LDI  R16,LOW(3)
; 0000 0105     cod=4*row+col;
_0x38:
	MOV  R30,R17
	LSL  R30
	LSL  R30
	ADD  R30,R16
	MOV  R19,R30
; 0000 0106     break;
	RJMP _0x33
; 0000 0107     }
; 0000 0108 }
_0x34:
	SUBI R17,-1
	RJMP _0x32
_0x33:
; 0000 0109 return cod;
	MOV  R30,R19
	RCALL __LOADLOCR4
	ADIW R28,8
	RET
; 0000 010A }
; .FEND
;
;void write_LED(char a)
; 0000 010D {
_write_LED:
; .FSTART _write_LED
; 0000 010E // write PORTC bits 7-4 with a 4 bits value a3-a0
; 0000 010F char val;
; 0000 0110 val=a & 0x0F;
	RCALL SUBOPT_0x3
;	a -> Y+1
;	val -> R17
; 0000 0111 PORTC=(PORTC & 0x0F) | (val << 4);
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	MOV  R30,R17
	SWAP R30
	ANDI R30,0xF0
	OR   R30,R26
	RJMP _0x20A0001
; 0000 0112 }
; .FEND
;void write_PF(char a)
; 0000 0114 {
_write_PF:
; .FSTART _write_PF
; 0000 0115 // write PORTC bits 3-0 with a 4 bits value a3-a0
; 0000 0116 char val;
; 0000 0117 val=a & 0x0F;
	RCALL SUBOPT_0x3
;	a -> Y+1
;	val -> R17
; 0000 0118 PORTC=(PORTC & 0xF0) | val;
	ANDI R30,LOW(0xF0)
	OR   R30,R17
_0x20A0001:
	OUT  0x8,R30
; 0000 0119 }
	LDD  R17,Y+0
	ADIW R28,2
	RET
; .FEND
;/* initialization file */
;
;#include <mega164a.h>
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
;
;#include "defs.h"
;
;
;/*
; * most intialization values are generated using Code Wizard and depend on clock value
; */
;void Init_initController(void)
; 0001 000C {

	.CSEG
_Init_initController:
; .FSTART _Init_initController
; 0001 000D // Crystal Oscillator division factor: 1
; 0001 000E #pragma optsize-
; 0001 000F CLKPR=0x80;
	LDI  R30,LOW(128)
	STS  97,R30
; 0001 0010 CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0001 0011 #ifdef _OPTIMIZE_SIZE_
; 0001 0012 #pragma optsize+
; 0001 0013 #endif
; 0001 0014 
; 0001 0015 // Input/Output Ports initialization
; 0001 0016 // Port A initialization
; 0001 0017 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0001 0018 DDRA=0b00001111; // PORTA 7-4 In , PORTA 3-0 Out
	LDI  R30,LOW(15)
	OUT  0x1,R30
; 0001 0019 PORTA=0b11111111; // Pull up - PORTA 7-4 (in) , out in logic 1 - PORTA 3-0
	LDI  R30,LOW(255)
	OUT  0x2,R30
; 0001 001A 
; 0001 001B // Port B initialization
; 0001 001C PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x5,R30
; 0001 001D DDRB=0x00;
	OUT  0x4,R30
; 0001 001E 
; 0001 001F // Port C initialization
; 0001 0020 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0001 0021 DDRC=0b11111111; // PORTC out
	LDI  R30,LOW(255)
	OUT  0x7,R30
; 0001 0022 PORTC = 0b00000000; //PORTC out in 0 logic
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0001 0023 
; 0001 0024 // Port D initialization
; 0001 0025 PORTD=0b00100000; // D.5 needs pull-up resistor
	LDI  R30,LOW(32)
	OUT  0xB,R30
; 0001 0026 DDRD= 0b01010000; // D.6 is LED, D.4 is test output
	LDI  R30,LOW(80)
	OUT  0xA,R30
; 0001 0027 
; 0001 0028 // Timer/Counter 0 initialization
; 0001 0029 // Clock source: System Clock
; 0001 002A // Clock value: Timer 0 Stopped
; 0001 002B // Mode: Normal top=FFh
; 0001 002C // OC0 output: Disconnected
; 0001 002D TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0001 002E TCCR0B=0x00;
	OUT  0x25,R30
; 0001 002F TCNT0=0x00;
	OUT  0x26,R30
; 0001 0030 OCR0A=0x00;
	OUT  0x27,R30
; 0001 0031 OCR0B=0x00;
	OUT  0x28,R30
; 0001 0032 
; 0001 0033 // Timer/Counter 1 initialization
; 0001 0034 // Clock source: System Clock
; 0001 0035 // Clock value: 19.531 kHz = CLOCK/256
; 0001 0036 // Mode: CTC top=OCR1A
; 0001 0037 // OC1A output: Discon.
; 0001 0038 // OC1B output: Discon.
; 0001 0039 // Noise Canceler: Off
; 0001 003A // Input Capture on Falling Edge
; 0001 003B // Timer 1 Overflow Interrupt: Off
; 0001 003C // Input Capture Interrupt: Off
; 0001 003D // Compare A Match Interrupt: On
; 0001 003E // Compare B Match Interrupt: Off
; 0001 003F 
; 0001 0040 TCCR1A=0x00;
	STS  128,R30
; 0001 0041 TCCR1B=0x0D;
	LDI  R30,LOW(13)
	STS  129,R30
; 0001 0042 TCNT1H=0x00;
	RCALL SUBOPT_0x1
; 0001 0043 TCNT1L=0x00;
; 0001 0044 ICR1H=0x00;
	LDI  R30,LOW(0)
	STS  135,R30
; 0001 0045 ICR1L=0x00;
	STS  134,R30
; 0001 0046 
; 0001 0047 // 1 sec = 19531 counts = 4C4BH counts
; 0001 0048 // 4C4BH = 4CH (MSB) and 4BH (LSB)
; 0001 0049 
; 0001 004A 
; 0001 004B //1 sec
; 0001 004C //OCR1AH=0x4C;
; 0001 004D //OCR1AL=0x4B;
; 0001 004E 
; 0001 004F // 20 ms
; 0001 0050 OCR1AH=0x01;
	RCALL SUBOPT_0x2
; 0001 0051 OCR1AL=0x86;
	STS  136,R30
; 0001 0052 
; 0001 0053 //OCR1AH=0x00;
; 0001 0054 //OCR1AL=0x40;
; 0001 0055 
; 0001 0056 
; 0001 0057 OCR1BH=0x00;
	LDI  R30,LOW(0)
	STS  139,R30
; 0001 0058 OCR1BL=0x00;
	STS  138,R30
; 0001 0059 
; 0001 005A // Timer/Counter 2 initialization
; 0001 005B // Clock source: System Clock
; 0001 005C // Clock value: Timer2 Stopped
; 0001 005D // Mode: Normal top=0xFF
; 0001 005E // OC2A output: Disconnected
; 0001 005F // OC2B output: Disconnected
; 0001 0060 ASSR=0x00;
	STS  182,R30
; 0001 0061 TCCR2A=0x00;
	STS  176,R30
; 0001 0062 TCCR2B=0x00;
	STS  177,R30
; 0001 0063 TCNT2=0x00;
	STS  178,R30
; 0001 0064 OCR2A=0x00;
	STS  179,R30
; 0001 0065 OCR2B=0x00;
	STS  180,R30
; 0001 0066 
; 0001 0067 // External Interrupt(s) initialization
; 0001 0068 // INT0: Off
; 0001 0069 // INT1: Off
; 0001 006A // INT2: Off
; 0001 006B // Interrupt on any change on pins PCINT0-7: Off
; 0001 006C // Interrupt on any change on pins PCINT8-15: Off
; 0001 006D // Interrupt on any change on pins PCINT16-23: Off
; 0001 006E // Interrupt on any change on pins PCINT24-31: Off
; 0001 006F EICRA=0x00;
	STS  105,R30
; 0001 0070 EIMSK=0x00;
	OUT  0x1D,R30
; 0001 0071 PCICR=0x00;
	STS  104,R30
; 0001 0072 
; 0001 0073 // Timer/Counter 0,1,2 Interrupt(s) initialization
; 0001 0074 TIMSK0=0x00;
	STS  110,R30
; 0001 0075 TIMSK1=0x02;
	LDI  R30,LOW(2)
	STS  111,R30
; 0001 0076 TIMSK2=0x00;
	LDI  R30,LOW(0)
	STS  112,R30
; 0001 0077 
; 0001 0078 // USART0 initialization
; 0001 0079 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0001 007A // USART0 Receiver: On
; 0001 007B // USART0 Transmitter: On
; 0001 007C // USART0 Mode: Asynchronous
; 0001 007D // USART0 Baud rate: 9600
; 0001 007E UCSR0A=0x00;
	STS  192,R30
; 0001 007F UCSR0B=0xD8;
	LDI  R30,LOW(216)
	STS  193,R30
; 0001 0080 UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  194,R30
; 0001 0081 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0001 0082 UBRR0L=0x81;
	LDI  R30,LOW(129)
	STS  196,R30
; 0001 0083 
; 0001 0084 // USART1 initialization
; 0001 0085 // USART1 disabled
; 0001 0086 UCSR1B=0x00;
	LDI  R30,LOW(0)
	STS  201,R30
; 0001 0087 
; 0001 0088 
; 0001 0089 // Analog Comparator initialization
; 0001 008A // Analog Comparator: Off
; 0001 008B // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0001 008C ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0001 008D ADCSRB=0x00;
	LDI  R30,LOW(0)
	STS  123,R30
; 0001 008E DIDR1=0x00;
	STS  127,R30
; 0001 008F 
; 0001 0090 // Watchdog Timer initialization
; 0001 0091 // Watchdog Timer Prescaler: OSC/2048
; 0001 0092 #pragma optsize-
; 0001 0093 
; 0001 0094 ///*
; 0001 0095 #asm("wdr")
	WDR
; 0001 0096 // Write 2 consecutive values to enable watchdog
; 0001 0097 // this is NOT a mistake !
; 0001 0098 WDTCSR=0x18;
	LDI  R30,LOW(24)
	STS  96,R30
; 0001 0099 WDTCSR=0x08;
	LDI  R30,LOW(8)
	STS  96,R30
; 0001 009A //*/
; 0001 009B 
; 0001 009C //  disable JTAG
; 0001 009D    MCUCR|= (1<<JTD);
	IN   R30,0x35
	ORI  R30,0x80
	OUT  0x35,R30
; 0001 009E    MCUCR|= (1<<JTD);
	IN   R30,0x35
	ORI  R30,0x80
	OUT  0x35,R30
; 0001 009F 
; 0001 00A0 #ifdef _OPTIMIZE_SIZE_
; 0001 00A1 #pragma optsize+
; 0001 00A2 #endif
; 0001 00A3 
; 0001 00A4 }
	RET
; .FEND
;
;
;
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

	.CSEG
_put_usart_G100:
; .FSTART _put_usart_G100
	ST   -Y,R27
	ST   -Y,R26
	LDD  R26,Y+2
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	ADIW R28,3
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	RCALL SUBOPT_0x4
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	RCALL SUBOPT_0x4
	RJMP _0x20000CC
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	RCALL SUBOPT_0x5
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x6
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x7
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x7
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	RCALL SUBOPT_0x5
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	RCALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	RCALL SUBOPT_0x5
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	RCALL SUBOPT_0x4
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	RCALL SUBOPT_0x4
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CD
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x6
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	RCALL SUBOPT_0x4
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x6
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000CC:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X+
	LD   R31,X+
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_printf:
; .FSTART _printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	RCALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __ADDW2R15
	LD   R30,X+
	LD   R31,X+
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET
; .FEND

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_rx_buffer0:
	.BYTE 0x8
_tx_buffer0:
	.BYTE 0x8
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	STS  133,R30
	STS  132,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(1)
	STS  137,R30
	LDI  R30,LOW(134)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	ANDI R30,LOW(0xF)
	MOV  R17,R30
	IN   R30,0x8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x4:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x5:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
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

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__MODB21U:
	RCALL __DIVB21U
	MOV  R30,R26
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x1388
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
