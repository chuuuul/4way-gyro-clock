
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 16.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

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
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
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
	.DEF _int_temp=R4
	.DEF _int_temp_msb=R5
	.DEF _bellbell_flag=R7
	.DEF _mode=R6
	.DEF _key=R9
	.DEF _state=R8

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
	JMP  _ext_int7_isr
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
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0

_0x0:
	.DB  0x74,0x65,0x6D,0x70,0x20,0x3D,0x20,0x25
	.DB  0x64,0x20,0x43,0x20,0xD,0xA,0x0,0x54
	.DB  0x69,0x6D,0x65,0x20,0x53,0x65,0x74,0x74
	.DB  0x69,0x6E,0x67,0x0,0x20,0x0,0x63,0x6C
	.DB  0x6F,0x63,0x6B,0x20,0xA,0xD,0x0,0x43
	.DB  0x6C,0x6F,0x63,0x6B,0x0,0xBD,0xC3,0xB0
	.DB  0xA3,0x20,0x3A,0x20,0x25,0x64,0xBD,0xC3
	.DB  0x20,0x25,0x64,0xBA,0xD0,0x20,0x25,0x64
	.DB  0xC3,0xCA,0xA,0xD,0x0,0x61,0x6C,0x61
	.DB  0x72,0x6D,0x20,0xA,0xD,0x0,0x41,0x6C
	.DB  0x61,0x72,0x6D,0x20,0x4F,0x4E,0x20,0x20
	.DB  0x20,0x20,0x0,0x41,0x6C,0x61,0x72,0x6D
	.DB  0x20,0x4F,0x46,0x46,0x0,0x74,0x69,0x6D
	.DB  0x65,0x72,0x20,0xA,0xD,0x0,0x54,0x69
	.DB  0x6D,0x65,0x72,0x20,0x4F,0x46,0x46,0x0
	.DB  0x54,0x69,0x6D,0x65,0x72,0x20,0x4F,0x4E
	.DB  0x20,0x20,0x20,0x20,0x0,0x54,0x65,0x6D
	.DB  0x70,0x20,0xA,0xD,0x0,0x54,0x65,0x6D
	.DB  0x70,0x65,0x72,0x61,0x74,0x75,0x72,0x65
	.DB  0x0,0x73,0x70,0x65,0x63,0x69,0x61,0x6C
	.DB  0x20,0x6B,0x65,0x79,0x20,0x69,0x6E,0x74
	.DB  0x65,0x72,0x72,0x75,0x70,0x74,0x20,0xD
	.DB  0xA,0x0,0x6D,0x6F,0x64,0x65,0x20,0x3A
	.DB  0x20,0x31,0x20,0xA,0xD,0x0,0x6D,0x6F
	.DB  0x64,0x65,0x20,0x3A,0x20,0x32,0x20,0xA
	.DB  0xD,0x0,0x6D,0x6F,0x64,0x65,0x20,0x3A
	.DB  0x20,0x33,0x20,0xA,0xD,0x0,0x6D,0x6F
	.DB  0x64,0x65,0x20,0x3A,0x20,0x34,0x20,0xA
	.DB  0xD,0x0,0x73,0x74,0x61,0x72,0x74,0xD
	.DB  0xA,0x0,0x44,0x69,0x67,0x69,0x74,0x61
	.DB  0x6C,0x20,0x43,0x6C,0x6F,0x63,0x6B,0x0
	.DB  0x77,0x69,0x74,0x68,0x20,0x47,0x79,0x72
	.DB  0x6F,0x0
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2080060:
	.DB  0x1
_0x2080000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x01
	.DW  0x07
	.DW  __REG_VARS*2

	.DW  0x0D
	.DW  _0x4B
	.DW  _0x0*2+15

	.DW  0x02
	.DW  _0x4B+13
	.DW  _0x0*2+28

	.DW  0x06
	.DW  _0x4C
	.DW  _0x0*2+39

	.DW  0x02
	.DW  _0x4C+6
	.DW  _0x0*2+28

	.DW  0x0D
	.DW  _0x4E
	.DW  _0x0*2+78

	.DW  0x0A
	.DW  _0x4E+13
	.DW  _0x0*2+91

	.DW  0x02
	.DW  _0x4E+23
	.DW  _0x0*2+28

	.DW  0x0A
	.DW  _0x51
	.DW  _0x0*2+110

	.DW  0x0D
	.DW  _0x51+10
	.DW  _0x0*2+120

	.DW  0x02
	.DW  _0x51+23
	.DW  _0x0*2+28

	.DW  0x0C
	.DW  _0x53
	.DW  _0x0*2+141

	.DW  0x02
	.DW  _0x53+12
	.DW  _0x0*2+28

	.DW  0x02
	.DW  _0xBB
	.DW  _0x0*2+28

	.DW  0x0E
	.DW  _0xBC
	.DW  _0x0*2+234

	.DW  0x0A
	.DW  _0xBC+14
	.DW  _0x0*2+248

	.DW  0x01
	.DW  __seed_G104
	.DW  _0x2080060*2

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
	STS  XMCRB,R30

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

	OUT  RAMPZ,R24

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
	.ORG 0x500

	.CSEG
;
;/////////////////  메뉴얼  /////////////////////
;//  mode = 1 : 시계
;//  mode = 2 : 알람
;//  mode = 3 : 타이머
;//  mode = 4 : 온도
;/////////////////////////////////////////////
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdio.h>
;#include <math.h>
;#include <clock.h>
;//#include <alcd.h>
;
;#include "key_func.c"
;#ifndef _key_func_
;#define _key_func_
;
;
;char key_in(void)            // 키입력 감지 함수
; 0000 000F {

	.CSEG
_key_in:
; .FSTART _key_in
;  char buf = 0;
;
;  if( (PINC & 0x7F) != 0x00)
	ST   -Y,R17
;	buf -> R17
	LDI  R17,0
	IN   R30,0x13
	ANDI R30,0x7F
	CPI  R30,0
	BREQ _0x3
;   {
;     buf = (PINC & 0x7F) ;
	IN   R30,0x13
	ANDI R30,0x7F
	MOV  R17,R30
;     key_flag = 1;            // 키를 입력받았는지 확인
	SET
	BLD  R2,0
;
;     while( (PINC & 0x7F)  != 0x00)     // 누르는 동안에도 display 표시
_0x4:
	IN   R30,0x13
	ANDI R30,0x7F
	CPI  R30,0
	BRNE _0x4
;      {
;        //lcd_out();                    // 캐터링
;      }
;   }
;  return buf;
_0x3:
	MOV  R30,R17
	LD   R17,Y+
	RET
;}
; .FEND
;
;
;void key_chk(void)
;{
_key_chk:
; .FSTART _key_chk
;
;    key_flag = 0;
	CLT
	BLD  R2,0
;    switch(key)
	MOV  R30,R9
	CALL SUBOPT_0x0
;    {
;     case 0x01:             // hour setting
	BRNE _0xA
;        if (up_down_flag == 0)
	SBRC R2,1
	RJMP _0xB
;        {
;            if(mode == 1)
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0xC
;                time.hour++;
	CALL SUBOPT_0x1
;            if(mode == 2)
_0xC:
	LDI  R30,LOW(2)
	CP   R30,R6
	BRNE _0xD
;                alarm.hour++;
	__GETB1MN _alarm,2
	SUBI R30,-LOW(1)
	__PUTB1MN _alarm,2
	SUBI R30,LOW(1)
;            if(mode == 3)
_0xD:
	LDI  R30,LOW(3)
	CP   R30,R6
	BRNE _0xE
;                timer.hour++;
	__GETB1MN _timer,2
	SUBI R30,-LOW(1)
	__PUTB1MN _timer,2
	SUBI R30,LOW(1)
;        }
_0xE:
;        if (up_down_flag == 1)
_0xB:
	SBRS R2,1
	RJMP _0xF
;        {
;            if(mode == 1)
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x10
;                time.hour--;
	__GETB1MN _time,2
	SUBI R30,LOW(1)
	__PUTB1MN _time,2
	SUBI R30,-LOW(1)
;            if(mode == 2)
_0x10:
	LDI  R30,LOW(2)
	CP   R30,R6
	BRNE _0x11
;                alarm.hour--;
	__GETB1MN _alarm,2
	SUBI R30,LOW(1)
	__PUTB1MN _alarm,2
	SUBI R30,-LOW(1)
;            if(mode == 3)
_0x11:
	LDI  R30,LOW(3)
	CP   R30,R6
	BRNE _0x12
;                timer.hour--;
	CALL SUBOPT_0x2
;        }
_0x12:
;        break;
_0xF:
	RJMP _0x9
;
;     case 0x02:             // min setting
_0xA:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x13
;        if (up_down_flag == 0)
	SBRC R2,1
	RJMP _0x14
;        {
;            if(mode == 1)
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x15
;                time.min++;
	CALL SUBOPT_0x3
;            if(mode == 2)
_0x15:
	LDI  R30,LOW(2)
	CP   R30,R6
	BRNE _0x16
;                alarm.min++;
	__GETB1MN _alarm,1
	SUBI R30,-LOW(1)
	__PUTB1MN _alarm,1
	SUBI R30,LOW(1)
;            if(mode == 3)
_0x16:
	LDI  R30,LOW(3)
	CP   R30,R6
	BRNE _0x17
;                timer.min++;
	__GETB1MN _timer,1
	SUBI R30,-LOW(1)
	__PUTB1MN _timer,1
	SUBI R30,LOW(1)
;        }
_0x17:
;
;        if (up_down_flag == 1)
_0x14:
	SBRS R2,1
	RJMP _0x18
;        {
;            if(mode == 1)
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x19
;                time.min--;
	__GETB1MN _time,1
	SUBI R30,LOW(1)
	__PUTB1MN _time,1
	SUBI R30,-LOW(1)
;            if(mode == 2)
_0x19:
	LDI  R30,LOW(2)
	CP   R30,R6
	BRNE _0x1A
;                alarm.min--;
	__GETB1MN _alarm,1
	SUBI R30,LOW(1)
	__PUTB1MN _alarm,1
	SUBI R30,-LOW(1)
;            if(mode == 3)
_0x1A:
	LDI  R30,LOW(3)
	CP   R30,R6
	BRNE _0x1B
;                timer.min--;
	CALL SUBOPT_0x4
;        }
_0x1B:
;        break;
_0x18:
	RJMP _0x9
;
;     case 0x04:             // sec setting
_0x13:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x1C
;        if (up_down_flag == 0)
	SBRC R2,1
	RJMP _0x1D
;        {
;            if(mode == 1)
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x1E
;                time.sec++;
	LDS  R30,_time
	SUBI R30,-LOW(1)
	STS  _time,R30
;            if(mode == 2)
_0x1E:
	LDI  R30,LOW(2)
	CP   R30,R6
	BRNE _0x1F
;                alarm.sec++;
	LDS  R30,_alarm
	SUBI R30,-LOW(1)
	STS  _alarm,R30
;            if(mode == 3)
_0x1F:
	LDI  R30,LOW(3)
	CP   R30,R6
	BRNE _0x20
;                timer.sec++;
	LDS  R30,_timer
	SUBI R30,-LOW(1)
	STS  _timer,R30
;        }
_0x20:
;        if (up_down_flag == 1)
_0x1D:
	SBRS R2,1
	RJMP _0x21
;        {
;            if(mode == 1)
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x22
;                time.sec--;
	LDS  R30,_time
	SUBI R30,LOW(1)
	STS  _time,R30
;            if(mode == 2)
_0x22:
	LDI  R30,LOW(2)
	CP   R30,R6
	BRNE _0x23
;                alarm.sec--;
	LDS  R30,_alarm
	SUBI R30,LOW(1)
	STS  _alarm,R30
;            if(mode == 3)
_0x23:
	LDI  R30,LOW(3)
	CP   R30,R6
	BRNE _0x24
;                timer.sec--;
	LDS  R30,_timer
	SUBI R30,LOW(1)
	STS  _timer,R30
;        }
_0x24:
;        break;
_0x21:
	RJMP _0x9
;
;     case 0x08:             // Up, Down Toggle
_0x1C:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x9
;        up_down_flag = ~up_down_flag;
	LDI  R30,LOW(2)
	EOR  R2,R30
;        break;
;    }
_0x9:
;
;    if(mode==2)  alarm_position_carry();
	LDI  R30,LOW(2)
	CP   R30,R6
	BRNE _0x26
	RCALL _alarm_position_carry
;    if(mode==3)  timer_position_carry();
_0x26:
	LDI  R30,LOW(3)
	CP   R30,R6
	BRNE _0x27
	RCALL _timer_position_carry
;
;}
_0x27:
	RET
