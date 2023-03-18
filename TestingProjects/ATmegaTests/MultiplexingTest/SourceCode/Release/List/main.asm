
;CodeVisionAVR C Compiler V2.05.6 Evaluation
;(C) Copyright 1998-2012 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

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
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

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
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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
	.DEF _S1=R4
	.DEF _H=R3
	.DEF _Z=R6
	.DEF _M=R5
	.DEF _S=R8
	.DEF _cnt_time=R7
	.DEF _T_SEC=R10
	.DEF _S2=R9
	.DEF _S_PULSE=R12
	.DEF _PULSE=R11
	.DEF _Q=R14
	.DEF _S3=R13

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
	.DB  0x0,0x0

_0x3:
	.DB  0x5F,0x0,0x0,0x0,0x1,0x0,0x0,0x0
	.DB  0x5F,0x0,0x0,0x1,0x1,0x0,0x0,0x0
	.DB  0x5F,0x0,0x0,0x2,0x1,0x0,0x0,0x0
	.DB  0x5F,0x0,0x0,0x3,0x1,0x0,0x0,0x0
	.DB  0x5F,0x0,0x0,0x4,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x28
_0x4:
	.DB  0x7,0x0,0x0,0x0,0x2,0x0,0x0,0x0
	.DB  0x7,0x0,0x0,0x1,0x2,0x0,0x0,0x0
	.DB  0x7,0x0,0x0,0x2,0x2,0x0,0x0,0x0
	.DB  0x7,0x0,0x0,0x3,0x2,0x0,0x0,0x0
	.DB  0x7,0x0,0x0,0x4,0x2,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x28,0x1
_0x5:
	.DB  0x0,0x0,0x0,0x1,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x2,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x3,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x4,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x5,0x3,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x28,0x2
_0x6:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x28,0x3
_0x7:
	.DB  0x0,0x1,0x2,0x3
_0x8:
	.DB  LOW(_A0),HIGH(_A0),LOW(_A1),HIGH(_A1),LOW(_A2),HIGH(_A2),LOW(_A3),HIGH(_A3)

__GLOBAL_INI_TBL:
	.DW  0x06
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

_0xFFFFFFFF:
	.DW  0

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
	.ORG 0

	.DSEG
	.ORG 0x200

	.CSEG
