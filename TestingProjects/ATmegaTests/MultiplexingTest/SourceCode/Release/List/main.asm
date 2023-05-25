
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
	.DEF _cnt_time=R3
	.DEF _T_SEC=R6
	.DEF _S2=R5
	.DEF _S_PULSE=R8
	.DEF _MODE=R7
	.DEF _PULSE=R10
	.DEF _Q=R9
	.DEF _Q1=R12
	.DEF _S3=R11
	.DEF _TOTAL_CONS=R14
	.DEF _C4=R13

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
	.DB  0x44,0x5F,0x34,0x15,0xF,0x85,0x84,0x57
	.DB  0x4,0x5

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0

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
	.DB  0x7,0x0,0x6,0x0,0x8,0x0,0xA,0x0
	.DB  0xB
_0xA:
	.DB  0x0,0x20,0x60,0xE0
_0xB:
	.DB  0x1,0x2,0x3

__GLOBAL_INI_TBL:
	.DW  0x0C
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

	.DW  0x09
	.DW  _CONSUM
	.DW  _0x9*2

	.DW  0x04
	.DW  _CLC_LEVEL
	.DW  _0xA*2

	.DW  0x03
	.DW  _CLC_RANGE_OUTPUT
	.DW  _0xB*2

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
;const long int H1 = 8;
;const long int H2 = 16;
;
;const long int Ter = 0x10000000;
;
;long int A0[]={0x00000000+H1<<16, 1, 0x01000000+H1<<16, 1, 0x02000000+H1<<16, 1, 0x03000000+H1<<16, 1, 0x04000000+H1<<16, 1, Ter, 0};

	.DSEG