; .FEND
;#endif
;#include "func.c"
;#ifndef _func_
;#define _func_
;
;
;
;void lcd_out()
; 0000 0010 {
_lcd_out:
; .FSTART _lcd_out
;    switch(mode)
	MOV  R30,R6
	CALL SUBOPT_0x0
;    {
;        case 1 :
	BRNE _0x2B
;            if( clock_config_flag == 0 )       // config_flag 0 이면 시계 표시
	SBRC R2,3
	RJMP _0x2C
;                clock_display();
	RCALL _clock_display
;            else if( clock_config_flag == 1 )  // config_flag 1 이면 설정 모드
	RJMP _0x2D
_0x2C:
	SBRC R2,3
;                {
;                    clock_config();
	RCALL _clock_config
;                }
;            break;
_0x2D:
	RJMP _0x2A
;        case 2 :
_0x2B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2F
;            alarm_display();
	RCALL _alarm_display
;
;            break;
	RJMP _0x2A
;        case 3 :
_0x2F:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x30
;            timer_display();
	RCALL _timer_display
;
;            break;
	RJMP _0x2A
;        case 4 :
_0x30:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2A
;            printf("temp = %d C \r\n",int_temp);
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
;            temp_display();
	RCALL _temp_display
;            break;
;    }
_0x2A:
;}
	RET
; .FEND
;
;
;void ring_the_bell (void)
;{
_ring_the_bell:
; .FSTART _ring_the_bell
;        if (bellbell_flag == 1)
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x32
;        {
;            bellbell_flag = 2 ;
	LDI  R30,LOW(2)
	MOV  R7,R30
;            PORTE.2 = 1;
	SBI  0x3,2
;        }
;        else if (bellbell_flag == 2)
	RJMP _0x35
_0x32:
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x36
;        {
;            PORTE.2 = 0;
	CBI  0x3,2
;            bellbell_flag = 1;
	LDI  R30,LOW(1)
	MOV  R7,R30
;        }
;}
_0x36:
_0x35:
	RET
; .FEND
;
;
;void clock_position_carry(void)   // 시계 자리수 올림
;{
_clock_position_carry:
; .FSTART _clock_position_carry
;    if( time.sec >= 60)
	LDS  R26,_time
	CPI  R26,LOW(0x3C)
	BRLT _0x39
;    {
;        time.min++;
	CALL SUBOPT_0x3
;        time.sec = 0;
	LDI  R30,LOW(0)
	STS  _time,R30
;    }
;    if( time.min >= 60)
_0x39:
	__GETB2MN _time,1
	CPI  R26,LOW(0x3C)
	BRLT _0x3A
;    {
;        time.hour++;
	CALL SUBOPT_0x1
;        time.min=0;
	LDI  R30,LOW(0)
	__PUTB1MN _time,1
;    }
;    if( time.hour > 23)
_0x3A:
	__GETB2MN _time,2
	CPI  R26,LOW(0x18)
	BRLT _0x3B
;    {
;        time.hour = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _time,2
;    }
;    if( time.sec < 0) time.sec  = 59;
_0x3B:
	LDS  R26,_time
	CPI  R26,0
	BRGE _0x3C
	LDI  R30,LOW(59)
	STS  _time,R30
;    if( time.min < 0) time.min  = 59;
_0x3C:
	__GETB2MN _time,1
	CPI  R26,0
	BRGE _0x3D
	LDI  R30,LOW(59)
	__PUTB1MN _time,1
;    if( time.hour < 0) time.sec = 23;
_0x3D:
	__GETB2MN _time,2
	CPI  R26,0
	BRGE _0x3E
	LDI  R30,LOW(23)
	STS  _time,R30
;}
_0x3E:
	RET
; .FEND
;
;
;
;
;void alarm_position_carry(void)   // 알람 자리수 올림
;{
_alarm_position_carry:
; .FSTART _alarm_position_carry
;    if( alarm.sec >= 60) alarm.sec = 0;
	LDS  R26,_alarm
	CPI  R26,LOW(0x3C)
	BRLT _0x3F
	LDI  R30,LOW(0)
	STS  _alarm,R30
;    if( alarm.min >= 60) alarm.min=0;
_0x3F:
	__GETB2MN _alarm,1
	CPI  R26,LOW(0x3C)
	BRLT _0x40
	LDI  R30,LOW(0)
	__PUTB1MN _alarm,1
;    if( alarm.hour >= 24) alarm.hour = 0;
_0x40:
	__GETB2MN _alarm,2
	CPI  R26,LOW(0x18)
	BRLT _0x41
	LDI  R30,LOW(0)
	__PUTB1MN _alarm,2
;    if( alarm.sec < 0) alarm.sec  = 59;
_0x41:
	LDS  R26,_alarm
	CPI  R26,0
	BRGE _0x42
	LDI  R30,LOW(59)
	STS  _alarm,R30
;    if( alarm.min < 0) alarm.min  = 59;
_0x42:
	__GETB2MN _alarm,1
	CPI  R26,0
	BRGE _0x43
	LDI  R30,LOW(59)
	__PUTB1MN _alarm,1
;    if( alarm.hour < 0) alarm.sec = 23;
_0x43:
	__GETB2MN _alarm,2
	CPI  R26,0
	BRGE _0x44
	LDI  R30,LOW(23)
	STS  _alarm,R30
;}
_0x44:
	RET
; .FEND
;void timer_position_carry(void)   // 타이머 자리수 올림
;{
_timer_position_carry:
; .FSTART _timer_position_carry
;    if( timer.sec >= 60) timer.sec = 0;
	LDS  R26,_timer
	CPI  R26,LOW(0x3C)
	BRLT _0x45
	LDI  R30,LOW(0)
	STS  _timer,R30
;    if( timer.min >= 60) timer.min=0;
_0x45:
	__GETB2MN _timer,1
	CPI  R26,LOW(0x3C)
	BRLT _0x46
	LDI  R30,LOW(0)
	__PUTB1MN _timer,1
;    if( timer.hour >= 24) timer.hour = 0;
_0x46:
	__GETB2MN _timer,2
	CPI  R26,LOW(0x18)
	BRLT _0x47
	LDI  R30,LOW(0)
	__PUTB1MN _timer,2
;    if( timer.sec < 0)
_0x47:
	LDS  R26,_timer
	CPI  R26,0
	BRGE _0x48
;    {
;        timer.min--;
	CALL SUBOPT_0x4
;        timer.sec  = 59;
	LDI  R30,LOW(59)
	STS  _timer,R30
;    }
;    if( timer.min < 0)
_0x48:
	__GETB2MN _timer,1
	CPI  R26,0
	BRGE _0x49
;    {
;        timer.min  = 59;
	LDI  R30,LOW(59)
	__PUTB1MN _timer,1
;        timer.hour--;
	CALL SUBOPT_0x2
;    }
;    if( timer.hour < 0)
_0x49:
	__GETB2MN _timer,2
	CPI  R26,0
	BRGE _0x4A
;    {
;        timer.hour=23;
	LDI  R30,LOW(23)
	__PUTB1MN _timer,2
;    }
;}
_0x4A:
	RET
; .FEND
;
;
;void clock_config(void)
;{
_clock_config:
; .FSTART _clock_config
;
;
;    LCD_string(0x10, "Time Setting",2,0);
	LDI  R30,LOW(16)
	ST   -Y,R30
	__POINTW1MN _0x4B,0
	CALL SUBOPT_0x5
;
;    LCD_string(0x10," ",5,1);
	__POINTW1MN _0x4B,13
	CALL SUBOPT_0x6
;    LCD_data((time.hour/10) + 0x30);
;    LCD_data((time.hour%10) + 0x30);
;    LCD_data(':');
;    LCD_data((time.min/10) + 0x30);
;    LCD_data((time.min%10) + 0x30);
;    LCD_data(':');
;    LCD_data((time.sec/10) + 0x30);
;    LCD_data((time.sec%10) + 0x30);
	CALL SUBOPT_0x7
	RJMP _0x20A0008
;    LCD_data(' ');
;}
; .FEND

	.DSEG
_0x4B:
	.BYTE 0xF
;
;void clock_display(void)
;{

	.CSEG
_clock_display:
; .FSTART _clock_display
;
;    printf("clock \n\r");
	__POINTW1FN _0x0,30
	CALL SUBOPT_0x8
;
;
;    LCD_string(0x10, "Clock",2,0);
	LDI  R30,LOW(16)
	ST   -Y,R30
	__POINTW1MN _0x4C,0
	CALL SUBOPT_0x5
;
;    LCD_string(0x10," ",5,1);
	__POINTW1MN _0x4C,6
	CALL SUBOPT_0x6
;    LCD_data((time.hour/10) + 0x30);
;    LCD_data((time.hour%10) + 0x30);
;    LCD_data(':');
;    LCD_data((time.min/10) + 0x30);
;    LCD_data((time.min%10) + 0x30);
;    LCD_data(':');
;    LCD_data((time.sec/10) + 0x30);
;    LCD_data((time.sec%10) + 0x30);
	CALL SUBOPT_0x7
	CALL SUBOPT_0x9
;    LCD_data(' ');
;
;    printf("시간 : %d시 %d분 %d초\n\r", time.hour, time.min, time.sec);
	__POINTW1FN _0x0,45
	ST   -Y,R31
	ST   -Y,R30
	__GETB1MN _time,2
	CALL SUBOPT_0xA
	__GETB1MN _time,1
	CALL SUBOPT_0xA
	LDS  R30,_time
	CALL SUBOPT_0xA
	LDI  R24,12
	CALL _printf
	ADIW R28,14
;
;}
	RET