;/*******************************************************
;This program was created by the CodeWizardAVR V3.49a
;Automatic Program Generator
;© Copyright 1998-2022 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro
;
;Project :
;Version :
;Date    : 3/11/2023
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega164A
;Program type            : Application
;AVR Core Clock frequency: 10.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;// I/O Registers definitions
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
;// #include <util/delay.h>
;
;// Useful definitions
;// Numar perioade necesare duratei unui
;// puls intreg (100 ms)
;#define T 5
;
;// Numar de perioade necesare
;// duratei unui puls pozitiv (cu durata 20 ms)
;#define DP 1
;
;/// CLS definitions ///
;char S1 = 0; // CLS state
;const long int H1 = 95;
;const long int H2 = 7;
;
;const long int Ter = 0x28000000;
;
;long int A0[]={0x00000000+H1, 1, 0x01000000+H1, 1, 0x02000000+H1, 1, 0x03000000+H1, 1, 0x04000000+H1, 1, Ter, 0};

	.DSEG
;long int A1[]={0x00000000+H2, 2, 0x01000000+H2, 2, 0x02000000+H2, 2, 0x03000000+H2, 2, 0x04000000+H2, 2, Ter, 1};
;long int A2[]={0x01000000, 0, 0x02000000, 0, 0x03000000, 0, 0x04000000, 0, 0x05000000, 3, Ter, 2};
;long int A3[]={0x00000000, 0, Ter, 3};
;
;char Tout[] = {0, 1, 2, 3};
;long int *TABA[] = {A0, A1, A2, A3};
;///////////////////////
;
;/// Time variables ///
;char H = 0; //hour
;char Z = 0; //day
;char M = 0; //minutes
;char S = 0; //seconds
;/////////////////////
;
;
;char cnt_time = 0; //contor de timp
;char T_SEC; // numar de perioade necesare pentru a acoperi 1 sec
;char S2; //starea de contorizare a PS-ului
;
;char S_PULSE;
;
;
;////// Global variables ////////
;// PULSE
;char PULSE;
;
;// State variables ( Q -> consumption range,
;// S1 -> consumption counting state,
;// S3 -> display state)
;char Q, S3;
;
;// Consumption array
;char CONSUM[] = {0, 0, 0, 0};
;
;// Total consumption
;char TOTAL_CONS = 0;
;
;// Digits
;char C4, C3, C2, C1;
;
;// CA
;char CA;
;
;// Digit patterns (CLC)
;const char DIGITS[] = {
;    0b11000000, // 0
;    0b11111001, // 1
;    0b10100100, // 2
;    0b10110000, // 3
;    0b10011001, // 4
;    0b10010010, // 5
;    0b10000010, // 6
;    0b11111000, // 7
;    0b10000000, // 8
;    0b10010000  // 9
;};
;///////////////////////////////
;
;// Pulses contor
;char cntP = 0;
;
;//// Function headers ////
;void Init();
;void UpdateConsumption();
;void DisplayConsumption();
;void DisplayDigit(char currentDisplay, char digit);
;void UpdateTime();
;void CLS();
;void MockPULSE();
;/////////////////////////
;
;
;/////// SCI ///////
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0078 {

	.CSEG
_timer0_ovf_isr:
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
; 0000 0079     // Reinitialize Timer 0 value
; 0000 007A     TCNT0=0x3C;
	LDI  R30,LOW(60)
	OUT  0x26,R30
; 0000 007B 
; 0000 007C     // Update CA
; 0000 007D     CA = (PORTD & 0x20) >> 5;
	IN   R30,0xB
	ANDI R30,LOW(0x20)
	LDI  R31,0
	ASR  R31
	ROR  R30
	CALL __ASRW4
	STS  _CA,R30
; 0000 007E 
; 0000 007F     // Update mock pulse
; 0000 0080     MockPULSE();
	RCALL _MockPULSE
; 0000 0081 
; 0000 0082     // Check for pulses coming from ADSP
; 0000 0083     UpdateConsumption();
	RCALL _UpdateConsumption
; 0000 0084 
; 0000 0085     // DisplayConsumption();
; 0000 0086 
; 0000 0087 }
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
;///////////////////
;
;void main(void)
; 0000 008B {
_main:
; 0000 008C // Declare your local variables here
; 0000 008D 
; 0000 008E // Crystal Oscillator division factor: 1
; 0000 008F #pragma optsize-
; 0000 0090 CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 0091 CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 0092 #ifdef _OPTIMIZE_SIZE_
; 0000 0093 #pragma optsize+
; 0000 0094 #endif
; 0000 0095 
; 0000 0096 // Input/Output Ports initialization
; 0000 0097 // Port A initialization
; 0000 0098 // Function: Bit7=Out Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0099 DDRA=(1<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(128)
	OUT  0x1,R30
; 0000 009A // State: Bit7=1 Bit6=P Bit5=P Bit4=P Bit3=P Bit2=P Bit1=P Bit0=P
; 0000 009B PORTA=(1<<PORTA7) | (1<<PORTA6) | (1<<PORTA5) | (1<<PORTA4) | (1<<PORTA3) | (1<<PORTA2) | (1<<PORTA1) | (1<<PORTA0);
	LDI  R30,LOW(255)
	OUT  0x2,R30
; 0000 009C 
; 0000 009D // Port B initialization
; 0000 009E // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 009F DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	OUT  0x4,R30
; 0000 00A0 // State: Bit7=1 Bit6=1 Bit5=1 Bit4=1 Bit3=1 Bit2=1 Bit1=1 Bit0=1
; 0000 00A1 PORTB=(1<<PORTB7) | (1<<PORTB6) | (1<<PORTB5) | (1<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);
	OUT  0x5,R30
; 0000 00A2 
; 0000 00A3 // Port C initialization
; 0000 00A4 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 00A5 DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	OUT  0x7,R30
; 0000 00A6 // State: Bit7=1 Bit6=1 Bit5=1 Bit4=1 Bit3=1 Bit2=1 Bit1=1 Bit0=1
; 0000 00A7 PORTC=(1<<PORTC7) | (1<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (1<<PORTC3) | (1<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);
	OUT  0x8,R30
; 0000 00A8 
; 0000 00A9 // Port D initialization
; 0000 00AA // Function: Bit7=In Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 00AB DDRD=(0<<DDD7) | (0<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(63)
	OUT  0xA,R30
; 0000 00AC // State: Bit7=T Bit6=T Bit5=1 Bit4=1 Bit3=1 Bit2=1 Bit1=1 Bit0=1
; 0000 00AD PORTD=(0<<PORTD7) | (0<<PORTD6) | (1<<PORTD5) | (1<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (1<<PORTD1) | (1<<PORTD0);
	OUT  0xB,R30
; 0000 00AE 
; 0000 00AF // Timer/Counter 0 initialization
; 0000 00B0 // Clock source: System Clock
; 0000 00B1 // Clock value: 9.766 kHz
; 0000 00B2 // Mode: Normal top=0xFF
; 0000 00B3 // OC0A output: Disconnected
; 0000 00B4 // OC0B output: Disconnected
; 0000 00B5 // Timer Period: 20.07 ms
; 0000 00B6 TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 00B7 TCCR0B=(0<<WGM02) | (1<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(5)
	OUT  0x25,R30
; 0000 00B8 TCNT0=0x3C;
	LDI  R30,LOW(60)
	OUT  0x26,R30
; 0000 00B9 OCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 00BA OCR0B=0x00;
	OUT  0x28,R30
; 0000 00BB 
; 0000 00BC // Timer/Counter 1 initialization
; 0000 00BD // Clock source: System Clock
; 0000 00BE // Clock value: Timer1 Stopped
; 0000 00BF // Mode: Normal top=0xFFFF
; 0000 00C0 // OC1A output: Disconnected
; 0000 00C1 // OC1B output: Disconnected
; 0000 00C2 // Noise Canceler: Off
; 0000 00C3 // Input Capture on Falling Edge
; 0000 00C4 // Timer1 Overflow Interrupt: Off
; 0000 00C5 // Input Capture Interrupt: Off
; 0000 00C6 // Compare A Match Interrupt: Off
; 0000 00C7 // Compare B Match Interrupt: Off
; 0000 00C8 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	STS  128,R30
; 0000 00C9 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	STS  129,R30
; 0000 00CA TCNT1H=0x00;
	STS  133,R30
; 0000 00CB TCNT1L=0x00;
	STS  132,R30
; 0000 00CC ICR1H=0x00;
	STS  135,R30
; 0000 00CD ICR1L=0x00;
	STS  134,R30
; 0000 00CE OCR1AH=0x00;
	STS  137,R30
; 0000 00CF OCR1AL=0x00;
	STS  136,R30
; 0000 00D0 OCR1BH=0x00;
	STS  139,R30
; 0000 00D1 OCR1BL=0x00;
	STS  138,R30
; 0000 00D2 
; 0000 00D3 // Timer/Counter 2 initialization
; 0000 00D4 // Clock source: System Clock
; 0000 00D5 // Clock value: Timer2 Stopped
; 0000 00D6 // Mode: Normal top=0xFF
; 0000 00D7 // OC2A output: Disconnected
; 0000 00D8 // OC2B output: Disconnected
; 0000 00D9 ASSR=(0<<EXCLK) | (0<<AS2);
	STS  182,R30
; 0000 00DA TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
	STS  176,R30
; 0000 00DB TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	STS  177,R30
; 0000 00DC TCNT2=0x00;
	STS  178,R30
; 0000 00DD OCR2A=0x00;
	STS  179,R30
; 0000 00DE OCR2B=0x00;
	STS  180,R30
; 0000 00DF 
; 0000 00E0 // Timer/Counter 0 Interrupt(s) initialization
; 0000 00E1 TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);
	LDI  R30,LOW(1)
	STS  110,R30
; 0000 00E2 
; 0000 00E3 // Timer/Counter 1 Interrupt(s) initialization
; 0000 00E4 TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);
	LDI  R30,LOW(0)
	STS  111,R30
; 0000 00E5 
; 0000 00E6 // Timer/Counter 2 Interrupt(s) initialization
; 0000 00E7 TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);
	STS  112,R30
; 0000 00E8 
; 0000 00E9 // External Interrupt(s) initialization
; 0000 00EA // INT0: Off
; 0000 00EB // INT1: Off
; 0000 00EC // INT2: Off
; 0000 00ED // Interrupt on any change on pins PCINT0-7: Off
; 0000 00EE // Interrupt on any change on pins PCINT8-15: Off
; 0000 00EF // Interrupt on any change on pins PCINT16-23: Off
; 0000 00F0 // Interrupt on any change on pins PCINT24-31: Off
; 0000 00F1 EICRA=(0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  105,R30
; 0000 00F2 EIMSK=(0<<INT2) | (0<<INT1) | (0<<INT0);
	OUT  0x1D,R30
; 0000 00F3 PCICR=(0<<PCIE3) | (0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	STS  104,R30
; 0000 00F4 
; 0000 00F5 // USART0 initialization
; 0000 00F6 // USART0 disabled
; 0000 00F7 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	STS  193,R30
; 0000 00F8 
; 0000 00F9 // USART1 initialization
; 0000 00FA // USART1 disabled
; 0000 00FB UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	STS  201,R30
; 0000 00FC 
; 0000 00FD // Analog Comparator initialization
; 0000 00FE // Analog Comparator: Off
; 0000 00FF // The Analog Comparator's positive input is
; 0000 0100 // connected to the AIN0 pin
; 0000 0101 // The Analog Comparator's negative input is
; 0000 0102 // connected to the AIN1 pin
; 0000 0103 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 0104 ADCSRB=(0<<ACME);
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 0105 // Digital input buffer on AIN0: On
; 0000 0106 // Digital input buffer on AIN1: On
; 0000 0107 DIDR1=(0<<AIN0D) | (0<<AIN1D);
	STS  127,R30
; 0000 0108 
; 0000 0109 // ADC initialization
; 0000 010A // ADC disabled
; 0000 010B ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	STS  122,R30
; 0000 010C 
; 0000 010D // SPI initialization
; 0000 010E // SPI disabled
; 0000 010F SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0x2C,R30
; 0000 0110 
; 0000 0111 // TWI initialization
; 0000 0112 // TWI disabled
; 0000 0113 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  188,R30
; 0000 0114 
; 0000 0115 // Globally enable interrupts
; 0000 0116 #asm("sei")
	sei
; 0000 0117 
; 0000 0118 // Initialize the device
; 0000 0119 Init();
	RCALL _Init
; 0000 011A 
; 0000 011B while (1)
_0x9:
; 0000 011C       {
; 0000 011D       // Display the consumption
; 0000 011E       DisplayConsumption();
	RCALL _DisplayConsumption
; 0000 011F 
; 0000 0120       // Wait for interruptions
; 0000 0121       }
	RJMP _0x9
; 0000 0122 }
_0xC:
	RJMP _0xC
;
;///// Function definitions /////
;void Init()
; 0000 0126 {
_Init:
; 0000 0127     // Setting initial states = 0
; 0000 0128     Q = S1 = S2 = S3 = S_PULSE = 0;
	LDI  R30,LOW(0)
	MOV  R12,R30
	MOV  R13,R30
	MOV  R9,R30
	MOV  R4,R30
	MOV  R14,R30
; 0000 0129 
; 0000 012A     // Turn off displays
; 0000 012B     PORTC = 0xff;
	LDI  R30,LOW(255)
	OUT  0x8,R30
; 0000 012C     PORTD = 0xff;
	OUT  0xB,R30
; 0000 012D     PORTB = 0xff;
	OUT  0x5,R30
; 0000 012E }
	RET
;
;void UpdateConsumption()
; 0000 0131 {
_UpdateConsumption:
; 0000 0132     // Identify PULSE
; 0000 0133     // PULSE = PINA & 0x01;
; 0000 0134 
; 0000 0135     /* switch(S2)
; 0000 0136     {
; 0000 0137         case 0:
; 0000 0138         {
; 0000 0139             char cntP = 0;
; 0000 013A 
; 0000 013B             // PD6 -> Sending request from ADSP
; 0000 013C             // PD7 -> Reading ack from ATmega164A
; 0000 013D 
; 0000 013E             // Check if sending request flag is up
; 0000 013F             // (Receiving sending request on PD6)
; 0000 0140             if (PORTD && 0x40)
; 0000 0141             {
; 0000 0142                 // Send reading ack
; 0000 0143                 // (Sending ack on PD7)
; 0000 0144                 PORTD |= 0x80;
; 0000 0145 
; 0000 0146                 // Going further to reading the pulses
; 0000 0147                 S2 = 1;
; 0000 0148             }
; 0000 0149             break;
; 0000 014A         }
; 0000 014B         case 1:
; 0000 014C         {
; 0000 014D             // If PULSE is on, start counting
; 0000 014E             if (PULSE)
; 0000 014F             {
; 0000 0150                 // Increment cntP
; 0000 0151                 cntP += 1;
; 0000 0152 
; 0000 0153                 // Reset reading flag
; 0000 0154                 PORTD &= 0x7f;
; 0000 0155 
; 0000 0156                 // Go further if the pulse period has passed,
; 0000 0157                 // otherwise go back wait for sensding ack again.
; 0000 0158                 S2 = (cntP == DP) ? 2 : 1;
; 0000 0159             }
; 0000 015A             break;
; 0000 015B         }
; 0000 015C         case 2:
; 0000 015D         {
; 0000 015E             if (~PULSE)
; 0000 015F             {
; 0000 0160                 // Update current consumption range
; 0000 0161                 Q = CLS();
; 0000 0162 
; 0000 0163                 // Increment consumption
; 0000 0164                 CONS[Q] += 1;
; 0000 0165 
; 0000 0166                 // Wait for another pulse
; 0000 0167                 S2 = 0;
; 0000 0168             }
; 0000 0169             break;
; 0000 016A         }
; 0000 016B     } */
; 0000 016C 
; 0000 016D     switch(S2)
	MOV  R30,R9
	LDI  R31,0