;long int A1[]={0x00000000+H2<<16, 2, 0x01000000+H2<<16, 2, 0x02000000+H2<<16, 2, 0x03000000+H2<<16, 2, 0x04000000+H2<<16, 2, Ter, 1};
;long int A2[]={0x01000000, 0, 0x02000000, 0, 0x03000000, 0, 0x04000000, 0, 0x05000000, 3, Ter, 2};
;long int A3[]={0x00000000, 0, Ter, 3};
;
;char Tout[] = {0, 1, 2, 3};
;long int *TABA[] = {A0, A1, A2, A3};
;///////////////////////
;
;/// Time variables ///
;long int Z = 0; //day
;long int H = 0; //hour
;long int M = 0; //minutes
;long int S = 0; //seconds
;/////////////////////
;
;
;char cnt_time = 0; //contor de timp
;char T_SEC; // numar de perioade necesare pentru a acoperi 1 sec
;char S2; //starea de contorizare a PS-ului
;
;char S_PULSE;
;
;// Working mode ///
;// 0 -> range on; 1 -> range off
;char MODE = 0;
;///////////////////
;
;////// Global variables ////////
;// PULSE
;char PULSE;
;
;// State variables ( Q -> consumption range,
;// S1 -> consumption counting state,
;// S3 -> display state)
;char Q, Q1, S3;
;
;// Consumption array
;//            0 - H1   H1 - H2   H2 - 0   Sat - Sun   Total
;//              ^         ^         ^         ^         ^
;int CONSUM[] = {7,        6,        8,        10,        11};
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
;// Power level
;int PowerLevel = 0;
;
;// Digit patterns (CLC)
;// PB 7 6 5 4 3 2 1 0
;//    B G C F A . D E
;// 0 = LED ON; 1 = LED OFF
;const char DIGITS[] = {
;    0b01000100,  // 0
;    0b01011111,  // 1
;    0b00110100,  // 2
;    0b00010101,  // 3
;    0b00001111,  // 4
;    0b10000101,  // 5
;    0b10000100,  // 6
;    0b01010111,  // 7
;    0b00000100,  // 8
;    0b00000101   // 9
;/*
;    0b11000000,  0
;    0b11111001,  1
;    0b10100100,  2
;    0b10110000,  3
;    0b10011001,  4
;    0b10010010,  5
;    0b10000010,  6
;    0b11111000,  7
;    0b10000000,  8
;    0b10010000   9
;    */
;};
;///////////////////////////////
;
;// Power Level (CLC) ///
;// char CLC_LEVEL[] = {0x00, 0x10, 0x30, 0x70, 0xF0};  // 4 levels
;char CLC_LEVEL[] = {0x00, 0x20, 0x60, 0xE0};           // 3 levels
;////////////////////////
;
;// Consumption range output (CLC) //
;char CLC_RANGE_OUTPUT[] = {0x01, 0x02, 0x03, 0x00};
;///////////////////////////////////
;
;// Pulses contor
;char cntP = 0;
;char cntMockPulse = 0;
;
;//// Function headers ////
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
;/////////////////////////
;
;
;/////// SCI ///////
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 009D {

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
; 0000 009E     // Reinitialize Timer 0 value
; 0000 009F     TCNT0=0x3C;
	LDI  R30,LOW(60)
	OUT  0x26,R30
; 0000 00A0 
; 0000 00A1     // Read CA
; 0000 00A2     CA = (PIND & 0x80) >> 7;
	IN   R30,0x9
	ANDI R30,LOW(0x80)
	LDI  R31,0
	CALL __ASRW3
	CALL __ASRW4
	STS  _CA,R30
; 0000 00A3 
; 0000 00A4     // DisplayInfo
; 0000 00A5     DisplayInfo();
	RCALL _DisplayInfo
; 0000 00A6 
; 0000 00A7     // Update mock pulse
; 0000 00A8     // MockPULSE();
; 0000 00A9 
; 0000 00AA     // Check for pulses coming from ADSP
; 0000 00AB     UpdateConsumption();
	RCALL _UpdateConsumption
; 0000 00AC }
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
; 0000 00B0 {
_main:
; 0000 00B1 // Declare your local variables here
; 0000 00B2 
; 0000 00B3 // Crystal Oscillator division factor: 1
; 0000 00B4 #pragma optsize-
; 0000 00B5 CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 00B6 CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 00B7 #ifdef _OPTIMIZE_SIZE_
; 0000 00B8 #pragma optsize+
; 0000 00B9 #endif
; 0000 00BA 
; 0000 00BB // Input/Output Ports initialization
; 0000 00BC // Port A initialization
; 0000 00BD // Function: Bit7=Out Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00BE DDRA=(1<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(128)
	OUT  0x1,R30
; 0000 00BF // State: Bit7=1 Bit6=P Bit5=P Bit4=P Bit3=P Bit2=P Bit1=P Bit0=T
; 0000 00C0 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0000 00C1 
; 0000 00C2 // Port B initialization
; 0000 00C3 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 00C4 DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(255)
	OUT  0x4,R30
; 0000 00C5 // State: Bit7=1 Bit6=1 Bit5=1 Bit4=1 Bit3=1 Bit2=1 Bit1=1 Bit0=1
; 0000 00C6 PORTB=(1<<PORTB7) | (1<<PORTB6) | (1<<PORTB5) | (1<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);
	OUT  0x5,R30
; 0000 00C7 
; 0000 00C8 // Port C initialization
; 0000 00C9 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 00CA DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	OUT  0x7,R30
; 0000 00CB // State: Bit7=1 Bit6=1 Bit5=1 Bit4=1 Bit3=1 Bit2=1 Bit1=1 Bit0=1
; 0000 00CC PORTC=(1<<PORTC7) | (1<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (1<<PORTC3) | (1<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);
	OUT  0x8,R30
; 0000 00CD 
; 0000 00CE // Port D initialization
; 0000 00CF // Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 00D0 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(15)
	OUT  0xA,R30
; 0000 00D1 // State: Bit7=T Bit6=T Bit5=1 Bit4=0 Bit3=1 Bit2=1 Bit1=1 Bit0=1
; 0000 00D2 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 00D3 
; 0000 00D4 // Timer/Counter 0 initialization
; 0000 00D5 // Clock source: System Clock
; 0000 00D6 // Clock value: 9.766 kHz
; 0000 00D7 // Mode: Normal top=0xFF
; 0000 00D8 // OC0A output: Disconnected
; 0000 00D9 // OC0B output: Disconnected
; 0000 00DA // Timer Period: 20.07 ms
; 0000 00DB TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	OUT  0x24,R30
; 0000 00DC TCCR0B=(0<<WGM02) | (1<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(5)
	OUT  0x25,R30
; 0000 00DD TCNT0=0x3C;
	LDI  R30,LOW(60)
	OUT  0x26,R30
; 0000 00DE OCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 00DF OCR0B=0x00;
	OUT  0x28,R30
; 0000 00E0 
; 0000 00E1 // Timer/Counter 1 initialization
; 0000 00E2 // Clock source: System Clock
; 0000 00E3 // Clock value: Timer1 Stopped
; 0000 00E4 // Mode: Normal top=0xFFFF
; 0000 00E5 // OC1A output: Disconnected
; 0000 00E6 // OC1B output: Disconnected
; 0000 00E7 // Noise Canceler: Off
; 0000 00E8 // Input Capture on Falling Edge
; 0000 00E9 // Timer1 Overflow Interrupt: Off
; 0000 00EA // Input Capture Interrupt: Off
; 0000 00EB // Compare A Match Interrupt: Off
; 0000 00EC // Compare B Match Interrupt: Off
; 0000 00ED TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	STS  128,R30
; 0000 00EE TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	STS  129,R30
; 0000 00EF TCNT1H=0x00;
	STS  133,R30
; 0000 00F0 TCNT1L=0x00;
	STS  132,R30
; 0000 00F1 ICR1H=0x00;
	STS  135,R30
; 0000 00F2 ICR1L=0x00;
	STS  134,R30
; 0000 00F3 OCR1AH=0x00;
	STS  137,R30
; 0000 00F4 OCR1AL=0x00;
	STS  136,R30
; 0000 00F5 OCR1BH=0x00;
	STS  139,R30
; 0000 00F6 OCR1BL=0x00;
	STS  138,R30
; 0000 00F7 
; 0000 00F8 // Timer/Counter 2 initialization
; 0000 00F9 // Clock source: System Clock
; 0000 00FA // Clock value: Timer2 Stopped
; 0000 00FB // Mode: Normal top=0xFF
; 0000 00FC // OC2A output: Disconnected
; 0000 00FD // OC2B output: Disconnected
; 0000 00FE ASSR=(0<<EXCLK) | (0<<AS2);
	STS  182,R30
; 0000 00FF TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
	STS  176,R30
; 0000 0100 TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	STS  177,R30
; 0000 0101 TCNT2=0x00;
	STS  178,R30
; 0000 0102 OCR2A=0x00;
	STS  179,R30
; 0000 0103 OCR2B=0x00;
	STS  180,R30
; 0000 0104 
; 0000 0105 // Timer/Counter 0 Interrupt(s) initialization
; 0000 0106 TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);
	LDI  R30,LOW(1)
	STS  110,R30
; 0000 0107 
; 0000 0108 // Timer/Counter 1 Interrupt(s) initialization
; 0000 0109 TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);
	LDI  R30,LOW(0)
	STS  111,R30
; 0000 010A 
; 0000 010B // Timer/Counter 2 Interrupt(s) initialization
; 0000 010C TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);
	STS  112,R30