; .FEND

	.DSEG
_0x4C:
	.BYTE 0x8
;
;void alarm_display(void)
;{

	.CSEG
_alarm_display:
; .FSTART _alarm_display
;    printf("alarm \n\r");
	__POINTW1FN _0x0,69
	CALL SUBOPT_0x8
;
;    if(alarm_flag == 1)
	SBRS R2,5
	RJMP _0x4D
;    {
;        LCD_string(0x10, "Alarm ON    ",2,0);
	LDI  R30,LOW(16)
	ST   -Y,R30
	__POINTW1MN _0x4E,0
	RJMP _0xCD
;    }
;    else
_0x4D:
;    {
;        LCD_string(0x10, "Alarm OFF",2,0);
	LDI  R30,LOW(16)
	ST   -Y,R30
	__POINTW1MN _0x4E,13
_0xCD:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xB
;    }
;
;    LCD_string(0x10," ",5,1);
	LDI  R30,LOW(16)
	ST   -Y,R30
	__POINTW1MN _0x4E,23
	CALL SUBOPT_0xC
;    LCD_data((alarm.hour/10) + 0x30);
	__GETB2MN _alarm,2
	CALL SUBOPT_0xD
;    LCD_data((alarm.hour%10) + 0x30);
	__GETB2MN _alarm,2
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
;    LCD_data(':');
;    LCD_data((alarm.min/10) + 0x30);
	__GETB2MN _alarm,1
	CALL SUBOPT_0xD
;    LCD_data((alarm.min%10) + 0x30);
	__GETB2MN _alarm,1
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
;    LCD_data(':');
;    LCD_data((alarm.sec/10) + 0x30);
	LDS  R26,_alarm
	CALL SUBOPT_0xD
;    LCD_data((alarm.sec%10) + 0x30);
	LDS  R26,_alarm
	CALL SUBOPT_0xE
	RJMP _0x20A0008
;    LCD_data(' ');
;}
; .FEND

	.DSEG
_0x4E:
	.BYTE 0x19
;
;void timer_display(void)
;{

	.CSEG
_timer_display:
; .FSTART _timer_display
;    printf("timer \n\r");
	__POINTW1FN _0x0,101
	CALL SUBOPT_0x8
;
;    if(timer_flag == 0 )
	SBRC R2,2
	RJMP _0x50
;        LCD_string(0x10, "Timer OFF",2,0);
	LDI  R30,LOW(16)
	ST   -Y,R30
	__POINTW1MN _0x51,0
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xB
;    if(timer_flag == 1 )
_0x50:
	SBRS R2,2
	RJMP _0x52
;        LCD_string(0x10, "Timer ON    ",2,0);
	LDI  R30,LOW(16)
	ST   -Y,R30
	__POINTW1MN _0x51,10
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xB
;
;
;    LCD_string(0x10," ",5,1);
_0x52:
	LDI  R30,LOW(16)
	ST   -Y,R30
	__POINTW1MN _0x51,23
	CALL SUBOPT_0xC
;    LCD_data((timer.hour/10) + 0x30);
	__GETB2MN _timer,2
	CALL SUBOPT_0xD
;    LCD_data((timer.hour%10) + 0x30);
	__GETB2MN _timer,2
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
;    LCD_data(':');
;    LCD_data((timer.min/10) + 0x30);
	__GETB2MN _timer,1
	CALL SUBOPT_0xD
;    LCD_data((timer.min%10) + 0x30);
	__GETB2MN _timer,1
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
;    LCD_data(':');
;    LCD_data((timer.sec/10) + 0x30);
	LDS  R26,_timer
	CALL SUBOPT_0xD
;    LCD_data((timer.sec%10) + 0x30);
	LDS  R26,_timer
	CALL SUBOPT_0xE
	RJMP _0x20A0008
;    LCD_data(' ');
;}
; .FEND

	.DSEG
_0x51:
	.BYTE 0x19
;
;void temp_display(void)
;{

	.CSEG
_temp_display:
; .FSTART _temp_display
;    printf("Temp \n\r");
	__POINTW1FN _0x0,133
	CALL SUBOPT_0x8
;
;    LCD_string(0x10, "Temperature",2,0);
	LDI  R30,LOW(16)
	ST   -Y,R30
	__POINTW1MN _0x53,0
	CALL SUBOPT_0x5
;
;    LCD_string(0x10," ",5,1);
	__POINTW1MN _0x53,12
	CALL SUBOPT_0xC
;    LCD_data((int_temp/100) + 0x30);
	MOVW R26,R4
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x10
;    LCD_data((int_temp%100/10) + 0x30);
	MOVW R26,R4
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x10
;    LCD_data('.');
	LDI  R26,LOW(46)
	RCALL _LCD_data
;    LCD_data((int_temp%10) + 0x30);
	MOVW R26,R4
	CALL SUBOPT_0x7
	CALL SUBOPT_0x9
;    LCD_data(' ');
;    LCD_data('C');
	LDI  R26,LOW(67)
	CALL SUBOPT_0x9
;    LCD_data(' ');
;    LCD_data(' ');
	LDI  R26,LOW(32)
_0x20A0008:
	RCALL _LCD_data
;    LCD_data(' ');
	LDI  R26,LOW(32)
	RCALL _LCD_data
;
;}
	RET
; .FEND

	.DSEG
_0x53:
	.BYTE 0xE
;
;#endif
;#include "ext_int.c"
;#ifndef _ext_int_
;#define _ext_int_
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)      // 0.001초마다 실행
; 0000 0011 {

	.CSEG
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	CALL SUBOPT_0x11
;
;    time_loop++;
	LDI  R26,LOW(_time_loop)
	LDI  R27,HIGH(_time_loop)
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
;    TCNT0 = 131;
	LDI  R30,LOW(131)
	OUT  0x32,R30
;    if(time_loop==1000)
	LDS  R26,_time_loop
	LDS  R27,_time_loop+1
	LDS  R24,_time_loop+2
	LDS  R25,_time_loop+3
	__CPD2N 0x3E8
	BREQ PC+2
	RJMP _0x54
;    {
;        if(pause_flag == 0)
	SBRC R2,4
	RJMP _0x55
;            time.sec++;
	LDS  R30,_time
	SUBI R30,-LOW(1)
	STS  _time,R30
;        time_loop = 0;
_0x55:
	LDI  R30,LOW(0)
	STS  _time_loop,R30
	STS  _time_loop+1,R30
	STS  _time_loop+2,R30
	STS  _time_loop+3,R30
;        clock_position_carry();
	RCALL _clock_position_carry
;
;        if((alarm_flag == 1) && (time.hour == alarm.hour) && (time.min == alarm.min) && (time.sec == alarm.sec))
	SBRS R2,5
	RJMP _0x57
	__GETB2MN _time,2
	__GETB1MN _alarm,2
	CP   R30,R26
	BRNE _0x57
	__GETB2MN _time,1
	__GETB1MN _alarm,1
	CP   R30,R26
	BRNE _0x57
	LDS  R30,_alarm
	LDS  R26,_time
	CP   R30,R26
	BREQ _0x58
_0x57:
	RJMP _0x56
_0x58:
;            bellbell_flag = 1; //알람 시작 조건 / 알람 시작
	LDI  R30,LOW(1)
	MOV  R7,R30
;
;
;        if(timer_flag == 1)
_0x56:
	SBRS R2,2
	RJMP _0x59
;        {
;            timer.sec--;
	LDS  R30,_timer
	SUBI R30,LOW(1)
	STS  _timer,R30
;            timer_position_carry();
	RCALL _timer_position_carry
;            if(timer.sec + timer.min + timer.hour == 0)        // 타이머가 00000되면 알람
	LDS  R26,_timer
	LDI  R27,0
	SBRC R26,7
	SER  R27
	__GETB1MN _timer,1
	LDI  R31,0
	SBRC R30,7
	SER  R31
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _timer,2
	LDI  R31,0
	SBRC R30,7
	SER  R31
	ADD  R30,R26
	ADC  R31,R27
	SBIW R30,0
	BRNE _0x5A
;            {
;                timer_flag = 0;
	CLT
	BLD  R2,2
;                bellbell_flag = 1;
	LDI  R30,LOW(1)
	MOV  R7,R30
;            }
;        }
_0x5A:
;
;        if( bellbell_flag > 0)
_0x59:
	LDI  R30,LOW(0)
	CP   R30,R7
	BRSH _0x5B
;            ring_the_bell();
	RCALL _ring_the_bell
;
;
;        if(refresh_flag == 1)
_0x5B:
	SBRS R2,6
	RJMP _0x5C
;        {
;            LCD_clear();
	RCALL _LCD_clear
;            refresh_flag = 0;
	CLT
	BLD  R2,6
;        }
;        lcd_out();      //LCD 표현의 거의 모든게 여기있음
_0x5C:
	RCALL _lcd_out
;
;
;    }
;
;}
_0x54:
	RJMP _0xCE
; .FEND
;
;
;
;/*
;interrupt [EXT_INT6] void ext_int6_isr(void)
;{
;        mode++;
;        if(mode > 3) mode = 1;
;        printf("현재모드는 %d입니다 \r\n",mode);
;}*/
;
;interrupt [EXT_INT7] void ext_int7_isr(void)            // 수정모드
;{
_ext_int7_isr:
; .FSTART _ext_int7_isr
	CALL SUBOPT_0x11
;    printf("special key interrupt \r\n");
	__POINTW1FN _0x0,153
	CALL SUBOPT_0x8
;
;
;    while( (PINE & 0x80) != 0x00)     // 누르는 동안에도 display 표시
_0x5D:
	SBIS 0x1,7
	RJMP _0x5F
;    {
;        delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
;    }
	RJMP _0x5D
_0x5F:
;
;    if(bellbell_flag > 0)
	LDI  R30,LOW(0)
	CP   R30,R7
	BRSH _0x60
;    {
;        bellbell_flag = 0;
	CLR  R7
;        PORTE.2 = 0;
	CBI  0x3,2
;    }
;
;    else
	RJMP _0x63
_0x60:
;    {
;        switch (mode)
	MOV  R30,R6
	CALL SUBOPT_0x0
;        {
;        case 1:    //시계모드일때
	BRNE _0x67
;            clock_config_flag = ~ clock_config_flag;
	LDI  R30,LOW(8)
	EOR  R2,R30
;            pause_flag = ~pause_flag;
	LDI  R30,LOW(16)
	EOR  R2,R30
;            break;
	RJMP _0x66
;        case 2:
_0x67:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x68
;            alarm_flag = ~ alarm_flag;
	LDI  R30,LOW(32)
	EOR  R2,R30
;
;            break;
	RJMP _0x66
;
;        case 3:
_0x68:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x69
;            timer_flag = ~timer_flag ;
	LDI  R30,LOW(4)
	EOR  R2,R30
;
;            break;
;
;        case 4:
_0x69:
;
;            break;
;        }
_0x66:
;
;    }
_0x63:
;    refresh_flag = 1;
	SET
	BLD  R2,6
;}
_0xCE:
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
;#endif
;#include "uart.c"
;
;
;#ifndef _uart_
;#define _uart_
;
;
;void uart0_init(void)
; 0000 0012 {
_uart0_init:
; .FSTART _uart0_init
;  UCSR0A = 0x00;  // flag  clr, 멀티프로세싱 모드
	LDI  R30,LOW(0)
	OUT  0xB,R30
;  UCSR0B = 0x98; //rx,tx en, rx int on
	LDI  R30,LOW(152)
	OUT  0xA,R30
;  UCSR0C = 0x06; //n-p,1-stop
	LDI  R30,LOW(6)
	STS  149,R30
;  UBRR0H = 0x00;
	LDI  R30,LOW(0)
	STS  144,R30
;  UBRR0L = 103; //8mhz, 9600, 103 - 16mhz, 47 = 7.2738mhz
	LDI  R30,LOW(103)
	OUT  0x9,R30
;}
	RET