; 0000 016E     {
; 0000 016F         case 0:
	SBIW R30,0
	BRNE _0x10
; 0000 0170         {
; 0000 0171             // If PULSE is on, start counting
; 0000 0172             if (PULSE)
	TST  R11
	BREQ _0x11
; 0000 0173             {
; 0000 0174                 // Increment cntP
; 0000 0175                 cntP += 1;
	LDS  R30,_cntP
	SUBI R30,-LOW(1)
	STS  _cntP,R30
; 0000 0176 
; 0000 0177                 // Reset reading flag
; 0000 0178                 PORTD &= 0x7f;
	CBI  0xB,7
; 0000 0179 
; 0000 017A                 // Go further if the pulse period has passed,
; 0000 017B                 // otherwise go back wait for sensding ack again.
; 0000 017C                 S2 = (cntP == DP) ? 1 : 0;
	LDS  R26,_cntP
	CPI  R26,LOW(0x1)
	BRNE _0x12
	LDI  R30,LOW(1)
	RJMP _0x13
_0x12:
	LDI  R30,LOW(0)
_0x13:
	MOV  R9,R30
; 0000 017D             }
; 0000 017E             break;
_0x11:
	RJMP _0xF
; 0000 017F         }
; 0000 0180         case 1:
_0x10:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xF
; 0000 0181         {
; 0000 0182             if (~PULSE)
	MOV  R30,R11
	COM  R30
	CPI  R30,0
	BREQ _0x16
; 0000 0183             {
; 0000 0184                 // Update current consumption range
; 0000 0185                 CLS();
	RCALL _CLS
; 0000 0186 
; 0000 0187                 // Increment consumption
; 0000 0188                 CONSUM[Q] += 1;
	MOV  R26,R14
	LDI  R27,0
	SUBI R26,LOW(-_CONSUM)
	SBCI R27,HIGH(-_CONSUM)
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
; 0000 0189 
; 0000 018A                 // Wait for another pulse
; 0000 018B                 S2 = 0;
	CLR  R9
; 0000 018C                 cntP = 0;
	LDI  R30,LOW(0)
	STS  _cntP,R30
; 0000 018D             }
; 0000 018E             break;
_0x16:
; 0000 018F         }
; 0000 0190     }
_0xF:
; 0000 0191 }
	RET