; 0000 010D 
; 0000 010E // External Interrupt(s) initialization
; 0000 010F // INT0: Off
; 0000 0110 // INT1: Off
; 0000 0111 // INT2: Off
; 0000 0112 // Interrupt on any change on pins PCINT0-7: Off
; 0000 0113 // Interrupt on any change on pins PCINT8-15: Off
; 0000 0114 // Interrupt on any change on pins PCINT16-23: Off
; 0000 0115 // Interrupt on any change on pins PCINT24-31: Off
; 0000 0116 EICRA=(0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  105,R30
; 0000 0117 EIMSK=(0<<INT2) | (0<<INT1) | (0<<INT0);
	OUT  0x1D,R30
; 0000 0118 PCICR=(0<<PCIE3) | (0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	STS  104,R30
; 0000 0119 
; 0000 011A // USART0 initialization
; 0000 011B // USART0 disabled
; 0000 011C UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	STS  193,R30
; 0000 011D 
; 0000 011E // USART1 initialization
; 0000 011F // USART1 disabled
; 0000 0120 UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	STS  201,R30
; 0000 0121 
; 0000 0122 // Analog Comparator initialization
; 0000 0123 // Analog Comparator: Off
; 0000 0124 // The Analog Comparator's positive input is
; 0000 0125 // connected to the AIN0 pin
; 0000 0126 // The Analog Comparator's negative input is
; 0000 0127 // connected to the AIN1 pin
; 0000 0128 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 0129 ADCSRB=(0<<ACME);
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 012A // Digital input buffer on AIN0: On
; 0000 012B // Digital input buffer on AIN1: On
; 0000 012C DIDR1=(0<<AIN0D) | (0<<AIN1D);
	STS  127,R30
; 0000 012D 
; 0000 012E // ADC initialization
; 0000 012F // ADC disabled
; 0000 0130 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	STS  122,R30
; 0000 0131 
; 0000 0132 // SPI initialization
; 0000 0133 // SPI disabled
; 0000 0134 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0x2C,R30
; 0000 0135 
; 0000 0136 // TWI initialization
; 0000 0137 // TWI disabled
; 0000 0138 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  188,R30
; 0000 0139 
; 0000 013A // Globally enable interrupts
; 0000 013B #asm("sei")
	sei
; 0000 013C 
; 0000 013D // Initialize the device
; 0000 013E Init();
	RCALL _Init
; 0000 013F 
; 0000 0140 while (1)
_0xC:
; 0000 0141       {
; 0000 0142       // Display the consumption
; 0000 0143       DisplayConsumption();
	RCALL _DisplayConsumption
; 0000 0144 
; 0000 0145       // Wait for interruptions
; 0000 0146       }
	RJMP _0xC
; 0000 0147 }
_0xF:
	RJMP _0xF
;
;///// Function definitions /////
;void Init()
; 0000 014B {
_Init:
; 0000 014C     // Setting initial states = 0
; 0000 014D     Q = Q1 = S1 = S2 = S3 = S_PULSE = 0;
	LDI  R30,LOW(0)
	MOV  R8,R30
	MOV  R11,R30
	MOV  R5,R30
	MOV  R4,R30
	MOV  R12,R30
	MOV  R9,R30
; 0000 014E 
; 0000 014F     // Setting the working mode
; 0000 0150     MODE = 0;
	CLR  R7
; 0000 0151 }
	RET
;
;void UpdateConsumption()
; 0000 0154 {
_UpdateConsumption:
; 0000 0155     // Identify PULSE
; 0000 0156     PULSE = PINA & 0x01;
	IN   R30,0x0
	ANDI R30,LOW(0x1)
	MOV  R10,R30
; 0000 0157 
; 0000 0158     /* switch(S2)
; 0000 0159     {
; 0000 015A         case 0:
; 0000 015B         {
; 0000 015C             char cntP = 0;
; 0000 015D 
; 0000 015E             // PD6 -> Sending request from ADSP
; 0000 015F             // PD7 -> Reading ack from ATmega164A
; 0000 0160 
; 0000 0161             // Check if sending request flag is up
; 0000 0162             // (Receiving sending request on PD6)
; 0000 0163             if (PORTD && 0x40)
; 0000 0164             {
; 0000 0165                 // Send reading ack
; 0000 0166                 // (Sending ack on PD7)
; 0000 0167                 PORTD |= 0x80;
; 0000 0168 
; 0000 0169                 // Going further to reading the pulses
; 0000 016A                 S2 = 1;
; 0000 016B             }
; 0000 016C             break;
; 0000 016D         }
; 0000 016E         case 1:
; 0000 016F         {
; 0000 0170             // If PULSE is on, start counting
; 0000 0171             if (PULSE)
; 0000 0172             {
; 0000 0173                 // Increment cntP
; 0000 0174                 cntP += 1;
; 0000 0175 
; 0000 0176                 // Reset reading flag
; 0000 0177                 PORTD &= 0x7f;
; 0000 0178 
; 0000 0179                 // Go further if the pulse period has passed,
; 0000 017A                 // otherwise go back wait for sensding ack again.
; 0000 017B                 S2 = (cntP == DP) ? 2 : 1;
; 0000 017C             }
; 0000 017D             break;
; 0000 017E         }
; 0000 017F         case 2:
; 0000 0180         {
; 0000 0181             if (~PULSE)
; 0000 0182             {
; 0000 0183                 // Update current consumption range
; 0000 0184                 Q = CLS();
; 0000 0185 
; 0000 0186                 // Increment consumption
; 0000 0187                 CONS[Q] += 1;
; 0000 0188 
; 0000 0189                 // Wait for another pulse
; 0000 018A                 S2 = 0;
; 0000 018B             }
; 0000 018C             break;
; 0000 018D         }
; 0000 018E     } */
; 0000 018F 
; 0000 0190 
; 0000 0191     // Read power level
; 0000 0192     PowerLevel = (PINA & 0xfe) >> 1;
	IN   R30,0x0
	ANDI R30,0xFE
	LDI  R31,0
	ASR  R31
	ROR  R30
	STS  _PowerLevel,R30
	STS  _PowerLevel+1,R31
; 0000 0193 
; 0000 0194     // For testing purposes, we will assume PowerLevel = 6 kW
; 0000 0195     PowerLevel = 8;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	STS  _PowerLevel,R30
	STS  _PowerLevel+1,R31
; 0000 0196 
; 0000 0197     switch(S2)
	MOV  R30,R5
	LDI  R31,0
; 0000 0198     {
; 0000 0199         case 0:
	SBIW R30,0
	BRNE _0x13
; 0000 019A         {
; 0000 019B             // If PULSE is on, start counting
; 0000 019C             if (PULSE)
	TST  R10
	BREQ _0x14
; 0000 019D             {
; 0000 019E                 // Increment cntP
; 0000 019F                 cntP += 1;
	LDS  R30,_cntP
	SUBI R30,-LOW(1)
	STS  _cntP,R30
; 0000 01A0 
; 0000 01A1                 // Reset reading flag
; 0000 01A2                 // PORTD &= 0x7f;
; 0000 01A3 
; 0000 01A4                 // Go further if the pulse period has passed,
; 0000 01A5                 // otherwise go back wait for sensding ack again.
; 0000 01A6                 S2 = (cntP == DP) ? 1 : 0;
	LDS  R26,_cntP
	CPI  R26,LOW(0x1)
	BRNE _0x15
	LDI  R30,LOW(1)
	RJMP _0x16
_0x15:
	LDI  R30,LOW(0)
_0x16:
	MOV  R5,R30
; 0000 01A7             }
; 0000 01A8             break;
_0x14:
	RJMP _0x12
; 0000 01A9         }
; 0000 01AA         case 1:
_0x13:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x12
; 0000 01AB         {
; 0000 01AC             if (PULSE == 0)
	TST  R10
	BRNE _0x19
; 0000 01AD             {
; 0000 01AE                 // Update current consumption range
; 0000 01AF                 CLS();
	RCALL _CLS
; 0000 01B0 
; 0000 01B1                 // Increment consumption
; 0000 01B2                 if (MODE == 0)
	TST  R7
	BRNE _0x1A
; 0000 01B3                 {
; 0000 01B4                     CONSUM[Q] += 1;    // Working range on
	MOV  R30,R9
	RCALL SUBOPT_0x0
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 01B5                 }
; 0000 01B6                 else
	RJMP _0x1B
_0x1A:
; 0000 01B7                 {
; 0000 01B8                     CONSUM[4] += 1;    // Working range off
	__GETW1MN _CONSUM,8
	ADIW R30,1
	__PUTW1MN _CONSUM,8
; 0000 01B9                 }
_0x1B:
; 0000 01BA 
; 0000 01BB                 // Wait for another pulse
; 0000 01BC                 S2 = 0;
	CLR  R5
; 0000 01BD                 cntP = 0;
	LDI  R30,LOW(0)
	STS  _cntP,R30
; 0000 01BE             }
; 0000 01BF             break;
_0x19:
; 0000 01C0         }
; 0000 01C1     }
_0x12:
; 0000 01C2 }
	RET
;
;
;// Mocks the PULSE coming from ADSP2181 (PF0) -> ATMega164A (PINA0)
;void MockPULSE()
; 0000 01C7 {
; 0000 01C8      switch(S_PULSE)
; 0000 01C9      {
; 0000 01CA         case 0:
; 0000 01CB         {
; 0000 01CC             cntMockPulse = 0;
; 0000 01CD             PULSE = 1;
; 0000 01CE             S_PULSE = 1;
; 0000 01CF             break;
; 0000 01D0         }
; 0000 01D1         case 1:
; 0000 01D2         {
; 0000 01D3             cntMockPulse += 1;
; 0000 01D4             PULSE = 0;
; 0000 01D5             if (cntMockPulse == 49)
; 0000 01D6                 S_PULSE = 0;
; 0000 01D7             break;
; 0000 01D8         }
; 0000 01D9      }
; 0000 01DA }
;
;void DisplayConsumption()
; 0000 01DD {
_DisplayConsumption:
; 0000 01DE     // We assume:
; 0000 01DF     // PORTCc: PC0 - PC6 -> 7 segments (A-G)
; 0000 01E0     // PORTD: PD0 - PD3 -> select the common cathode for each digit (multiplexing)
; 0000 01E1               // PD3 - C4, PD2 - C3, PD1 - C2, PD0 - C1
; 0000 01E2     // Q - consumption range:
; 0000 01E3         // 0 -> 00:00 - H1:00
; 0000 01E4         // 1 -> H1:00 - H2:00               (MON - FRI)
; 0000 01E5         // 2 -> H2:00 - 00:00 (next day)
; 0000 01E6         // 3 -> SAT - SUN
; 0000 01E7 
; 0000 01E8     // The actual approach:
; 0000 01E9     // Each main loop iteration we multiplex the digits and display one at a time
; 0000 01EA 
; 0000 01EB     // If MODE = 1 -> display total consumption,
; 0000 01EC     // else -> display consumption based on current range.
; 0000 01ED     int cons = (MODE) ?  CONSUM[4] : CONSUM[Q1];
; 0000 01EE 
; 0000 01EF     // Compute and display C4
; 0000 01F0     C4 = cons / 1000;
	ST   -Y,R17
	ST   -Y,R16
;	cons -> R16,R17
	MOV  R30,R7
	LDI  R31,0
	SBIW R30,0
	BREQ _0x22
	__GETW1MN _CONSUM,8
	RJMP _0x23
_0x22:
	MOV  R30,R12
	RCALL SUBOPT_0x0
	CALL __GETW1P
_0x23:
	MOVW R16,R30
	MOVW R26,R16
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21
	MOV  R13,R30
; 0000 01F1     cons %= 1000;
	MOVW R26,R16
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __MODW21
	MOVW R16,R30
; 0000 01F2     DisplayDigit(4, C4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	MOV  R26,R13
	RCALL _DisplayDigit
; 0000 01F3 
; 0000 01F4     // Compute and display C3
; 0000 01F5     C3 = cons / 100;
	MOVW R26,R16
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	STS  _C3,R30
; 0000 01F6     cons %= 100;
	MOVW R26,R16
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	MOVW R16,R30
; 0000 01F7     DisplayDigit(3, C3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDS  R26,_C3
	RCALL _DisplayDigit
; 0000 01F8 
; 0000 01F9     // Compute and display C2
; 0000 01FA     C2 = cons / 10;
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	STS  _C2,R30
; 0000 01FB     DisplayDigit(2, C2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDS  R26,_C2
	RCALL _DisplayDigit
; 0000 01FC 
; 0000 01FD     // Compute and display C1
; 0000 01FE     C1 = cons % 10;
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	STS  _C1,R30
; 0000 01FF     DisplayDigit(1, C1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDS  R26,_C1
	RCALL _DisplayDigit
; 0000 0200 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;void DisplayDigit(char currentDisplay, char digit)
; 0000 0203 {
_DisplayDigit:
; 0000 0204     // Select the desired display (turn on the pin
; 0000 0205     // corresponding to the desired digit (C4/C3/C2/C1)
; 0000 0206     char output;
; 0000 0207 
; 0000 0208     // Set PORTD pins to the corresponding digit
; 0000 0209     // PORTD = DIGITS[digit];
; 0000 020A 
; 0000 020B     switch (currentDisplay)
	ST   -Y,R26
	ST   -Y,R17
;	currentDisplay -> Y+2
;	digit -> Y+1
;	output -> R17
	LDD  R30,Y+2
	LDI  R31,0
; 0000 020C     {
; 0000 020D         case 4:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x28
; 0000 020E             // Turn PD3 on
; 0000 020F             //output &= 0b00000111;
; 0000 0210             output = 0x01;
	LDI  R17,LOW(1)
; 0000 0211             break;
	RJMP _0x27
; 0000 0212         case 3:
_0x28:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x29
; 0000 0213             // Turn PD2 on
; 0000 0214             // output &= 0b00001011;
; 0000 0215             output = 0x02;
	LDI  R17,LOW(2)
; 0000 0216             break;
	RJMP _0x27
; 0000 0217         case 2:
_0x29:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2A
; 0000 0218             // Turn PD1 on
; 0000 0219             output = 0x04;
	LDI  R17,LOW(4)
; 0000 021A             break;
	RJMP _0x27
; 0000 021B         case 1:
_0x2A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x27
; 0000 021C             // Turn PD0 on
; 0000 021D             output = 0x08;
	LDI  R17,LOW(8)
; 0000 021E             break;
; 0000 021F     }
_0x27:
; 0000 0220 
; 0000 0221     // Delete PD0-3
; 0000 0222     PORTD &= 0xF0;
	IN   R30,0xB
	ANDI R30,LOW(0xF0)
	OUT  0xB,R30
; 0000 0223 
; 0000 0224     // Assign output to PORTCc in order to select the desired display;
; 0000 0225     PORTD |= output;
	IN   R30,0xB
	OR   R30,R17
	OUT  0xB,R30
; 0000 0226 
; 0000 0227     // Set PORTCc pins to the corresponding digit
; 0000 0228     PORTB = DIGITS[digit];
	LDD  R30,Y+1
	LDI  R31,0
	SUBI R30,LOW(-_DIGITS*2)
	SBCI R31,HIGH(-_DIGITS*2)
	LPM  R0,Z
	OUT  0x5,R0
; 0000 0229 
; 0000 022A     // Add delay (10 us)
; 0000 022B     // _display_us(10);
; 0000 022C }
	LDD  R17,Y+0
	ADIW R28,3
	RET
;
;
;void UpdateTime(){
; 0000 022F void UpdateTime(){
; 0000 0230     cnt_time += 1; //incrementare contor de timp
; 0000 0231     if(cnt_time != T_SEC) return;
; 0000 0232 
; 0000 0233     cnt_time = 0; // se reseteaza contorul
; 0000 0234     S+=1;  //incrementeaza contor secunde
; 0000 0235 
; 0000 0236     if(S!=60) return;
; 0000 0237     S = 0;//se reseteaza nr de secunde
; 0000 0238     M += 1; //incrementeaza contor minute
; 0000 0239 
; 0000 023A     if(M!=60) return;
; 0000 023B     M = 0;
; 0000 023C     H += 1;
; 0000 023D 
; 0000 023E     if(H!=24) return;
; 0000 023F     H = 0;
; 0000 0240     Z += 1;
; 0000 0241 
; 0000 0242     if (Z == 7) Z = 0;
; 0000 0243     return;
; 0000 0244 }
;
;void CLS()
; 0000 0247 {
_CLS:
; 0000 0248     char out;
; 0000 0249 
; 0000 024A     //exemplu
; 0000 024B     // Ziua 3, ora 8, min 6, sec 3
; 0000 024C     // 0x03080603
; 0000 024D     long int now = (Z<<24) | (H<<16) | (M<<8) | S;
; 0000 024E 
; 0000 024F     long int *adr = TABA[Q];
; 0000 0250     char ready = 0;
; 0000 0251     int i = 0;
; 0000 0252 
; 0000 0253     while (!ready)
	SBIW R28,4
	CALL __SAVELOCR6
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
	CALL __LSLD12
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_H
	LDS  R31,_H+1
	LDS  R22,_H+2
	LDS  R23,_H+3
	CALL __LSLD16
	CALL __ORD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDS  R26,_M
	LDS  R27,_M+1
	LDS  R24,_M+2
	LDS  R25,_M+3
	LDI  R30,LOW(8)
	CALL __LSLD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ORD12
	LDS  R26,_S
	LDS  R27,_S+1
	LDS  R24,_S+2
	LDS  R25,_S+3
	CALL __ORD12
	__PUTD1S 6
	MOV  R30,R9
	LDI  R26,LOW(_TABA)
	LDI  R27,HIGH(_TABA)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	MOVW R18,R30
	LDI  R16,0
	__GETWRN 20,21,0
_0x31:
	CPI  R16,0
	BRNE _0x33
; 0000 0254     {
; 0000 0255         if (now == adr[i]) {
	RCALL SUBOPT_0x1
	__GETD2S 6
	CALL __CPD12
	BRNE _0x34
; 0000 0256             Q = adr[i + 1];
	MOVW R30,R20
	ADIW R30,1
	MOVW R26,R18
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LD   R9,X
; 0000 0257             ready = 1;
	LDI  R16,LOW(1)
; 0000 0258         }
; 0000 0259         else if (adr[i] == Ter) ready = 1;
	RJMP _0x35
_0x34:
	RCALL SUBOPT_0x1
	__CPD1N 0x10000000
	BRNE _0x36
	LDI  R16,LOW(1)
; 0000 025A         else i = i+2;
	RJMP _0x37
_0x36:
	__ADDWRN 20,21,2
; 0000 025B     }
_0x37:
_0x35:
	RJMP _0x31
_0x33:
; 0000 025C 
; 0000 025D     out = Tout[Q];
	MOV  R30,R9
	LDI  R31,0
	SUBI R30,LOW(-_Tout)
	SBCI R31,HIGH(-_Tout)
	LD   R17,Z
; 0000 025E }
	CALL __LOADLOCR6
	ADIW R28,10
	RET
;
;void DisplayInfo()
; 0000 0261 {
_DisplayInfo:
; 0000 0262     DisplayConsumptionDisplayMode();
	RCALL _DisplayConsumptionDisplayMode
; 0000 0263     DisplayPowerLevel();
	RCALL _DisplayPowerLevel
; 0000 0264 }
	RET
;
;void DisplayPowerLevel()
; 0000 0267 {
_DisplayPowerLevel:
; 0000 0268    char out;
; 0000 0269 
; 0000 026A //   if (!PowerLevel)          PowerLevel = 0 kW
; 0000 026B //   {
; 0000 026C //        out = CLC_LEVEL[0];
; 0000 026D //   }
; 0000 026E //   else if (PowerLevel < 2.5)    0 < PowerLevel < 2.5 kW
; 0000 026F //   {
; 0000 0270 //        out = CLC_LEVEL[1];
; 0000 0271 //   }
; 0000 0272 //   else if (PowerLevel < 5)      2.5 <= PowerLevel < 5 kW
; 0000 0273 //   {
; 0000 0274 //        out = CLC_LEVEL[2];
; 0000 0275 //   }
; 0000 0276 //   else if (PowerLevel < 7.5)    5 <= PowerLevel < 7.5 kW
; 0000 0277 //   {
; 0000 0278 //        out = CLC_LEVEL[3];
; 0000 0279 //   }
; 0000 027A //   else                          PowerLvel >= 7.5 kW
; 0000 027B //   {
; 0000 027C //        out = CLC_LEVEL[4];
; 0000 027D //   }
; 0000 027E 
; 0000 027F    if (!PowerLevel)         // PowerLevel = 0 kW
	ST   -Y,R17
;	out -> R17
	LDS  R30,_PowerLevel
	LDS  R31,_PowerLevel+1
	SBIW R30,0
	BRNE _0x38
; 0000 0280    {
; 0000 0281         out = CLC_LEVEL[0];
	LDS  R17,_CLC_LEVEL
; 0000 0282    }
; 0000 0283    else if (PowerLevel < 3)   // 0 < PowerLevel < 3 kW
	RJMP _0x39
_0x38:
	LDS  R26,_PowerLevel
	LDS  R27,_PowerLevel+1
	SBIW R26,3
	BRGE _0x3A
; 0000 0284    {
; 0000 0285         out = CLC_LEVEL[1];
	__GETBRMN 17,_CLC_LEVEL,1
; 0000 0286    }
; 0000 0287    else if (PowerLevel < 6)     // 3 <= PowerLevel < 6 kW
	RJMP _0x3B
_0x3A:
	LDS  R26,_PowerLevel
	LDS  R27,_PowerLevel+1
	SBIW R26,6
	BRGE _0x3C
; 0000 0288    {
; 0000 0289         out = CLC_LEVEL[2];
	__GETBRMN 17,_CLC_LEVEL,2
; 0000 028A    }
; 0000 028B    else                         // PowerLvel >= 6 kW
	RJMP _0x3D
_0x3C:
; 0000 028C    {
; 0000 028D         out = CLC_LEVEL[3];
	__GETBRMN 17,_CLC_LEVEL,3
; 0000 028E    }
_0x3D:
_0x3B:
_0x39:
; 0000 028F 
; 0000 0290    // Delete PB7-PB5
; 0000 0291    PORTC &= 0x1f;
	IN   R30,0x8
	ANDI R30,LOW(0x1F)
	RJMP _0x2000002
; 0000 0292 
; 0000 0293    // Display out on PB7-PB5
; 0000 0294    PORTC |= out;
; 0000 0295 }
;
;void DisplayConsumptionDisplayMode()
; 0000 0298 {
_DisplayConsumptionDisplayMode:
; 0000 0299     char out;
; 0000 029A 
; 0000 029B     if (MODE == 1)  // Working without ranges
	ST   -Y,R17
;	out -> R17
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x3E
; 0000 029C     {
; 0000 029D         // Clear PB4-0
; 0000 029E         PORTC &= 0xE0;
	IN   R30,0x8
	ANDI R30,LOW(0xE0)
	OUT  0x8,R30
; 0000 029F 
; 0000 02A0         // Display on PB4-0
; 0000 02A1         PORTC |= 0x10;
	SBI  0x8,4
; 0000 02A2 
; 0000 02A3         return;
	RJMP _0x2000001
; 0000 02A4     }
; 0000 02A5 
; 0000 02A6     switch(S3)
_0x3E:
	MOV  R30,R11
	LDI  R31,0
; 0000 02A7     {
; 0000 02A8         case 0:
	SBIW R30,0
	BRNE _0x42
; 0000 02A9         {
; 0000 02AA             if (CA)            // Pressed CA
	LDS  R30,_CA
	CPI  R30,0
	BREQ _0x43
; 0000 02AB             {
; 0000 02AC                 S3 = 1;
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 02AD             }
; 0000 02AE             break;
_0x43:
	RJMP _0x41
; 0000 02AF         }
; 0000 02B0         case 1:                 // Released CA
_0x42:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x44
; 0000 02B1         {
; 0000 02B2             if (!CA)
	LDS  R30,_CA
	CPI  R30,0
	BRNE _0x45
; 0000 02B3             {
; 0000 02B4                 S3 = 2;
	LDI  R30,LOW(2)
	MOV  R11,R30
; 0000 02B5                 Q1 = 1;
	LDI  R30,LOW(1)
	MOV  R12,R30
; 0000 02B6             }
; 0000 02B7             break;
_0x45:
	RJMP _0x41
; 0000 02B8         }
; 0000 02B9         case 2:                //  Pressed CA
_0x44:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x46
; 0000 02BA         {
; 0000 02BB             if (CA)
	LDS  R30,_CA
	CPI  R30,0
	BREQ _0x47
; 0000 02BC             {
; 0000 02BD                 S3 = 3;
	LDI  R30,LOW(3)
	MOV  R11,R30
; 0000 02BE             }
; 0000 02BF             break;
_0x47:
	RJMP _0x41
; 0000 02C0         }
; 0000 02C1         case 3:                // Released CA
_0x46:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x48
; 0000 02C2         {
; 0000 02C3             if (!CA)
	LDS  R30,_CA
	CPI  R30,0
	BRNE _0x49
; 0000 02C4             {
; 0000 02C5                 S3 = 4;
	LDI  R30,LOW(4)
	MOV  R11,R30
; 0000 02C6                 Q1 = 2;
	LDI  R30,LOW(2)
	MOV  R12,R30
; 0000 02C7             }
; 0000 02C8             break;
_0x49:
	RJMP _0x41
; 0000 02C9         }
; 0000 02CA         case 4:
_0x48:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x4A
; 0000 02CB         {
; 0000 02CC             if (CA)
	LDS  R30,_CA
	CPI  R30,0
	BREQ _0x4B
; 0000 02CD             {
; 0000 02CE                 S3 = 5;
	LDI  R30,LOW(5)
	MOV  R11,R30
; 0000 02CF             }
; 0000 02D0             break;
_0x4B:
	RJMP _0x41
; 0000 02D1         }
; 0000 02D2         case 5:
_0x4A:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x4C
; 0000 02D3         {
; 0000 02D4             if (!CA)
	LDS  R30,_CA
	CPI  R30,0
	BRNE _0x4D
; 0000 02D5             {
; 0000 02D6                 S3 = 6;
	LDI  R30,LOW(6)
	MOV  R11,R30
; 0000 02D7                 Q1 = 3;
	LDI  R30,LOW(3)
	MOV  R12,R30
; 0000 02D8             }
; 0000 02D9             break;
_0x4D:
	RJMP _0x41
; 0000 02DA         }
; 0000 02DB         case 6:
_0x4C:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x4E
; 0000 02DC         {
; 0000 02DD             if (CA)
	LDS  R30,_CA
	CPI  R30,0
	BREQ _0x4F
; 0000 02DE             {
; 0000 02DF                 S3 = 7;
	LDI  R30,LOW(7)
	MOV  R11,R30
; 0000 02E0             }
; 0000 02E1             break;
_0x4F:
	RJMP _0x41
; 0000 02E2         }
; 0000 02E3         case 7:
_0x4E:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x41
; 0000 02E4         {
; 0000 02E5             if (!CA)
	LDS  R30,_CA
	CPI  R30,0
	BRNE _0x51
; 0000 02E6             {
; 0000 02E7                 S3 = 0;
	CLR  R11
; 0000 02E8                 Q1 = 0;
	CLR  R12
; 0000 02E9             }
; 0000 02EA             break;
_0x51:
; 0000 02EB         }
; 0000 02EC     }
_0x41:
; 0000 02ED 
; 0000 02EE     out = CLC_RANGE_OUTPUT[Q1] | (CLC_RANGE_OUTPUT[Q] << 2);
	MOV  R30,R12
	LDI  R31,0
	SUBI R30,LOW(-_CLC_RANGE_OUTPUT)
	SBCI R31,HIGH(-_CLC_RANGE_OUTPUT)
	LD   R26,Z
	MOV  R30,R9
	LDI  R31,0
	SUBI R30,LOW(-_CLC_RANGE_OUTPUT)
	SBCI R31,HIGH(-_CLC_RANGE_OUTPUT)
	LD   R30,Z
	LSL  R30
	LSL  R30
	OR   R30,R26
	MOV  R17,R30
; 0000 02EF 
; 0000 02F0     // Delete PC4-PC0
; 0000 02F1     PORTC &= 0xE0;
	IN   R30,0x8
	ANDI R30,LOW(0xE0)
_0x2000002:
	OUT  0x8,R30
; 0000 02F2 
; 0000 02F3     // Display out on PC3-PC0
; 0000 02F4     PORTC |= out;
	IN   R30,0x8
	OR   R30,R17
	OUT  0x8,R30
; 0000 02F5 }
_0x2000001:
	LD   R17,Y+
	RET
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
_Z:
	.BYTE 0x4
_H:
	.BYTE 0x4
_M:
	.BYTE 0x4
_S:
	.BYTE 0x4
_CONSUM:
	.BYTE 0xA
_C3:
	.BYTE 0x1
_C2:
	.BYTE 0x1
_C1:
	.BYTE 0x1
_CA:
	.BYTE 0x1
_PowerLevel:
	.BYTE 0x2
_CLC_LEVEL:
	.BYTE 0x4
_CLC_RANGE_OUTPUT:
	.BYTE 0x4
_cntP:
	.BYTE 0x1
_cntMockPulse:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(_CONSUM)
	LDI  R27,HIGH(_CONSUM)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	MOVW R30,R20
	MOVW R26,R18
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	RET


	.CSEG
__ORD12:
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSLD12R
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

__LSLD16:
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
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