; .FEND
;
;
;#endif
;#include "i2c.c"
;#ifndef _i2c_
;#define _i2c_
;
;#define SLA             0xd0
;#define r_mode          1
;#define w_mode          0
;
;
;void I2C_write(unsigned char add,unsigned char dat); // 쓰기
;unsigned char read(char addr); // 읽기
;
;
;// 최대속도 400kbps 를 지원
;// SCL Freq =  cpu clock / (16+2(TWBR)*4^TWPS)  // cpu clock = 160000 twps = 0
;// 400k = 160000 / (16+ (2 *TWBR * 1)
;// TWBR = 12 -> 0x0C
;
;
;/*
;레지스터 종류는
;TWAR (Address Resgister)       // TWAR : 슬레이브 전송기나 슬레이브 수신기로 프로그램 되었을 때
;                                         TWI 가 응답할 7 비트의 슬레이브 주소를 라이트 합니다.
;TWBR (Bit Rate Register)       // TWBR : 비트 레이트 발생기의 나눗셈 비율을 결정합니다
;TWCR (Control Register)        // TWCR : TWI 의 동작을 제어합니다.
;TWDR (Address/Data Shift)      // 송신모드 : 다음 전송할 데이터를 갖는다 // 수신모드 : 수신된 이전 데이터를 갖는다.
;TWSR (Status Register)         // TWPS(0~1) : 비트레이트 프리스케일러 제어 // TWS(3~7) : TWI로직과 TWI버스상태 나타냄
;
;TWCR 레지스터 ( mega128_bits.h에 정의되어있음)
;#define TWIE    0     // (Interrupt Enable)이 비트가 1 이고 SREG 레지스터의 비트가 1 로 셋되어 있으면 TWINT 플래그가 1 � ...
;#define TWEN    2     // (TW Enable)TWEN 비트에 1 을 쓰면 TWI 작동이 가능하게 됩니다. // TWEN 비트에 0 을 쓰면 TWI 작동� ...
;#define TWWC    3     // 설정 x  // TWI 데이터 레지스터(TWDR)에 쓰려고 할 때 TWWC bit가 1이 된다.
;                         이 때 TWINT bit가 low인 상태이어야 한다. 이 플래그는 TWINT가 1인 상태에서 TWDR 레지스터에 쓰면  ...
;#define TWSTO   4     // 마스터 모드에서 2 선 시리얼 버스상에서 STOP 신호를 발생시키기 위하여 1 을 씁니다. TWSTO 비트는  ...
;#define TWSTA   5     // 2선 시리얼 버스상에서 마스터가 되고자 할 때 TWSTA 비트에 1 을 씁니다
;#define TWEA    6     // TWEA 비트는 확인 신호(Acknoledge) 펄스를 발생시키는 것을 제어합니다.
;#define TWINT   7     // (Interrupt Flag)이 비트는 현재 작업이 끝났을 때 하드웨어에 의해서 '1'로 설정된다.
;                         SREG의 I비트와 TWCR의 TWIE가 '1'로 설정되었다면, MCU가 TWI interrupt vector로 점프시킨다.
;                         TWINT 플래그는 해당 비트를 '1'로 쓰는 것으로 소프트웨어에 의한 클리어를 해야만 한다.
;                         이 비트는 하드웨어에 의해 자동으로 클리어 되지 않는다. 그래서 TWI 연산을 하기 위해 처음에 클리� ...
;
;*/
;
;
;void I2C_init(void)
; 0000 0013 {
_I2C_init:
; .FSTART _I2C_init
;    TWSR = 0x00;
	LDI  R30,LOW(0)
	STS  113,R30
;    TWBR = 0x0C;            // 400Kbps 로 설정
	LDI  R30,LOW(12)
	STS  112,R30
;
;    TWCR = (1<<TWEN);       // 0x04 TWEN이 1이어야지 작동
	LDI  R30,LOW(4)
	STS  116,R30
;
;    I2C_write(0x1B,0x00);                   //MPU6050 초기화
	LDI  R30,LOW(27)
	CALL SUBOPT_0x12
;    I2C_write(0x6B,0x00);                   //MPU6050 초기화
	LDI  R30,LOW(107)
	CALL SUBOPT_0x12
;    I2C_write(0x6C,0x00);                   //MPU6050 초기화
	LDI  R30,LOW(108)
	CALL SUBOPT_0x12
;
;}
	RET
; .FEND
;
;void I2C_write(unsigned char add,unsigned char dat) //자이로 센서 설정
;{
_I2C_write:
; .FSTART _I2C_write
;
;    TWCR = ( 1<<TWEN | 1<<TWSTA | 1<<TWINT ); //0xA4     // TWEN으로 Enable 하고 TWSTA로 마스터 설정하고 TWINT는 1로 시� ...
	ST   -Y,R26
;	add -> Y+1
;	dat -> Y+0
	LDI  R30,LOW(164)
	STS  116,R30
;
;    while((TWCR&0x80)==0x00); // 전송 대기  // twint 가 1인지 확인하는것인데 twint가 1이면 0이 될때까지 기다린다
_0x6B:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BREQ _0x6B
;    while((TWSR&0xF8)!=0x08); //신호 대기   // twsr이 0x08이면 start 코드 전송 완료
_0x6E:
	LDS  R30,113
	ANDI R30,LOW(0xF8)
	CPI  R30,LOW(0x8)
	BRNE _0x6E
;
;    TWDR=SLA + w_mode; // AD+W저장
	CALL SUBOPT_0x13
;    TWCR=0x84; // 전송
;
;    while((TWCR&0x80)==0x00); //전송대기
_0x71:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BREQ _0x71
;    while((TWSR&0xF8)!=0x18); //ACK대기
_0x74:
	LDS  R30,113
	ANDI R30,LOW(0xF8)
	CPI  R30,LOW(0x18)
	BRNE _0x74
;
;
;    TWDR=add; // RA
	CALL SUBOPT_0x14
;    TWCR=0x84; // 전송
;
;    while((TWCR&0x80)==0x00);
_0x77:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BREQ _0x77
;    while((TWSR&0xF8)!=0x28); // ACK
_0x7A:
	CALL SUBOPT_0x15
	BRNE _0x7A
;
;    TWDR=dat; // DATA
	LD   R30,Y
	STS  115,R30
;    TWCR=0x84; // 전송
	LDI  R30,LOW(132)
	STS  116,R30
;
;
;    while((TWCR&0x80)==0x00);
_0x7D:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BREQ _0x7D
;    while((TWSR&0xF8)!=0x28); // ACK
_0x80:
	CALL SUBOPT_0x15
	BRNE _0x80
;
;    TWCR|=0x94; // P
	LDS  R30,116
	ORI  R30,LOW(0x94)
	CALL SUBOPT_0x16
;    delay_us(50);  // 50us
;}
	RJMP _0x20A0007
; .FEND
;
;
;
;unsigned char read(char addr) //자이로 센서 값 읽어오기
;{
_read:
; .FSTART _read
;    unsigned char data; // data넣을 변수
;
;    TWCR=0xA4; // S
	ST   -Y,R26
	ST   -Y,R17
;	addr -> Y+1
;	data -> R17
	LDI  R30,LOW(164)
	STS  116,R30
;
;    while((TWCR&0x80)==0x00); //통신대기
_0x83:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BREQ _0x83
;    while((TWSR&0xF8)!=0x08); //신호대기
_0x86:
	LDS  R30,113
	ANDI R30,LOW(0xF8)
	CPI  R30,LOW(0x8)
	BRNE _0x86
;
;
;    TWDR=SLA + w_mode; // AD+W
	CALL SUBOPT_0x13
;    TWCR=0x84; // 전송
;
;    while((TWCR&0x80)==0x00); //통신대기
_0x89:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BREQ _0x89
;    while((TWSR&0xF8)!=0x18); //ACK
_0x8C:
	LDS  R30,113
	ANDI R30,LOW(0xF8)
	CPI  R30,LOW(0x18)
	BRNE _0x8C
;    TWDR=addr; // RA
	CALL SUBOPT_0x14
;    TWCR=0x84; //전송
;
;
;
;    while((TWCR&0x80)==0x00); //통신대기
_0x8F:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BREQ _0x8F
;    while((TWSR&0xF8)!=0x28); //ACK
_0x92:
	CALL SUBOPT_0x15
	BRNE _0x92
;    TWCR=0xA4; // RS
	LDI  R30,LOW(164)
	STS  116,R30
;
;    while((TWCR&0x80)==0x00); //통신대기
_0x95:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BREQ _0x95
;    while((TWSR&0xF8)!=0x10); //ACK
_0x98:
	LDS  R30,113
	ANDI R30,LOW(0xF8)
	CPI  R30,LOW(0x10)
	BRNE _0x98
;    TWDR=SLA + r_mode; // AD+R
	LDI  R30,LOW(209)
	STS  115,R30
;    TWCR=0x84; //전송
	LDI  R30,LOW(132)
	STS  116,R30
;
;
;    while((TWCR&0x80)==0x00); //통신대기
_0x9B:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BREQ _0x9B
;    while((TWSR&0xF8)!=0x40); // ACK
_0x9E:
	LDS  R30,113
	ANDI R30,LOW(0xF8)
	CPI  R30,LOW(0x40)
	BRNE _0x9E
;    TWCR=0x84;//전송
	LDI  R30,LOW(132)
	STS  116,R30
;
;    while((TWCR&0x80)==0x00); //통신대기
_0xA1:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BREQ _0xA1
;    while((TWSR&0xF8)!=0x58); //ACK
_0xA4:
	LDS  R30,113
	ANDI R30,LOW(0xF8)
	CPI  R30,LOW(0x58)
	BRNE _0xA4
;    data=TWDR;
	LDS  R17,115
;
;    TWCR=0x94; // P
	LDI  R30,LOW(148)
	CALL SUBOPT_0x16
;    delay_us(50);  // 50us
;    return data;
	MOV  R30,R17
	LDD  R17,Y+0
_0x20A0007:
	ADIW R28,2
	RET
;
;}
; .FEND
;
;
;
;
;
;
;#endif
;#include "gyro_func.c"
;#ifndef _gyro_func_
;#define _gyro_func_
;
;
;void dgree_to_mode(void){
; 0000 0014 void dgree_to_mode(void){
_dgree_to_mode:
; .FSTART _dgree_to_mode
;
;    if(deg_y >= 315 || deg_y <= 45 )        // -45 ~ 45도 실행함수
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
	BRSH _0xA8
	CALL SUBOPT_0x19
	BREQ PC+2
	BRCC PC+2
	RJMP _0xA8
	RJMP _0xA7
_0xA8:
;    {
;        printf("mode : 1 \n\r");
	__POINTW1FN _0x0,178
	CALL SUBOPT_0x8
;        mode = 1;
	LDI  R30,LOW(1)
	MOV  R6,R30
;    }
;    if(deg_y >= 45 && deg_y <= 135 )        //45 ~ 135도 실행함수
_0xA7:
	CALL SUBOPT_0x19
	BRLO _0xAB
	CALL SUBOPT_0x1A
	BREQ PC+3
	BRCS PC+2
	RJMP _0xAB
	RJMP _0xAC
_0xAB:
	RJMP _0xAA
_0xAC:
;    {
;        printf("mode : 2 \n\r");
	__POINTW1FN _0x0,190
	CALL SUBOPT_0x8
;        mode = 2;
	LDI  R30,LOW(2)
	MOV  R6,R30
;    }
;    if(deg_y >= 135 && deg_y <= 225 )       // 135 ~ 255도 실행함수
_0xAA:
	CALL SUBOPT_0x1A
	BRLO _0xAE
	CALL SUBOPT_0x1B
	BREQ PC+3
	BRCS PC+2
	RJMP _0xAE
	RJMP _0xAF
_0xAE:
	RJMP _0xAD
_0xAF:
;    {
;        mode = 3;
	LDI  R30,LOW(3)
	MOV  R6,R30
;        printf("mode : 3 \n\r");
	__POINTW1FN _0x0,202
	CALL SUBOPT_0x8
;    }
;    if(deg_y >= 225 && deg_y <= 315 )       // 225 ~ 315도 실행함수
_0xAD:
	CALL SUBOPT_0x1B
	BRLO _0xB1
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
	BREQ PC+3
	BRCS PC+2
	RJMP _0xB1
	RJMP _0xB2
_0xB1:
	RJMP _0xB0
_0xB2:
;    {
;        mode = 4;
	LDI  R30,LOW(4)
	MOV  R6,R30
;        printf("mode : 4 \n\r");
	__POINTW1FN _0x0,214
	CALL SUBOPT_0x8
;    }
;}
_0xB0:
	RET
; .FEND
;
;void input_gyro_data(void)
;{
_input_gyro_data:
; .FSTART _input_gyro_data
;    ////////////////////자이로////////////////////
;
;    gx_high=read(0x43);  //자이로 x high값 읽어오기
	LDI  R26,LOW(67)
	RCALL _read
	STS  _gx_high,R30
;    gy_high=read(0x45);  //자이로 y high값 읽어오기
	LDI  R26,LOW(69)
	RCALL _read
	STS  _gy_high,R30
;    gz_high=read(0x47);  //자이로 z high값 읽어오기
	LDI  R26,LOW(71)
	RCALL _read
	STS  _gz_high,R30
;
;    gx_low=read(0x44);   //자이로 x low값 읽어오기
	LDI  R26,LOW(68)
	RCALL _read
	STS  _gx_low,R30
;    gy_low=read(0x46);   //자이로 y low값 읽어오기
	LDI  R26,LOW(70)
	RCALL _read
	STS  _gy_low,R30
;    gz_low=read(0x48);   //자이로 z low값 읽어오기
	LDI  R26,LOW(72)
	RCALL _read
	STS  _gz_low,R30
;
;    temp_high = read(0x41);
	LDI  R26,LOW(65)
	RCALL _read
	STS  _temp_high,R30
;    temp_low = read(0x42);
	LDI  R26,LOW(66)
	RCALL _read
	STS  _temp_low,R30
;
;    gx = (gx_high<<8) | (gx_low);
	LDS  R27,_gx_high
	LDI  R26,LOW(0)
	LDS  R30,_gx_low
	CALL SUBOPT_0x1C
	STS  _gx,R30
	STS  _gx+1,R31
	STS  _gx+2,R22
	STS  _gx+3,R23
;    gy = (gy_high<<8) | (gy_low);
	LDS  R27,_gy_high
	LDI  R26,LOW(0)
	LDS  R30,_gy_low
	CALL SUBOPT_0x1C
	STS  _gy,R30
	STS  _gy+1,R31
	STS  _gy+2,R22
	STS  _gy+3,R23
;    gz = (gz_high<<8) | (gz_low);
	LDS  R27,_gz_high
	LDI  R26,LOW(0)
	LDS  R30,_gz_low
	CALL SUBOPT_0x1C
	STS  _gz,R30
	STS  _gz+1,R31
	STS  _gz+2,R22
	STS  _gz+3,R23
;
;    temp = (temp_high <<8) | temp_low ;
	LDS  R27,_temp_high
	LDI  R26,LOW(0)
	LDS  R30,_temp_low
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	LDI  R26,LOW(_temp)
	LDI  R27,HIGH(_temp)
	CALL SUBOPT_0x1D
	CALL __PUTDP1
;    temp = temp/340 + 36.53;
	CALL SUBOPT_0x1E
	__GETD1N 0x43AA0000
	CALL __DIVF21
	__GETD2N 0x42121EB8
	CALL __ADDF12
	STS  _temp,R30
	STS  _temp+1,R31
	STS  _temp+2,R22
	STS  _temp+3,R23
;    int_temp = temp*10;     //소수점 1자리까지만 나타내기위해 *10 해서 인트형으로 변환
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
	CALL __CFD1
	MOVW R4,R30
;
;    //////////////////////////////////////////
;    /////////////////가속도////////////////////
;
;    ax_high=read(0x3b);  //가속도 x high값 읽어오기
	LDI  R26,LOW(59)
	RCALL _read
	STS  _ax_high,R30
;    ay_high=read(0x3d);  //가속도 y high값 읽어오기
	LDI  R26,LOW(61)
	RCALL _read
	STS  _ay_high,R30
;    az_high=read(0x3f);  //가속도 z high값 읽어오기
	LDI  R26,LOW(63)
	RCALL _read
	STS  _az_high,R30
;
;
;    ax_low=read(0x3c);   //자이로 x low값 읽어오기
	LDI  R26,LOW(60)
	RCALL _read
	STS  _ax_low,R30
;    ay_low=read(0x3e);   //자이로 y low값 읽어오기
	LDI  R26,LOW(62)
	RCALL _read
	STS  _ay_low,R30
;    az_low=read(0x40);   //자이로 z low값 읽어오기
	LDI  R26,LOW(64)
	RCALL _read
	STS  _az_low,R30
;
;    ax = (ax_high<<8) | (ax_low);
	LDS  R27,_ax_high
	LDI  R26,LOW(0)
	LDS  R30,_ax_low
	CALL SUBOPT_0x1C
	STS  _ax,R30
	STS  _ax+1,R31
	STS  _ax+2,R22
	STS  _ax+3,R23
;    ay = (ay_high<<8) | (ay_low);
	LDS  R27,_ay_high
	LDI  R26,LOW(0)
	LDS  R30,_ay_low
	CALL SUBOPT_0x1C
	STS  _ay,R30
	STS  _ay+1,R31
	STS  _ay+2,R22
	STS  _ay+3,R23
;    az = (az_high<<8) | (az_low);
	LDS  R27,_az_high
	LDI  R26,LOW(0)
	LDS  R30,_az_low
	CALL SUBOPT_0x1C
	STS  _az,R30
	STS  _az+1,R31
	STS  _az+2,R22
	STS  _az+3,R23
;
;    delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
;
;    //상보필터부분
;
;
;    deg_x = atan2(ax, az) * 180 / PI  ;  //rad to deg
	CALL SUBOPT_0x20
	CALL __PUTPARD1
	LDS  R30,_az
	LDS  R31,_az+1
	LDS  R22,_az+2
	LDS  R23,_az+3
	CALL SUBOPT_0x21
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;    dgy_x = gy / 131.0f  ;  //16-bit data to 250 deg/sec
	LDS  R30,_gy
	LDS  R31,_gy+1
	LDS  R22,_gy+2
	LDS  R23,_gy+3
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	STS  _dgy_x,R30
	STS  _dgy_x+1,R31
	STS  _dgy_x+2,R22
	STS  _dgy_x+3,R23
;    angle_x = (0.95 * (angle_x + (dgy_x * 0.001))) + (0.05 * deg_x) ; //complementary filter
	LDS  R26,_dgy_x
	LDS  R27,_dgy_x+1
	LDS  R24,_dgy_x+2
	LDS  R25,_dgy_x+3
	CALL SUBOPT_0x25
	LDS  R26,_angle_x
	LDS  R27,_angle_x+1
	LDS  R24,_angle_x+2
	LDS  R25,_angle_x+3
	CALL SUBOPT_0x26
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x27
	CALL SUBOPT_0x28
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	STS  _angle_x,R30
	STS  _angle_x+1,R31
	STS  _angle_x+2,R22
	STS  _angle_x+3,R23
;
;
;    deg_y = atan2(ay, ax)*180 / PI ;
	LDS  R30,_ay
	LDS  R31,_ay+1
	LDS  R22,_ay+2
	LDS  R23,_ay+3
	CALL __CDF1
	CALL __PUTPARD1
	CALL SUBOPT_0x20
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x22
	CALL SUBOPT_0x29
;    dgy_y = gz / 131.f ;
	LDS  R30,_gz
	LDS  R31,_gz+1
	LDS  R22,_gz+2
	LDS  R23,_gz+3
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	STS  _dgy_y,R30
	STS  _dgy_y+1,R31
	STS  _dgy_y+2,R22
	STS  _dgy_y+3,R23
;    angle_y = (0.95 * (angle_y + (dgy_y * 0.001))) + (0.05 * deg_y); ; //complementary filter
	LDS  R26,_dgy_y
	LDS  R27,_dgy_y+1
	LDS  R24,_dgy_y+2
	LDS  R25,_dgy_y+3
	CALL SUBOPT_0x25
	LDS  R26,_angle_y
	LDS  R27,_angle_y+1
	LDS  R24,_angle_y+2
	LDS  R25,_angle_y+3
	CALL SUBOPT_0x26
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x28
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	STS  _angle_y,R30
	STS  _angle_y+1,R31
	STS  _angle_y+2,R22
	STS  _angle_y+3,R23
;
;    deg_x = deg_x+180;
	CALL SUBOPT_0x27
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x23
;    deg_y = deg_y+180;
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x29
;    //printf("x : %.2f / y: %.2f \r\n",deg_x,deg_y);
;
;}
	RET
; .FEND
;
;
;
;#endif
;#include "lcd_con.c"
;#ifndef _lcd_con_
;#define _lcd_con_
;
;
;
;void LCD_controller(unsigned char control)
; 0000 0015 {
_LCD_controller:
; .FSTART _LCD_controller
;    delay_ms(1);
	ST   -Y,R26
;	control -> Y+0
	CALL SUBOPT_0x2C
;    CTRLBUS = 0x00; //RW clear.
	LDI  R30,LOW(0)
	OUT  0x18,R30
;    delay_ms(1); //RW & RS Setup time is 40ns min.
	CALL SUBOPT_0x2C
;    CTRLBUS |= 1<<E; // E set.
	SBI  0x18,2
;    delay_ms(1); //Data Setup time is 80ns min.
	CALL SUBOPT_0x2C
;    DATABUS = control; // Data input.
	LD   R30,Y
	OUT  0x1B,R30
;    delay_ms(1); // valid data is 130ns min.
	CALL SUBOPT_0x2C
;    CTRLBUS = (1<<RS)|(1<<RW)|(0<<E); // RS set. RW set. E clear.
	LDI  R30,LOW(3)
	OUT  0x18,R30
;}
	JMP  _0x20A0006
; .FEND
;
;void LCD_data(unsigned char Data)
;{
_LCD_data:
; .FSTART _LCD_data
;    delay_ms(1);
	ST   -Y,R26
;	Data -> Y+0
	CALL SUBOPT_0x2C
;    CTRLBUS = 1<<RS; //RS set. RW clear. E clear.
	LDI  R30,LOW(1)
	OUT  0x18,R30
;    delay_ms(1); //RW & RS Setup time is 40ns min.
	CALL SUBOPT_0x2C
;    CTRLBUS |= 1<<E; // E set.
	SBI  0x18,2
;    delay_ms(1); //Data Setup time is 80ns min.
	CALL SUBOPT_0x2C
;    DATABUS = Data; // Data input.
	LD   R30,Y
	OUT  0x1B,R30
;    delay_ms(1); // valid data min is 130ns.
	CALL SUBOPT_0x2C
;    CTRLBUS = 1<<RW; // RS clear. RW set. E clear.
	LDI  R30,LOW(2)
	OUT  0x18,R30
;}
	JMP  _0x20A0006
; .FEND
;
;void LCD_string(unsigned char address, char *Str,char x,char y)
;{
_LCD_string:
; .FSTART _LCD_string
;
;    int i=1;
;
;    if(y==1)
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	address -> Y+6
;	*Str -> Y+4
;	x -> Y+3
;	y -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,1
	LDD  R26,Y+2
	CPI  R26,LOW(0x1)
	BRNE _0xB3
;        i = 17;
	__GETWRN 16,17,17
;
;
;
;    LCD_controller(address); // LCD display start position
_0xB3:
	LDD  R26,Y+6
	RCALL _LCD_controller
;    while(*Str!=0)
_0xB4:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R30,X
	CPI  R30,0
	BREQ _0xB6
;    {
;
;        if(address+i == 0x21)
	LDD  R30,Y+6
	LDI  R31,0
	ADD  R30,R16
	ADC  R31,R17
	CPI  R30,LOW(0x21)
	LDI  R26,HIGH(0x21)
	CPC  R31,R26
	BRNE _0xB7
;            LCD_controller(0xc0); // second line display
	LDI  R26,LOW(192)
	RCALL _LCD_controller
;        while(x>0)
_0xB7:
_0xB8:
	LDD  R26,Y+3
	CPI  R26,LOW(0x1)
	BRLO _0xBA
;        {
;            x--;
	LDD  R30,Y+3
	SUBI R30,LOW(1)
	STD  Y+3,R30
;            LCD_data(' ');
	LDI  R26,LOW(32)
	RCALL _LCD_data
;        }
	RJMP _0xB8
_0xBA:
;        LCD_data(*Str);
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R26,X
	RCALL _LCD_data
;        i++;
	__ADDWRN 16,17,1
;        Str++;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
;    }
	RJMP _0xB4
_0xB6:
;}
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,7
	RET
; .FEND
;
;
;void LCD_clear()
;{
_LCD_clear:
; .FSTART _LCD_clear
;    LCD_string(0x10," ",0,0);
	LDI  R30,LOW(16)
	ST   -Y,R30
	__POINTW1MN _0xBB,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _LCD_string
;    LCD_controller(0x01); // Display Clear.
	LDI  R26,LOW(1)
	RCALL _LCD_controller
;    delay_us(2);
	__DELAY_USB 11
;}
	RET
; .FEND

	.DSEG
_0xBB:
	.BYTE 0x2
;
;void LCD_initialize()
;{

	.CSEG
_LCD_initialize:
; .FSTART _LCD_initialize
;    /* 8bit interface mode */
;    delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
;    LCD_controller(0x3c); // Function set. Use 2-line, display on.
	LDI  R26,LOW(60)
	CALL SUBOPT_0x2D
;    delay_ms(40); // wait for more than 39us.
;    LCD_controller(0x0c); // Display ON/OFF Control. display on ,cursor off,blink off
	LDI  R26,LOW(12)
	CALL SUBOPT_0x2D
;    delay_ms(40); // wait for more than 39us.
;    LCD_controller(0x01); // Display Clear.
	LDI  R26,LOW(1)
	RCALL _LCD_controller
;    delay_ms(1); // wait for more than 1.53ms.
	CALL SUBOPT_0x2C
;    LCD_controller(0x06); // Entry Mode Set. I/D increment mode, entire shift off
	LDI  R26,LOW(6)
	RCALL _LCD_controller
;}
	RET
; .FEND
;
;#endif
;
;
;
;
;void main(void)
; 0000 001B {
_main:
; .FSTART _main
; 0000 001C 
; 0000 001D //####################### 내부풀업 ##################################
; 0000 001E     DDRD = 0x3F;     //외부인터럽트 입력선언 상위4비트 출력, 하위4비트 입력
	LDI  R30,LOW(63)
	OUT  0x11,R30
; 0000 001F     PORTD = 0xF0;
	LDI  R30,LOW(240)
	OUT  0x12,R30
; 0000 0020     PORTB = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0021     SFIOR = 0xFB & SFIOR;   // Atmega 내부풀업 사용 : ddrx = 0 / portx = 1 / pud = 0
	IN   R30,0x20
	ANDI R30,0xFB
	OUT  0x20,R30
; 0000 0022     uart0_init();
	RCALL _uart0_init
; 0000 0023 //#################################################################
; 0000 0024     DDRA = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0025     DDRB = 0xFF;
	OUT  0x17,R30
; 0000 0026 
; 0000 0027     // 타이머0 오버플로우 인터럽트
; 0000 0028     TCCR0= 0x05;     // Prescale : 128
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 0029     TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x37,R30
; 0000 002A     TCNT0 = 131;       //256-125 = 131
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 002B     //1/ 16000000 *  128  * 125 = 1ms,  (256-125)=131
; 0000 002C 
; 0000 002D     DDRE = 0x04;        // 부저전용 PORTE.2
	LDI  R30,LOW(4)
	OUT  0x2,R30
; 0000 002E 
; 0000 002F 
; 0000 0030     EIMSK = 0x80;   //int0~7 다쓸거니까
	LDI  R30,LOW(128)
	OUT  0x39,R30
; 0000 0031     //EICRA = 0xff;   //int0~3 전부 상승엣지로 눌렸을때 작동하게
; 0000 0032     EICRB = 0x80;   //int4~7 전부 상승엣지로
	OUT  0x3A,R30
; 0000 0033 
; 0000 0034     //★★★★★★★★★★★★★★★★★ Proteus : 주석처리 / 빵판 : 주석해제 ★★★★★★★★★★★★★
; 0000 0035     I2C_init();
	RCALL _I2C_init
; 0000 0036     //★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★ ...
; 0000 0037     printf("start\r\n");
	__POINTW1FN _0x0,226
	CALL SUBOPT_0x8
; 0000 0038 
; 0000 0039 
; 0000 003A     LCD_initialize();
	RCALL _LCD_initialize
; 0000 003B 
; 0000 003C     LCD_string(0x10, "Digital Clock",1,0);
	LDI  R30,LOW(16)
	ST   -Y,R30
	__POINTW1MN _0xBC,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _LCD_string
; 0000 003D     LCD_string(0x10, "with Gyro",1,1);
	LDI  R30,LOW(16)
	ST   -Y,R30
	__POINTW1MN _0xBC,14
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _LCD_string
; 0000 003E 
; 0000 003F     delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 0040     LCD_clear();
	RCALL _LCD_clear
; 0000 0041 
; 0000 0042     #asm("sei")
	sei
; 0000 0043 
; 0000 0044     while(1)
_0xBD:
; 0000 0045     {
; 0000 0046             delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0047             input_gyro_data();                // 자이로 값 -> 각도 계산, 보정
	RCALL _input_gyro_data
; 0000 0048             dgree_to_mode();                   // 각도 값 -> 모드 변환
	RCALL _dgree_to_mode
; 0000 0049 
; 0000 004A 
; 0000 004B             if (state != mode)
	CP   R6,R8
	BREQ _0xC0
; 0000 004C             {
; 0000 004D                 refresh_flag=1;
	SET
	BLD  R2,6
; 0000 004E                 state = mode;
	MOV  R8,R6
; 0000 004F             }
; 0000 0050 
; 0000 0051             switch(mode)
_0xC0:
	MOV  R30,R6
	CALL SUBOPT_0x0
; 0000 0052             {
; 0000 0053             case 1:
	BRNE _0xC4
; 0000 0054                 if (pause_flag == 1)
	SBRS R2,4
	RJMP _0xC5
; 0000 0055                 {
; 0000 0056                     key = key_in();
	RCALL _key_in
	MOV  R9,R30
; 0000 0057                     if(key_flag == 1) key_chk();
	SBRC R2,0
	RCALL _key_chk
; 0000 0058                 }
; 0000 0059                 break;
_0xC5:
	RJMP _0xC3
; 0000 005A 
; 0000 005B             case 2:
_0xC4:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xC7
; 0000 005C                 key = key_in();
	RCALL _key_in
	MOV  R9,R30
; 0000 005D                 if(key_flag == 1) key_chk();
	SBRC R2,0
	RCALL _key_chk
; 0000 005E                 break;
	RJMP _0xC3
; 0000 005F 
; 0000 0060             case 3:
_0xC7:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xC3
; 0000 0061                 if(timer_flag == 0)
	SBRC R2,2
	RJMP _0xCA
; 0000 0062                 {
; 0000 0063                     key = key_in();
	RCALL _key_in
	MOV  R9,R30
; 0000 0064                     if(key_flag == 1) key_chk();
	SBRC R2,0
	RCALL _key_chk
; 0000 0065                 }
; 0000 0066             }
_0xCA:
_0xC3:
; 0000 0067 
; 0000 0068     }
	RJMP _0xBD
; 0000 0069 
; 0000 006A 
; 0000 006B }
_0xCC:
	RJMP _0xCC
; .FEND

	.DSEG
_0xBC:
	.BYTE 0x18
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
; .FSTART _putchar
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x20A0006:
	ADIW R28,1
	RET
; .FEND
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
__ftoe_G100:
; .FSTART __ftoe_G100
	CALL SUBOPT_0x2E
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2000019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2000000,0
	CALL _strcpyf
	RJMP _0x20A0005
_0x2000019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2000018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2000000,1
	CALL _strcpyf
	RJMP _0x20A0005
_0x2000018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x200001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x200001B:
	LDD  R17,Y+11
_0x200001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x200001E
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	RJMP _0x200001C
_0x200001E:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x200001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	RJMP _0x2000020
_0x200001F:
	LDD  R19,Y+11
	CALL SUBOPT_0x31
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000021
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
_0x2000022:
	CALL SUBOPT_0x31
	BRLO _0x2000024
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
	RJMP _0x2000022
_0x2000024:
	RJMP _0x2000025
_0x2000021:
_0x2000026:
	CALL SUBOPT_0x31
	BRSH _0x2000028
	CALL SUBOPT_0x32
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x34
	SUBI R19,LOW(1)
	RJMP _0x2000026
_0x2000028:
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
_0x2000025:
	__GETD1S 12
	CALL SUBOPT_0x35
	CALL SUBOPT_0x34
	CALL SUBOPT_0x31
	BRLO _0x2000029
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
_0x2000029:
_0x2000020:
	LDI  R17,LOW(0)
_0x200002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x200002C
	CALL SUBOPT_0x36
	CALL SUBOPT_0x37
	CALL SUBOPT_0x35
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	CALL SUBOPT_0x30
	CALL SUBOPT_0x38
	CALL SUBOPT_0x32
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x39
	CALL SUBOPT_0x3A
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x32
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x34
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x200002A
	CALL SUBOPT_0x39
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x200002A
_0x200002C:
	CALL SUBOPT_0x3D
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x200002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x2000113
_0x200002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x2000113:
	ST   X,R30
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3D
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x3D
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20A0005:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2000036
	CPI  R18,37
	BRNE _0x2000037
	LDI  R17,LOW(1)
	RJMP _0x2000038
_0x2000037:
	CALL SUBOPT_0x3E
_0x2000038:
	RJMP _0x2000035
_0x2000036:
	CPI  R30,LOW(0x1)
	BRNE _0x2000039
	CPI  R18,37
	BRNE _0x200003A
	CALL SUBOPT_0x3E
	RJMP _0x2000114
_0x200003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x200003B
	LDI  R16,LOW(1)
	RJMP _0x2000035
_0x200003B:
	CPI  R18,43
	BRNE _0x200003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2000035
_0x200003C:
	CPI  R18,32
	BRNE _0x200003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2000035
_0x200003D:
	RJMP _0x200003E
_0x2000039:
	CPI  R30,LOW(0x2)
	BRNE _0x200003F
_0x200003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000040
	ORI  R16,LOW(128)
	RJMP _0x2000035
_0x2000040:
	RJMP _0x2000041
_0x200003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2000042
_0x2000041:
	CPI  R18,48
	BRLO _0x2000044
	CPI  R18,58
	BRLO _0x2000045
_0x2000044:
	RJMP _0x2000043
_0x2000045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2000035
_0x2000043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2000046
	LDI  R17,LOW(4)
	RJMP _0x2000035
_0x2000046:
	RJMP _0x2000047
_0x2000042:
	CPI  R30,LOW(0x4)
	BRNE _0x2000049
	CPI  R18,48
	BRLO _0x200004B
	CPI  R18,58
	BRLO _0x200004C
_0x200004B:
	RJMP _0x200004A
_0x200004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2000035
_0x200004A:
_0x2000047:
	CPI  R18,108
	BRNE _0x200004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2000035
_0x200004D:
	RJMP _0x200004E
_0x2000049:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x2000035
_0x200004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000053
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x40
	CALL SUBOPT_0x3F
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x41
	RJMP _0x2000054
_0x2000053:
	CPI  R30,LOW(0x45)
	BREQ _0x2000057
	CPI  R30,LOW(0x65)
	BRNE _0x2000058
_0x2000057:
	RJMP _0x2000059
_0x2000058:
	CPI  R30,LOW(0x66)
	BREQ PC+2
	RJMP _0x200005A
_0x2000059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x42
	CALL __GETD1P
	CALL SUBOPT_0x43
	CALL SUBOPT_0x44
	LDD  R26,Y+13
	TST  R26
	BRMI _0x200005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x200005D
	CPI  R26,LOW(0x20)
	BREQ _0x200005F
	RJMP _0x2000060
_0x200005B:
	CALL SUBOPT_0x45
	CALL __ANEGF1
	CALL SUBOPT_0x43
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x200005D:
	SBRS R16,7
	RJMP _0x2000061
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x41
	RJMP _0x2000062
_0x2000061:
_0x200005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2000062:
_0x2000060:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2000064
	CALL SUBOPT_0x45
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CALL _ftoa
	RJMP _0x2000065
_0x2000064:
	CALL SUBOPT_0x45
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G100
_0x2000065:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x46
	RJMP _0x2000066
_0x200005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2000068
	CALL SUBOPT_0x44
	CALL SUBOPT_0x47
	CALL SUBOPT_0x46
	RJMP _0x2000069
_0x2000068:
	CPI  R30,LOW(0x70)
	BRNE _0x200006B
	CALL SUBOPT_0x44
	CALL SUBOPT_0x47
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000069:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x200006D
	CP   R20,R17
	BRLO _0x200006E
_0x200006D:
	RJMP _0x200006C
_0x200006E:
	MOV  R17,R20
_0x200006C:
_0x2000066:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x200006F
_0x200006B:
	CPI  R30,LOW(0x64)
	BREQ _0x2000072
	CPI  R30,LOW(0x69)
	BRNE _0x2000073
_0x2000072:
	ORI  R16,LOW(4)
	RJMP _0x2000074
_0x2000073:
	CPI  R30,LOW(0x75)
	BRNE _0x2000075
_0x2000074:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2000076
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x48
	LDI  R17,LOW(10)
	RJMP _0x2000077
_0x2000076:
	__GETD1N 0x2710
	CALL SUBOPT_0x48
	LDI  R17,LOW(5)
	RJMP _0x2000077
_0x2000075:
	CPI  R30,LOW(0x58)
	BRNE _0x2000079
	ORI  R16,LOW(8)
	RJMP _0x200007A
_0x2000079:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x20000B8
_0x200007A:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x200007C
	__GETD1N 0x10000000
	CALL SUBOPT_0x48
	LDI  R17,LOW(8)
	RJMP _0x2000077
_0x200007C:
	__GETD1N 0x1000
	CALL SUBOPT_0x48
	LDI  R17,LOW(4)
_0x2000077:
	CPI  R20,0
	BREQ _0x200007D
	ANDI R16,LOW(127)
	RJMP _0x200007E
_0x200007D:
	LDI  R20,LOW(1)
_0x200007E:
	SBRS R16,1
	RJMP _0x200007F
	CALL SUBOPT_0x44
	CALL SUBOPT_0x42
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2000115
_0x200007F:
	SBRS R16,2
	RJMP _0x2000081
	CALL SUBOPT_0x44
	CALL SUBOPT_0x47
	CALL __CWD1
	RJMP _0x2000115
_0x2000081:
	CALL SUBOPT_0x44
	CALL SUBOPT_0x47
	CLR  R22
	CLR  R23
_0x2000115:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2000083
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2000084
	CALL SUBOPT_0x45
	CALL __ANEGD1
	CALL SUBOPT_0x43
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2000084:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2000085
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2000086
_0x2000085:
	ANDI R16,LOW(251)
_0x2000086:
_0x2000083:
	MOV  R19,R20
_0x200006F:
	SBRC R16,0
	RJMP _0x2000087
_0x2000088:
	CP   R17,R21
	BRSH _0x200008B
	CP   R19,R21
	BRLO _0x200008C
_0x200008B:
	RJMP _0x200008A
_0x200008C:
	SBRS R16,7
	RJMP _0x200008D
	SBRS R16,2
	RJMP _0x200008E
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x200008F
_0x200008E:
	LDI  R18,LOW(48)
_0x200008F:
	RJMP _0x2000090
_0x200008D:
	LDI  R18,LOW(32)
_0x2000090:
	CALL SUBOPT_0x3E
	SUBI R21,LOW(1)
	RJMP _0x2000088
_0x200008A:
_0x2000087:
_0x2000091:
	CP   R17,R20
	BRSH _0x2000093
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000094
	CALL SUBOPT_0x49
	BREQ _0x2000095
	SUBI R21,LOW(1)
_0x2000095:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2000094:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x41
	CPI  R21,0
	BREQ _0x2000096
	SUBI R21,LOW(1)
_0x2000096:
	SUBI R20,LOW(1)
	RJMP _0x2000091
_0x2000093:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2000097
_0x2000098:
	CPI  R19,0
	BREQ _0x200009A
	SBRS R16,3
	RJMP _0x200009B
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x200009C
_0x200009B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x200009C:
	CALL SUBOPT_0x3E
	CPI  R21,0
	BREQ _0x200009D
	SUBI R21,LOW(1)
_0x200009D:
	SUBI R19,LOW(1)
	RJMP _0x2000098
_0x200009A:
	RJMP _0x200009E
_0x2000097:
_0x20000A0:
	CALL SUBOPT_0x4A
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20000A2
	SBRS R16,3
	RJMP _0x20000A3
	SUBI R18,-LOW(55)
	RJMP _0x20000A4
_0x20000A3:
	SUBI R18,-LOW(87)
_0x20000A4:
	RJMP _0x20000A5
_0x20000A2:
	SUBI R18,-LOW(48)
_0x20000A5:
	SBRC R16,4
	RJMP _0x20000A7
	CPI  R18,49
	BRSH _0x20000A9
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20000A8
_0x20000A9:
	RJMP _0x20000AB
_0x20000A8:
	CP   R20,R19
	BRSH _0x2000116
	CP   R21,R19
	BRLO _0x20000AE
	SBRS R16,0
	RJMP _0x20000AF
_0x20000AE:
	RJMP _0x20000AD
_0x20000AF:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20000B0
_0x2000116:
	LDI  R18,LOW(48)
_0x20000AB:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20000B1
	CALL SUBOPT_0x49
	BREQ _0x20000B2
	SUBI R21,LOW(1)
_0x20000B2:
_0x20000B1:
_0x20000B0:
_0x20000A7:
	CALL SUBOPT_0x3E
	CPI  R21,0
	BREQ _0x20000B3
	SUBI R21,LOW(1)
_0x20000B3:
_0x20000AD:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x4A
	CALL __MODD21U
	CALL SUBOPT_0x43
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x48
	__GETD1S 16
	CALL __CPD10
	BREQ _0x20000A1
	RJMP _0x20000A0
_0x20000A1:
_0x200009E:
	SBRS R16,0
	RJMP _0x20000B4
_0x20000B5:
	CPI  R21,0
	BREQ _0x20000B7
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x41
	RJMP _0x20000B5
_0x20000B7:
_0x20000B4:
_0x20000B8:
_0x2000054:
_0x2000114:
	LDI  R17,LOW(0)
_0x2000035:
	RJMP _0x2000030
_0x2000032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
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
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL __ADDW2R15
	CALL __GETW1P
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
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	CALL SUBOPT_0x4B
	CALL _ftrunc
	CALL SUBOPT_0x4C
    brne __floor1
__floor0:
	CALL SUBOPT_0x4D
	RJMP _0x20A0004
__floor1:
    brtc __floor0
	CALL SUBOPT_0x4E
	CALL __SUBF12
	RJMP _0x20A0004
; .FEND
_xatan:
; .FSTART _xatan
	CALL __PUTPARD2
	SBIW R28,4
	CALL SUBOPT_0x38
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x4D
	__GETD2N 0x40CBD065
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x3B
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x4D
	__GETD2N 0x41296D00
	CALL __ADDF12
	CALL SUBOPT_0x50
	CALL SUBOPT_0x4F
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	ADIW R28,8
	RET
; .FEND
_yatan:
; .FSTART _yatan
	CALL SUBOPT_0x4B
	__GETD1N 0x3ED413CD
	CALL __CMPF12
	BRSH _0x2020020
	CALL SUBOPT_0x50
	RCALL _xatan
	RJMP _0x20A0004
_0x2020020:
	CALL SUBOPT_0x50
	__GETD1N 0x401A827A
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2020021
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x51
	__GETD2N 0x3FC90FDB
	CALL SUBOPT_0x3C
	RJMP _0x20A0004
_0x2020021:
	CALL SUBOPT_0x4E
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x4E
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x51
	__GETD2N 0x3F490FDB
	CALL __ADDF12
_0x20A0004:
	ADIW R28,4
	RET
; .FEND
_atan2:
; .FSTART _atan2
	CALL __PUTPARD2
	SBIW R28,4
	CALL SUBOPT_0x38
	CALL __CPD10
	BRNE _0x202002D
	__GETD1S 8
	CALL __CPD10
	BRNE _0x202002E
	__GETD1N 0x7F7FFFFF
	RJMP _0x20A0003
_0x202002E:
	__GETD2S 8
	CALL __CPD02
	BRGE _0x202002F
	__GETD1N 0x3FC90FDB
	RJMP _0x20A0003
_0x202002F:
	__GETD1N 0xBFC90FDB
	RJMP _0x20A0003
_0x202002D:
	CALL SUBOPT_0x38
	__GETD2S 8
	CALL __DIVF21
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x36
	CALL __CPD02
	BRGE _0x2020030
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2020031
	CALL SUBOPT_0x50
	RCALL _yatan
	RJMP _0x20A0003
_0x2020031:
	CALL SUBOPT_0x52
	CALL __ANEGF1
	RJMP _0x20A0003
_0x2020030:
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2020032
	CALL SUBOPT_0x52
	__GETD2N 0x40490FDB
	CALL SUBOPT_0x3C
	RJMP _0x20A0003
_0x2020032:
	CALL SUBOPT_0x50
	RCALL _yatan
	__GETD2N 0xC0490FDB
	CALL __ADDF12
_0x20A0003:
	ADIW R28,12
	RET
; .FEND

	.CSEG

	.CSEG
_strcpyf:
; .FSTART _strcpyf
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
; .FEND
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
_ftoa:
; .FSTART _ftoa
	RCALL SUBOPT_0x2E
	LDI  R30,LOW(0)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x208000D
	RCALL SUBOPT_0x53
	__POINTW2FN _0x2080000,0
	CALL _strcpyf
	RJMP _0x20A0002
_0x208000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x208000C
	RCALL SUBOPT_0x53
	__POINTW2FN _0x2080000,1
	CALL _strcpyf
	RJMP _0x20A0002
_0x208000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x208000F
	__GETD1S 9
	CALL __ANEGF1
	RCALL SUBOPT_0x54
	RCALL SUBOPT_0x55
	LDI  R30,LOW(45)
	ST   X,R30
_0x208000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2080010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2080010:
	LDD  R17,Y+8
_0x2080011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2080013
	RCALL SUBOPT_0x56
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x57
	RJMP _0x2080011
_0x2080013:
	RCALL SUBOPT_0x58
	CALL __ADDF12
	RCALL SUBOPT_0x54
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	RCALL SUBOPT_0x57
_0x2080014:
	RCALL SUBOPT_0x58
	CALL __CMPF12
	BRLO _0x2080016
	RCALL SUBOPT_0x56
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x57
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2080017
	RCALL SUBOPT_0x53
	__POINTW2FN _0x2080000,5
	CALL _strcpyf
	RJMP _0x20A0002
_0x2080017:
	RJMP _0x2080014
_0x2080016:
	CPI  R17,0
	BRNE _0x2080018
	RCALL SUBOPT_0x55
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2080019
_0x2080018:
_0x208001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x208001C
	RCALL SUBOPT_0x56
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x35
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	RCALL SUBOPT_0x57
	RCALL SUBOPT_0x58
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x3A
	LDI  R31,0
	RCALL SUBOPT_0x56
	RCALL SUBOPT_0x1D
	CALL __MULF12
	RCALL SUBOPT_0x59
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x54
	RJMP _0x208001A
_0x208001C:
_0x2080019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20A0001
	RCALL SUBOPT_0x55
	LDI  R30,LOW(46)
	ST   X,R30
_0x208001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2080020
	RCALL SUBOPT_0x59
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x54
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x3A
	LDI  R31,0
	RCALL SUBOPT_0x59
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x54
	RJMP _0x208001E
_0x2080020:
_0x20A0001:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20A0002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
; .FEND

	.DSEG

	.CSEG

	.DSEG
_gx_low:
	.BYTE 0x1
_gx_high:
	.BYTE 0x1
_gy_low:
	.BYTE 0x1
_gy_high:
	.BYTE 0x1
_gz_low:
	.BYTE 0x1
_gz_high:
	.BYTE 0x1
_ax_low:
	.BYTE 0x1
_ax_high:
	.BYTE 0x1
_ay_low:
	.BYTE 0x1
_ay_high:
	.BYTE 0x1
_az_low:
	.BYTE 0x1
_az_high:
	.BYTE 0x1
_gx:
	.BYTE 0x4
_gy:
	.BYTE 0x4
_gz:
	.BYTE 0x4
_ax:
	.BYTE 0x4
_ay:
	.BYTE 0x4
_az:
	.BYTE 0x4
_angle_x:
	.BYTE 0x4
_deg_x:
	.BYTE 0x4
_angle_y:
	.BYTE 0x4
_deg_y:
	.BYTE 0x4
_dgy_x:
	.BYTE 0x4
_dgy_y:
	.BYTE 0x4
_temp_low:
	.BYTE 0x1
_temp_high:
	.BYTE 0x1
_temp:
	.BYTE 0x4
_time:
	.BYTE 0x5
_alarm:
	.BYTE 0x5
_timer:
	.BYTE 0x5
_time_loop:
	.BYTE 0x4
__seed_G104:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	__GETB1MN _time,2
	SUBI R30,-LOW(1)
	__PUTB1MN _time,2
	SUBI R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	__GETB1MN _timer,2
	SUBI R30,LOW(1)
	__PUTB1MN _timer,2
	SUBI R30,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	__GETB1MN _time,1
	SUBI R30,-LOW(1)
	__PUTB1MN _time,1
	SUBI R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	__GETB1MN _timer,1
	SUBI R30,LOW(1)
	__PUTB1MN _timer,1
	SUBI R30,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x5:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _LCD_string
	LDI  R30,LOW(16)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:78 WORDS
SUBOPT_0x6:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _LCD_string
	__GETB2MN _time,2
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _LCD_data
	__GETB2MN _time,2
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _LCD_data
	LDI  R26,LOW(58)
	CALL _LCD_data
	__GETB2MN _time,1
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _LCD_data
	__GETB2MN _time,1
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _LCD_data
	LDI  R26,LOW(58)
	CALL _LCD_data
	LDS  R26,_time
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _LCD_data
	LDS  R26,_time
	LDI  R27,0
	SBRC R26,7
	SER  R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x8:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	CALL _LCD_data
	LDI  R26,LOW(32)
	JMP  _LCD_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	CALL __CBD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _LCD_string

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xC:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _LCD_string

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0xD:
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _LCD_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xE:
	LDI  R27,0
	SBRC R26,7
	SER  R27
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF:
	CALL _LCD_data
	LDI  R26,LOW(58)
	JMP  _LCD_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	CALL __DIVW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _LCD_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x11:
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
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _I2C_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(208)
	STS  115,R30
	LDI  R30,LOW(132)
	STS  116,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	LDD  R30,Y+1
	STS  115,R30
	LDI  R30,LOW(132)
	STS  116,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	LDS  R30,113
	ANDI R30,LOW(0xF8)
	CPI  R30,LOW(0x28)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	STS  116,R30
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x17:
	LDS  R26,_deg_y
	LDS  R27,_deg_y+1
	LDS  R24,_deg_y+2
	LDS  R25,_deg_y+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	__GETD1N 0x439D8000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	RCALL SUBOPT_0x17
	__GETD1N 0x42340000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	RCALL SUBOPT_0x17
	__GETD1N 0x43070000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	RCALL SUBOPT_0x17
	__GETD1N 0x43610000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1C:
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	CALL __CWD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	LDS  R26,_temp
	LDS  R27,_temp+1
	LDS  R24,_temp+2
	LDS  R25,_temp+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x1F:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x20:
	LDS  R30,_ax
	LDS  R31,_ax+1
	LDS  R22,_ax+2
	LDS  R23,_ax+3
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x22:
	CALL _atan2
	__GETD2N 0x43340000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40490FDB
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x23:
	STS  _deg_x,R30
	STS  _deg_x+1,R31
	STS  _deg_x+2,R22
	STS  _deg_x+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	__GETD1N 0x43030000
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	__GETD1N 0x3A83126F
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	CALL __ADDF12
	__GETD2N 0x3F733333
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x27:
	LDS  R30,_deg_x
	LDS  R31,_deg_x+1
	LDS  R22,_deg_x+2
	LDS  R23,_deg_x+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	__GETD2N 0x3D4CCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x29:
	STS  _deg_y,R30
	STS  _deg_y+1,R31
	STS  _deg_y+2,R22
	STS  _deg_y+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2A:
	LDS  R30,_deg_y
	LDS  R31,_deg_y+1
	LDS  R22,_deg_y+2
	LDS  R23,_deg_y+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	__GETD2N 0x43340000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2C:
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	CALL _LCD_controller
	LDI  R26,LOW(40)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2E:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2F:
	__GETD2S 4
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x30:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x31:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x32:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x33:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x35:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x36:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x37:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x38:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3A:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	RCALL SUBOPT_0x36
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3C:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3D:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3E:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x3F:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x40:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x41:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x42:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x43:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x44:
	RCALL SUBOPT_0x3F
	RJMP SUBOPT_0x40

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x45:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x46:
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x47:
	RCALL SUBOPT_0x42
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x48:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x49:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4A:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4B:
	CALL __PUTPARD2
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4C:
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4D:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4E:
	RCALL SUBOPT_0x4D
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4F:
	CALL __MULF12
	__GETD2N 0x414A8F4E
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x50:
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x51:
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	JMP  _xatan

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x52:
	RCALL SUBOPT_0x4D
	CALL __ANEGF1
	MOVW R26,R30
	MOVW R24,R22
	JMP  _yatan

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x53:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x54:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x55:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x56:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x57:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x58:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x59:
	__GETD2S 9
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

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

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

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

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
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

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
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

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
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

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
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

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
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

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
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

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
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