;
;void MockPULSE()
; 0000 0194 {
_MockPULSE:
; 0000 0195      switch(S_PULSE)
	MOV  R30,R12
	LDI  R31,0
; 0000 0196      {
; 0000 0197         case 0:
	SBIW R30,0
	BRNE _0x1A
; 0000 0198         {
; 0000 0199             PULSE = 1;
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 019A             S_PULSE = 1;
	MOV  R12,R30
; 0000 019B             break;
	RJMP _0x19
; 0000 019C         }
; 0000 019D         case 1:
_0x1A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x19
; 0000 019E         {
; 0000 019F             PULSE = 0;
	CLR  R11
; 0000 01A0             S_PULSE = 0;
	CLR  R12
; 0000 01A1             break;
; 0000 01A2         }
; 0000 01A3      }
_0x19:
; 0000 01A4 }
	RET
;
;void DisplayConsumption()
; 0000 01A7 {
_DisplayConsumption:
; 0000 01A8     // We assume:
; 0000 01A9     // PORTC: PC0 - PC6 -> 7 segments (A-G)
; 0000 01AA     // PORTD: PD0 - PD3 -> select the common cathode for each digit (multiplexing)
; 0000 01AB               // PD3 - C4, PD2 - C3, PD1 - C2, PD0 - C1
; 0000 01AC     // Q - consumption range:
; 0000 01AD         // 0 -> 00:00 - H1:00
; 0000 01AE         // 1 -> H1:00 - H2:00               (MON - FRI)
; 0000 01AF         // 2 -> H2:00 - 00:00 (next day)
; 0000 01B0         // 3 -> SAT - SUN
; 0000 01B1 
; 0000 01B2     // The actual approach:
; 0000 01B3     // Each main loop iteration we multiplex the digits and display one at a time
; 0000 01B4 
; 0000 01B5     // If CA is pressed -> display total consumption,
; 0000 01B6     // else -> display consumption based on current range.
; 0000 01B7     char cons;
; 0000 01B8     CA = 1;
	ST   -Y,R17
;	cons -> R17
	LDI  R30,LOW(1)
	STS  _CA,R30
; 0000 01B9     cons = (!CA) ? TOTAL_CONS : CONSUM[Q];
	CPI  R30,0
	BRNE _0x1C
	LDS  R30,_TOTAL_CONS
	RJMP _0x1D
_0x1C:
	MOV  R30,R14
	LDI  R31,0
	SUBI R30,LOW(-_CONSUM)
	SBCI R31,HIGH(-_CONSUM)
	LD   R30,Z
_0x1D:
	MOV  R17,R30
; 0000 01BA 
; 0000 01BB     // Compute and display C4
; 0000 01BC     C4 = cons / 1000;
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21
	STS  _C4,R30
; 0000 01BD     cons %= 1000;
	MOV  R26,R17
	CLR  R27
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __MODW21
	MOV  R17,R30
; 0000 01BE     DisplayDigit(4, C4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDS  R26,_C4
	RCALL _DisplayDigit
; 0000 01BF 
; 0000 01C0     // Compute and display C3
; 0000 01C1     C3 = cons / 100;
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	STS  _C3,R30
; 0000 01C2     cons %= 100;
	MOV  R26,R17
	CLR  R27
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	MOV  R17,R30
; 0000 01C3     DisplayDigit(3, C3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDS  R26,_C3
	RCALL _DisplayDigit
; 0000 01C4 
; 0000 01C5     // Compute and display C2
; 0000 01C6     C2 = cons / 10;
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	STS  _C2,R30
; 0000 01C7     DisplayDigit(2, C2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDS  R26,_C2
	RCALL _DisplayDigit
; 0000 01C8 
; 0000 01C9     // Compute and display C1
; 0000 01CA     C1 = cons % 10;
	MOV  R26,R17
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	STS  _C1,R30
; 0000 01CB     DisplayDigit(1, C1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDS  R26,_C1
	RCALL _DisplayDigit
; 0000 01CC }
	LD   R17,Y+
	RET
;
;void DisplayDigit(char currentDisplay, char digit)
; 0000 01CF {
_DisplayDigit:
; 0000 01D0     // Select the desired display (turn on the pin
; 0000 01D1     // corresponding to the desired digit (C4/C3/C2/C1)
; 0000 01D2     char output = 0xff;
; 0000 01D3 
; 0000 01D4     // Set PORTC pins to the corresponding digit
; 0000 01D5     // PORTC = DIGITS[digit];
; 0000 01D6 
; 0000 01D7     switch (currentDisplay)
	ST   -Y,R26
	ST   -Y,R17
;	currentDisplay -> Y+2
;	digit -> Y+1
;	output -> R17
	LDI  R17,255
	LDD  R30,Y+2
	LDI  R31,0
; 0000 01D8     {
; 0000 01D9         case 4:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x22
; 0000 01DA             // Turn PD3 on
; 0000 01DB             //output &= 0b11110111;
; 0000 01DC             output &= 0b11111000;
	ANDI R17,LOW(248)
; 0000 01DD             break;
	RJMP _0x21
; 0000 01DE         case 3:
_0x22:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x23
; 0000 01DF             // Turn PD2 on
; 0000 01E0             // output &= 0b11111011;
; 0000 01E1             output &= 0b11110100;
	ANDI R17,LOW(244)
; 0000 01E2             break;
	RJMP _0x21
; 0000 01E3         case 2:
_0x23:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x24
; 0000 01E4             // Turn PD1 on
; 0000 01E5             output &= 0b11110010;
	ANDI R17,LOW(242)
; 0000 01E6             break;
	RJMP _0x21
; 0000 01E7         case 1:
_0x24:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x21
; 0000 01E8             // Turn PD0 on
; 0000 01E9             output &= 0b11110001;
	ANDI R17,LOW(241)
; 0000 01EA             break;
; 0000 01EB     }
_0x21:
; 0000 01EC 
; 0000 01ED     // Assign output to PORTC in order to select the desired display;
; 0000 01EE     PORTD = output;
	OUT  0xB,R17
; 0000 01EF 
; 0000 01F0     // Set PORTC pins to the corresponding digit
; 0000 01F1     PORTC = DIGITS[digit];
	LDD  R30,Y+1
	LDI  R31,0
	SUBI R30,LOW(-_DIGITS*2)
	SBCI R31,HIGH(-_DIGITS*2)
	LPM  R0,Z
	OUT  0x8,R0
; 0000 01F2 
; 0000 01F3     // Add delay (10 us)
; 0000 01F4     // _display_us(10);
; 0000 01F5 }
	LDD  R17,Y+0
	ADIW R28,3
	RET
;
;
;void UpdateTime(){
; 0000 01F8 void UpdateTime(){
; 0000 01F9     cnt_time += 1; //incrementare contor de timp
; 0000 01FA     if(cnt_time != T_SEC) return;
; 0000 01FB 
; 0000 01FC     cnt_time = 0; // se reseteaza contorul
; 0000 01FD     S+=1;  //incrementeaza contor secunde
; 0000 01FE 
; 0000 01FF     if(S!=60) return;
; 0000 0200     S = 0;//se reseteaza nr de secunde
; 0000 0201     M += 1; //incrementeaza contor minute
; 0000 0202 
; 0000 0203     if(M!=60) return;
; 0000 0204     M = 0;
; 0000 0205     H += 1;
; 0000 0206 
; 0000 0207     if(H!=24) return;
; 0000 0208     H = 0;
; 0000 0209     Z += 1;
; 0000 020A 
; 0000 020B     if (Z == 7) Z = 0;
; 0000 020C     return;
; 0000 020D }
;
;
;
;void CLS()
; 0000 0212 {
_CLS:
; 0000 0213     char out;
; 0000 0214 
; 0000 0215     //exemplu
; 0000 0216     // Ziua 3, ora 8, min 6, sec 3
; 0000 0217     // 0x03080603
; 0000 0218     int now = (Z<<24) | (H<<16) | (M<<8) | S;
; 0000 0219 
; 0000 021A     long int *adr = TABA[Q];
; 0000 021B     char ready = 0;
; 0000 021C     int i = 0;
; 0000 021D 
; 0000 021E     while (!ready)
	SBIW R28,2
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	CALL __SAVELOCR6
;	out -> R17
;	now -> R18,R19
;	*adr -> R20,R21
;	ready -> R16
;	i -> Y+6
	MOV  R26,R6
	LDI  R27,0
	LDI  R30,LOW(24)
	CALL __LSLW12
	MOVW R22,R30
	MOV  R26,R3
	LDI  R27,0
	LDI  R30,LOW(16)
	CALL __LSLW12
	OR   R30,R22
	OR   R31,R23
	MOVW R26,R30
	MOV  R31,R5
	LDI  R30,LOW(0)
	OR   R30,R26
	OR   R31,R27
	MOVW R26,R30
	MOV  R30,R8
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	MOVW R18,R30
	MOV  R30,R14
	LDI  R26,LOW(_TABA)
	LDI  R27,HIGH(_TABA)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	MOVW R20,R30
	LDI  R16,0
_0x2B:
	CPI  R16,0
	BRNE _0x2D
; 0000 021F     {
; 0000 0220         if (now == adr[i]) {
	RCALL SUBOPT_0x0
	MOVW R26,R18
	CALL __CWD2
	CALL __CPD12
	BRNE _0x2E
; 0000 0221             Q = adr[i + 1];
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	MOVW R26,R20
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LD   R14,X
; 0000 0222             ready = 1;  // ies din while
	LDI  R16,LOW(1)
; 0000 0223         }
; 0000 0224         else if (adr[i] == T) ready = 1;
	RJMP _0x2F
_0x2E:
	RCALL SUBOPT_0x0
	__CPD1N 0x5
	BRNE _0x30
	LDI  R16,LOW(1)
; 0000 0225         else i = i+2;
	RJMP _0x31
_0x30:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0226     }
_0x31:
_0x2F:
	RJMP _0x2B
_0x2D:
; 0000 0227 
; 0000 0228     out = Tout[Q];
	MOV  R30,R14
	LDI  R31,0
	SUBI R30,LOW(-_Tout)
	SBCI R31,HIGH(-_Tout)
	LD   R17,Z
; 0000 0229 }
	CALL __LOADLOCR6
	ADIW R28,8
	RET
;
;////////////////////////////////////////

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
_CONSUM:
	.BYTE 0x4
_TOTAL_CONS:
	.BYTE 0x1
_C4:
	.BYTE 0x1
_C3:
	.BYTE 0x1
_C2:
	.BYTE 0x1
_C1:
	.BYTE 0x1
_CA:
	.BYTE 0x1
_cntP:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	MOVW R26,R20
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	RET


	.CSEG
__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
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

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
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
	COM  R26
	COM  R27
	ADIW R26,1
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
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

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

;END OF CODE MARKER
__END_OF_CODE:
