
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128
;Program type             : Application
;Clock frequency          : 14,745600 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : float, width, precision
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
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
	.DEF _rx_wr_index0=R5
	.DEF _rx_rd_index0=R4
	.DEF _rx_counter0=R7
	.DEF _counter_ms=R6
	.DEF _adc_data=R8
	.DEF _t_kuba_count=R11
	.DEF _pressureOver=R10
	.DEF _timerSignOn=R13
	.DEF _ssTrig=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  _ext_int2_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer2_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  _usart0_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  _adc_isr
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

_yesno:
	.DB  LOW(_set_off*2),HIGH(_set_off*2),LOW(_set_on*2),HIGH(_set_on*2)
_labels:
	.DB  LOW(_label_min*2),HIGH(_label_min*2),LOW(_label_grad*2),HIGH(_label_grad*2),LOW(_label_mmhb*2),HIGH(_label_mmhb*2),LOW(_label_percent*2),HIGH(_label_percent*2)
	.DB  LOW(_label_ml*2),HIGH(_label_ml*2),LOW(_label_mlph*2),HIGH(_label_mlph*2),LOW(_label_ms*2),HIGH(_label_ms*2)
_nlcd_Font:
	.DB  0x4,0x2,0xFF,0x2,0x4,0x20,0x40,0xFF
	.DB  0x40,0x20,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x5F,0x0,0x0,0x0,0x7,0x0,0x7
	.DB  0x0,0x14,0x7F,0x14,0x7F,0x14,0x24,0x2A
	.DB  0x7F,0x2A,0x12,0x23,0x13,0x8,0x64,0x62
	.DB  0x36,0x49,0x55,0x22,0x50,0x0,0x5,0x3
	.DB  0x0,0x0,0x0,0x1C,0x22,0x41,0x0,0x0
	.DB  0x41,0x22,0x1C,0x0,0x8,0x2A,0x1C,0x2A
	.DB  0x8,0x8,0x8,0x3E,0x8,0x8,0x0,0x50
	.DB  0x30,0x0,0x0,0x8,0x8,0x8,0x8,0x8
	.DB  0x0,0x30,0x30,0x0,0x0,0x20,0x10,0x8
	.DB  0x4,0x2,0x3E,0x51,0x49,0x45,0x3E,0x0
	.DB  0x42,0x7F,0x40,0x0,0x42,0x61,0x51,0x49
	.DB  0x46,0x21,0x41,0x45,0x4B,0x31,0x18,0x14
	.DB  0x12,0x7F,0x10,0x27,0x45,0x45,0x45,0x39
	.DB  0x3C,0x4A,0x49,0x49,0x30,0x1,0x71,0x9
	.DB  0x5,0x3,0x36,0x49,0x49,0x49,0x36,0x6
	.DB  0x49,0x49,0x29,0x1E,0x0,0x36,0x36,0x0
	.DB  0x0,0x0,0x56,0x36,0x0,0x0,0x0,0x8
	.DB  0x14,0x22,0x41,0x14,0x14,0x14,0x14,0x14
	.DB  0x41,0x22,0x14,0x8,0x0,0x2,0x1,0x51
	.DB  0x9,0x6,0x32,0x49,0x79,0x41,0x3E,0x7E
	.DB  0x11,0x11,0x11,0x7E,0x7F,0x49,0x49,0x49
	.DB  0x36,0x3E,0x41,0x41,0x41,0x22,0x7F,0x41
	.DB  0x41,0x22,0x1C,0x7F,0x49,0x49,0x49,0x41
	.DB  0x7F,0x9,0x9,0x1,0x1,0x3E,0x41,0x41
	.DB  0x51,0x32,0x7F,0x8,0x8,0x8,0x7F,0x0
	.DB  0x41,0x7F,0x41,0x0,0x20,0x40,0x41,0x3F
	.DB  0x1,0x7F,0x8,0x14,0x22,0x41,0x7F,0x40
	.DB  0x40,0x40,0x40,0x7F,0x2,0x4,0x2,0x7F
	.DB  0x7F,0x4,0x8,0x10,0x7F,0x3E,0x41,0x41
	.DB  0x41,0x3E,0x7F,0x9,0x9,0x9,0x6,0x3E
	.DB  0x41,0x51,0x21,0x5E,0x7F,0x9,0x19,0x29
	.DB  0x46,0x46,0x49,0x49,0x49,0x31,0x1,0x1
	.DB  0x7F,0x1,0x1,0x3F,0x40,0x40,0x40,0x3F
	.DB  0x1F,0x20,0x40,0x20,0x1F,0x7F,0x20,0x18
	.DB  0x20,0x7F,0x63,0x14,0x8,0x14,0x63,0x3
	.DB  0x4,0x78,0x4,0x3,0x61,0x51,0x49,0x45
	.DB  0x43,0x0,0x0,0x7F,0x41,0x41,0x2,0x4
	.DB  0x8,0x10,0x20,0x41,0x41,0x7F,0x0,0x0
	.DB  0x4,0x2,0x1,0x2,0x4,0x40,0x40,0x40
	.DB  0x40,0x40,0x0,0x1,0x2,0x4,0x0,0x20
	.DB  0x54,0x54,0x54,0x78,0x7F,0x48,0x44,0x44
	.DB  0x38,0x38,0x44,0x44,0x44,0x20,0x38,0x44
	.DB  0x44,0x48,0x7F,0x38,0x54,0x54,0x54,0x18
	.DB  0x8,0x7E,0x9,0x1,0x2,0x8,0x14,0x54
	.DB  0x54,0x3C,0x7F,0x8,0x4,0x4,0x78,0x0
	.DB  0x44,0x7D,0x40,0x0,0x20,0x40,0x44,0x3D
	.DB  0x0,0x0,0x7F,0x10,0x28,0x44,0x0,0x41
	.DB  0x7F,0x40,0x0,0x7C,0x4,0x18,0x4,0x78
	.DB  0x7C,0x8,0x4,0x4,0x78,0x38,0x44,0x44
	.DB  0x44,0x38,0x7C,0x14,0x14,0x14,0x8,0x8
	.DB  0x14,0x14,0x18,0x7C,0x7C,0x8,0x4,0x4
	.DB  0x8,0x48,0x54,0x54,0x54,0x20,0x4,0x3F
	.DB  0x44,0x40,0x20,0x3C,0x40,0x40,0x20,0x7C
	.DB  0x1C,0x20,0x40,0x20,0x1C,0x3C,0x40,0x30
	.DB  0x40,0x3C,0x44,0x28,0x10,0x28,0x44,0xC
	.DB  0x50,0x50,0x50,0x3C,0x44,0x64,0x54,0x4C
	.DB  0x44,0x0,0x8,0x36,0x41,0x0,0x0,0x0
	.DB  0x7F,0x0,0x0,0x0,0x41,0x36,0x8,0x0
	.DB  0x2,0x1,0x2,0x4,0x2,0x8,0x1C,0x2A
	.DB  0x8,0x8,0x7E,0x11,0x11,0x11,0x7E,0x7F
	.DB  0x49,0x49,0x49,0x33,0x7F,0x49,0x49,0x49
	.DB  0x36,0x7F,0x1,0x1,0x1,0x3,0xE0,0x51
	.DB  0x4F,0x41,0xFF,0x7F,0x49,0x49,0x49,0x49
	.DB  0x77,0x8,0x7F,0x8,0x77,0x49,0x49,0x49
	.DB  0x49,0x36,0x7F,0x10,0x8,0x4,0x7F,0x7C
	.DB  0x21,0x12,0x9,0x7C,0x7F,0x8,0x14,0x22
	.DB  0x41,0x20,0x41,0x3F,0x1,0x7F,0x7F,0x2
	.DB  0xC,0x2,0x7F,0x7F,0x8,0x8,0x8,0x7F
	.DB  0x3E,0x41,0x41,0x41,0x3E,0x7F,0x1,0x1
	.DB  0x1,0x7F,0x7F,0x9,0x9,0x9,0x6,0x3E
	.DB  0x41,0x41,0x41,0x22,0x1,0x1,0x7F,0x1
	.DB  0x1,0x27,0x48,0x48,0x48,0x3F,0x1C,0x22
	.DB  0x7F,0x22,0x1C,0x63,0x14,0x8,0x14,0x63
	.DB  0x7F,0x40,0x40,0x40,0xFF,0x7,0x8,0x8
	.DB  0x8,0x7F,0x7F,0x40,0x7F,0x40,0x7F,0x7F
	.DB  0x40,0x7F,0x40,0xFF,0x1,0x7F,0x48,0x48
	.DB  0x30,0x7F,0x48,0x30,0x0,0x7F,0x7F,0x48
	.DB  0x48,0x30,0x0,0x22,0x41,0x49,0x49,0x3E
	.DB  0x7F,0x8,0x3E,0x41,0x3E,0x46,0x29,0x19
	.DB  0x9,0x7F,0x20,0x54,0x54,0x54,0x78,0x3C
	.DB  0x4A,0x4A,0x49,0x31,0x7C,0x54,0x54,0x28
	.DB  0x0,0x7C,0x4,0x4,0x4,0xC,0xE0,0x54
	.DB  0x4C,0x44,0xFC,0x38,0x54,0x54,0x54,0x8
	.DB  0x6C,0x10,0x7C,0x10,0x6C,0x44,0x44,0x54
	.DB  0x54,0x28,0x7C,0x20,0x10,0x8,0x7C,0x78
	.DB  0x42,0x24,0x12,0x78,0x7C,0x10,0x28,0x44
	.DB  0x0,0x20,0x44,0x3C,0x4,0x7C,0x7C,0x8
	.DB  0x10,0x8,0x7C,0x7C,0x10,0x10,0x10,0x7C
	.DB  0x38,0x44,0x44,0x44,0x38,0x7C,0x4,0x4
	.DB  0x4,0x7C,0x7C,0x14,0x14,0x14,0x8,0x38
	.DB  0x44,0x44,0x44,0x44,0x4,0x4,0x7C,0x4
	.DB  0x4,0xC,0x50,0x50,0x50,0x3C,0x18,0x24
	.DB  0x7E,0x24,0x18,0x44,0x28,0x10,0x28,0x44
	.DB  0x7C,0x40,0x40,0x40,0xFC,0xC,0x10,0x10
	.DB  0x10,0x7C,0x7C,0x40,0x7C,0x40,0x7C,0x7C
	.DB  0x40,0x7C,0x40,0xFC,0x4,0x7C,0x50,0x50
	.DB  0x20,0x7C,0x50,0x20,0x0,0x7C,0x7C,0x50
	.DB  0x50,0x20,0x0,0x28,0x44,0x54,0x54,0x38
	.DB  0x7C,0x10,0x38,0x44,0x38,0x8,0x54,0x34
	.DB  0x14,0x7C
_valve_cls_lbs:
	.DB  0xC7,0x0
_valve_reg_lbs:
	.DB  0xD0,0x0
_valve_opn_lbs:
	.DB  0xCE,0x0
_valve_lbs:
	.DB  LOW(_valve_cls_lbs*2),HIGH(_valve_cls_lbs*2),LOW(_valve_reg_lbs*2),HIGH(_valve_reg_lbs*2),LOW(_valve_opn_lbs*2),HIGH(_valve_opn_lbs*2)
_distilation:
	.DB  0xC4,0xE8,0xF1,0xF2,0xE8,0xEB,0xFF,0xF6
	.DB  0xE8,0xFF,0x0
_rectification:
	.DB  0xD0,0xE5,0xEA,0xF2,0xE8,0xF4,0xE8,0xEA
	.DB  0xE0,0xF6,0xE8,0xFF,0x0
_settings:
	.DB  0xCF,0xE0,0xF0,0xE0,0xEC,0xE5,0xF2,0xF0
	.DB  0xFB,0x0
_set_dist:
	.DB  0xC4,0xE8,0xF1,0xF2,0xE8,0xEB,0xFF,0xF6
	.DB  0xE8,0xE8,0x0
_set_rectif:
	.DB  0xD0,0xE5,0xEA,0xF2,0xE8,0xF4,0xE8,0xEA
	.DB  0xE0,0xF6,0xE8,0xE8,0x0
_set_temp_sensors:
	.DB  0xC4,0xE0,0xF2,0xF7,0xE8,0xEA,0xEE,0xE2
	.DB  0x20,0xF2,0xE5,0xEC,0xEF,0x0
_set_calibrate_vlv:
	.DB  0xCA,0xE0,0xEB,0xE8,0xE1,0xF0,0xEE,0xE2
	.DB  0xEA,0xE0,0x20,0xEA,0xEB,0x2E,0x0
_set_dis_t:
	.DB  0x74,0x20,0xEA,0xF3,0xE1,0xE0,0x20,0xEE
	.DB  0xF2,0xEA,0xEB,0x2E,0x0
_set_dis_pten:
	.DB  0xD0,0xF2,0xFD,0xED,0x20,0xED,0xE0,0xF7
	.DB  0xE0,0xEB,0xFC,0xED,0xE0,0xFF,0x0
_set_rect_pten_min:
	.DB  0xD0,0xF2,0xFD,0xED,0x20,0xEC,0xE8,0xED
	.DB  0x20,0x74,0x3E,0x36,0x30,0x0
_set_rect_Pkol_max:
	.DB  0x50,0x20,0xEA,0xEE,0xEB,0xEE,0xED,0xFB
	.DB  0x20,0xEC,0xE0,0xEA,0xF1,0x0
_set_rect_t_otbor:
	.DB  0x74,0x20,0xEE,0xF2,0xE1,0xEE,0xF0,0xE0
	.DB  0x0
_set_rect_dt_otbor:
	.DB  0x64,0x74,0x20,0xEE,0xF2,0xE1,0xEE,0xF0
	.DB  0xE0,0x0
_set_rect_T1_valve:
	.DB  0x54,0x31,0x20,0xE7,0xE0,0xE4,0x2E,0x20
	.DB  0xEA,0xEB,0xE0,0xEF,0x2E,0x0
_set_rect_T2_valve:
	.DB  0x54,0x32,0x20,0xE7,0xE0,0xE4,0x2E,0x20
	.DB  0xEA,0xEB,0xE0,0xEF,0x2E,0x0
_set_rect_t_kuba_v:
	.DB  0x74,0x20,0xEA,0xF3,0xE1,0xE0,0x20,0xE7
	.DB  0xE0,0xE4,0x2E,0x20,0xEA,0xEB,0x0
_set_rect_t_kuba_off:
	.DB  0x74,0x20,0xEA,0xF3,0xE1,0xE0,0x20,0xEE
	.DB  0xF2,0xEA,0xEB,0x2E,0x0
_set_rect_head_val:
	.DB  0xCE,0xE1,0xFA,0xE5,0xEC,0x20,0xE3,0xEE
	.DB  0xEB,0xEE,0xE2,0x0
_set_rect_body_spd:
	.DB  0xD1,0xEA,0xEE,0xF0,0xEE,0xF1,0xF2,0xFC
	.DB  0x20,0xEE,0xF2,0xE1,0x2E,0x0
_set_rect_pulse_d:
	.DB  0xC4,0xEB,0xE8,0xF2,0x2E,0x20,0xE8,0xEC
	.DB  0xEF,0xF3,0xEB,0xFC,0xF1,0xE0,0x0
_set_rect_fact_q:
	.DB  0xD4,0xE0,0xEA,0xF2,0x20,0xEE,0xE1,0xFA
	.DB  0xE5,0xEC,0x20,0xEE,0xF2,0xE1,0x0
_set_rect_k_factor:
	.DB  0xCA,0xEE,0xFD,0xF4,0xF4,0x2E,0x20,0xF0
	.DB  0xE0,0xF1,0xF5,0xEE,0xE4,0xE0,0x0
_set_sens_tkub:
	.DB  0xD2,0x20,0xEA,0xF3,0xE1,0xE0,0x0
_set_sens_tkolona_down:
	.DB  0xD2,0x20,0xEA,0xEE,0xEB,0xEE,0xED,0xFB
	.DB  0x20,0xED,0xE8,0xE7,0x0
_set_sens_tkolona_up:
	.DB  0xD2,0x20,0xEA,0xEE,0xEB,0xEE,0xED,0xFB
	.DB  0x20,0xE2,0xE5,0xF0,0xF5,0x0
_set_on:
	.DB  0xC2,0xEA,0xEB,0x2E,0x0
_set_off:
	.DB  0xC2,0xFB,0xEA,0xEB,0x2E,0x0
_label_grad:
	.DB  0xD1,0x0
_label_min:
	.DB  0xEC,0xE8,0xED,0x0
_label_mmhb:
	.DB  0xEC,0xEC,0x2E,0xF0,0xF2,0x2E,0xF1,0xF2
	.DB  0x0
_label_percent:
	.DB  0x25,0x0
_label_ml:
	.DB  0xEC,0xEB,0x2E,0x0
_label_mlph:
	.DB  0xEC,0xEB,0x2E,0x2F,0xF7,0x0
_label_ms:
	.DB  0x2A,0x31,0x30,0x20,0xEC,0xF1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x25:
	.DB  0x4
_0x26:
	.DB  0x90,0x1
_0x32:
	.DB  0x0
_0x0:
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x0,0x20,0x4E,0x69,0x6B,0x6F,0x70,0x6F
	.DB  0x6C,0x0,0x20,0x20,0x20,0x20,0x70,0x72
	.DB  0x65,0x73,0x65,0x6E,0x74,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x20,0x20,0x20,0x2D,0x3C
	.DB  0xD1,0xCF,0xC8,0xD0,0xD2,0x3E,0x2D,0x20
	.DB  0x20,0x20,0x20,0x0,0x20,0x20,0x20,0xEA
	.DB  0xEE,0xED,0xF2,0xF0,0xEE,0xEB,0xEB,0xE5
	.DB  0xF0,0x20,0x20,0x20,0x0,0x20,0x68,0x77
	.DB  0x20,0x76,0x2E,0x31,0x2E,0x31,0x64,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x20,0x73
	.DB  0x77,0x20,0x76,0x2E,0x30,0x2E,0x33,0x32
	.DB  0x2E,0x66,0x20,0x75,0x6E,0x69,0x0,0x20
	.DB  0xC8,0xED,0xE8,0xF6,0xE8,0xE0,0xEB,0xE8
	.DB  0xE7,0xE0,0xF6,0xE8,0xFF,0x20,0x20,0x0
	.DB  0x20,0x20,0xE4,0xE0,0xF2,0xF7,0xE8,0xEA
	.DB  0xEE,0xE2,0x20,0xD2,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0xCD,0xE0,0xE9
	.DB  0xE4,0xE5,0xED,0xEE,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x25,0x69,0x20,0xF8,0xF2,0x0
_0x6000A:
	.DB  LOW(_HandlerEventButUp),HIGH(_HandlerEventButUp),LOW(_HandlerEventButDown),HIGH(_HandlerEventButDown),LOW(_HandlerEventButEnter),HIGH(_HandlerEventButEnter),LOW(_HandlerEventButEsc),HIGH(_HandlerEventButEsc)
	.DB  LOW(_HandlerEventTimer_1s),HIGH(_HandlerEventTimer_1s),LOW(_HandlerEventTimer_250ms),HIGH(_HandlerEventTimer_250ms),LOW(_HandlerEventTimer_10ms),HIGH(_HandlerEventTimer_10ms),LOW(_HandlerEventButLUp),HIGH(_HandlerEventButLUp)
	.DB  LOW(_HandlerEventButLDown),HIGH(_HandlerEventButLDown),LOW(_HandlerEventTimer_10s),HIGH(_HandlerEventTimer_10s),LOW(_HandlerEventTimer_1Hz),HIGH(_HandlerEventTimer_1Hz)
_0x80003:
	.DB  0x1
_0x80117:
	.DB  0x0,0x0,0x0,0x0
_0x80000:
	.DB  0xCD,0xE5,0xF2,0x20,0xED,0xE0,0xE7,0xED
	.DB  0xE0,0xF7,0xE5,0xED,0xED,0xFB,0xF5,0x0
	.DB  0x20,0x20,0x20,0xE4,0xE0,0xF2,0xF7,0xE8
	.DB  0xEA,0xEE,0xE2,0x20,0x20,0x20,0x20,0x0
	.DB  0x20,0x20,0x20,0x20,0x74,0x20,0xEA,0xF3
	.DB  0xE1,0xE0,0x21,0x20,0x20,0x20,0x20,0x0
	.DB  0x74,0x20,0xEA,0xEE,0xEB,0xEE,0xED,0xFB
	.DB  0x20,0xE2,0xE5,0xF0,0xF5,0x21,0x20,0x0
	.DB  0x20,0xCF,0xEE,0xE4,0xEA,0xEB,0xFE,0xF7
	.DB  0xE5,0xED,0xFB,0x20,0xED,0xE5,0x20,0x0
	.DB  0x20,0x20,0xE2,0xF1,0xE5,0x20,0xE4,0xE0
	.DB  0xF2,0xF7,0xE8,0xEA,0xE8,0x20,0x20,0x0
	.DB  0x20,0xE8,0xEB,0xE8,0x20,0xEE,0xF2,0xEA
	.DB  0xEB,0xFE,0xF7,0xE5,0xED,0xFB,0x20,0x0
	.DB  0x20,0xEF,0xEE,0xEB,0xED,0xEE,0xF1,0xF2
	.DB  0xFC,0xFE,0x20,0xE2,0xF1,0xE5,0x21,0x0
	.DB  0x20,0x20,0x20,0xCD,0xE5,0x20,0xE2,0xE5
	.DB  0xF0,0xED,0xFB,0xE9,0x20,0x20,0x20,0x0
	.DB  0x20,0x20,0x20,0x20,0xE4,0xE0,0xF2,0xF7
	.DB  0xE8,0xEA,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x20,0x20,0x20,0x20,0xCD,0xE5,0x20,0xE2
	.DB  0xE5,0xF0,0xED,0xFB,0xE9,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0xE4,0xE0
	.DB  0xF2,0xF7,0xE8,0xEA,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x74,0x20,0xEA,0xEE,0xEB
	.DB  0xEE,0xED,0xFB,0x20,0xE2,0xE5,0xF0,0xF5
	.DB  0x21,0x20,0x0,0x20,0x20,0x20,0xC4,0xE8
	.DB  0xF1,0xF2,0xE8,0xEB,0xFF,0xF6,0xE8,0xFF
	.DB  0x20,0x20,0x20,0x0,0xCF,0xF0,0xE5,0xF0
	.DB  0xE2,0xE0,0xF2,0xFC,0x0,0xEF,0xF0,0xEE
	.DB  0xF6,0xE5,0xF1,0xF1,0x3F,0x0,0x3C,0x45
	.DB  0x4E,0x54,0x3E,0xC4,0xE0,0x20,0x3C,0x45
	.DB  0x53,0x43,0x3E,0xCD,0xE5,0xF2,0x0,0xC4
	.DB  0xE8,0xF1,0xF2,0xE8,0xEB,0xEB,0xFF,0xF6
	.DB  0xE8,0xFF,0x0,0xC2,0xF0,0xE5,0xEC,0xFF
	.DB  0x3A,0x25,0x32,0x69,0x3A,0x25,0x32,0x69
	.DB  0x3A,0x25,0x32,0x69,0x0,0x74,0xEA,0xEE
	.DB  0xEB,0x20,0xE2,0x20,0x25,0x2D,0x33,0x2E
	.DB  0x32,0x66,0x20,0x25,0x73,0x0,0x74,0xEA
	.DB  0xF3,0xE1,0xE0,0x20,0x20,0x25,0x2D,0x33
	.DB  0x2E,0x32,0x66,0x20,0x25,0x73,0x0,0x25
	.DB  0x63,0xCA,0xEB,0x2D,0x25,0x73,0x20,0x25
	.DB  0x63,0x25,0x34,0x2E,0x30,0x66,0x20,0xEC
	.DB  0xEB,0x2F,0xF7,0x0,0x25,0x63,0xD2,0xDD
	.DB  0xCD,0x20,0x25,0x33,0x69,0x25,0x25,0x0
	.DB  0x20,0x74,0x20,0xEA,0xEE,0xEB,0xEE,0xED
	.DB  0xFB,0x20,0xED,0xE8,0xE7,0x21,0x20,0x0
	.DB  0xD0,0xE5,0xEA,0xF2,0xE8,0xF4,0xE8,0xEA
	.DB  0xE0,0xF6,0xE8,0xFF,0x0,0x20,0xD0,0xE5
	.DB  0xEA,0xF2,0xE8,0xF4,0xE8,0xEA,0xE0,0xF6
	.DB  0xE8,0xFF,0x0,0x74,0xEA,0xEE,0xEB,0x20
	.DB  0xED,0x20,0x25,0x2D,0x33,0x2E,0x32,0x66
	.DB  0x20,0x25,0x73,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0xD2,0xDD,0xCD
	.DB  0x25,0x33,0x69,0x25,0x25,0x0,0xD1,0x5C
	.DB  0xD1,0x20,0x25,0x73,0x20,0xCA,0x20,0x25
	.DB  0x69,0x0,0x56,0xF2,0x20,0x25,0x34,0x2E
	.DB  0x30,0x66,0x20,0xEC,0xEB,0x2F,0xF7,0x0
	.DB  0x51,0xE3,0x20,0x25,0x34,0x2E,0x32,0x66
	.DB  0x20,0xEC,0xEB,0x0,0x20,0x20,0x20,0xC4
	.DB  0xE8,0xF1,0xF2,0xE8,0xEB,0xEB,0xFF,0xF6
	.DB  0xE8,0xFF,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0xD0,0xE5,0xEA,0xF2,0xE8,0xF4,0xE8,0xEA
	.DB  0xE0,0xF6,0xE8,0xFF,0x20,0x20,0x0,0xCF
	.DB  0xF0,0xEE,0xF6,0xE5,0xF1,0xF1,0x0,0xEE
	.DB  0xEA,0xEE,0xED,0xF7,0xE5,0xED,0x21,0x0
	.DB  0xCA,0xE0,0xEB,0xE8,0xE1,0xF0,0xEE,0xE2
	.DB  0xEA,0xE0,0x0,0xCE,0xF2,0xE4,0xEE,0xE7
	.DB  0xE8,0xF0,0xEE,0xE2,0xE0,0xED,0xED,0xEE
	.DB  0x3A,0x20,0x0,0x51,0x20,0x25,0x34,0x2E
	.DB  0x32,0x66,0x20,0xEC,0xEB,0x0,0x6B,0x20
	.DB  0x25,0x31,0x2E,0x34,0x66,0x20,0xEC,0xEB
	.DB  0x0,0x69,0x20,0x25,0x69,0x20,0xE8,0xEC
	.DB  0xEF,0x2E,0x0
_0xA0003:
	.DB  LOW(_distilation*2),HIGH(_distilation*2),LOW(_RunDistilation),HIGH(_RunDistilation),0x0,0x0,0x0,LOW(_rectification*2)
	.DB  HIGH(_rectification*2),LOW(_RunRectification),HIGH(_RunRectification),0x0,0x0,0x0,LOW(_settings*2),HIGH(_settings*2)
	.DB  LOW(_goto_menu),HIGH(_goto_menu),0x3
_0xA0004:
	.DB  LOW(_set_dist*2),HIGH(_set_dist*2),LOW(_goto_menu),HIGH(_goto_menu),0x1,0x0,0x2,LOW(_set_rectif*2)
	.DB  HIGH(_set_rectif*2),LOW(_goto_menu),HIGH(_goto_menu),0x2,0x0,0x2,LOW(_set_temp_sensors*2),HIGH(_set_temp_sensors*2)
	.DB  LOW(_goto_menu),HIGH(_goto_menu),0x4,0x0,0x2,LOW(_set_calibrate_vlv*2),HIGH(_set_calibrate_vlv*2),LOW(_CalibrateValve)
	.DB  HIGH(_CalibrateValve),0x0,0x0,0x2
_0xA0005:
	.DB  LOW(_set_dis_t*2),HIGH(_set_dis_t*2),LOW(_SetParam),HIGH(_SetParam),0x0,0x3,0x0,LOW(_set_dis_pten*2)
	.DB  HIGH(_set_dis_pten*2),LOW(_SetParam),HIGH(_SetParam),0x0,0x3
_0xA0006:
	.DB  LOW(_set_rect_pten_min*2),HIGH(_set_rect_pten_min*2),LOW(_SetParam),HIGH(_SetParam),0x0,0x3,0x1,LOW(_set_rect_Pkol_max*2)
	.DB  HIGH(_set_rect_Pkol_max*2),LOW(_SetParam),HIGH(_SetParam),0x0,0x3,0x1,LOW(_set_rect_t_otbor*2),HIGH(_set_rect_t_otbor*2)
	.DB  LOW(_SetParam),HIGH(_SetParam),0x0,0x3,0x1,LOW(_set_rect_dt_otbor*2),HIGH(_set_rect_dt_otbor*2),LOW(_SetParam)
	.DB  HIGH(_SetParam),0x0,0x3,0x1,LOW(_set_rect_T1_valve*2),HIGH(_set_rect_T1_valve*2),LOW(_SetParam),HIGH(_SetParam)
	.DB  0x0,0x3,0x1,LOW(_set_rect_T2_valve*2),HIGH(_set_rect_T2_valve*2),LOW(_SetParam),HIGH(_SetParam),0x0
	.DB  0x3,0x1,LOW(_set_rect_t_kuba_v*2),HIGH(_set_rect_t_kuba_v*2),LOW(_SetParam),HIGH(_SetParam),0x0,0x3
	.DB  0x1,LOW(_set_rect_t_kuba_off*2),HIGH(_set_rect_t_kuba_off*2),LOW(_SetParam),HIGH(_SetParam),0x0,0x3,0x1
	.DB  LOW(_set_rect_head_val*2),HIGH(_set_rect_head_val*2),LOW(_SetParam),HIGH(_SetParam),0x0,0x3,0x1,LOW(_set_rect_body_spd*2)
	.DB  HIGH(_set_rect_body_spd*2),LOW(_SetParam),HIGH(_SetParam),0x0,0x3,0x1,LOW(_set_rect_pulse_d*2),HIGH(_set_rect_pulse_d*2)
	.DB  LOW(_SetParam),HIGH(_SetParam),0x0,0x3,0x1,LOW(_set_rect_fact_q*2),HIGH(_set_rect_fact_q*2),LOW(_SetParam)
	.DB  HIGH(_SetParam),0x0,0x3,0x1,LOW(_set_rect_k_factor*2),HIGH(_set_rect_k_factor*2),LOW(_SetParam),HIGH(_SetParam)
	.DB  0x0,0x3,0x1
_0xA0007:
	.DB  LOW(_set_sens_tkub*2),HIGH(_set_sens_tkub*2),LOW(_InitSensors),HIGH(_InitSensors),0x0,0x3,0x2,LOW(_set_sens_tkolona_down*2)
	.DB  HIGH(_set_sens_tkolona_down*2),LOW(_InitSensors),HIGH(_InitSensors),0x0,0x3,0x2,LOW(_set_sens_tkolona_up*2),HIGH(_set_sens_tkolona_up*2)
	.DB  LOW(_InitSensors),HIGH(_InitSensors),0x0,0x3,0x2
_0xA0008:
	.DB  0x0,0x3,LOW(_menu__G005),HIGH(_menu__G005),0x1,0x2,LOW(_menu_set_dist_G005),HIGH(_menu_set_dist_G005)
	.DB  0x2,0xD,LOW(_menu_set_rect_G005),HIGH(_menu_set_rect_G005),0x3,0x4,LOW(_menu_settings_G005),HIGH(_menu_settings_G005)
	.DB  0x4,0x3,LOW(_menu_set_init_G005),HIGH(_menu_set_init_G005)
_0xA0000:
	.DB  0x2D,0x25,0x73,0x2D,0x0,0x2D,0x3D,0xCC
	.DB  0xE5,0xED,0xFE,0x3D,0x2D,0x0,0x5B,0x25
	.DB  0x73,0x5D,0x0,0x25,0x73,0x0
_0xC0000:
	.DB  0x2D,0x25,0x73,0x2D,0x0,0x2A,0x25,0x73
	.DB  0x2A,0x0,0x25,0x31,0x2E,0x34,0x66,0x20
	.DB  0x25,0x73,0x0,0x25,0x33,0x2E,0x32,0x66
	.DB  0x20,0x25,0x73,0x0,0x25,0x75,0x20,0x25
	.DB  0x73,0x0,0x3C,0x25,0x73,0x3E,0x0,0xC8
	.DB  0xED,0xE8,0xF6,0xE8,0xE0,0xEB,0xE8,0xE7
	.DB  0xE0,0xF6,0xE8,0xFF,0x0,0xCF,0xEE,0xE4
	.DB  0xEA,0xEB,0xFE,0xF7,0xE8,0xF2,0xE5,0x20
	.DB  0xEE,0xE4,0xE8,0xED,0x0,0xE4,0xE0,0xF2
	.DB  0xF7,0xE8,0xEA,0x20,0x21,0x21,0x21,0x0
	.DB  0xED,0xE0,0xE6,0xEC,0xE8,0xF2,0xE5,0x20
	.DB  0x3C,0x45,0x4E,0x54,0x3E,0x0,0x49,0x44
	.DB  0x3A,0x25,0x32,0x58,0x25,0x32,0x58,0x0
	.DB  0x20,0xC8,0xED,0xE8,0xF6,0xE8,0xE0,0xEB
	.DB  0xE8,0xE7,0xE0,0xF6,0xE8,0xFF,0x20,0x0
	.DB  0x20,0xEF,0xF0,0xEE,0xF8,0xEB,0xE0,0x0
	.DB  0x20,0xF3,0xF1,0xEF,0xE5,0xF8,0xED,0xEE
	.DB  0x21,0x0,0x20,0xED,0xE5,0x20,0xEF,0xF0
	.DB  0xEE,0xF8,0xEB,0xE0,0x2E,0x20,0xC4,0xEB
	.DB  0xFF,0x0,0xEF,0xEE,0xE2,0xF2,0xEE,0xF0
	.DB  0xE0,0x20,0xED,0xE0,0xE6,0xEC,0xE8,0xF2
	.DB  0xE5,0x0,0x3C,0x45,0x4E,0x54,0x3E,0x2E
	.DB  0x20,0x3C,0x45,0x53,0x43,0x3E,0x0,0xE4
	.DB  0xEB,0xFF,0x20,0xE2,0xFB,0xF5,0xEE,0xE4
	.DB  0xE0,0x2E,0x0,0x20,0x20,0x20,0xCA,0xE0
	.DB  0xEB,0xE8,0xE1,0xF0,0xEE,0xE2,0xEA,0xE0
	.DB  0x20,0x20,0x20,0x0,0x20,0xE4,0xEE,0xE7
	.DB  0xE8,0xF0,0x2E,0x20,0xEA,0xEB,0xE0,0xEF
	.DB  0xE0,0xED,0xE0,0x20,0x0,0x20,0x20,0xCE
	.DB  0xF2,0xE1,0xEE,0xF0,0x20,0x35,0x30,0x20
	.DB  0xEC,0xEB,0x2E,0x20,0x20,0x0,0x20,0x20
	.DB  0x20,0xC4,0xEB,0xFF,0x20,0xED,0xE0,0xF7
	.DB  0xE0,0xEB,0xE0,0x20,0x20,0x20,0x0,0x20
	.DB  0xED,0xE0,0xE6,0xEC,0xE8,0xF2,0xE5,0x20
	.DB  0x3C,0x45,0x4E,0x54,0x3E,0x20,0x20,0x0
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x01
	.DW  _valvePulse
	.DW  _0x25*2

	.DW  0x02
	.DW  _pwmPeriod
	.DW  _0x26*2

	.DW  0x11
	.DW  _0x27
	.DW  _0x0*2

	.DW  0x09
	.DW  _0x27+17
	.DW  _0x0*2+17

	.DW  0x11
	.DW  _0x27+26
	.DW  _0x0*2+26

	.DW  0x11
	.DW  _0x27+43
	.DW  _0x0*2+43

	.DW  0x11
	.DW  _0x27+60
	.DW  _0x0*2+60

	.DW  0x11
	.DW  _0x27+77
	.DW  _0x0*2+77

	.DW  0x11
	.DW  _0x27+94
	.DW  _0x0*2+94

	.DW  0x11
	.DW  _0x27+111
	.DW  _0x0*2+111

	.DW  0x11
	.DW  _0x27+128
	.DW  _0x0*2+128

	.DW  0x11
	.DW  _0x27+145
	.DW  _0x0*2+145

	.DW  0x01
	.DW  0x06
	.DW  _0x32*2

	.DW  0x16
	.DW  _FuncAr
	.DW  _0x6000A*2

	.DW  0x01
	.DW  _mode
	.DW  _0x80003*2

	.DW  0x10
	.DW  _0x80007
	.DW  _0x80000*2

	.DW  0x10
	.DW  _0x80007+16
	.DW  _0x80000*2+16

	.DW  0x10
	.DW  _0x80007+32
	.DW  _0x80000*2+32

	.DW  0x10
	.DW  _0x80007+48
	.DW  _0x80000*2

	.DW  0x10
	.DW  _0x80007+64
	.DW  _0x80000*2+16

	.DW  0x10
	.DW  _0x80007+80
	.DW  _0x80000*2+48

	.DW  0x10
	.DW  _0x80007+96
	.DW  _0x80000*2+64

	.DW  0x10
	.DW  _0x80007+112
	.DW  _0x80000*2+80

	.DW  0x10
	.DW  _0x80007+128
	.DW  _0x80000*2+96

	.DW  0x10
	.DW  _0x80007+144
	.DW  _0x80000*2+112

	.DW  0x10
	.DW  _0x80007+160
	.DW  _0x80000*2+128

	.DW  0x10
	.DW  _0x80007+176
	.DW  _0x80000*2+144

	.DW  0x10
	.DW  _0x80007+192
	.DW  _0x80000*2+32

	.DW  0x11
	.DW  _0x80007+208
	.DW  _0x80000*2+160

	.DW  0x11
	.DW  _0x80007+225
	.DW  _0x80000*2+177

	.DW  0x11
	.DW  _0x80007+242
	.DW  _0x80000*2+194

	.DW  0x11
	.DW  _0x8000F
	.DW  _0x80000*2+211

	.DW  0x09
	.DW  _0x8000F+17
	.DW  _0x80000*2+228

	.DW  0x09
	.DW  _0x8000F+26
	.DW  _0x80000*2+237

	.DW  0x11
	.DW  _0x8000F+35
	.DW  _0x80000*2+246

	.DW  0x0C
	.DW  _0x8000F+52
	.DW  _0x80000*2+263

	.DW  0x10
	.DW  _0x80025
	.DW  _0x80000*2

	.DW  0x10
	.DW  _0x80025+16
	.DW  _0x80000*2+16

	.DW  0x10
	.DW  _0x80025+32
	.DW  _0x80000*2+32

	.DW  0x10
	.DW  _0x80025+48
	.DW  _0x80000*2

	.DW  0x10
	.DW  _0x80025+64
	.DW  _0x80000*2+16

	.DW  0x10
	.DW  _0x80025+80
	.DW  _0x80000*2+360

	.DW  0x10
	.DW  _0x80025+96
	.DW  _0x80000*2

	.DW  0x10
	.DW  _0x80025+112
	.DW  _0x80000*2+16

	.DW  0x10
	.DW  _0x80025+128
	.DW  _0x80000*2+48

	.DW  0x10
	.DW  _0x80025+144
	.DW  _0x80000*2+64

	.DW  0x10
	.DW  _0x80025+160
	.DW  _0x80000*2+80

	.DW  0x10
	.DW  _0x80025+176
	.DW  _0x80000*2+96

	.DW  0x10
	.DW  _0x80025+192
	.DW  _0x80000*2+112

	.DW  0x10
	.DW  _0x80025+208
	.DW  _0x80000*2+128

	.DW  0x10
	.DW  _0x80025+224
	.DW  _0x80000*2+144

	.DW  0x10
	.DW  _0x80025+240
	.DW  _0x80000*2+32

	.DW  0x11
	.DW  _0x80025+256
	.DW  _0x80000*2+160

	.DW  0x11
	.DW  _0x80025+273
	.DW  _0x80000*2+177

	.DW  0x11
	.DW  _0x80025+290
	.DW  _0x80000*2+194

	.DW  0x10
	.DW  _0x80025+307
	.DW  _0x80000*2+128

	.DW  0x10
	.DW  _0x80025+323
	.DW  _0x80000*2+144

	.DW  0x10
	.DW  _0x80025+339
	.DW  _0x80000*2+360

	.DW  0x0D
	.DW  _0x80031
	.DW  _0x80000*2+376

	.DW  0x09
	.DW  _0x80031+13
	.DW  _0x80000*2+228

	.DW  0x09
	.DW  _0x80031+22
	.DW  _0x80000*2+237

	.DW  0x11
	.DW  _0x80031+31
	.DW  _0x80000*2+246

	.DW  0x0E
	.DW  _0x80031+48
	.DW  _0x80000*2+389

	.DW  0x11
	.DW  _0x80031+62
	.DW  _0x80000*2+420

	.DW  0x12
	.DW  _0x80044
	.DW  _0x80000*2+484

	.DW  0x11
	.DW  _0x80044+18
	.DW  _0x80000*2+502

	.DW  0x08
	.DW  _0x80044+35
	.DW  _0x80000*2+519

	.DW  0x09
	.DW  _0x80044+43
	.DW  _0x80000*2+527

	.DW  0x0B
	.DW  _0x80047
	.DW  _0x80000*2+536

	.DW  0x09
	.DW  _0x80047+11
	.DW  _0x80000*2+228

	.DW  0x09
	.DW  _0x80047+20
	.DW  _0x80000*2+237

	.DW  0x11
	.DW  _0x80047+29
	.DW  _0x80000*2+246

	.DW  0x0B
	.DW  _0x80047+46
	.DW  _0x80000*2+536

	.DW  0x10
	.DW  _0x80047+57
	.DW  _0x80000*2+547

	.DW  0x04
	.DW  0x0A
	.DW  _0x80117*2

	.DW  0x13
	.DW  _menu__G005
	.DW  _0xA0003*2

	.DW  0x1C
	.DW  _menu_settings_G005
	.DW  _0xA0004*2

	.DW  0x0D
	.DW  _menu_set_dist_G005
	.DW  _0xA0005*2

	.DW  0x5B
	.DW  _menu_set_rect_G005
	.DW  _0xA0006*2

	.DW  0x15
	.DW  _menu_set_init_G005
	.DW  _0xA0007*2

	.DW  0x14
	.DW  _menu
	.DW  _0xA0008*2

	.DW  0x0E
	.DW  _0xC001F
	.DW  _0xC0000*2+39

	.DW  0x10
	.DW  _0xC001F+14
	.DW  _0xC0000*2+53

	.DW  0x0B
	.DW  _0xC001F+30
	.DW  _0xC0000*2+69

	.DW  0x0E
	.DW  _0xC001F+41
	.DW  _0xC0000*2+80

	.DW  0x10
	.DW  _0xC0024
	.DW  _0xC0000*2+104

	.DW  0x08
	.DW  _0xC0024+16
	.DW  _0xC0000*2+120

	.DW  0x0A
	.DW  _0xC0024+24
	.DW  _0xC0000*2+128

	.DW  0x10
	.DW  _0xC0024+34
	.DW  _0xC0000*2+104

	.DW  0x10
	.DW  _0xC0024+50
	.DW  _0xC0000*2+138

	.DW  0x10
	.DW  _0xC0024+66
	.DW  _0xC0000*2+154

	.DW  0x0D
	.DW  _0xC0024+82
	.DW  _0xC0000*2+170

	.DW  0x0C
	.DW  _0xC0024+95
	.DW  _0xC0000*2+183

	.DW  0x11
	.DW  _0xC0026
	.DW  _0xC0000*2+195

	.DW  0x11
	.DW  _0xC0026+17
	.DW  _0xC0000*2+212

	.DW  0x11
	.DW  _0xC0026+34
	.DW  _0xC0000*2+229

	.DW  0x11
	.DW  _0xC0026+51
	.DW  _0xC0000*2+246

	.DW  0x11
	.DW  _0xC0026+68
	.DW  _0xC0000*2+263

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

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
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

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
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.3 Standard
;Automatic Program Generator
;© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 06.03.2015
;Author  : PerTic@n
;Company : If You Like This Software,Buy It
;Comments:
;
;
;Chip type               : ATmega128
;Program type            : Application
;AVR Core Clock frequency: 14,745600 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 1024
;*****************************************************/
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
;#include <nokia1100_lcd_lib.h>
;#include <circlebuffer.h>
;#include <handlers.h>
;#include <buttons.h>
;#include <general.h>
;#include <hwinit.h>
;#include <settings.h>
;#include <menu.h>
;
;#include <OWIPolled.h>
;#include <OWIHighLevelFunctions.h>
;#include <OWIBitFunctions.h>
;#include <OWIcrc.h>
;
;unsigned char ds1820_devices;
;OWI_device ds1820_rom_codes[MAX_DS1820];
;OWI_device t_rom_codes[MAX_DS1820];
;
;// External Interrupt 2 service routine
;interrupt [EXT_INT2] void ext_int2_isr(void)
; 0000 002D {

	.CSEG
_ext_int2_isr:
	CALL SUBOPT_0x0
; 0000 002E // Place your code here
; 0000 002F static  char halph_wave_counter = 0, halph_wave_counter3 = 0;
; 0000 0030 static  unsigned int halph_wave_counter2 = 0;
; 0000 0031 
; 0000 0032 if (++halph_wave_counter3 >= 99) { //100
	LDS  R26,_halph_wave_counter3_S0000000000
	SUBI R26,-LOW(1)
	STS  _halph_wave_counter3_S0000000000,R26
	CPI  R26,LOW(0x63)
	BRLO _0x3
; 0000 0033     ES_PlaceHeadEvent(EVENT_TIMER_1Hz);
	LDI  R26,LOW(11)
	CALL _ES_PlaceHeadEvent
; 0000 0034     halph_wave_counter3 = 0;
	LDI  R30,LOW(0)
	STS  _halph_wave_counter3_S0000000000,R30
; 0000 0035 }
; 0000 0036 
; 0000 0037  if (heater_power == 100) {
_0x3:
	LDS  R26,_heater_power
	CPI  R26,LOW(0x64)
	BRNE _0x4
; 0000 0038     HEATER_ON;
	SBI  0x1B,2
; 0000 0039     halph_wave_counter = 0;
	RJMP _0x2F
; 0000 003A  } else if (heater_power > 0) {
_0x4:
	LDS  R26,_heater_power
	CPI  R26,LOW(0x1)
	BRLO _0x6
; 0000 003B 
; 0000 003C     if (++halph_wave_counter >= heater_power) {
	LDS  R26,_halph_wave_counter_S0000000000
	SUBI R26,-LOW(1)
	STS  _halph_wave_counter_S0000000000,R26
	LDS  R30,_heater_power
	CP   R26,R30
	BRLO _0x7
; 0000 003D         HEATER_OFF;
	CBI  0x1B,2
; 0000 003E     } else {
	RJMP _0x8
_0x7:
; 0000 003F         HEATER_ON;
	SBI  0x1B,2
; 0000 0040     }
_0x8:
; 0000 0041 
; 0000 0042     if (halph_wave_counter >= 99) { //100
	LDS  R26,_halph_wave_counter_S0000000000
	CPI  R26,LOW(0x63)
	BRLO _0x9
; 0000 0043         halph_wave_counter = 0;
	LDI  R30,LOW(0)
	STS  _halph_wave_counter_S0000000000,R30
; 0000 0044     }
; 0000 0045  } else {
_0x9:
	RJMP _0xA
_0x6:
; 0000 0046     HEATER_OFF;
	CBI  0x1B,2
; 0000 0047     halph_wave_counter = 0;
_0x2F:
	LDI  R30,LOW(0)
	STS  _halph_wave_counter_S0000000000,R30
; 0000 0048  }
_0xA:
; 0000 0049 
; 0000 004A  //////////   valve pwm control ////
; 0000 004B  halph_wave_counter2 ++;
	LDI  R26,LOW(_halph_wave_counter2_S0000000000)
	LDI  R27,HIGH(_halph_wave_counter2_S0000000000)
	CALL SUBOPT_0x1
; 0000 004C  if (halph_wave_counter2 >= pwmPeriod - 1) {
	LDS  R30,_pwmPeriod
	LDS  R31,_pwmPeriod+1
	SBIW R30,1
	LDS  R26,_halph_wave_counter2_S0000000000
	LDS  R27,_halph_wave_counter2_S0000000000+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0xB
; 0000 004D      halph_wave_counter2 = 0;
	LDI  R30,LOW(0)
	STS  _halph_wave_counter2_S0000000000,R30
	STS  _halph_wave_counter2_S0000000000+1,R30
; 0000 004E      if (pwmOn) {
	LDS  R30,_pwmOn
	CPI  R30,0
	BREQ _0xC
; 0000 004F          impulseCounter++;
	LDI  R26,LOW(_impulseCounter)
	LDI  R27,HIGH(_impulseCounter)
	CALL SUBOPT_0x1
; 0000 0050      }
; 0000 0051  }
_0xC:
; 0000 0052  if (pwmOn) {
_0xB:
	LDS  R30,_pwmOn
	CPI  R30,0
	BREQ _0xD
; 0000 0053     if (halph_wave_counter2 < valvePulse) {
	LDS  R30,_valvePulse
	LDS  R26,_halph_wave_counter2_S0000000000
	LDS  R27,_halph_wave_counter2_S0000000000+1
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRSH _0xE
; 0000 0054         VALVE_OPN;
	SBI  0x1B,3
; 0000 0055     } else {
	RJMP _0xF
_0xE:
; 0000 0056         VALVE_CLS;
	CBI  0x1B,3
; 0000 0057     }
_0xF:
; 0000 0058  }
; 0000 0059 
; 0000 005A // heater_watchdog++;
; 0000 005B }
_0xD:
	RJMP _0x31
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
;unsigned char counter_ms = 0;
;
;// This flag is set on USART0 Receiver buffer overflow
;bit rx_buffer_overflow0;
;
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0000 0090 {
_usart0_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0091 char status,data;
; 0000 0092 status=UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0093 data=UDR0;
	IN   R16,12
; 0000 0094 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x10
; 0000 0095    {
; 0000 0096    rx_buffer0[rx_wr_index0++]=data;
	MOV  R30,R5
	INC  R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 0097 #if RX_BUFFER_SIZE0 == 256
; 0000 0098    // special case for receiver buffer size=256
; 0000 0099    if (++rx_counter0 == 0) rx_buffer_overflow0=1;
; 0000 009A #else
; 0000 009B    if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x11
	CLR  R5
; 0000 009C    if (++rx_counter0 == RX_BUFFER_SIZE0)
_0x11:
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x12
; 0000 009D       {
; 0000 009E       rx_counter0=0;
	CLR  R7
; 0000 009F       rx_buffer_overflow0=1;
	SET
	BLD  R2,0
; 0000 00A0       }
; 0000 00A1 #endif
; 0000 00A2    }
_0x12:
; 0000 00A3 }
_0x10:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART0 Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 00AA {
; 0000 00AB char data;
; 0000 00AC while (rx_counter0==0);
;	data -> R17
; 0000 00AD data=rx_buffer0[rx_rd_index0++];
; 0000 00AE #if RX_BUFFER_SIZE0 != 256
; 0000 00AF if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
; 0000 00B0 #endif
; 0000 00B1 #asm("cli")
; 0000 00B2 --rx_counter0;
; 0000 00B3 #asm("sei")
; 0000 00B4 return data;
; 0000 00B5 }
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 00BE {
_timer0_ovf_isr:
; 0000 00BF // Place your code here
; 0000 00C0 
; 0000 00C1 }
	RETI
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 00C5 {
_timer1_ovf_isr:
	CALL SUBOPT_0x0
; 0000 00C6 
; 0000 00C7 static unsigned char counter = 0;
; 0000 00C8 // Reinitialize Timer1 value
; 0000 00C9 TCNT1H=0xC7B1 >> 8;
	LDI  R30,LOW(199)
	OUT  0x2D,R30
; 0000 00CA TCNT1L=0xC7B1 & 0xff;
	LDI  R30,LOW(177)
	OUT  0x2C,R30
; 0000 00CB // Place your code here
; 0000 00CC 
; 0000 00CD ES_PlaceEvent(EVENT_TIMER_1S);
	LDI  R26,LOW(5)
	CALL _ES_PlaceEvent
; 0000 00CE counter ++;
	LDS  R30,_counter_S0000004000
	SUBI R30,-LOW(1)
	STS  _counter_S0000004000,R30
; 0000 00CF if (counter >= 10) {
	LDS  R26,_counter_S0000004000
	CPI  R26,LOW(0xA)
	BRLO _0x17
; 0000 00D0     ES_PlaceEvent(EVENT_TIMER_10S);
	LDI  R26,LOW(10)
	CALL _ES_PlaceEvent
; 0000 00D1     counter = 0;
	LDI  R30,LOW(0)
	STS  _counter_S0000004000,R30
; 0000 00D2 }
; 0000 00D3 
; 0000 00D4 if (mode == RUN_DIST || mode == RUN_RECT || mode == RUN_RECT_SET || mode == CALIBRATE_RUN) {
_0x17:
	LDS  R26,_mode
	CPI  R26,LOW(0x4)
	BREQ _0x19
	CPI  R26,LOW(0x5)
	BREQ _0x19
	CPI  R26,LOW(0x6)
	BREQ _0x19
	CPI  R26,LOW(0x8)
	BRNE _0x18
_0x19:
; 0000 00D5     sec ++;
	LDS  R30,_sec
	SUBI R30,-LOW(1)
	STS  _sec,R30
; 0000 00D6     if (sec >= 60) {
	LDS  R26,_sec
	CPI  R26,LOW(0x3C)
	BRLO _0x1B
; 0000 00D7         minutes ++;
	LDS  R30,_minutes
	SUBI R30,-LOW(1)
	STS  _minutes,R30
; 0000 00D8         sec = 0;
	LDI  R30,LOW(0)
	STS  _sec,R30
; 0000 00D9         if (minutes >= 60) {
	LDS  R26,_minutes
	CPI  R26,LOW(0x3C)
	BRLO _0x1C
; 0000 00DA             minutes = 0;
	STS  _minutes,R30
; 0000 00DB             hours ++;
	LDS  R30,_hours
	SUBI R30,-LOW(1)
	STS  _hours,R30
; 0000 00DC         }
; 0000 00DD     }
_0x1C:
; 0000 00DE }
_0x1B:
; 0000 00DF 
; 0000 00E0 if (mode == RUN_RECT || mode == RUN_RECT_SET) {
_0x18:
	LDS  R26,_mode
	CPI  R26,LOW(0x5)
	BREQ _0x1E
	CPI  R26,LOW(0x6)
	BRNE _0x1D
_0x1E:
; 0000 00E1         if (!timerOn){
	LDS  R30,_timerOn
	CPI  R30,0
	BRNE _0x20
; 0000 00E2             timer ++;
	LDI  R26,LOW(_timer)
	LDI  R27,HIGH(_timer)
	CALL SUBOPT_0x1
; 0000 00E3         }
; 0000 00E4         if (!timerOn && startStop){
_0x20:
	LDS  R30,_timerOn
	CPI  R30,0
	BRNE _0x22
	LDS  R30,_startStop
	CPI  R30,0
	BRNE _0x23
_0x22:
	RJMP _0x21
_0x23:
; 0000 00E5             timer_off ++;
	LDI  R26,LOW(_timer_off)
	LDI  R27,HIGH(_timer_off)
	CALL SUBOPT_0x1
; 0000 00E6         }
; 0000 00E7 }
_0x21:
; 0000 00E8 }
_0x1D:
	RJMP _0x31
;
;// Timer2 overflow interrupt service routine
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 00EC {
_timer2_ovf_isr:
	CALL SUBOPT_0x0
; 0000 00ED // Place your code here
; 0000 00EE 
; 0000 00EF if (++counter_ms >= 15) {
	INC  R6
	LDI  R30,LOW(15)
	CP   R6,R30
	BRLO _0x24
; 0000 00F0     ES_PlaceEvent(EVENT_TIMER_250MS);
	LDI  R26,LOW(6)
	CALL _ES_PlaceEvent
; 0000 00F1     counter_ms = 0;
	CLR  R6
; 0000 00F2 }
; 0000 00F3 
; 0000 00F4 ES_PlaceEvent(EVENT_TIMER_10MS);
_0x24:
	LDI  R26,LOW(7)
	CALL _ES_PlaceEvent
; 0000 00F5 
; 0000 00F6 }
_0x31:
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
;
;unsigned int adc_data;
;
;
;// ADC interrupt service routine
;interrupt [ADC_INT] void adc_isr(void)
; 0000 00FD {
_adc_isr:
; 0000 00FE // Read the AD conversion result
; 0000 00FF adc_data=ADCW;
	__INWR 8,9,4
; 0000 0100 
; 0000 0101 }
	RETI
;
;// Read the AD conversion result
;// with noise canceling
;unsigned int read_adc(unsigned char adc_input)
; 0000 0106 {
; 0000 0107 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
; 0000 0108 // Delay needed for the stabilization of the ADC input voltage
; 0000 0109 delay_us(10);
; 0000 010A #asm
; 0000 010B     in   r30,mcucr
; 0000 010C     cbr  r30,__sm_mask
; 0000 010D     sbr  r30,__se_bit | __sm_adc_noise_red
; 0000 010E     out  mcucr,r30
; 0000 010F     sleep
; 0000 0110     cbr  r30,__se_bit
; 0000 0111     out  mcucr,r30
; 0000 0112 #endasm
; 0000 0113 return adc_data;
; 0000 0114 }
;
;// Declare your global variables here
;#ifdef HW1_P
;signed int p_offset;
;#endif
;unsigned char sec = 0;
;unsigned char minutes = 0;
;unsigned char hours = 0;
;char heater_power = 0;
;char pwmOn = 0;
;char valvePulse = DEFAUL_VALVE_PULSE; // // смотри параметр в general.h

	.DSEG
;unsigned int impulseCounter = 0;
;unsigned int pwmPeriod = 400; // 4 s
;//char heater_watchdog = 0;
;
;void main(void)
; 0000 0125 {

	.CSEG
_main:
; 0000 0126 // Declare your local variables here
; 0000 0127 unsigned char event = 0;
; 0000 0128 
; 0000 0129 HW_Init();
;	event -> R17
	LDI  R17,0
	CALL _HW_Init
; 0000 012A 
; 0000 012B BEEP_ON;
	LDI  R30,LOW(127)
	OUT  0x31,R30
; 0000 012C //DEBUG_LED_ON;
; 0000 012D 
; 0000 012E OWI_Init(BUS);
	LDI  R26,LOW(8)
	CALL _OWI_Init
; 0000 012F BUT_Init();
	CALL _BUT_Init
; 0000 0130 nlcd_Init();
	RCALL _nlcd_Init
; 0000 0131 delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 0132 
; 0000 0133 nlcd_GotoXY(0,0);
	CALL SUBOPT_0x2
; 0000 0134 nlcd_PrintF("----------------");
	__POINTW2MN _0x27,0
	RCALL _nlcd_PrintF
; 0000 0135 nlcd_PrintWideF(" Nikopol");
	__POINTW2MN _0x27,17
	RCALL _nlcd_PrintWideF
; 0000 0136 nlcd_GotoXY(0,2);
	CALL SUBOPT_0x3
; 0000 0137 nlcd_PrintF("    present     ");
	__POINTW2MN _0x27,26
	RCALL _nlcd_PrintF
; 0000 0138 nlcd_PrintF("   -<СПИРТ>-    ");
	__POINTW2MN _0x27,43
	RCALL _nlcd_PrintF
; 0000 0139 nlcd_PrintF("   контроллер   ");
	__POINTW2MN _0x27,60
	RCALL _nlcd_PrintF
; 0000 013A #ifdef HW1_P
; 0000 013B     nlcd_PrintF(" hw v.1.1d P sen");
; 0000 013C #else
; 0000 013D     nlcd_PrintF(" hw v.1.1d      ");
	__POINTW2MN _0x27,77
	RCALL _nlcd_PrintF
; 0000 013E #endif
; 0000 013F 
; 0000 0140 #ifdef SLOW_HEAD_SPEED
; 0000 0141 nlcd_PrintF(" sw v.0.32.s uni");
; 0000 0142 #else
; 0000 0143 nlcd_PrintF(" sw v.0.32.f uni");
	__POINTW2MN _0x27,94
	RCALL _nlcd_PrintF
; 0000 0144 #endif
; 0000 0145 BEEP_OFF;
	LDI  R30,LOW(0)
	OUT  0x31,R30
; 0000 0146 delay_ms(2000);
	CALL SUBOPT_0x4
; 0000 0147 nlcd_Clear();
; 0000 0148 
; 0000 0149 //DEBUG_LED_OFF;
; 0000 014A 
; 0000 014B nlcd_GotoXY(0,2);
	CALL SUBOPT_0x3
; 0000 014C nlcd_PrintF(" Инициализация  ");
	__POINTW2MN _0x27,111
	RCALL _nlcd_PrintF
; 0000 014D nlcd_PrintF("  датчиков Т    ");
	__POINTW2MN _0x27,128
	RCALL _nlcd_PrintF
; 0000 014E nlcd_PrintF("    Найдено     ");
	__POINTW2MN _0x27,145
	RCALL _nlcd_PrintF
; 0000 014F 
; 0000 0150 if (OWI_SearchDevices(ds1820_rom_codes, MAX_DS1820, BUS, &ds1820_devices) == SEARCH_SUCCESSFUL) {
	CALL SUBOPT_0x5
	CPI  R30,0
	BRNE _0x28
; 0000 0151     sprintf(buf, "%i шт", ds1820_devices);
	CALL SUBOPT_0x6
	LDS  R30,_ds1820_devices
	CLR  R31
	CLR  R22
	CLR  R23
	RJMP _0x30
; 0000 0152 } else {
_0x28:
; 0000 0153     sprintf(buf, "%i шт", 0);
	CALL SUBOPT_0x6
	__GETD1N 0x0
_0x30:
	CALL __PUTPARD1
	CALL SUBOPT_0x7
; 0000 0154 }
; 0000 0155 nlcd_GotoXY(1,5);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x8
; 0000 0156 nlcd_Print(buf);
	CALL SUBOPT_0x9
; 0000 0157 delay_ms(2000);
	CALL SUBOPT_0x4
; 0000 0158 nlcd_Clear();
; 0000 0159 LoadParam();
	CALL _LoadParam
; 0000 015A SetNewParams();
	CALL _SetNewParams
; 0000 015B // Global enable interrupts
; 0000 015C #asm("sei")
	sei
; 0000 015D 
; 0000 015E /*
; 0000 015F // Watchdog Timer initialization
; 0000 0160 // Watchdog Timer Prescaler: OSC/2048k
; 0000 0161 #pragma optsize-
; 0000 0162 WDTCR=0x1F;
; 0000 0163 WDTCR=0x0F;
; 0000 0164 #ifdef _OPTIMIZE_SIZE_
; 0000 0165 #pragma optsize+
; 0000 0166 #endif
; 0000 0167 */
; 0000 0168 #ifdef HW1_P
; 0000 0169     PresureInit();
; 0000 016A #endif
; 0000 016B 
; 0000 016C while (1)
_0x2A:
; 0000 016D       {
; 0000 016E       // Place your code here
; 0000 016F       // #asm("wdr");
; 0000 0170         event = ES_GetEvent();
	CALL _ES_GetEvent
	MOV  R17,R30
; 0000 0171         if (event)
	CPI  R17,0
	BREQ _0x2D
; 0000 0172             ES_Dispatch(event);
	MOV  R26,R17
	CALL _ES_Dispatch
; 0000 0173       }
_0x2D:
	RJMP _0x2A
; 0000 0174 }
_0x2E:
	RJMP _0x2E

	.DSEG
_0x27:
	.BYTE 0xA2
;//***************************************************************************
;//  File........: nokia1100_lcd_lib.c
;//  Author(s)...: Chiper
;//  URL(s)......: http://digitalchip.ru/
;//  Device(s)...: ATMega...
;//  Compiler....: AVR-GCC
;//  Description.: Драйвер LCD-контроллера от Nokia1100 с графическими функциями
;//  Data........: 28.03.12
;//  Version.....: 2.1
;//***************************************************************************
;//  Notice: Все управляющие контакты LCD-контроллера должны быть подключены к
;//  одному и тому же порту на микроконтроллере
;//***************************************************************************
;
;#include <nokia1100_lcd_lib.h>
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
;#include <nokia1100_lcd_fnt.h>    // Подключаем шрифт (будет размещен в программной памяти)
;#include <stdlib.h>
;#include <delay.h>
;#include <general.h>
;
;//******************************************************************************
;// Макросы, определения, служебные переменные
;
;// Макросы для работы с битами
;#define ClearBit(reg, bit)       reg &= (~(1<<(bit)))
;#define SetBit(reg, bit)         reg |= (1<<(bit))
;#define InvBit(reg, bit)         reg ^= 1<<bit
;
;//#define pgm_read_byte(address_short) 	pgm_read_byte_near(address_short)
;
;//******************************************************************************
;// Инициализация контроллера
;void nlcd_Init(void)
; 0001 0022 {

	.CSEG
_nlcd_Init:
; 0001 0023     // Инициализируем порт на вывод для работы с LCD-контроллером
; 0001 0024     DDR_LCD |= (1<<SCLK_LCD_PIN)|(1<<SDA_LCD_PIN)|(1<<CS_LCD_PIN)|(1<<RST_LCD_PIN);
	IN   R30,0x14
	ORI  R30,LOW(0xF)
	OUT  0x14,R30
; 0001 0025 
; 0001 0026     CS_LCD_RESET;
	CBI  0x15,1
; 0001 0027     RST_LCD_RESET;
	CBI  0x15,0
; 0001 0028     delay_ms(20);            //20 выжидем не менее 5мс для установки генератора(менее 5 мс может неработать)
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0001 0029     RST_LCD_SET;
	SBI  0x15,0
; 0001 002A     nlcd_SendByte(CMD_LCD_MODE,0xE2); // *** SOFTWARE RESET
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(226)
	CALL SUBOPT_0xA
; 0001 002B     nlcd_SendByte(CMD_LCD_MODE,0x3A); // *** Use internal oscillator
	LDI  R26,LOW(58)
	CALL SUBOPT_0xA
; 0001 002C     nlcd_SendByte(CMD_LCD_MODE,0xEF); // *** FRAME FREQUENCY:
	LDI  R26,LOW(239)
	CALL SUBOPT_0xA
; 0001 002D     nlcd_SendByte(CMD_LCD_MODE,0x04); // *** 80Hz
	LDI  R26,LOW(4)
	CALL SUBOPT_0xA
; 0001 002E     nlcd_SendByte(CMD_LCD_MODE,0xD0); // *** 1:65 divider
	LDI  R26,LOW(208)
	CALL SUBOPT_0xA
; 0001 002F     nlcd_SendByte(CMD_LCD_MODE,0x20); // Запись в регистр Vop
	LDI  R26,LOW(32)
	CALL SUBOPT_0xA
; 0001 0030     nlcd_SendByte(CMD_LCD_MODE,0x90);
	LDI  R26,LOW(144)
	CALL SUBOPT_0xA
; 0001 0031     nlcd_SendByte(CMD_LCD_MODE,0xA4); // all on/normal display
	LDI  R26,LOW(164)
	CALL SUBOPT_0xA
; 0001 0032     nlcd_SendByte(CMD_LCD_MODE,0x2F); // Power control set(charge pump on/off)
	LDI  R26,LOW(47)
	CALL SUBOPT_0xA
; 0001 0033                                       // Определяет контрастность
; 0001 0034     nlcd_SendByte(CMD_LCD_MODE,0x40); // set start row address = 0
	LDI  R26,LOW(64)
	CALL SUBOPT_0xA
; 0001 0035     nlcd_SendByte(CMD_LCD_MODE,0xB0); // установить Y-адрес = 0
	LDI  R26,LOW(176)
	CALL SUBOPT_0xA
; 0001 0036     nlcd_SendByte(CMD_LCD_MODE,0x10); // установить X-адрес, старшие 3 бита
	LDI  R26,LOW(16)
	CALL SUBOPT_0xA
; 0001 0037     nlcd_SendByte(CMD_LCD_MODE,0x0);  // установить X-адрес, младшие 4 бита
	LDI  R26,LOW(0)
	CALL SUBOPT_0xA
; 0001 0038     #ifndef HW1_P
; 0001 0039         nlcd_SendByte(CMD_LCD_MODE,0xC8); // mirror Y axis (about X axis) // заремить для экрана в контроллере Олега
	LDI  R26,LOW(200)
	CALL SUBOPT_0xA
; 0001 003A     #endif
; 0001 003B     //nlcd_SendByte(CMD_LCD_MODE,0xA1); // Инвертировать экран по горизонтали
; 0001 003C 
; 0001 003D     nlcd_SendByte(CMD_LCD_MODE,0xAC); // set initial row (R0) of the display
	LDI  R26,LOW(172)
	CALL SUBOPT_0xA
; 0001 003E     nlcd_SendByte(CMD_LCD_MODE,0x07);
	LDI  R26,LOW(7)
	CALL SUBOPT_0xA
; 0001 003F     //nlcd_SendByte(CMD_LCD_MODE,0xF9); //
; 0001 0040     nlcd_SendByte(CMD_LCD_MODE,0xAF); // экран вкл/выкл
	LDI  R26,LOW(175)
	RCALL _nlcd_SendByte
; 0001 0041     nlcd_Clear(); // clear LCD
	RCALL _nlcd_Clear
; 0001 0042 }
	RET
;
;//******************************************************************************
;// Очистка экрана
;void nlcd_Clear(void)
; 0001 0047 {
_nlcd_Clear:
; 0001 0048     unsigned int i;
; 0001 0049     nlcd_SendByte(CMD_LCD_MODE,0x40); // Y = 0
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(64)
	CALL SUBOPT_0xA
; 0001 004A     nlcd_SendByte(CMD_LCD_MODE,0xB0);
	LDI  R26,LOW(176)
	CALL SUBOPT_0xA
; 0001 004B     nlcd_SendByte(CMD_LCD_MODE,0x10); // X = 0
	LDI  R26,LOW(16)
	CALL SUBOPT_0xA
; 0001 004C     nlcd_SendByte(CMD_LCD_MODE,0x00);
	LDI  R26,LOW(0)
	RCALL _nlcd_SendByte
; 0001 004D     nlcd_xcurr=0; nlcd_ycurr=0;          // Устанавливаем в 0 текущие координаты в видеобуфере
	LDI  R30,LOW(0)
	STS  _nlcd_xcurr_G001,R30
	STS  _nlcd_ycurr_G001,R30
; 0001 004E     //nlcd_SendByte(CMD_LCD_MODE,0xAE); // disable display;
; 0001 004F     for(i=0;i<NLCD_X_RES*NLCD_Y_RES ;i++) nlcd_SendByte(DATA_LCD_MODE,0x00);
	__GETWRN 16,17,0
_0x20004:
	__CPWRN 16,17,6528
	BRSH _0x20005
	CALL SUBOPT_0xB
	__ADDWRN 16,17,1
	RJMP _0x20004
_0x20005:
; 0001 0053 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;
;//******************************************************************************
;// Передача байта (команды или данных) на LCD-контроллер
;//  mode: CMD_LCD_MODE - передаем команду
;//          DATA_LCD_MODE - передаем данные
;//  c: значение передаваемого байта
;void nlcd_SendByte(char mode,unsigned char c)
; 0001 005C {
_nlcd_SendByte:
; 0001 005D     unsigned char i;
; 0001 005E     CS_LCD_RESET;
	ST   -Y,R26
	ST   -Y,R17
;	mode -> Y+2
;	c -> Y+1
;	i -> R17
	CBI  0x15,1
; 0001 005F     SCLK_LCD_RESET;
	CBI  0x15,3
; 0001 0060 
; 0001 0061     if (mode)                 // DATA_LCD_MODE
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x20006
; 0001 0062     {
; 0001 0063 
; 0001 0064         nlcd_memory[nlcd_xcurr][nlcd_ycurr] = c;    // Записываем банные в видеобуфер
	LDS  R30,_nlcd_xcurr_G001
	LDI  R26,LOW(9)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_nlcd_memory_G001)
	SBCI R31,HIGH(-_nlcd_memory_G001)
	MOVW R26,R30
	LDS  R30,_nlcd_ycurr_G001
	CALL SUBOPT_0xC
	LDD  R26,Y+1
	STD  Z+0,R26
; 0001 0065         nlcd_xcurr++;                                // Обновляем координаты в видеобуфере
	LDS  R30,_nlcd_xcurr_G001
	SUBI R30,-LOW(1)
	STS  _nlcd_xcurr_G001,R30
; 0001 0066         if (nlcd_xcurr>95)
	LDS  R26,_nlcd_xcurr_G001
	CPI  R26,LOW(0x60)
	BRLO _0x20007
; 0001 0067         {
; 0001 0068             nlcd_xcurr = 0;
	LDI  R30,LOW(0)
	STS  _nlcd_xcurr_G001,R30
; 0001 0069             nlcd_ycurr++;
	LDS  R30,_nlcd_ycurr_G001
	SUBI R30,-LOW(1)
	STS  _nlcd_ycurr_G001,R30
; 0001 006A         }
; 0001 006B         if (nlcd_ycurr>8) nlcd_ycurr = 0;
_0x20007:
	LDS  R26,_nlcd_ycurr_G001
	CPI  R26,LOW(0x9)
	BRLO _0x20008
	LDI  R30,LOW(0)
	STS  _nlcd_ycurr_G001,R30
; 0001 006C 
; 0001 006D         SDA_LCD_SET;                                // Передача байта в LCD-контроллер
_0x20008:
	SBI  0x15,2
; 0001 006E     }
; 0001 006F      else SDA_LCD_RESET;    // CMD_LCD_MODE
	RJMP _0x20009
_0x20006:
	CBI  0x15,2
; 0001 0070 
; 0001 0071     SCLK_LCD_SET;
_0x20009:
	SBI  0x15,3
; 0001 0072 
; 0001 0073     for(i=0; i<8; i++)
	LDI  R17,LOW(0)
_0x2000B:
	CPI  R17,8
	BRSH _0x2000C
; 0001 0074     {
; 0001 0075         SCLK_LCD_RESET;
	CBI  0x15,3
; 0001 0076         if(c & 0x80)
	LDD  R30,Y+1
	ANDI R30,LOW(0x80)
	BREQ _0x2000D
; 0001 0077         {
; 0001 0078             SDA_LCD_SET;
	SBI  0x15,2
; 0001 0079         } else {
	RJMP _0x2000E
_0x2000D:
; 0001 007A             SDA_LCD_RESET;
	CBI  0x15,2
; 0001 007B         }
_0x2000E:
; 0001 007C         SCLK_LCD_SET;
	SBI  0x15,3
; 0001 007D         c <<= 1;
	LDD  R30,Y+1
	LSL  R30
	STD  Y+1,R30
; 0001 007E         #ifdef LCD_DELAY_ON
; 0001 007F             delay_us(NLCD_MIN_DELAY);    // *****!!!!! 34 - Минимальная задержка, при которой работает мой LCD-контроллер
	__DELAY_USB 10
; 0001 0080         #endif
; 0001 0081     }
	SUBI R17,-1
	RJMP _0x2000B
_0x2000C:
; 0001 0082     CS_LCD_SET;
	SBI  0x15,1
; 0001 0083 }
	LDD  R17,Y+0
	RJMP _0x20A0015
;
;//******************************************************************************
;// Вывод символа на LCD-экран NOKIA 1100 в текущее место
;//  c: код символа
;void nlcd_Putc(unsigned char c)
; 0001 0089 {
_nlcd_Putc:
; 0001 008A     unsigned char i;
; 0001 008B     if (c>127) c=c-64;     // Переносим символы кирилицы в кодировке CP1251 в начало второй
	ST   -Y,R26
	ST   -Y,R17
;	c -> Y+1
;	i -> R17
	LDD  R26,Y+1
	CPI  R26,LOW(0x80)
	BRLO _0x2000F
	LDD  R30,Y+1
	SUBI R30,LOW(64)
	STD  Y+1,R30
; 0001 008C                         // половины таблицы ASCII (начиная с кода 0x80)
; 0001 008D     for (i = 0; i < 5; i++ ) {
_0x2000F:
	LDI  R17,LOW(0)
_0x20011:
	CPI  R17,5
	BRSH _0x20012
; 0001 008E          nlcd_SendByte(DATA_LCD_MODE, nlcd_Font[c-30][i]);  //32
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL SUBOPT_0xD
	LPM  R26,Z
	RCALL _nlcd_SendByte
; 0001 008F     }
	SUBI R17,-1
	RJMP _0x20011
_0x20012:
; 0001 0090     nlcd_SendByte(DATA_LCD_MODE,0x00); // Зазор между символами по горизонтали в 1 пиксель
	CALL SUBOPT_0xB
; 0001 0091 }
	LDD  R17,Y+0
	RJMP _0x20A0018
;
;//******************************************************************************
;// Вывод широкого символа на LCD-экран NOKIA 1100 в текущее место
;//  c: код символа
;void nlcd_PutcWide(unsigned char c)
; 0001 0097 {
_nlcd_PutcWide:
; 0001 0098     unsigned char i;
; 0001 0099     if (c>127) c=c-64;     // Переносим символы кирилицы в кодировке CP1251 в начало второй
	ST   -Y,R26
	ST   -Y,R17
;	c -> Y+1
;	i -> R17
	LDD  R26,Y+1
	CPI  R26,LOW(0x80)
	BRLO _0x20013
	LDD  R30,Y+1
	SUBI R30,LOW(64)
	STD  Y+1,R30
; 0001 009A     for ( i = 0; i < 5; i++ )  // половины таблицы ASCII (начиная с кода 0x80)
_0x20013:
	LDI  R17,LOW(0)
_0x20015:
	CPI  R17,5
	BRSH _0x20016
; 0001 009B     {
; 0001 009C         unsigned char glyph = nlcd_Font[c-30][i]; //32
; 0001 009D         nlcd_SendByte(DATA_LCD_MODE,glyph);
	SBIW R28,1
;	c -> Y+2
;	glyph -> Y+0
	CALL SUBOPT_0xD
	LPM  R30,Z
	ST   Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _nlcd_SendByte
; 0001 009E         nlcd_SendByte(DATA_LCD_MODE,glyph);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _nlcd_SendByte
; 0001 009F     }
	ADIW R28,1
	SUBI R17,-1
	RJMP _0x20015
_0x20016:
; 0001 00A0     nlcd_SendByte(DATA_LCD_MODE,0x00); // Зазор между символами по горизонтали в 1 пиксель
	CALL SUBOPT_0xB
; 0001 00A1 //    nlcd_SendByte(DATA_LCD_MODE,0x00); // Можно сделать две линии
; 0001 00A2 }
	LDD  R17,Y+0
	RJMP _0x20A0018
;
;//******************************************************************************
;// Вывод строки символов на LCD-экран NOKIA 1100 в текущее место. Если строка выходит
;// за экран в текущей строке, то остаток переносится на следующую строку.
;//  message: указатель на строку символов. 0x00 - признак конца строки.
;void nlcd_Print(char * message)
; 0001 00A9 {
_nlcd_Print:
; 0001 00AA     while (*message) nlcd_Putc(*message++); // Конец строки обозначен нулем
	ST   -Y,R27
	ST   -Y,R26
;	*message -> Y+0
_0x20017:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x20019
	LD   R30,X+
	ST   Y,R26
	STD  Y+1,R27
	MOV  R26,R30
	RCALL _nlcd_Putc
	RJMP _0x20017
_0x20019:
; 0001 00AB }
	RJMP _0x20A0018
;
;//******************************************************************************
;// Вывод строки символов на LCD-экран NOKIA 1100 в текущее место из программной памяти.
;// Если строка выходит за экран в текущей строке, то остаток переносится на следующую строку.
;//  message: указатель на строку символов в программной памяти. 0x00 - признак конца строки.
;void nlcd_PrintF(unsigned char * message)
; 0001 00B2 {
_nlcd_PrintF:
; 0001 00B3     unsigned char data;
; 0001 00B4     while (data = *message, data)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*message -> Y+1
;	data -> R17
_0x2001A:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X
	MOV  R17,R30
	CPI  R17,0
	BREQ _0x2001C
; 0001 00B5     {
; 0001 00B6         nlcd_Putc(data);
	MOV  R26,R17
	RCALL _nlcd_Putc
; 0001 00B7         message++;
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
; 0001 00B8     }
	RJMP _0x2001A
_0x2001C:
; 0001 00B9 }
	LDD  R17,Y+0
	RJMP _0x20A0015
;
;
;//******************************************************************************
;// Вывод строки символов на LCD-экран NOKIA 1100 в текущее место из программной памяти.
;// Если строка выходит за экран в текущей строке, то остаток переносится на следующую строку.
;//  message: указатель на строку символов в программной памяти. 0x00 - признак конца строки.
;void nlcd_PrintWideF(unsigned char * message)
; 0001 00C1 {
_nlcd_PrintWideF:
; 0001 00C2     unsigned char data;
; 0001 00C3     while (data = *message, data)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*message -> Y+1
;	data -> R17
_0x2001D:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X
	MOV  R17,R30
	CPI  R17,0
	BREQ _0x2001F
; 0001 00C4     {
; 0001 00C5         nlcd_PutcWide(data);
	MOV  R26,R17
	RCALL _nlcd_PutcWide
; 0001 00C6         message++;
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
; 0001 00C7     }
	RJMP _0x2001D
_0x2001F:
; 0001 00C8 }
	LDD  R17,Y+0
	RJMP _0x20A0015
;
;//******************************************************************************
;// Вывод строки символов двойной ширины на LCD-экран NOKIA 1100 в текущее место
;// из оперативной памяти. Если строка выходит за экран в текущей строке, то остаток
;// переносится на следующую строку.
;//  message: указатель на строку символов в программной памяти. 0x00 - признак конца строки.
;void nlcd_PrintWide(unsigned char * message)
; 0001 00D0 {
; 0001 00D1     while (*message) nlcd_PutcWide(*message++);  // Конец строки обозначен нулем
;	*message -> Y+0
; 0001 00D2 }
;
;
;//******************************************************************************
;// Устанавливает курсор в необходимое положение. Отсчет начинается в верхнем
;// левом углу. По горизонтали 16 знакомест, по вертикали - 8
;//  x: 0..15
;//  y: 0..7
;void nlcd_GotoXY(char x,char y)
; 0001 00DB {
_nlcd_GotoXY:
; 0001 00DC     x=x*6;    // Переходим от координаты в знакоместах к координатам в пикселях
	ST   -Y,R26
;	x -> Y+1
;	y -> Y+0
	LDD  R30,Y+1
	LDI  R26,LOW(6)
	MULS R30,R26
	MOVW R30,R0
	STD  Y+1,R30
; 0001 00DD     nlcd_xcurr=x;
	STS  _nlcd_xcurr_G001,R30
; 0001 00DE     nlcd_ycurr=y;
	LD   R30,Y
	STS  _nlcd_ycurr_G001,R30
; 0001 00DF     nlcd_SendByte(CMD_LCD_MODE,(0xB0|(y&0x0F)));      // установка адреса по Y: 0100 yyyy
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R30,Y+1
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xB0)
	MOV  R26,R30
	CALL SUBOPT_0xA
; 0001 00E0     nlcd_SendByte(CMD_LCD_MODE,(0x00|(x&0x0F)));      // установка адреса по X: 0000 xxxx - биты (x3 x2 x1 x0)
	LDD  R30,Y+2
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	CALL SUBOPT_0xA
; 0001 00E1     nlcd_SendByte(CMD_LCD_MODE,(0x10|((x>>4)&0x07))); // установка адреса по X: 0010 0xxx - биты (x6 x5 x4)
	LDD  R30,Y+2
	SWAP R30
	ANDI R30,LOW(0x7)
	ORI  R30,0x10
	MOV  R26,R30
	RCALL _nlcd_SendByte
; 0001 00E2 }
_0x20A0018:
	ADIW R28,2
	RET
;
;//******************************************************************************
;// Устанавливаер режим инверсии всего экрана. Данные на экране не изменяются, только инвертируются
;//  mode: INV_MODE_ON или INV_MODE_OFF
;void nlcd_Inverse(unsigned char mode)
; 0001 00E8 {
; 0001 00E9     if (mode){
;	mode -> Y+0
; 0001 00EA         nlcd_SendByte(CMD_LCD_MODE,0xA6);
; 0001 00EB     } else {
; 0001 00EC         nlcd_SendByte(CMD_LCD_MODE,0xA7);
; 0001 00ED     }
; 0001 00EE }
;
;
;//******************************************************************************
;// Устанавливает курсор в пикселях. Отсчет начинается в верхнем
;// левом углу. По горизонтали 96 пикселей, по вертикали - 65
;//  x: 0..95
;//  y: 0..64
;void nlcd_GotoXY_pix(char x,char y)
; 0001 00F7 {
; 0001 00F8     nlcd_xcurr=x;
;	x -> Y+1
;	y -> Y+0
; 0001 00F9     nlcd_ycurr=y/8;
; 0001 00FA 
; 0001 00FB     //nlcd_SendByte(CMD_LCD_MODE,(0xB0 | ((y / 8) & 0x0F)));      // установка адреса по Y: 0100 yyyy
; 0001 00FC     nlcd_SendByte(CMD_LCD_MODE,(0xB0|(nlcd_ycurr&0x0F)));      // установка адреса по Y: 0100 yyyy
; 0001 00FD     nlcd_SendByte(CMD_LCD_MODE,(0x00 | (x & 0x0F)));      // установка адреса по X: 0000 xxxx - биты (x3 x2 x1 x0)
; 0001 00FE     nlcd_SendByte(CMD_LCD_MODE,(0x10 | ((x>>4) & 0x07))); // установка адреса по X: 0010 0xxx - биты (x6 x5 x4)
; 0001 00FF }
;
;
;//******************************************************************************
;// Вывод точки на LCD-экран NOKIA 1100
;//  x: 0..95  координата по горизонтали (отсчет от верхнего левого угла)
;//    y: 0..64  координата по вертикали
;//    pixel_mode: PIXEL_ON  - для включения пикскела
;//                PIXEL_OFF - для выключения пиксела
;//                PIXEL_INV - для инверсии пиксела
;void nlcd_Pixel(unsigned char x,unsigned char y, unsigned char pixel_mode)
; 0001 010A {
; 0001 010B     unsigned char temp;
; 0001 010C     nlcd_GotoXY_pix(x,y);
;	x -> Y+3
;	y -> Y+2
;	pixel_mode -> Y+1
;	temp -> R17
; 0001 010D     temp=nlcd_memory[nlcd_xcurr][nlcd_ycurr];
; 0001 010E     switch(pixel_mode)
; 0001 010F     {
; 0001 0110         case PIXEL_ON:
; 0001 0111             SetBit(temp, y%8);            // Включаем пиксел
; 0001 0112             break;
; 0001 0113         case PIXEL_OFF:
; 0001 0114              ClearBit(temp, y%8);        // Выключаем пиксел
; 0001 0115             break;
; 0001 0116         case PIXEL_INV:
; 0001 0117              InvBit(temp, y%8);          // Инвертируем пиксел
; 0001 0118             break;
; 0001 0119     }
; 0001 011A 
; 0001 011B     nlcd_memory[nlcd_xcurr][nlcd_ycurr] = temp; // Передаем байт в видеобуфер
; 0001 011C     nlcd_SendByte(DATA_LCD_MODE,temp); // Передаем байт в контроллер
; 0001 011D }
;
;//******************************************************************************
;// Вывод линии на LCD-экран NOKIA 1100
;//  x1, x2: 0..95  координата по горизонтали (отсчет от верхнего левого угла)
;//    y1, y2: 0..64  координата по вертикали
;//    pixel_mode: PIXEL_ON  - для включения пикскела
;//                PIXEL_OFF - для выключения пиксела
;//                PIXEL_INV - для инверсии пиксела
;void nlcd_Line (unsigned char x1,unsigned char y1, unsigned char x2,unsigned char y2, unsigned char pixel_mode)
; 0001 0127 {
; 0001 0128     int dy, dx;
; 0001 0129     signed char addx = 1, addy = 1;
; 0001 012A     signed int     P, diff;
; 0001 012B 
; 0001 012C     unsigned char i = 0;
; 0001 012D 
; 0001 012E     dx = abs((signed char)(x2 - x1));
;	x1 -> Y+15
;	y1 -> Y+14
;	x2 -> Y+13
;	y2 -> Y+12
;	pixel_mode -> Y+11
;	dy -> R16,R17
;	dx -> R18,R19
;	addx -> R21
;	addy -> R20
;	P -> Y+9
;	diff -> Y+7
;	i -> Y+6
; 0001 012F     dy = abs((signed char)(y2 - y1));
; 0001 0130 
; 0001 0131     if(x1 > x2)    addx = -1;
; 0001 0132     if(y1 > y2)    addy = -1;
; 0001 0133 
; 0001 0134     if(dx >= dy)
; 0001 0135     {
; 0001 0136         dy *= 2;
; 0001 0137         P = dy - dx;
; 0001 0138 
; 0001 0139         diff = P - dx;
; 0001 013A 
; 0001 013B         for(; i<=dx; ++i)
; 0001 013C         {
; 0001 013D             nlcd_Pixel(x1, y1, pixel_mode);
; 0001 013E 
; 0001 013F             if(P < 0)
; 0001 0140             {
; 0001 0141                 P  += dy;
; 0001 0142                 x1 += addx;
; 0001 0143             }
; 0001 0144             else
; 0001 0145             {
; 0001 0146                 P  += diff;
; 0001 0147                 x1 += addx;
; 0001 0148                 y1 += addy;
; 0001 0149             }
; 0001 014A         }
; 0001 014B     }
; 0001 014C     else
; 0001 014D     {
; 0001 014E         dx *= 2;
; 0001 014F         P = dx - dy;
; 0001 0150         diff = P - dy;
; 0001 0151 
; 0001 0152         for(; i<=dy; ++i)
; 0001 0153         {
; 0001 0154             nlcd_Pixel(x1, y1, pixel_mode);
; 0001 0155 
; 0001 0156             if(P < 0)
; 0001 0157             {
; 0001 0158                 P  += dx;
; 0001 0159                 y1 += addy;
; 0001 015A             }
; 0001 015B             else
; 0001 015C             {
; 0001 015D                 P  += diff;
; 0001 015E                 x1 += addx;
; 0001 015F                 y1 += addy;
; 0001 0160             }
; 0001 0161         }
; 0001 0162     }
; 0001 0163 }
;
;
;
;//******************************************************************************
;// Вывод окружности на LCD-экран NOKIA 1100
;//  x: 0..95  координаты центра окружности (отсчет от верхнего левого угла)
;//    y: 0..64  координата по вертикали
;//  radius:   радиус окружности
;//  fill:        FILL_OFF  - без заливки окружности
;//                FILL_ON      - с заливкой
;//    pixel_mode: PIXEL_ON  - для включения пикскела
;//                PIXEL_OFF - для выключения пиксела
;//                PIXEL_INV - для инверсии пиксела
;
;void nlcd_Circle(unsigned char x, unsigned char y, unsigned char radius, unsigned char fill, unsigned char pixel_mode)
; 0001 0173 {
; 0001 0174     signed char  a, b, P;
; 0001 0175 
; 0001 0176     a = 0;
;	x -> Y+8
;	y -> Y+7
;	radius -> Y+6
;	fill -> Y+5
;	pixel_mode -> Y+4
;	a -> R17
;	b -> R16
;	P -> R19
; 0001 0177     b = radius;
; 0001 0178     P = 1 - radius;
; 0001 0179 
; 0001 017A     do
; 0001 017B     {
; 0001 017C         if(fill)
; 0001 017D         {
; 0001 017E             nlcd_Line(x-a, y+b, x+a, y+b, pixel_mode);
; 0001 017F             nlcd_Line(x-a, y-b, x+a, y-b, pixel_mode);
; 0001 0180             nlcd_Line(x-b, y+a, x+b, y+a, pixel_mode);
; 0001 0181             nlcd_Line(x-b, y-a, x+b, y-a, pixel_mode);
; 0001 0182         }
; 0001 0183         else
; 0001 0184         {
; 0001 0185             nlcd_Pixel(a+x, b+y, pixel_mode);
; 0001 0186             nlcd_Pixel(b+x, a+y, pixel_mode);
; 0001 0187             nlcd_Pixel(x-a, b+y, pixel_mode);
; 0001 0188             nlcd_Pixel(x-b, a+y, pixel_mode);
; 0001 0189             nlcd_Pixel(b+x, y-a, pixel_mode);
; 0001 018A             nlcd_Pixel(a+x, y-b, pixel_mode);
; 0001 018B             nlcd_Pixel(x-a, y-b, pixel_mode);
; 0001 018C             nlcd_Pixel(x-b, y-a, pixel_mode);
; 0001 018D         }
; 0001 018E 
; 0001 018F         if(P < 0) P += 3 + 2 * a++;
; 0001 0190             else P += 5 + 2 * (a++ - b--);
; 0001 0191     } while(a <= b);
; 0001 0192 }
;
;
;
;//******************************************************************************
;// Вывод окружности на LCD-экран NOKIA 1100
;//  x1, x2: 0..95  координата по горизонтали (отсчет от верхнего левого угла)
;//    y1, y2: 0..64  координата по вертикали
;//    pixel_mode: PIXEL_ON  - для включения пикскела
;//                PIXEL_OFF - для выключения пиксела
;//                PIXEL_INV - для инверсии пиксела
;void nlcd_Rect (unsigned char x1, unsigned char y1, unsigned char x2, unsigned char y2, unsigned char fill, unsigned char pixel_mode)
; 0001 019E {
; 0001 019F     if(fill)
;	x1 -> Y+5
;	y1 -> Y+4
;	x2 -> Y+3
;	y2 -> Y+2
;	fill -> Y+1
;	pixel_mode -> Y+0
; 0001 01A0     {            // С заливкой
; 0001 01A1         unsigned char  i, xmin, xmax, ymin, ymax;
; 0001 01A2 
; 0001 01A3         if(x1 < x2) { xmin = x1; xmax = x2; }    // Определяем минимальную и максимальную координату по X
;	x1 -> Y+10
;	y1 -> Y+9
;	x2 -> Y+8
;	y2 -> Y+7
;	fill -> Y+6
;	pixel_mode -> Y+5
;	i -> Y+4
;	xmin -> Y+3
;	xmax -> Y+2
;	ymin -> Y+1
;	ymax -> Y+0
; 0001 01A4          else { xmin = x2; xmax = x1; }
; 0001 01A5 
; 0001 01A6         if(y1 < y2) { ymin = y1; ymax = y2; }    // Определяем минимальную и максимальную координату по Y
; 0001 01A7          else { ymin = y2; ymax = y1; }
; 0001 01A8 
; 0001 01A9         for(; xmin <= xmax; ++xmin)
; 0001 01AA         {
; 0001 01AB             for(i=ymin; i<=ymax; ++i) nlcd_Pixel(xmin, i, pixel_mode);
; 0001 01AC }
; 0001 01AD     }
; 0001 01AE     else        // Без заливки
; 0001 01AF     {
; 0001 01B0         nlcd_Line(x1, y1, x2, y1, pixel_mode);        // Рисуем стороны прямоуголиника
; 0001 01B1         nlcd_Line(x1, y2, x2, y2, pixel_mode);
; 0001 01B2         nlcd_Line(x1, y1+1, x1, y2-1, pixel_mode);
; 0001 01B3         nlcd_Line(x2, y1+1, x2, y2-1, pixel_mode);
; 0001 01B4     }
; 0001 01B5 }
;
;
;//******************************************************************************
;// Вывод картинки на LCD-экран NOKIA 1100
;//  x: 0..95  координата верхнего левого угла по горизонтали (отсчет от верхнего левого угла экрана)
;//    y: 0..64  координата верхнего левого угла по вертикали
;//  picture: указатель на массив с монохромной картинкой, первые 2 байта указывают соответственно
;//             размер картинки по горизонтали и вертикали
;void nlcd_Pict  (unsigned char x, unsigned char y, unsigned char * picture)
; 0001 01BF {
; 0001 01C0     unsigned char pict_width = picture[0];  // ширина спрайта в пикселах
; 0001 01C1     unsigned char pict_height = picture[1]; // высота спрайта в пикселах
; 0001 01C2     unsigned char pict_height_bank=pict_height / 8+((pict_height%8)>0?1:0); // высота спрайта в банках
; 0001 01C3     unsigned char y_pos_in_bank = y/8 + ((y%8)>0?1:0);        // позиция по y в банках (строках по 8 пикс.)
; 0001 01C4     unsigned char j;
; 0001 01C5     unsigned char i;
; 0001 01C6 
; 0001 01C7     int adr = 2; // индекс текущего байта в массиве с картинкой
; 0001 01C8 
; 0001 01C9     for (i=0; i< pict_height_bank; i++)
;	x -> Y+11
;	y -> Y+10
;	*picture -> Y+8
;	pict_width -> R17
;	pict_height -> R16
;	pict_height_bank -> R19
;	y_pos_in_bank -> R18
;	j -> R21
;	i -> R20
;	adr -> Y+6
; 0001 01CA     { // проход построчно (по банкам)
; 0001 01CB 
; 0001 01CC         if (i<((NLCD_Y_RES/8)+1)) // не выводить картинку за пределами экрана
; 0001 01CD         {
; 0001 01CE             //позиционирование на новую строку
; 0001 01CF             nlcd_xcurr=x;
; 0001 01D0             nlcd_ycurr=y_pos_in_bank + i;
; 0001 01D1 
; 0001 01D2             nlcd_SendByte(CMD_LCD_MODE,(0xB0|((y_pos_in_bank+i)&0x0F))); // установка адреса по Y: 0100 yyyy
; 0001 01D3             nlcd_SendByte(CMD_LCD_MODE,(0x00|(x&0x0F)));      // установка адреса по X: 0000 xxxx - биты (x3 x2 x1 x0)
; 0001 01D4             nlcd_SendByte(CMD_LCD_MODE,(0x10|((x>>4)&0x07))); // установка адреса по X: 0010 0xxx - биты (x6 x5 x4)
; 0001 01D5 
; 0001 01D6             //вывод строки
; 0001 01D7             for (j = 0; j < pict_width; j++ )
; 0001 01D8             {
; 0001 01D9                 if ((x+j) < NLCD_X_RES) nlcd_SendByte(DATA_LCD_MODE,picture[adr]); // не выводить картинку за пределами экрана
; 0001 01DA                 adr++;
; 0001 01DB             }
; 0001 01DC         }
; 0001 01DD     }
; 0001 01DE }
;
;//***************************************************************************
;//
;//  Author(s)...: Павел Бобков  http://ChipEnable.Ru
;//
;//  Target(s)...: avr
;//
;//  Compiler....: IAR
;//
;//  Description.: драйвер кнопок
;//
;//  Data........: 12.12.13
;//
;//***************************************************************************
;
;#include "buttons.h"
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
;
;#define FLAG_BUT_PRESSED    (1<<0)
;#define FLAG_BUT_HOLD       (1<<1)
;#define FLAG_BUT_RELEASED   (1<<2)
;
;
;/*макрос проверки состояния пина. зависит от
;активного уровня в настройках*/
;#define _TestBit1(var, bit)            ((var) & (1<<(bit)))
;#define _TestBit0(var, bit)            (!((var) & (1<<(bit))))
;#define _TestBit(var, bit, lev)        _TestBit##lev(var, bit)
;#define TestBitLev(var, bit, lev)      _TestBit(var, bit, lev)
;
;/*настройка портов на вход, вкл/выкл подтяжки*/
;#define ButtonInit_m(dir, port, pin, pull)   do{dir &= ~(1<<pin);                 \
;                                                if (pull) {port |= (1<<pin);}     \
;                                                else{port &= ~(1<<pin);}}while(0)
;
;/*сохранение события во временной переменной, если оно разрешено*/
;#define SaveEvent_m(settings, mask, curEvent, reg) do{if ((settings) & (mask)){reg = curEvent;}}while(0)
;
;/*макрос для опроса. в одном случае реализует часть switch оператора, в другом просто опрос*/
;#if (BUT_POLL_ROTATION > 0)
;#define CheckOneBut_m(id, port, pin, lev, settings, reg)     case ((id) - 1):                   \
;                                                                if (TestBitLev(port, pin, lev)){\
;                                                                   reg = 1;                     \
;                                                                }                               \
;                                                                else{                           \
;                                                                   reg = 0;                     \
;                                                                }                               \
;                                                                BUT_Check(reg, id, settings);   \
;                                                                break;
;
;   #define Switch_m(x)  switch(x){
;   #define End_m()      }
;#else
;
;#define CheckOneBut_m(id, port, pin, lev, settings, reg)        if (TestBitLev(port, pin, lev)){\
;                                                                   reg = 1;                     \
;                                                                }                               \
;                                                                else{                           \
;                                                                   reg = 0;                     \
;                                                                }                               \
;                                                                BUT_Check(reg, id, settings);
;
;   #define Switch_m(x)
;   #define End_m()
;#endif
;
;/*границы для счетчика антидребезга и двойного клика*/
;#define BUT_COUNT_MAX        (BUT_COUNT_HELD + 1)
;#define BUT_COUNT_THR_2_MAX  (BUT_COUNT_THR_2 + 1)
;
;/*антидребезговый счетчик*/
;#if (BUT_COUNT_HELD <= 250)
;  static uint8_t countDeb[BUT_AMOUNT];
;  static uint8_t countDebTmp;
;#else
;  static uint16_t countDeb[BUT_AMOUNT];
;  static uint16_t countDebTmp;
;#endif
;
;/*счетчики для реализации двойного клика*/
;#if (BUT_DOUBLE_CLICK_EN == 1)
;  #if (BUT_COUNT_THR_2 <= 253)
;    static uint8_t countHold[BUT_AMOUNT];
;    static uint8_t countHoldTmp;
;  #else
;    static uint16_t countHold[BUT_AMOUNT];
;    static uint16_t countHoldTmp;
;  #endif
;#endif
;
;/*буфер, в котором хрянятся флаги кнопок*/
;static uint8_t stateBut[BUT_AMOUNT];
;
;/*************** кольцевой буфер ******************/
;
;static uint8_t buf[BUT_SIZE_BUF];
;static uint8_t head, tail, count;
;
;static void PutBut(uint8_t but)
; 0002 0062 {

	.CSEG
_PutBut_G002:
; 0002 0063   if (count < BUT_SIZE_BUF){
	ST   -Y,R26
;	but -> Y+0
	LDS  R26,_count_G002
	CPI  R26,LOW(0x8)
	BRSH _0x40003
; 0002 0064      buf[head] = but;
	LDS  R30,_head_G002
	CALL SUBOPT_0xE
	LD   R26,Y
	STD  Z+0,R26
; 0002 0065      count++;
	LDS  R30,_count_G002
	SUBI R30,-LOW(1)
	STS  _count_G002,R30
; 0002 0066      head++;
	LDS  R30,_head_G002
	SUBI R30,-LOW(1)
	STS  _head_G002,R30
; 0002 0067      head &= (BUT_SIZE_BUF - 1);
	ANDI R30,LOW(0x7)
	STS  _head_G002,R30
; 0002 0068   }
; 0002 0069 }
_0x40003:
	RJMP _0x20A0016
;
;uint8_t BUT_GetBut(void)
; 0002 006C {
_BUT_GetBut:
; 0002 006D   uint8_t but = 0;
; 0002 006E 
; 0002 006F   if (count){
	ST   -Y,R17
;	but -> R17
	LDI  R17,0
	LDS  R30,_count_G002
	CPI  R30,0
	BREQ _0x40004
; 0002 0070      but = buf[tail];
	LDS  R30,_tail_G002
	CALL SUBOPT_0xE
	LD   R17,Z
; 0002 0071      count--;
	LDS  R30,_count_G002
	SUBI R30,LOW(1)
	STS  _count_G002,R30
; 0002 0072      tail++;
	LDS  R30,_tail_G002
	SUBI R30,-LOW(1)
	STS  _tail_G002,R30
; 0002 0073      tail &= (BUT_SIZE_BUF - 1);
	ANDI R30,LOW(0x7)
	STS  _tail_G002,R30
; 0002 0074   }
; 0002 0075 
; 0002 0076   return but;
_0x40004:
	MOV  R30,R17
	RJMP _0x20A0017
; 0002 0077 }
;
;/************************************************/
;
;static void BUT_Check(uint8_t state, uint8_t i, uint8_t settings)
; 0002 007C {
_BUT_Check_G002:
; 0002 007D   uint8_t stateTmp;
; 0002 007E   uint8_t event;
; 0002 007F 
; 0002 0080   i--;
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	state -> Y+4
;	i -> Y+3
;	settings -> Y+2
;	stateTmp -> R17
;	event -> R16
	LDD  R30,Y+3
	SUBI R30,LOW(1)
	STD  Y+3,R30
; 0002 0081 
; 0002 0082   stateTmp = stateBut[i];
	CALL SUBOPT_0xF
	SUBI R30,LOW(-_stateBut_G002)
	SBCI R31,HIGH(-_stateBut_G002)
	LD   R17,Z
; 0002 0083   event = 0;
	LDI  R16,LOW(0)
; 0002 0084 
; 0002 0085 #if (BUT_DOUBLE_CLICK_EN == 1)
; 0002 0086   countHoldTmp = countHold[i];
; 0002 0087 #endif
; 0002 0088 
; 0002 0089  countDebTmp = countDeb[i];
	CALL SUBOPT_0xF
	SUBI R30,LOW(-_countDeb_G002)
	SBCI R31,HIGH(-_countDeb_G002)
	LD   R30,Z
	STS  _countDebTmp_G002,R30
; 0002 008A 
; 0002 008B  if (state){
	LDD  R30,Y+4
	CPI  R30,0
	BREQ _0x40005
; 0002 008C     if (countDebTmp < BUT_COUNT_MAX){
	LDS  R26,_countDebTmp_G002
	CPI  R26,LOW(0x15)
	BRSH _0x40006
; 0002 008D        countDebTmp++;
	LDS  R30,_countDebTmp_G002
	SUBI R30,-LOW(1)
	STS  _countDebTmp_G002,R30
; 0002 008E 
; 0002 008F        if (countDebTmp > BUT_COUNT_THR){
	LDS  R26,_countDebTmp_G002
	CPI  R26,LOW(0x6)
	BRLO _0x40007
; 0002 0090           if (!(stateTmp & FLAG_BUT_PRESSED)){
	SBRC R17,0
	RJMP _0x40008
; 0002 0091              stateTmp |= FLAG_BUT_PRESSED;
	ORI  R17,LOW(1)
; 0002 0092 
; 0002 0093 #if (BUT_PRESSED_EN == 1)
; 0002 0094              SaveEvent_m(settings, BUT_EV_PRESSED, BUT_PRESSED_CODE, event);
	LDD  R30,Y+2
	ANDI R30,LOW(0x1)
	BREQ _0x4000C
	LDI  R16,LOW(1)
_0x4000C:
; 0002 0095 #endif
; 0002 0096           }
; 0002 0097        }
_0x40008:
; 0002 0098 
; 0002 0099        if (countDebTmp > BUT_COUNT_HELD){
_0x40007:
	LDS  R26,_countDebTmp_G002
	CPI  R26,LOW(0x15)
	BRLO _0x4000D
; 0002 009A          if (!(stateTmp & FLAG_BUT_HOLD)){
	SBRC R17,1
	RJMP _0x4000E
; 0002 009B             stateTmp &= ~(FLAG_BUT_RELEASED);
	ANDI R17,LOW(251)
; 0002 009C             stateTmp |= FLAG_BUT_HOLD;
	ORI  R17,LOW(2)
; 0002 009D 
; 0002 009E #if (BUT_HELD_EN == 1)
; 0002 009F             SaveEvent_m(settings, BUT_EV_HELD, BUT_HELD_CODE, event);
	LDD  R30,Y+2
	ANDI R30,LOW(0x2)
	BREQ _0x40012
	LDI  R16,LOW(2)
_0x40012:
; 0002 00A0 #endif
; 0002 00A1          }
; 0002 00A2        }
_0x4000E:
; 0002 00A3     }
_0x4000D:
; 0002 00A4   }
_0x40006:
; 0002 00A5   else{
	RJMP _0x40013
_0x40005:
; 0002 00A6 
; 0002 00A7 #if (BUT_DOUBLE_CLICK_EN == 1)
; 0002 00A8      if ((stateTmp & FLAG_BUT_PRESSED)&&(!(stateTmp & FLAG_BUT_HOLD))){
; 0002 00A9 
; 0002 00AA        if (stateTmp & FLAG_BUT_RELEASED){
; 0002 00AB           stateTmp &= ~FLAG_BUT_RELEASED;
; 0002 00AC           SaveEvent_m(settings, BUT_EV_DOUBLE_CLICK, BUT_DOUBLE_CLICK_CODE, event);
; 0002 00AD        }
; 0002 00AE        else{
; 0002 00AF           countHoldTmp = 0;
; 0002 00B0           stateTmp |= FLAG_BUT_RELEASED;
; 0002 00B1        }
; 0002 00B2      }
; 0002 00B3 
; 0002 00B4      if (stateTmp & FLAG_BUT_RELEASED){
; 0002 00B5         if (countHoldTmp > BUT_COUNT_THR_2){
; 0002 00B6            countHoldTmp = 0;
; 0002 00B7            stateTmp &= ~FLAG_BUT_RELEASED;
; 0002 00B8   #if (BUT_RELEASED_EN == 1)
; 0002 00B9            SaveEvent_m(settings, BUT_EV_RELEASED, BUT_RELEASED_CODE, event);
; 0002 00BA   #endif
; 0002 00BB         }
; 0002 00BC      }
; 0002 00BD #else
; 0002 00BE      if ((stateTmp & FLAG_BUT_PRESSED)&&(!(stateTmp & FLAG_BUT_HOLD))){
	SBRS R17,0
	RJMP _0x40015
	SBRS R17,1
	RJMP _0x40016
_0x40015:
	RJMP _0x40014
_0x40016:
; 0002 00BF         SaveEvent_m(settings, BUT_EV_RELEASED, BUT_RELEASED_CODE, event);
	LDD  R30,Y+2
	ANDI R30,LOW(0x4)
	BREQ _0x4001A
	LDI  R16,LOW(3)
_0x4001A:
; 0002 00C0      }
; 0002 00C1 #endif
; 0002 00C2 
; 0002 00C3 #if (BUT_RELEASE_LONG_EN == 1)
; 0002 00C4      if ((stateTmp & FLAG_BUT_PRESSED)&&(stateTmp & FLAG_BUT_HOLD)){
; 0002 00C5         SaveEvent_m(settings, BUT_EV_RELEASED_LONG, BUT_RELEASED_LONG_CODE, event);
; 0002 00C6      }
; 0002 00C7 #endif
; 0002 00C8 
; 0002 00C9      countDebTmp = 0;
_0x40014:
	LDI  R30,LOW(0)
	STS  _countDebTmp_G002,R30
; 0002 00CA      stateTmp &= ~(FLAG_BUT_PRESSED|FLAG_BUT_HOLD);
	ANDI R17,LOW(252)
; 0002 00CB   }
_0x40013:
; 0002 00CC 
; 0002 00CD 
; 0002 00CE 
; 0002 00CF #if (BUT_DOUBLE_CLICK_EN == 1)
; 0002 00D0   if (stateTmp & FLAG_BUT_RELEASED){
; 0002 00D1      if (countHoldTmp < BUT_COUNT_THR_2_MAX){
; 0002 00D2         countHoldTmp++;
; 0002 00D3      }
; 0002 00D4   }
; 0002 00D5 
; 0002 00D6   countHold[i] = countHoldTmp;
; 0002 00D7 #endif
; 0002 00D8 
; 0002 00D9   if (event){
	CPI  R16,0
	BREQ _0x4001B
; 0002 00DA      PutBut(i+1);
	LDD  R26,Y+3
	SUBI R26,-LOW(1)
	RCALL _PutBut_G002
; 0002 00DB      PutBut(event);
	MOV  R26,R16
	RCALL _PutBut_G002
; 0002 00DC   }
; 0002 00DD 
; 0002 00DE   countDeb[i] = countDebTmp;
_0x4001B:
	CALL SUBOPT_0xF
	SUBI R30,LOW(-_countDeb_G002)
	SBCI R31,HIGH(-_countDeb_G002)
	LDS  R26,_countDebTmp_G002
	STD  Z+0,R26
; 0002 00DF   stateBut[i] = stateTmp;
	CALL SUBOPT_0xF
	SUBI R30,LOW(-_stateBut_G002)
	SBCI R31,HIGH(-_stateBut_G002)
	ST   Z,R17
; 0002 00E0 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
;
;/******************************************************/
;
;void BUT_Init(void)
; 0002 00E5 {
_BUT_Init:
; 0002 00E6   uint8_t i;
; 0002 00E7 
; 0002 00E8   for(i = 0; i < BUT_AMOUNT; i++){
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x4001D:
	CPI  R17,4
	BRSH _0x4001E
; 0002 00E9      countDeb[i] = 0;
	CALL SUBOPT_0x10
	SUBI R30,LOW(-_countDeb_G002)
	SBCI R31,HIGH(-_countDeb_G002)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0002 00EA      stateBut[i] = 0;
	CALL SUBOPT_0x10
	SUBI R30,LOW(-_stateBut_G002)
	SBCI R31,HIGH(-_stateBut_G002)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0002 00EB 
; 0002 00EC #if (BUT_DOUBLE_CLICK_EN == 1)
; 0002 00ED      countHold[i] = 0;
; 0002 00EE #endif
; 0002 00EF 
; 0002 00F0   }
	SUBI R17,-1
	RJMP _0x4001D
_0x4001E:
; 0002 00F1 
; 0002 00F2   for(i = 0; i < BUT_SIZE_BUF; i++){
	LDI  R17,LOW(0)
_0x40020:
	CPI  R17,8
	BRSH _0x40021
; 0002 00F3      buf[i] = 0;
	MOV  R30,R17
	CALL SUBOPT_0xE
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0002 00F4   }
	SUBI R17,-1
	RJMP _0x40020
_0x40021:
; 0002 00F5 
; 0002 00F6   head = 0;
	LDI  R30,LOW(0)
	STS  _head_G002,R30
; 0002 00F7   tail = 0;
	STS  _tail_G002,R30
; 0002 00F8   count = 0;
	STS  _count_G002,R30
; 0002 00F9 
; 0002 00FA #ifdef BUT_1_ID
; 0002 00FB   ButtonInit_m(BUT_1_DDRX, BUT_1_PORTX, BUT_1_PIN, BUT_1_PULL);
	CBI  0x1A,0
	CBI  0x1B,0
; 0002 00FC #endif
; 0002 00FD 
; 0002 00FE #ifdef BUT_2_ID
; 0002 00FF   ButtonInit_m(BUT_2_DDRX, BUT_2_PORTX, BUT_2_PIN, BUT_2_PULL);
	CBI  0x1A,1
	CBI  0x1B,1
; 0002 0100 #endif
; 0002 0101 
; 0002 0102 #ifdef BUT_3_ID
; 0002 0103   ButtonInit_m(BUT_3_DDRX, BUT_3_PORTX, BUT_3_PIN, BUT_3_PULL);
	CBI  0x1A,4
	CBI  0x1B,4
; 0002 0104 #endif
; 0002 0105 
; 0002 0106 #ifdef BUT_4_ID
; 0002 0107   ButtonInit_m(BUT_4_DDRX, BUT_4_PORTX, BUT_4_PIN, BUT_4_PULL);
	CBI  0x1A,5
	CBI  0x1B,5
; 0002 0108 #endif
; 0002 0109 
; 0002 010A #ifdef BUT_5_ID
; 0002 010B   ButtonInit_m(BUT_5_DDRX, BUT_5_PORTX, BUT_5_PIN, BUT_5_PULL);
; 0002 010C #endif
; 0002 010D 
; 0002 010E #ifdef BUT_6_ID
; 0002 010F   ButtonInit_m(BUT_6_DDRX, BUT_6_PORTX, BUT_6_PIN, BUT_6_PULL);
; 0002 0110 #endif
; 0002 0111 
; 0002 0112 #ifdef BUT_7_ID
; 0002 0113   ButtonInit_m(BUT_7_DDRX, BUT_7_PORTX, BUT_7_PIN, BUT_7_PULL);
; 0002 0114 #endif
; 0002 0115 
; 0002 0116 #ifdef BUT_8_ID
; 0002 0117   ButtonInit_m(BUT_8_DDRX, BUT_8_PORTX, BUT_8_PIN, BUT_8_PULL);
; 0002 0118 #endif
; 0002 0119 
; 0002 011A #ifdef BUT_9_ID
; 0002 011B   ButtonInit_m(BUT_9_DDRX, BUT_9_PORTX, BUT_9_PIN, BUT_9_PULL);
; 0002 011C #endif
; 0002 011D 
; 0002 011E #ifdef BUT_10_ID
; 0002 011F   ButtonInit_m(BUT_10_DDRX, BUT_10_PORTX, BUT_10_PIN, BUT_10_PULL);
; 0002 0120 #endif
; 0002 0121 
; 0002 0122 #ifdef BUT_11_ID
; 0002 0123   ButtonInit_m(BUT_11_DDRX, BUT_11_PORTX, BUT_11_PIN, BUT_11_PULL);
; 0002 0124 #endif
; 0002 0125 
; 0002 0126 #ifdef BUT_12_ID
; 0002 0127   ButtonInit_m(BUT_12_DDRX, BUT_12_PORTX, BUT_12_PIN, BUT_12_PULL);
; 0002 0128 #endif
; 0002 0129 
; 0002 012A #ifdef BUT_13_ID
; 0002 012B   ButtonInit_m(BUT_13_DDRX, BUT_13_PORTX, BUT_13_PIN, BUT_13_PULL);
; 0002 012C #endif
; 0002 012D 
; 0002 012E #ifdef BUT_14_ID
; 0002 012F   ButtonInit_m(BUT_14_DDRX, BUT_14_PORTX, BUT_14_PIN, BUT_14_PULL);
; 0002 0130 #endif
; 0002 0131 
; 0002 0132 #ifdef BUT_15_ID
; 0002 0133   ButtonInit_m(BUT_15_DDRX, BUT_15_PORTX, BUT_15_PIN, BUT_15_PULL);
; 0002 0134 #endif
; 0002 0135 
; 0002 0136 #ifdef BUT_16_ID
; 0002 0137   ButtonInit_m(BUT_16_DDRX, BUT_16_PORTX, BUT_16_PIN, BUT_16_PULL);
; 0002 0138 #endif
; 0002 0139 
; 0002 013A #ifdef BUT_17_ID
; 0002 013B   ButtonInit_m(BUT_17_DDRX, BUT_17_PORTX, BUT_17_PIN, BUT_17_PULL);
; 0002 013C #endif
; 0002 013D 
; 0002 013E #ifdef BUT_18_ID
; 0002 013F   ButtonInit_m(BUT_18_DDRX, BUT_18_PORTX, BUT_18_PIN, BUT_18_PULL);
; 0002 0140 #endif
; 0002 0141 
; 0002 0142 #ifdef BUT_19_ID
; 0002 0143   ButtonInit_m(BUT_19_DDRX, BUT_19_PORTX, BUT_19_PIN, BUT_19_PULL);
; 0002 0144 #endif
; 0002 0145 
; 0002 0146 #ifdef BUT_20_ID
; 0002 0147   ButtonInit_m(BUT_20_DDRX, BUT_20_PORTX, BUT_20_PIN, BUT_20_PULL);
; 0002 0148 #endif
; 0002 0149 
; 0002 014A #ifdef BUT_21_ID
; 0002 014B   ButtonInit_m(BUT_21_DDRX, BUT_21_PORTX, BUT_21_PIN, BUT_21_PULL);
; 0002 014C #endif
; 0002 014D 
; 0002 014E #ifdef BUT_22_ID
; 0002 014F   ButtonInit_m(BUT_22_DDRX, BUT_22_PORTX, BUT_22_PIN, BUT_22_PULL);
; 0002 0150 #endif
; 0002 0151 
; 0002 0152 #ifdef BUT_23_ID
; 0002 0153   ButtonInit_m(BUT_23_DDRX, BUT_23_PORTX, BUT_23_PIN, BUT_23_PULL);
; 0002 0154 #endif
; 0002 0155 
; 0002 0156 #ifdef BUT_24_ID
; 0002 0157   ButtonInit_m(BUT_24_DDRX, BUT_24_PORTX, BUT_24_PIN, BUT_24_PULL);
; 0002 0158 #endif
; 0002 0159 
; 0002 015A #ifdef BUT_25_ID
; 0002 015B   ButtonInit_m(BUT_25_DDRX, BUT_25_PORTX, BUT_25_PIN, BUT_25_PULL);
; 0002 015C #endif
; 0002 015D 
; 0002 015E #ifdef BUT_26_ID
; 0002 015F   ButtonInit_m(BUT_26_DDRX, BUT_26_PORTX, BUT_26_PIN, BUT_26_PULL);
; 0002 0160 #endif
; 0002 0161 
; 0002 0162 #ifdef BUT_27_ID
; 0002 0163   ButtonInit_m(BUT_27_DDRX, BUT_27_PORTX, BUT_27_PIN, BUT_27_PULL);
; 0002 0164 #endif
; 0002 0165 
; 0002 0166 #ifdef BUT_28_ID
; 0002 0167   ButtonInit_m(BUT_28_DDRX, BUT_28_PORTX, BUT_28_PIN, BUT_28_PULL);
; 0002 0168 #endif
; 0002 0169 
; 0002 016A #ifdef BUT_29_ID
; 0002 016B   ButtonInit_m(BUT_29_DDRX, BUT_29_PORTX, BUT_29_PIN, BUT_29_PULL);
; 0002 016C #endif
; 0002 016D 
; 0002 016E #ifdef BUT_30_ID
; 0002 016F   ButtonInit_m(BUT_30_DDRX, BUT_30_PORTX, BUT_30_PIN, BUT_30_PULL);
; 0002 0170 #endif
; 0002 0171 
; 0002 0172 #ifdef BUT_31_ID
; 0002 0173   ButtonInit_m(BUT_31_DDRX, BUT_31_PORTX, BUT_31_PIN, BUT_31_PULL);
; 0002 0174 #endif
; 0002 0175 
; 0002 0176 #ifdef BUT_32_ID
; 0002 0177   ButtonInit_m(BUT_32_DDRX, BUT_32_PORTX, BUT_32_PIN, BUT_32_PULL);
; 0002 0178 #endif
; 0002 0179 }
	RJMP _0x20A0017
;
;/**********************************************/
;
;void BUT_Poll(void)
; 0002 017E {
_BUT_Poll:
; 0002 017F #if (BUT_POLL_ROTATION > 0)
; 0002 0180   static uint8_t i = 0;
; 0002 0181 #endif
; 0002 0182 
; 0002 0183   uint8_t state = 0;
; 0002 0184 
; 0002 0185   Switch_m(i);
; 0002 0186 
; 0002 0187 #ifdef BUT_1_ID
; 0002 0188   CheckOneBut_m(BUT_1_ID, BUT_1_PINX, BUT_1_PIN, BUT_1_LEV, BUT_1_EVENT, state);
	ST   -Y,R17
;	state -> R17
	LDI  R17,0
	SBIC 0x19,0
	RJMP _0x40036
	LDI  R17,LOW(1)
	RJMP _0x40037
_0x40036:
	LDI  R17,LOW(0)
_0x40037:
	ST   -Y,R17
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _BUT_Check_G002
; 0002 0189 #endif
; 0002 018A 
; 0002 018B #ifdef BUT_2_ID
; 0002 018C   CheckOneBut_m(BUT_2_ID, BUT_2_PINX, BUT_2_PIN, BUT_2_LEV, BUT_2_EVENT, state);
	SBIC 0x19,1
	RJMP _0x40038
	LDI  R17,LOW(1)
	RJMP _0x40039
_0x40038:
	LDI  R17,LOW(0)
_0x40039:
	ST   -Y,R17
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _BUT_Check_G002
; 0002 018D #endif
; 0002 018E 
; 0002 018F #ifdef BUT_3_ID
; 0002 0190   CheckOneBut_m(BUT_3_ID, BUT_3_PINX, BUT_3_PIN, BUT_3_LEV, BUT_3_EVENT, state);
	SBIC 0x19,4
	RJMP _0x4003A
	LDI  R17,LOW(1)
	RJMP _0x4003B
_0x4003A:
	LDI  R17,LOW(0)
_0x4003B:
	ST   -Y,R17
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _BUT_Check_G002
; 0002 0191 #endif
; 0002 0192 
; 0002 0193 #ifdef BUT_4_ID
; 0002 0194   CheckOneBut_m(BUT_4_ID, BUT_4_PINX, BUT_4_PIN, BUT_4_LEV, BUT_4_EVENT, state);
	SBIC 0x19,5
	RJMP _0x4003C
	LDI  R17,LOW(1)
	RJMP _0x4003D
_0x4003C:
	LDI  R17,LOW(0)
_0x4003D:
	ST   -Y,R17
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _BUT_Check_G002
; 0002 0195 #endif
; 0002 0196 
; 0002 0197 #ifdef BUT_5_ID
; 0002 0198   CheckOneBut_m(BUT_5_ID, BUT_5_PINX, BUT_5_PIN, BUT_5_LEV, BUT_5_EVENT, state);
; 0002 0199 #endif
; 0002 019A 
; 0002 019B #ifdef BUT_6_ID
; 0002 019C   CheckOneBut_m(BUT_6_ID, BUT_6_PINX, BUT_6_PIN, BUT_6_LEV, BUT_6_EVENT, state);
; 0002 019D #endif
; 0002 019E 
; 0002 019F #ifdef BUT_7_ID
; 0002 01A0   CheckOneBut_m(BUT_7_ID, BUT_7_PINX, BUT_7_PIN, BUT_7_LEV, BUT_7_EVENT, state);
; 0002 01A1 #endif
; 0002 01A2 
; 0002 01A3 #ifdef BUT_8_ID
; 0002 01A4   CheckOneBut_m(BUT_8_ID, BUT_8_PINX, BUT_8_PIN, BUT_8_LEV, BUT_8_EVENT, state);
; 0002 01A5 #endif
; 0002 01A6 
; 0002 01A7 #ifdef BUT_9_ID
; 0002 01A8   CheckOneBut_m(BUT_9_ID, BUT_9_PINX, BUT_9_PIN, BUT_9_LEV, BUT_9_EVENT, state);
; 0002 01A9 #endif
; 0002 01AA 
; 0002 01AB #ifdef BUT_10_ID
; 0002 01AC   CheckOneBut_m(BUT_10_ID, BUT_10_PINX, BUT_10_PIN, BUT_10_LEV, BUT_10_EVENT, state);
; 0002 01AD #endif
; 0002 01AE 
; 0002 01AF #ifdef BUT_11_ID
; 0002 01B0   CheckOneBut_m(BUT_11_ID, BUT_11_PINX, BUT_11_PIN, BUT_11_LEV, BUT_11_EVENT, state);
; 0002 01B1 #endif
; 0002 01B2 
; 0002 01B3 #ifdef BUT_12_ID
; 0002 01B4   CheckOneBut_m(BUT_12_ID, BUT_12_PINX, BUT_12_PIN, BUT_12_LEV, BUT_12_EVENT, state);
; 0002 01B5 #endif
; 0002 01B6 
; 0002 01B7 #ifdef BUT_13_ID
; 0002 01B8   CheckOneBut_m(BUT_13_ID, BUT_13_PINX, BUT_13_PIN, BUT_13_LEV, BUT_13_EVENT, state);
; 0002 01B9 #endif
; 0002 01BA 
; 0002 01BB #ifdef BUT_14_ID
; 0002 01BC   CheckOneBut_m(BUT_14_ID, BUT_14_PINX, BUT_14_PIN, BUT_14_LEV, BUT_14_EVENT, state);
; 0002 01BD #endif
; 0002 01BE 
; 0002 01BF #ifdef BUT_15_ID
; 0002 01C0   CheckOneBut_m(BUT_15_ID, BUT_15_PINX, BUT_15_PIN, BUT_15_LEV, BUT_15_EVENT, state);
; 0002 01C1 #endif
; 0002 01C2 
; 0002 01C3 #ifdef BUT_16_ID
; 0002 01C4   CheckOneBut_m(BUT_16_ID, BUT_16_PINX, BUT_16_PIN, BUT_16_LEV, BUT_16_EVENT, state);
; 0002 01C5 #endif
; 0002 01C6 
; 0002 01C7 #ifdef BUT_17_ID
; 0002 01C8   CheckOneBut_m(BUT_17_ID, BUT_17_PINX, BUT_17_PIN, BUT_17_LEV, BUT_17_EVENT, state);
; 0002 01C9 #endif
; 0002 01CA 
; 0002 01CB #ifdef BUT_18_ID
; 0002 01CC   CheckOneBut_m(BUT_18_ID, BUT_18_PINX, BUT_18_PIN, BUT_18_LEV, BUT_18_EVENT, state);
; 0002 01CD #endif
; 0002 01CE 
; 0002 01CF #ifdef BUT_19_ID
; 0002 01D0   CheckOneBut_m(BUT_19_ID, BUT_19_PINX, BUT_19_PIN, BUT_19_LEV, BUT_19_EVENT, state);
; 0002 01D1 #endif
; 0002 01D2 
; 0002 01D3 #ifdef BUT_20_ID
; 0002 01D4   CheckOneBut_m(BUT_20_ID, BUT_20_PINX, BUT_20_PIN, BUT_20_LEV, BUT_20_EVENT, state);
; 0002 01D5 #endif
; 0002 01D6 
; 0002 01D7 #ifdef BUT_21_ID
; 0002 01D8   CheckOneBut_m(BUT_21_ID, BUT_21_PINX, BUT_21_PIN, BUT_21_LEV, BUT_21_EVENT, state);
; 0002 01D9 #endif
; 0002 01DA 
; 0002 01DB #ifdef BUT_22_ID
; 0002 01DC   CheckOneBut_m(BUT_22_ID, BUT_22_PINX, BUT_22_PIN, BUT_22_LEV, BUT_22_EVENT, state);
; 0002 01DD #endif
; 0002 01DE 
; 0002 01DF #ifdef BUT_23_ID
; 0002 01E0   CheckOneBut_m(BUT_23_ID, BUT_23_PINX, BUT_23_PIN, BUT_23_LEV, BUT_23_EVENT, state);
; 0002 01E1 #endif
; 0002 01E2 
; 0002 01E3 #ifdef BUT_24_ID
; 0002 01E4   CheckOneBut_m(BUT_24_ID, BUT_24_PINX, BUT_24_PIN, BUT_24_LEV, BUT_24_EVENT, state);
; 0002 01E5 #endif
; 0002 01E6 
; 0002 01E7 #ifdef BUT_25_ID
; 0002 01E8   CheckOneBut_m(BUT_25_ID, BUT_25_PINX, BUT_25_PIN, BUT_25_LEV, BUT_25_EVENT, state);
; 0002 01E9 #endif
; 0002 01EA 
; 0002 01EB #ifdef BUT_26_ID
; 0002 01EC   CheckOneBut_m(BUT_26_ID, BUT_26_PINX, BUT_26_PIN, BUT_26_LEV, BUT_26_EVENT, state);
; 0002 01ED #endif
; 0002 01EE 
; 0002 01EF #ifdef BUT_27_ID
; 0002 01F0   CheckOneBut_m(BUT_27_ID, BUT_27_PINX, BUT_27_PIN, BUT_27_LEV, BUT_27_EVENT, state);
; 0002 01F1 #endif
; 0002 01F2 
; 0002 01F3 #ifdef BUT_28_ID
; 0002 01F4   CheckOneBut_m(BUT_28_ID, BUT_28_PINX, BUT_28_PIN, BUT_28_LEV, BUT_28_EVENT, state);
; 0002 01F5 #endif
; 0002 01F6 
; 0002 01F7 #ifdef BUT_29_ID
; 0002 01F8   CheckOneBut_m(BUT_29_ID, BUT_29_PINX, BUT_29_PIN, BUT_29_LEV, BUT_29_EVENT, state);
; 0002 01F9 #endif
; 0002 01FA 
; 0002 01FB #ifdef BUT_30_ID
; 0002 01FC   CheckOneBut_m(BUT_30_ID, BUT_30_PINX, BUT_30_PIN, BUT_30_LEV, BUT_30_EVENT, state);
; 0002 01FD #endif
; 0002 01FE 
; 0002 01FF #ifdef BUT_31_ID
; 0002 0200   CheckOneBut_m(BUT_31_ID, BUT_31_PINX, BUT_31_PIN, BUT_31_LEV, BUT_31_EVENT, state);
; 0002 0201 #endif
; 0002 0202 
; 0002 0203 #ifdef BUT_32_ID
; 0002 0204   CheckOneBut_m(BUT_32_ID, BUT_32_PINX, BUT_32_PIN, BUT_32_LEV, BUT_32_EVENT, state);
; 0002 0205 #endif
; 0002 0206 
; 0002 0207    End_m();
; 0002 0208 
; 0002 0209 #if (BUT_POLL_ROTATION > 0)
; 0002 020A    i++;
; 0002 020B    if (i >= BUT_AMOUNT){
; 0002 020C      i = 0;
; 0002 020D    }
; 0002 020E #endif
; 0002 020F 
; 0002 0210 }
	RJMP _0x20A0017
;
;
;#include <circlebuffer.h>
;#include <handlers.h>
;
;//кольцевой буфер
;static volatile unsigned char cycleBuf[SIZE_BUF];
;static unsigned char tailBuf = 0;
;static unsigned char headBuf = 0;
;static volatile unsigned char countBuf = 0;
;
;
;//возвращает колличество событий находящихся в буфере
;unsigned char ES_GetCount(void)
; 0003 000E {

	.CSEG
; 0003 000F   return countBuf;
; 0003 0010 }
;
;//"очищает" буфер
;void ES_FlushBuf(void)
; 0003 0014 {
; 0003 0015   tailBuf = 0;
; 0003 0016   headBuf = 0;
; 0003 0017   countBuf = 0;
; 0003 0018 }
;
;//взять событие
;unsigned char ES_GetEvent(void)
; 0003 001C {
_ES_GetEvent:
; 0003 001D   unsigned char event;
; 0003 001E   if (countBuf > 0){                    //если приемный буфер не пустой
	ST   -Y,R17
;	event -> R17
	LDS  R26,_countBuf_G003
	CPI  R26,LOW(0x1)
	BRLO _0x60003
; 0003 001F     event = cycleBuf[headBuf];          //считать из него событие
	CALL SUBOPT_0x11
	LD   R17,Z
; 0003 0020     countBuf--;                         //уменьшить счетчик
	LDS  R30,_countBuf_G003
	SUBI R30,LOW(1)
	STS  _countBuf_G003,R30
; 0003 0021     headBuf++;                          //инкрементировать индекс головы буфера
	LDS  R30,_headBuf_G003
	SUBI R30,-LOW(1)
	STS  _headBuf_G003,R30
; 0003 0022     if (headBuf == SIZE_BUF) headBuf = 0;
	LDS  R26,_headBuf_G003
	CPI  R26,LOW(0x20)
	BRNE _0x60004
	LDI  R30,LOW(0)
	STS  _headBuf_G003,R30
; 0003 0023     return event;                         //вернуть событие
_0x60004:
	MOV  R30,R17
	RJMP _0x20A0017
; 0003 0024   }
; 0003 0025   return 0;
_0x60003:
	LDI  R30,LOW(0)
_0x20A0017:
	LD   R17,Y+
	RET
; 0003 0026 }
;
;//положить событие
;void ES_PlaceEvent(unsigned char event)
; 0003 002A {
_ES_PlaceEvent:
; 0003 002B   if (countBuf < SIZE_BUF){                    //если в буфере еще есть место
	ST   -Y,R26
;	event -> Y+0
	LDS  R26,_countBuf_G003
	CPI  R26,LOW(0x20)
	BRSH _0x60005
; 0003 002C       cycleBuf[tailBuf] = event;               //кинуть событие в буфер
	LDS  R30,_tailBuf_G003
	LDI  R31,0
	SUBI R30,LOW(-_cycleBuf_G003)
	SBCI R31,HIGH(-_cycleBuf_G003)
	LD   R26,Y
	STD  Z+0,R26
; 0003 002D       tailBuf++;                               //увеличить индекс хвоста буфера
	LDS  R30,_tailBuf_G003
	SUBI R30,-LOW(1)
	STS  _tailBuf_G003,R30
; 0003 002E       if (tailBuf == SIZE_BUF) tailBuf = 0;
	LDS  R26,_tailBuf_G003
	CPI  R26,LOW(0x20)
	BRNE _0x60006
	LDI  R30,LOW(0)
	STS  _tailBuf_G003,R30
; 0003 002F       countBuf++;                              //увеличить счетчик
_0x60006:
	LDS  R30,_countBuf_G003
	SUBI R30,-LOW(1)
	STS  _countBuf_G003,R30
; 0003 0030   }
; 0003 0031 }
_0x60005:
	RJMP _0x20A0016
;
;void ES_PlaceHeadEvent(unsigned char event)
; 0003 0034 {
_ES_PlaceHeadEvent:
; 0003 0035   if (countBuf < SIZE_BUF){                    //если в буфере еще есть место
	ST   -Y,R26
;	event -> Y+0
	LDS  R26,_countBuf_G003
	CPI  R26,LOW(0x20)
	BRSH _0x60007
; 0003 0036       if (headBuf == 0){
	LDS  R30,_headBuf_G003
	CPI  R30,0
	BRNE _0x60008
; 0003 0037         headBuf = SIZE_BUF - 1;
	LDI  R30,LOW(31)
	RJMP _0x6000B
; 0003 0038       }else {
_0x60008:
; 0003 0039         headBuf --;
	LDS  R30,_headBuf_G003
	SUBI R30,LOW(1)
_0x6000B:
	STS  _headBuf_G003,R30
; 0003 003A       }
; 0003 003B       cycleBuf[headBuf] = event;               //кинуть событие в начало буфера
	CALL SUBOPT_0x11
	LD   R26,Y
	STD  Z+0,R26
; 0003 003C       countBuf++;                              //увеличить счетчик
	LDS  R30,_countBuf_G003
	SUBI R30,-LOW(1)
	STS  _countBuf_G003,R30
; 0003 003D   }
; 0003 003E }
_0x60007:
_0x20A0016:
	ADIW R28,1
	RET
;
;//массив указателей на функции-обработчики
;void (*FuncAr[])(void) =
;{
;  HandlerEventButUp,
;  HandlerEventButDown,
;  HandlerEventButEnter,
;  HandlerEventButEsc,
;  HandlerEventTimer_1s,
;  HandlerEventTimer_250ms,
;  HandlerEventTimer_10ms,
;  HandlerEventButLUp,
;  HandlerEventButLDown,
;  HandlerEventTimer_10s,
;  HandlerEventTimer_1Hz
;};

	.DSEG
;
;//++++++++++++++++++++++++++++++++++++++++++
;void ES_Dispatch(unsigned char event)
; 0003 0052 {

	.CSEG
_ES_Dispatch:
; 0003 0053   void (*pFunc)(void);
; 0003 0054   pFunc = FuncAr[event-1];
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	event -> Y+2
;	*pFunc -> R16,R17
	LDD  R30,Y+2
	LDI  R31,0
	SBIW R30,1
	LDI  R26,LOW(_FuncAr)
	LDI  R27,HIGH(_FuncAr)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R16,X+
	LD   R17,X
; 0003 0055   pFunc();
	MOVW R30,R16
	ICALL
; 0003 0056 }
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20A0015:
	ADIW R28,3
	RET
;#include <handlers.h>
;#include <circlebuffer.h>
;#include <nokia1100_lcd_lib.h>
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
;#include <buttons.h>
;#include <stdio.h>
;#include <menu.h>
;#include <settings.h>
;#include <general.h>
;#include <hwinit.h>
;
;#include <OWIPolled.h>
;#include <OWIHighLevelFunctions.h>
;#include <OWIBitFunctions.h>
;#include <OWIcrc.h>
;#include <stdlib.h>
;
;extern OWI_device ds1820_rom_codes[MAX_DS1820];
;extern OWI_device t_rom_codes[MAX_DS1820];
;
;char buf[20]; //17
;float t_kuba, t_kolona_down, t_kolona_up;
;float t_kuba_old, t_kolona_down_old, t_kolona_up_old;
;#ifdef HW1_P
;float p_kolona;
;#endif
;float headDisp;
;float t_kuba_avg, t_kuba_sum;
;char t_kuba_count;
;char abortProcess = 0;
;char startStop = 0;
;char pressureOver = 0;
;char timerOn = 0;
;char timerSignOn = 0;
;unsigned int timer = 0;
;unsigned int timer_off = 0;
;unsigned int timerSign = 0;
;unsigned int impulseCounterCalibrate;
;unsigned char mode = MENU;

	.DSEG
;float Votb;
;unsigned int ssCounter = 0;
;unsigned char ssTrig = 0;
;unsigned char distSettingMode = DIST_SET_MODE_PWR;
;unsigned char distValveMode = DIST_VLV_MODE_CLS;
;
;flash unsigned char valve_cls_lbs[] = {"З"};
;flash unsigned char valve_reg_lbs[] = {"Р"};
;flash unsigned char valve_opn_lbs[] = {"О"};
;flash unsigned char * flash valve_lbs[3] = {valve_cls_lbs, valve_reg_lbs, valve_opn_lbs};
;
;void CalculateDistBodySpeed();
;
;//*****************************************************************************
;// основные подпрограммы  Дистиляции
;//*****************************************************************************
;void RunDistilation(){
; 0004 0037 void RunDistilation(){

	.CSEG
_RunDistilation:
; 0004 0038     nlcd_Clear();
	CALL _nlcd_Clear
; 0004 0039     if ((t_rom_codes[0].id[0] == 0xFF) || (t_rom_codes[0].id[0] == 0x00)) {
	LDS  R26,_t_rom_codes
	CPI  R26,LOW(0xFF)
	BREQ _0x80005
	CPI  R26,LOW(0x0)
	BRNE _0x80004
_0x80005:
; 0004 003A         nlcd_GotoXY(0,0);
	CALL SUBOPT_0x2
; 0004 003B         nlcd_PrintF("Нет назначенных");
	__POINTW2MN _0x80007,0
	CALL _nlcd_PrintF
; 0004 003C         nlcd_PrintF("   датчиков    ");
	__POINTW2MN _0x80007,16
	CALL _nlcd_PrintF
; 0004 003D         nlcd_PrintF("    t куба!    ");
	__POINTW2MN _0x80007,32
	RJMP _0x20A0014
; 0004 003E         delay_ms(5000);
; 0004 003F         nlcd_Clear();
; 0004 0040         print_menu();
; 0004 0041         return;
; 0004 0042     }
; 0004 0043      // t колоны верх
; 0004 0044     if ((t_rom_codes[2].id[0] == 0xFF) || (t_rom_codes[2].id[0] == 0x00)) {
_0x80004:
	__GETB2MN _t_rom_codes,16
	CPI  R26,LOW(0xFF)
	BREQ _0x80009
	__GETB2MN _t_rom_codes,16
	CPI  R26,LOW(0x0)
	BRNE _0x80008
_0x80009:
; 0004 0045         nlcd_GotoXY(0,0);
	CALL SUBOPT_0x2
; 0004 0046         nlcd_PrintF("Нет назначенных");
	__POINTW2MN _0x80007,48
	CALL _nlcd_PrintF
; 0004 0047         nlcd_PrintF("   датчиков    ");
	__POINTW2MN _0x80007,64
	CALL _nlcd_PrintF
; 0004 0048         nlcd_PrintF("t колоны верх! ");
	__POINTW2MN _0x80007,80
	RJMP _0x20A0014
; 0004 0049         delay_ms(5000);
; 0004 004A         nlcd_Clear();
; 0004 004B         print_menu();
; 0004 004C         return;
; 0004 004D     }
; 0004 004E 
; 0004 004F     OWI_SearchDevices(ds1820_rom_codes, MAX_DS1820, BUS, &ds1820_devices);
_0x80008:
	CALL SUBOPT_0x5
; 0004 0050     if (ds1820_devices < 2) { // < 3
	LDS  R26,_ds1820_devices
	CPI  R26,LOW(0x2)
	BRSH _0x8000B
; 0004 0051         nlcd_GotoXY(0,0);
	CALL SUBOPT_0x2
; 0004 0052         nlcd_PrintF(" Подключены не ");
	__POINTW2MN _0x80007,96
	CALL _nlcd_PrintF
; 0004 0053         nlcd_PrintF("  все датчики  ");
	__POINTW2MN _0x80007,112
	CALL _nlcd_PrintF
; 0004 0054         nlcd_PrintF(" или отключены ");
	__POINTW2MN _0x80007,128
	CALL _nlcd_PrintF
; 0004 0055         nlcd_PrintF(" полностью все!");
	__POINTW2MN _0x80007,144
	RJMP _0x20A0014
; 0004 0056         delay_ms(5000);
; 0004 0057         nlcd_Clear();
; 0004 0058         print_menu();
; 0004 0059         return;
; 0004 005A     }
; 0004 005B     /*
; 0004 005C     if (ds1820_devices == 0) {
; 0004 005D         nlcd_GotoXY(0,0);
; 0004 005E         nlcd_PrintF("Нет подключенных");
; 0004 005F         nlcd_PrintF(" датчиков !!!");
; 0004 0060         delay_ms(5000);
; 0004 0061         nlcd_Clear();
; 0004 0062         print_menu();
; 0004 0063         return;
; 0004 0064     }
; 0004 0065      */
; 0004 0066     if (InitSensor(t_rom_codes[0].id, BUS, 25, 35, DS18B20_11BIT_RES)) {
_0x8000B:
	CALL SUBOPT_0x12
	BREQ _0x8000C
; 0004 0067         nlcd_GotoXY(0,0);
	CALL SUBOPT_0x2
; 0004 0068         nlcd_PrintF("   Не верный   ");
	__POINTW2MN _0x80007,160
	CALL _nlcd_PrintF
; 0004 0069         nlcd_PrintF("    датчик     ");
	__POINTW2MN _0x80007,176
	CALL _nlcd_PrintF
; 0004 006A         nlcd_PrintF("    t куба!    ");
	__POINTW2MN _0x80007,192
	RJMP _0x20A0014
; 0004 006B         delay_ms(5000);
; 0004 006C         nlcd_Clear();
; 0004 006D         print_menu();
; 0004 006E         return;
; 0004 006F     }
; 0004 0070 
; 0004 0071     if (InitSensor(t_rom_codes[1].id, BUS, 25, 35, DS18B20_11BIT_RES)) {
_0x8000C:
	CALL SUBOPT_0x13
	BREQ _0x8000D
; 0004 0072         nlcd_GotoXY(0,0);
	CALL SUBOPT_0x2
; 0004 0073         nlcd_PrintF("    Не верный   ");
	__POINTW2MN _0x80007,208
	CALL _nlcd_PrintF
; 0004 0074         nlcd_PrintF("     датчик     ");
	__POINTW2MN _0x80007,225
	CALL _nlcd_PrintF
; 0004 0075         nlcd_PrintF(" t колоны верх! ");
	__POINTW2MN _0x80007,242
	RJMP _0x20A0014
; 0004 0076         delay_ms(5000);
; 0004 0077         nlcd_Clear();
; 0004 0078         print_menu();
; 0004 0079         return;
; 0004 007A     }
; 0004 007B 
; 0004 007C    // if (!InitSensor(t_rom_codes[0].id, BUS, 25, 35, DS18B20_11BIT_RES)) {
; 0004 007D         sec = 0;
_0x8000D:
	CALL SUBOPT_0x14
; 0004 007E         minutes = 0;
; 0004 007F         hours = 0;
; 0004 0080         Votb = 1200.0; //  мл/ч
	__GETD1N 0x44960000
	CALL SUBOPT_0x15
; 0004 0081         CalculateDistBodySpeed();
	RCALL _CalculateDistBodySpeed
; 0004 0082         heater_power = dis_p_ten;
	LDS  R30,_dis_p_ten
	STS  _heater_power,R30
; 0004 0083         VALVE_CLS;
	CBI  0x1B,3
; 0004 0084         mode = RUN_DIST;
	LDI  R30,LOW(4)
	RJMP _0x20A0013
; 0004 0085    /* } else {
; 0004 0086         nlcd_GotoXY(0,0);
; 0004 0087         nlcd_PrintF(" Не верный ");
; 0004 0088         nlcd_PrintF(" датчик !!!");
; 0004 0089         delay_ms(5000);
; 0004 008A         nlcd_Clear();
; 0004 008B         print_menu();
; 0004 008C     }   */
; 0004 008D 
; 0004 008E }

	.DSEG
_0x80007:
	.BYTE 0x103
;
;void ViewDistilation(){
; 0004 0090 void ViewDistilation(){

	.CSEG
_ViewDistilation:
; 0004 0091 unsigned char tkuba_c[2] = {" "};
; 0004 0092 unsigned char tkol_up_c[2] = {" "};
; 0004 0093 unsigned char tmp[3];
; 0004 0094    if (abortProcess) {
	SBIW R28,7
	LDI  R30,LOW(32)
	STD  Y+3,R30
	LDI  R30,LOW(0)
	STD  Y+4,R30
	LDI  R30,LOW(32)
	STD  Y+5,R30
	LDI  R30,LOW(0)
	STD  Y+6,R30
;	tkuba_c -> Y+5
;	tkol_up_c -> Y+3
;	tmp -> Y+0
	LDS  R30,_abortProcess
	CPI  R30,0
	BREQ _0x8000E
; 0004 0095       //nlcd_Clear();
; 0004 0096       nlcd_GotoXY(0,1);
	CALL SUBOPT_0x16
; 0004 0097       nlcd_PrintF("   Дистиляция   ");
	__POINTW2MN _0x8000F,0
	CALL _nlcd_PrintF
; 0004 0098       nlcd_GotoXY(0,2);
	CALL SUBOPT_0x3
; 0004 0099       nlcd_PrintF("Прервать");
	__POINTW2MN _0x8000F,17
	CALL SUBOPT_0x17
; 0004 009A       nlcd_GotoXY(0,3);
	LDI  R26,LOW(3)
	CALL _nlcd_GotoXY
; 0004 009B       nlcd_PrintF("процесс?");
	__POINTW2MN _0x8000F,26
	CALL SUBOPT_0x17
; 0004 009C       nlcd_GotoXY(0,4);
	LDI  R26,LOW(4)
	CALL _nlcd_GotoXY
; 0004 009D       nlcd_PrintF("<ENT>Да <ESC>Нет");
	__POINTW2MN _0x8000F,35
	CALL _nlcd_PrintF
; 0004 009E    } else {
	RJMP _0x80010
_0x8000E:
; 0004 009F        if (t_kuba - t_kuba_old >= DELTA){ // Температура растет
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	BRLO _0x80011
; 0004 00A0         tkuba_c[0] = 30;   // up
	LDI  R30,LOW(30)
	RJMP _0x80103
; 0004 00A1       } else if (t_kuba - t_kuba_old <= -DELTA){  // Температура падает
_0x80011:
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	BREQ PC+4
	BRCS PC+3
	JMP  _0x80013
; 0004 00A2         tkuba_c[0] = 31;   // down
	LDI  R30,LOW(31)
	RJMP _0x80103
; 0004 00A3       } else {
_0x80013:
; 0004 00A4         tkuba_c[0] = ' ';
	LDI  R30,LOW(32)
_0x80103:
	STD  Y+5,R30
; 0004 00A5       }
; 0004 00A6 
; 0004 00A7       if (t_kolona_up - t_kolona_up_old >= DELTA){ // Температура растет
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x19
	BRLO _0x80015
; 0004 00A8         tkol_up_c[0] = 30; // up
	LDI  R30,LOW(30)
	RJMP _0x80104
; 0004 00A9       } else if (t_kolona_up - t_kolona_up_old <= -DELTA){  // Температура падает
_0x80015:
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1A
	BREQ PC+4
	BRCS PC+3
	JMP  _0x80017
; 0004 00AA         tkol_up_c[0] = 31;; // down
	LDI  R30,LOW(31)
	RJMP _0x80104
; 0004 00AB       } else {
_0x80017:
; 0004 00AC         tkol_up_c[0] = ' ';
	LDI  R30,LOW(32)
_0x80104:
	STD  Y+3,R30
; 0004 00AD       }
; 0004 00AE 
; 0004 00AF       #ifdef P_SENS_ON
; 0004 00B0         p_kolona = ((signed int)(read_adc(0)) - p_offset) * 4.88 / 7.511 / 13.5954348;
; 0004 00B1       #endif
; 0004 00B2 
; 0004 00B3       nlcd_GotoXY(3,0);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x1C
; 0004 00B4       nlcd_PrintF("Дистилляция");
	__POINTW2MN _0x8000F,52
	CALL SUBOPT_0x1D
; 0004 00B5       nlcd_GotoXY(1,2);
	CALL SUBOPT_0x1E
; 0004 00B6       sprintf(buf, "Время:%2i:%2i:%2i", hours, minutes, sec);
	CALL SUBOPT_0x1F
; 0004 00B7       nlcd_Print(buf);
; 0004 00B8       nlcd_GotoXY(1,3);
	CALL SUBOPT_0x20
; 0004 00B9       sprintf(buf,"tкол в %-3.2f %s", t_kolona_up, tkol_up_c);
	CALL SUBOPT_0x21
	MOVW R30,R28
	ADIW R30,11
	CALL SUBOPT_0x22
; 0004 00BA       nlcd_Print(buf);
; 0004 00BB       nlcd_GotoXY(1,4);
	CALL SUBOPT_0x23
; 0004 00BC       sprintf(buf,"tкуба  %-3.2f %s", t_kuba, tkuba_c);
	MOVW R30,R28
	ADIW R30,13
	CALL SUBOPT_0x22
; 0004 00BD       nlcd_Print(buf);
; 0004 00BE       #ifdef P_SENS_ON
; 0004 00BF           nlcd_GotoXY(1,5);
; 0004 00C0           sprintf(buf, "P%+3.1f", p_kolona);
; 0004 00C1           nlcd_Print(buf);
; 0004 00C2       #endif
; 0004 00C3       //------ Состояние клапана
; 0004 00C4       nlcd_GotoXY(0,6);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x24
; 0004 00C5       strcpyf(tmp, valve_lbs[distValveMode]);
	LDS  R30,_distValveMode
	LDI  R26,LOW(_valve_lbs*2)
	LDI  R27,HIGH(_valve_lbs*2)
	CALL SUBOPT_0x25
; 0004 00C6       sprintf(buf, "%cКл-%s %c%4.0f мл/ч",(distSettingMode == DIST_SET_MODE_VALV)?'>':' ',tmp,(distSettingMode == DIST_SET_MODE_FLOW)?'>':' ', Votb);
	__POINTW1FN _0x80000,327
	ST   -Y,R31
	ST   -Y,R30
	LDS  R26,_distSettingMode
	CPI  R26,LOW(0x1)
	BRNE _0x80019
	LDI  R30,LOW(62)
	RJMP _0x8001A
_0x80019:
	LDI  R30,LOW(32)
_0x8001A:
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
	LDS  R26,_distSettingMode
	CPI  R26,LOW(0x2)
	BRNE _0x8001C
	LDI  R30,LOW(62)
	RJMP _0x8001D
_0x8001C:
	LDI  R30,LOW(32)
_0x8001D:
	CALL SUBOPT_0x26
	CALL SUBOPT_0x28
	CALL __PUTPARD1
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
; 0004 00C7       nlcd_Print(buf);
	CALL SUBOPT_0x9
; 0004 00C8       // ТЭН
; 0004 00C9       nlcd_GotoXY(0,7);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x29
; 0004 00CA       sprintf(buf,"%cТЭН %3i%%", (distSettingMode == DIST_SET_MODE_PWR)?'>':' ', heater_power);
	CALL SUBOPT_0x2A
	__POINTW1FN _0x80000,348
	ST   -Y,R31
	ST   -Y,R30
	LDS  R26,_distSettingMode
	CPI  R26,LOW(0x0)
	BRNE _0x8001F
	LDI  R30,LOW(62)
	RJMP _0x80020
_0x8001F:
	LDI  R30,LOW(32)
_0x80020:
	CALL SUBOPT_0x26
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0004 00CB       nlcd_Print(buf);
	CALL SUBOPT_0x9
; 0004 00CC 
; 0004 00CD     }
_0x80010:
; 0004 00CE }
	ADIW R28,7
	RET

	.DSEG
_0x8000F:
	.BYTE 0x40
;//*****************************************************************************
;// основные подпрограммы  Ректификации
;//*****************************************************************************
;void RunRectification(){
; 0004 00D2 void RunRectification(){

	.CSEG
_RunRectification:
; 0004 00D3     nlcd_Clear();
	CALL _nlcd_Clear
; 0004 00D4     // t куба
; 0004 00D5     if ((t_rom_codes[0].id[0] == 0xFF) || (t_rom_codes[0].id[0] == 0x00)) {
	LDS  R26,_t_rom_codes
	CPI  R26,LOW(0xFF)
	BREQ _0x80023
	CPI  R26,LOW(0x0)
	BRNE _0x80022
_0x80023:
; 0004 00D6         nlcd_GotoXY(0,0);
	CALL SUBOPT_0x2
; 0004 00D7         nlcd_PrintF("Нет назначенных");
	__POINTW2MN _0x80025,0
	CALL _nlcd_PrintF
; 0004 00D8         nlcd_PrintF("   датчиков    ");
	__POINTW2MN _0x80025,16
	CALL _nlcd_PrintF
; 0004 00D9         nlcd_PrintF("    t куба!    ");
	__POINTW2MN _0x80025,32
	RJMP _0x20A0014
; 0004 00DA         delay_ms(5000);
; 0004 00DB         nlcd_Clear();
; 0004 00DC         print_menu();
; 0004 00DD         return;
; 0004 00DE     }
; 0004 00DF     // t колоны низ
; 0004 00E0     if ((t_rom_codes[1].id[0] == 0xFF) || (t_rom_codes[1].id[0] == 0x00)) {
_0x80022:
	__GETB2MN _t_rom_codes,8
	CPI  R26,LOW(0xFF)
	BREQ _0x80027
	__GETB2MN _t_rom_codes,8
	CPI  R26,LOW(0x0)
	BRNE _0x80026
_0x80027:
; 0004 00E1         nlcd_GotoXY(0,0);
	CALL SUBOPT_0x2
; 0004 00E2         nlcd_PrintF("Нет назначенных");
	__POINTW2MN _0x80025,48
	CALL _nlcd_PrintF
; 0004 00E3         nlcd_PrintF("   датчиков    ");
	__POINTW2MN _0x80025,64
	CALL _nlcd_PrintF
; 0004 00E4         nlcd_PrintF(" t колоны низ! ");
	__POINTW2MN _0x80025,80
	RJMP _0x20A0014
; 0004 00E5         delay_ms(5000);
; 0004 00E6         nlcd_Clear();
; 0004 00E7         print_menu();
; 0004 00E8         return;
; 0004 00E9     }
; 0004 00EA     // t колоны верх
; 0004 00EB     if ((t_rom_codes[2].id[0] == 0xFF) || (t_rom_codes[2].id[0] == 0x00)) {
_0x80026:
	__GETB2MN _t_rom_codes,16
	CPI  R26,LOW(0xFF)
	BREQ _0x8002A
	__GETB2MN _t_rom_codes,16
	CPI  R26,LOW(0x0)
	BRNE _0x80029
_0x8002A:
; 0004 00EC         nlcd_GotoXY(0,0);
	CALL SUBOPT_0x2
; 0004 00ED         nlcd_PrintF("Нет назначенных");
	__POINTW2MN _0x80025,96
	CALL _nlcd_PrintF
; 0004 00EE         nlcd_PrintF("   датчиков    ");
	__POINTW2MN _0x80025,112
	CALL _nlcd_PrintF
; 0004 00EF         nlcd_PrintF("t колоны верх! ");
	__POINTW2MN _0x80025,128
	RJMP _0x20A0014
; 0004 00F0         delay_ms(5000);
; 0004 00F1         nlcd_Clear();
; 0004 00F2         print_menu();
; 0004 00F3         return;
; 0004 00F4     }
; 0004 00F5     OWI_SearchDevices(ds1820_rom_codes, MAX_DS1820, BUS, &ds1820_devices);
_0x80029:
	CALL SUBOPT_0x5
; 0004 00F6     if (ds1820_devices < 3) { // < 3
	LDS  R26,_ds1820_devices
	CPI  R26,LOW(0x3)
	BRSH _0x8002C
; 0004 00F7         nlcd_GotoXY(0,0);
	CALL SUBOPT_0x2
; 0004 00F8         nlcd_PrintF(" Подключены не ");
	__POINTW2MN _0x80025,144
	CALL _nlcd_PrintF
; 0004 00F9         nlcd_PrintF("  все датчики  ");
	__POINTW2MN _0x80025,160
	CALL _nlcd_PrintF
; 0004 00FA         nlcd_PrintF(" или отключены ");
	__POINTW2MN _0x80025,176
	CALL _nlcd_PrintF
; 0004 00FB         nlcd_PrintF(" полностью все!");
	__POINTW2MN _0x80025,192
	RJMP _0x20A0014
; 0004 00FC         delay_ms(5000);
; 0004 00FD         nlcd_Clear();
; 0004 00FE         print_menu();
; 0004 00FF         return;
; 0004 0100     }
; 0004 0101 
; 0004 0102     if (InitSensor(t_rom_codes[0].id, BUS, 25, 35, DS18B20_11BIT_RES)) {
_0x8002C:
	CALL SUBOPT_0x12
	BREQ _0x8002D
; 0004 0103         nlcd_GotoXY(0,0);
	CALL SUBOPT_0x2
; 0004 0104         nlcd_PrintF("   Не верный   ");
	__POINTW2MN _0x80025,208
	CALL _nlcd_PrintF
; 0004 0105         nlcd_PrintF("    датчик     ");
	__POINTW2MN _0x80025,224
	CALL _nlcd_PrintF
; 0004 0106         nlcd_PrintF("    t куба!    ");
	__POINTW2MN _0x80025,240
	RJMP _0x20A0014
; 0004 0107         delay_ms(5000);
; 0004 0108         nlcd_Clear();
; 0004 0109         print_menu();
; 0004 010A         return;
; 0004 010B     }
; 0004 010C 
; 0004 010D     if (InitSensor(t_rom_codes[1].id, BUS, 25, 35, DS18B20_11BIT_RES)) {
_0x8002D:
	CALL SUBOPT_0x13
	BREQ _0x8002E
; 0004 010E         nlcd_GotoXY(0,0);
	CALL SUBOPT_0x2
; 0004 010F         nlcd_PrintF("    Не верный   ");
	__POINTW2MN _0x80025,256
	CALL _nlcd_PrintF
; 0004 0110         nlcd_PrintF("     датчик     ");
	__POINTW2MN _0x80025,273
	CALL _nlcd_PrintF
; 0004 0111         nlcd_PrintF(" t колоны верх! ");
	__POINTW2MN _0x80025,290
	RJMP _0x20A0014
; 0004 0112         delay_ms(5000);
; 0004 0113         nlcd_Clear();
; 0004 0114         print_menu();
; 0004 0115         return;
; 0004 0116     }
; 0004 0117 
; 0004 0118     if (InitSensor(t_rom_codes[2].id, BUS, 25, 35, DS18B20_11BIT_RES)) {
_0x8002E:
	CALL SUBOPT_0x2D
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(25)
	ST   -Y,R30
	LDI  R30,LOW(35)
	ST   -Y,R30
	LDI  R26,LOW(95)
	CALL _InitSensor
	CPI  R30,0
	BREQ _0x8002F
; 0004 0119         nlcd_GotoXY(0,0);
	CALL SUBOPT_0x2
; 0004 011A         nlcd_PrintF("   Не верный   ");
	__POINTW2MN _0x80025,307
	CALL _nlcd_PrintF
; 0004 011B         nlcd_PrintF("    датчик     ");
	__POINTW2MN _0x80025,323
	CALL _nlcd_PrintF
; 0004 011C         nlcd_PrintF(" t колоны низ! ");
	__POINTW2MN _0x80025,339
_0x20A0014:
	CALL _nlcd_PrintF
; 0004 011D         delay_ms(5000);
	LDI  R26,LOW(5000)
	LDI  R27,HIGH(5000)
	CALL _delay_ms
; 0004 011E         nlcd_Clear();
	CALL SUBOPT_0x2E
; 0004 011F         print_menu();
; 0004 0120         return;
	RET
; 0004 0121     }
; 0004 0122 
; 0004 0123     sec = 0;
_0x8002F:
	CALL SUBOPT_0x14
; 0004 0124     minutes = 0;
; 0004 0125     hours = 0;
; 0004 0126     heater_power = 100;
	LDI  R30,LOW(100)
	STS  _heater_power,R30
; 0004 0127     VALVE_CLS;
	CBI  0x1B,3
; 0004 0128     impulseCounter = 0;
	CALL SUBOPT_0x2F
; 0004 0129     ssCounter = 0;
	CALL SUBOPT_0x30
; 0004 012A     ssTrig = 0;
; 0004 012B     startStop = 0;
	LDI  R30,LOW(0)
	STS  _startStop,R30
; 0004 012C     mode = RUN_RECT;
	LDI  R30,LOW(5)
_0x20A0013:
	STS  _mode,R30
; 0004 012D }
	RET

	.DSEG
_0x80025:
	.BYTE 0x163
;
;void ViewRectification(){
; 0004 012F void ViewRectification(){

	.CSEG
_ViewRectification:
; 0004 0130 unsigned char tkuba_c[2] = {" "};
; 0004 0131 unsigned char tkol_up_c[2] = {" "};
; 0004 0132 unsigned char tkol_down_c[2] = {" "};
; 0004 0133 unsigned char tmp[17];
; 0004 0134 
; 0004 0135    if (abortProcess) {
	SBIW R28,23
	LDI  R30,LOW(32)
	STD  Y+17,R30
	LDI  R30,LOW(0)
	STD  Y+18,R30
	LDI  R30,LOW(32)
	STD  Y+19,R30
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R30,LOW(32)
	STD  Y+21,R30
	LDI  R30,LOW(0)
	STD  Y+22,R30
;	tkuba_c -> Y+21
;	tkol_up_c -> Y+19
;	tkol_down_c -> Y+17
;	tmp -> Y+0
	LDS  R30,_abortProcess
	CPI  R30,0
	BREQ _0x80030
; 0004 0136       //nlcd_Clear();
; 0004 0137       nlcd_GotoXY(2,1);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _nlcd_GotoXY
; 0004 0138       nlcd_PrintF("Ректификация");
	__POINTW2MN _0x80031,0
	CALL SUBOPT_0x31
; 0004 0139       nlcd_GotoXY(4,2);
	LDI  R26,LOW(2)
	CALL _nlcd_GotoXY
; 0004 013A       nlcd_PrintF("Прервать");
	__POINTW2MN _0x80031,13
	CALL SUBOPT_0x31
; 0004 013B       nlcd_GotoXY(4,3);
	LDI  R26,LOW(3)
	CALL _nlcd_GotoXY
; 0004 013C       nlcd_PrintF("процесс?");
	__POINTW2MN _0x80031,22
	CALL SUBOPT_0x17
; 0004 013D       nlcd_GotoXY(0,4);
	LDI  R26,LOW(4)
	CALL _nlcd_GotoXY
; 0004 013E       nlcd_PrintF("<ENT>Да <ESC>Нет");
	__POINTW2MN _0x80031,31
	CALL _nlcd_PrintF
; 0004 013F    } else {
	RJMP _0x80032
_0x80030:
; 0004 0140 
; 0004 0141       if (t_kuba - t_kuba_old >= DELTA){ // Температура растет
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	BRLO _0x80033
; 0004 0142         tkuba_c[0] = 30;   // up
	LDI  R30,LOW(30)
	RJMP _0x80105
; 0004 0143       } else if (t_kuba - t_kuba_old <= -DELTA){  // Температура падает
_0x80033:
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	BREQ PC+4
	BRCS PC+3
	JMP  _0x80035
; 0004 0144         tkuba_c[0] = 31;   // down
	LDI  R30,LOW(31)
	RJMP _0x80105
; 0004 0145       } else {
_0x80035:
; 0004 0146         tkuba_c[0] = ' ';
	LDI  R30,LOW(32)
_0x80105:
	STD  Y+21,R30
; 0004 0147       }
; 0004 0148 
; 0004 0149       if (t_kolona_down - t_kolona_down_old >= DELTA){ // Температура растет
	CALL SUBOPT_0x32
	CALL SUBOPT_0x19
	BRLO _0x80037
; 0004 014A         tkol_down_c[0] = 30; // up
	LDI  R30,LOW(30)
	RJMP _0x80106
; 0004 014B       } else if (t_kolona_down - t_kolona_down_old <= -DELTA){  // Температура падает
_0x80037:
	CALL SUBOPT_0x32
	CALL SUBOPT_0x1A
	BREQ PC+4
	BRCS PC+3
	JMP  _0x80039
; 0004 014C         tkol_down_c[0] = 31; // down
	LDI  R30,LOW(31)
	RJMP _0x80106
; 0004 014D       } else {
_0x80039:
; 0004 014E         tkol_down_c[0] = ' ';
	LDI  R30,LOW(32)
_0x80106:
	STD  Y+17,R30
; 0004 014F       }
; 0004 0150 
; 0004 0151       if (t_kolona_up - t_kolona_up_old >= DELTA){ // Температура растет
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x19
	BRLO _0x8003B
; 0004 0152         tkol_up_c[0] = 30; // up
	LDI  R30,LOW(30)
	RJMP _0x80107
; 0004 0153       } else if (t_kolona_up - t_kolona_up_old <= -DELTA){  // Температура падает
_0x8003B:
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1A
	BREQ PC+4
	BRCS PC+3
	JMP  _0x8003D
; 0004 0154         tkol_up_c[0] = 31;; // down
	LDI  R30,LOW(31)
	RJMP _0x80107
; 0004 0155       } else {
_0x8003D:
; 0004 0156         tkol_up_c[0] = ' ';
	LDI  R30,LOW(32)
_0x80107:
	STD  Y+19,R30
; 0004 0157       }
; 0004 0158 
; 0004 0159       #ifdef P_SENS_ON
; 0004 015A         p_kolona = ((signed int)(read_adc(0)) - p_offset) * 4.88 / 7.511 / 13.5954348;
; 0004 015B       #endif
; 0004 015C 
; 0004 015D       //nlcd_GotoXY(1,0);
; 0004 015E      // nlcd_PrintF("  Процесс");
; 0004 015F       nlcd_GotoXY(1,0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x1C
; 0004 0160       nlcd_PrintF(" Ректификация");
	__POINTW2MN _0x80031,48
	CALL SUBOPT_0x1D
; 0004 0161       nlcd_GotoXY(1,1);
	LDI  R26,LOW(1)
	CALL SUBOPT_0x33
; 0004 0162       sprintf(buf, "Время:%2i:%2i:%2i", hours, minutes, sec);
	CALL SUBOPT_0x1F
; 0004 0163       nlcd_Print(buf);
; 0004 0164       nlcd_GotoXY(1,2);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL SUBOPT_0x1E
; 0004 0165       sprintf(buf,"tкол в %-3.2f %s", t_kolona_up, tkol_up_c);
	CALL SUBOPT_0x21
	MOVW R30,R28
	ADIW R30,27
	CALL SUBOPT_0x22
; 0004 0166       nlcd_Print(buf);
; 0004 0167       nlcd_GotoXY(1,3);
	CALL SUBOPT_0x20
; 0004 0168       sprintf(buf,"tкол н %-3.2f %s", t_kolona_down, tkol_down_c);
	__POINTW1FN _0x80000,403
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x34
	CALL __PUTPARD1
	MOVW R30,R28
	ADIW R30,25
	CALL SUBOPT_0x22
; 0004 0169       nlcd_Print(buf);
; 0004 016A       nlcd_GotoXY(1,4);
	CALL SUBOPT_0x23
; 0004 016B       sprintf(buf,"tкуба  %-3.2f %s", t_kuba, tkuba_c); //t_kuba_avg
	MOVW R30,R28
	ADIW R30,29
	CALL SUBOPT_0x22
; 0004 016C       nlcd_Print(buf);
; 0004 016D       nlcd_GotoXY(0,5);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x8
; 0004 016E       nlcd_PrintF("                "); // clear line :) it's not good
	__POINTW2MN _0x80031,62
	CALL _nlcd_PrintF
; 0004 016F       #ifdef P_SENS_ON
; 0004 0170           nlcd_GotoXY(1,5);
; 0004 0171           sprintf(buf, "P%+3.1f", p_kolona);
; 0004 0172           nlcd_Print(buf);
; 0004 0173       #endif
; 0004 0174       nlcd_GotoXY(8,5);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x8
; 0004 0175       sprintf(buf, "ТЭН%3i%%", heater_power);
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x35
	CALL SUBOPT_0x7
; 0004 0176       nlcd_Print(buf);
	CALL SUBOPT_0x9
; 0004 0177 
; 0004 0178       nlcd_GotoXY(1,6);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x24
; 0004 0179       strcpyf(tmp, yesno[startStop]);
	LDS  R30,_startStop
	LDI  R26,LOW(_yesno*2)
	LDI  R27,HIGH(_yesno*2)
	CALL SUBOPT_0x25
; 0004 017A       //sprintf(buf, "СтартСтоп %s", tmp);
; 0004 017B       sprintf(buf, "С\\С %s К %i", tmp, ssCounter);
	__POINTW1FN _0x80000,446
	CALL SUBOPT_0x36
	LDS  R30,_ssCounter
	LDS  R31,_ssCounter+1
	CALL SUBOPT_0x22
; 0004 017C       nlcd_Print(buf);
; 0004 017D       nlcd_GotoXY(1,7);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x29
; 0004 017E       if (startStop) {
	LDS  R30,_startStop
	CPI  R30,0
	BREQ _0x8003F
; 0004 017F           sprintf(buf, "Vт %4.0f мл/ч", Votb);
	CALL SUBOPT_0x2A
	__POINTW1FN _0x80000,458
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x28
	RJMP _0x80108
; 0004 0180       } else {
_0x8003F:
; 0004 0181           sprintf(buf, "Qг %4.2f мл", headDisp);
	CALL SUBOPT_0x2A
	__POINTW1FN _0x80000,472
	CALL SUBOPT_0x37
_0x80108:
	CALL __PUTPARD1
	CALL SUBOPT_0x7
; 0004 0182       }
; 0004 0183       nlcd_Print(buf);
	CALL SUBOPT_0x9
; 0004 0184 
; 0004 0185       // Debug
; 0004 0186       /*
; 0004 0187       nlcd_GotoXY(1,6);
; 0004 0188       sprintf(buf, "SS %i PWM %i", startStop, pwmOn);
; 0004 0189       nlcd_Print(buf);
; 0004 018A       nlcd_GotoXY(1,7);
; 0004 018B       sprintf(buf, "P%i T%i", valvePulse, pwmPeriod);
; 0004 018C       nlcd_Print(buf);
; 0004 018D        */
; 0004 018E     }
_0x80032:
; 0004 018F }
	ADIW R28,23
	RET

	.DSEG
_0x80031:
	.BYTE 0x4F
;//*****************************************************************************
;// Расчет параметров ШИМ
;//*****************************************************************************
;void CalculateHead() {
; 0004 0193 void CalculateHead() {

	.CSEG
_CalculateHead:
; 0004 0194    float Votb_fact;
; 0004 0195    valvePulse = DEFAUL_VALVE_PULSE; // смотри параметр в general.h
	SBIW R28,4
;	Votb_fact -> Y+0
	LDI  R30,LOW(4)
	STS  _valvePulse,R30
; 0004 0196    impulseCounter = 0;
	CALL SUBOPT_0x2F
; 0004 0197    Votb_fact = -0.000163  *HEADSPEED * HEADSPEED + 1.156 * HEADSPEED + 1.198;
	__GETD1N 0x42B94505
	RJMP _0x20A0012
; 0004 0198    pwmPeriod = ((float)valvePulse * onePulseDose) / (Votb_fact / 3600.0) * 100.0 ; // расчет периода ШИМ
; 0004 0199 }
;
;void CalculateBodySpeed() {
; 0004 019B void CalculateBodySpeed() {
_CalculateBodySpeed:
; 0004 019C     float Votb_fact;
; 0004 019D     valvePulse = rect_pulse_delay;  // Длительность импульса берем из параметров
	SBIW R28,4
;	Votb_fact -> Y+0
	LDS  R30,_rect_pulse_delay
	STS  _valvePulse,R30
; 0004 019E     if (t_kuba_avg >= 84.3F) {
	LDS  R26,_t_kuba_avg
	LDS  R27,_t_kuba_avg+1
	LDS  R24,_t_kuba_avg+2
	LDS  R25,_t_kuba_avg+3
	__GETD1N 0x42A8999A
	CALL __CMPF12
	BRLO _0x80041
; 0004 019F         Votb = ((980.0 - 10.0 * t_kuba_avg) / 137.0) * (float)rect_body_speed ;   //Считаем скорость отбора в зависимости от темпеартуры в кубе
	LDS  R30,_t_kuba_avg
	LDS  R31,_t_kuba_avg+1
	LDS  R22,_t_kuba_avg+2
	LDS  R23,_t_kuba_avg+3
	CALL SUBOPT_0x38
	CALL __MULF12
	__GETD2N 0x44750000
	CALL SUBOPT_0x39
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x43090000
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x3A
	CALL __MULF12
	RJMP _0x80109
; 0004 01A0     } else {
_0x80041:
; 0004 01A1         Votb = (float)rect_body_speed;  //Считаем скорость отбора
	CALL SUBOPT_0x3A
_0x80109:
	STS  _Votb,R30
	STS  _Votb+1,R31
	STS  _Votb+2,R22
	STS  _Votb+3,R23
; 0004 01A2     }
; 0004 01A3     //pwmPeriod =  ((float)valvePulse * onePulseDose) / ((Votb * 1.35F) / 3600.0) * 100.0;   // считаем период, исходя из скорости отбора, 1.35F для корректировки
; 0004 01A4     //pwmPeriod =  ((float)valvePulse * onePulseDose) / (Votb / 3600.0) * 100.0;   // считаем период, исходя из скорости отбора
; 0004 01A5     Votb_fact = -0.000163 * Votb * Votb + 1.156 * Votb + 1.198;
	RJMP _0x20A0011
; 0004 01A6     pwmPeriod =  ((float)valvePulse * onePulseDose) / (Votb_fact / 3600.0) * 100.0;   // считаем период, исходя из скорости отбора
; 0004 01A7     /*
; 0004 01A8     if (pwmPeriod < valvePulse) // если период ШИМ меньше длительности импульса, то просто открываем клапан
; 0004 01A9     {
; 0004 01AA        pwmPeriod = valvePulse;
; 0004 01AB     }
; 0004 01AC     */
; 0004 01AD }
;
;void CalculateDistBodySpeed() {
; 0004 01AF void CalculateDistBodySpeed() {
_CalculateDistBodySpeed:
; 0004 01B0   float Votb_fact;
; 0004 01B1   Votb_fact = -0.000163 * Votb * Votb + 1.156 * Votb + 1.198;
	SBIW R28,4
;	Votb_fact -> Y+0
_0x20A0011:
	LDS  R30,_Votb
	LDS  R31,_Votb+1
	LDS  R22,_Votb+2
	LDS  R23,_Votb+3
	__GETD2N 0xB92AEAFB
	CALL __MULF12
	CALL SUBOPT_0x3B
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x28
	__GETD2N 0x3F93F7CF
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	__GETD2N 0x3F995810
	CALL __ADDF12
_0x20A0012:
	CALL __PUTD1S0
; 0004 01B2   pwmPeriod =  ((float)valvePulse * onePulseDose) / (Votb_fact / 3600.0) * 100.0;   // считаем период, исходя из скорости отбора
	LDS  R30,_valvePulse
	LDI  R31,0
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL __GETD2S0
	__GETD1N 0x45610000
	CALL __DIVF21
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	__GETD2N 0x42C80000
	CALL __MULF12
	LDI  R26,LOW(_pwmPeriod)
	LDI  R27,HIGH(_pwmPeriod)
	CALL __CFD1U
	ST   X+,R30
	ST   X,R31
; 0004 01B3 }
	ADIW R28,4
	RET
;
;//*****************************************************************************
;// Подпрограмма остановки процесса
;//*****************************************************************************
;
;void StopProcess() {
; 0004 01B9 void StopProcess() {
_StopProcess:
; 0004 01BA      nlcd_Clear();
	CALL _nlcd_Clear
; 0004 01BB      if (mode == RUN_DIST) {
	LDS  R26,_mode
	CPI  R26,LOW(0x4)
	BRNE _0x80043
; 0004 01BC         nlcd_GotoXY(0,1);
	CALL SUBOPT_0x16
; 0004 01BD         nlcd_PrintF("   Дистилляция   ");
	__POINTW2MN _0x80044,0
	CALL _nlcd_PrintF
; 0004 01BE      }
; 0004 01BF      if (mode == RUN_RECT) {
_0x80043:
	LDS  R26,_mode
	CPI  R26,LOW(0x5)
	BRNE _0x80045
; 0004 01C0         nlcd_GotoXY(0,1);
	CALL SUBOPT_0x16
; 0004 01C1         nlcd_PrintF("  Ректификация  ");
	__POINTW2MN _0x80044,18
	CALL _nlcd_PrintF
; 0004 01C2      }
; 0004 01C3      nlcd_GotoXY(1,3);
_0x80045:
	LDI  R30,LOW(1)
	CALL SUBOPT_0x3E
; 0004 01C4      nlcd_PrintWideF("Процесс");
	__POINTW2MN _0x80044,35
	CALL _nlcd_PrintWideF
; 0004 01C5      nlcd_GotoXY(1,4);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x3F
; 0004 01C6      nlcd_PrintWideF("окончен!");
	__POINTW2MN _0x80044,43
	CALL _nlcd_PrintWideF
; 0004 01C7      BEEP_ON;
	LDI  R30,LOW(127)
	OUT  0x31,R30
; 0004 01C8      mode = END_PROC;
	LDI  R30,LOW(0)
	STS  _mode,R30
; 0004 01C9      VALVE_CLS;         // закрываем клапан
	CBI  0x1B,3
; 0004 01CA      heater_power = 0; // выключаем ТЭН
	STS  _heater_power,R30
; 0004 01CB      startStop = 0;
	STS  _startStop,R30
; 0004 01CC      pressureOver = 0;
	CLR  R10
; 0004 01CD      abortProcess = 0;
	STS  _abortProcess,R30
; 0004 01CE      pwmOn = 0;
	RJMP _0x20A0010
; 0004 01CF }

	.DSEG
_0x80044:
	.BYTE 0x34
;//*****************************************************************************
;//                              Калибровка
;//*****************************************************************************
;
;void CalibrateRun() {
; 0004 01D4 void CalibrateRun() {

	.CSEG
_CalibrateRun:
; 0004 01D5 //  предварительные настройки
; 0004 01D6     pwmPeriod = 100; // 1 sec
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	STS  _pwmPeriod,R30
	STS  _pwmPeriod+1,R31
; 0004 01D7     valvePulse = DEFAUL_VALVE_PULSE; // смотри параметр в general.h
	LDI  R30,LOW(4)
	STS  _valvePulse,R30
; 0004 01D8     impulseCounter = 0;
	CALL SUBOPT_0x2F
; 0004 01D9     sec = 0;
	CALL SUBOPT_0x14
; 0004 01DA     minutes = 0;
; 0004 01DB     hours = 0;
; 0004 01DC     abortProcess = 0;
	LDI  R30,LOW(0)
	STS  _abortProcess,R30
; 0004 01DD     heater_power = rect_p_ten_min;
	LDS  R30,_rect_p_ten_min
	STS  _heater_power,R30
; 0004 01DE     mode = CALIBRATE_RUN;
	LDI  R30,LOW(8)
	STS  _mode,R30
; 0004 01DF     impulseCounterCalibrate = (unsigned int)(CALIBRATE_Q / ((float)valvePulse * onePulseDose));
	CALL SUBOPT_0x40
	CALL SUBOPT_0x3D
	__GETD2N 0x42480000
	CALL SUBOPT_0x41
	STS  _impulseCounterCalibrate,R30
	STS  _impulseCounterCalibrate+1,R31
; 0004 01E0     pwmOn = 1;
	LDI  R30,LOW(1)
_0x20A0010:
	STS  _pwmOn,R30
; 0004 01E1 }
	RET
;
;void CalibrateStop(){
; 0004 01E3 void CalibrateStop(){
_CalibrateStop:
; 0004 01E4 // расчет нового коэффициента и его сохранение
; 0004 01E5     heater_power = 0;
	LDI  R30,LOW(0)
	STS  _heater_power,R30
; 0004 01E6     onePulseDose =  (float)factCalibrateQ / (float)((long)valvePulse * (long)impulseCounter);
	LDS  R30,_factCalibrateQ
	LDS  R31,_factCalibrateQ+1
	CALL SUBOPT_0x42
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDS  R26,_valvePulse
	CLR  R27
	CLR  R24
	CLR  R25
	CALL SUBOPT_0x43
	CALL __MULD12
	CALL __CDF1
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x44
; 0004 01E7     SaveParam();
	CALL _SaveParam
; 0004 01E8     abortProcess = 0;
	LDI  R30,LOW(0)
	STS  _abortProcess,R30
; 0004 01E9 }
	RET
;
;void CalibrateView() {
; 0004 01EB void CalibrateView() {
_CalibrateView:
; 0004 01EC     if (abortProcess) {
	LDS  R30,_abortProcess
	CPI  R30,0
	BREQ _0x80046
; 0004 01ED         nlcd_GotoXY(3,1);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _nlcd_GotoXY
; 0004 01EE         nlcd_PrintF("Калибровка");
	__POINTW2MN _0x80047,0
	CALL SUBOPT_0x31
; 0004 01EF         nlcd_GotoXY(4,2);
	LDI  R26,LOW(2)
	CALL _nlcd_GotoXY
; 0004 01F0         nlcd_PrintF("Прервать");
	__POINTW2MN _0x80047,11
	CALL SUBOPT_0x31
; 0004 01F1         nlcd_GotoXY(4,3);
	LDI  R26,LOW(3)
	CALL _nlcd_GotoXY
; 0004 01F2         nlcd_PrintF("процесс?");
	__POINTW2MN _0x80047,20
	CALL SUBOPT_0x17
; 0004 01F3         nlcd_GotoXY(0,4);
	LDI  R26,LOW(4)
	CALL _nlcd_GotoXY
; 0004 01F4         nlcd_PrintF("<ENT>Да <ESC>Нет");
	__POINTW2MN _0x80047,29
	CALL _nlcd_PrintF
; 0004 01F5     } else {
	RJMP _0x80048
_0x80046:
; 0004 01F6         if (impulseCounter >= impulseCounterCalibrate) {     // если закончили калибровку просим ввести реальное значение
	LDS  R30,_impulseCounterCalibrate
	LDS  R31,_impulseCounterCalibrate+1
	LDS  R26,_impulseCounter
	LDS  R27,_impulseCounter+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x80049
; 0004 01F7             pwmOn = 0;
	CALL SUBOPT_0x45
; 0004 01F8             VALVE_CLS;
; 0004 01F9             heater_power = 0;
	LDI  R30,LOW(0)
	STS  _heater_power,R30
; 0004 01FA             factCalibrateQ =  CALIBRATE_Q;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _factCalibrateQ,R30
	STS  _factCalibrateQ+1,R31
; 0004 01FB             param_id = 13;
	LDI  R30,LOW(13)
	CALL SUBOPT_0x46
; 0004 01FC             params[param_id].value = factCalibrateQ;
	LDS  R26,_factCalibrateQ
	LDS  R27,_factCalibrateQ+1
	STD  Z+0,R26
	STD  Z+1,R27
; 0004 01FD             last_menu = current_menu;
	CALL SUBOPT_0x47
; 0004 01FE             last_pos = current_pos;
; 0004 01FF             current_menu = MENU_RECT;
; 0004 0200             current_pos = 11; // Фактический объем
	LDI  R30,LOW(11)
	STS  _current_pos,R30
; 0004 0201             nlcd_Clear();
	CALL _nlcd_Clear
; 0004 0202             mode = CALIBRATE_MOD;
	LDI  R30,LOW(9)
	STS  _mode,R30
; 0004 0203         } else {
	RJMP _0x8004A
_0x80049:
; 0004 0204             nlcd_GotoXY(3,0);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x1C
; 0004 0205             nlcd_PrintF("Калибровка");
	__POINTW2MN _0x80047,46
	CALL SUBOPT_0x1D
; 0004 0206             nlcd_GotoXY(1,1);
	LDI  R26,LOW(1)
	CALL SUBOPT_0x33
; 0004 0207             sprintf(buf,"Время:%2i:%2i:%2i", hours, minutes, sec);
	CALL SUBOPT_0x1F
; 0004 0208             nlcd_Print(buf);
; 0004 0209             nlcd_GotoXY(1,3);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x3E
; 0004 020A             nlcd_PrintF("Отдозированно: ");
	__POINTW2MN _0x80047,57
	CALL _nlcd_PrintF
; 0004 020B             nlcd_GotoXY(3,4);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(4)
	CALL SUBOPT_0x33
; 0004 020C             sprintf(buf, "Q %4.2f мл", headDisp);
	__POINTW1FN _0x80000,563
	CALL SUBOPT_0x37
	CALL SUBOPT_0x48
; 0004 020D             nlcd_Print(buf);
	CALL SUBOPT_0x9
; 0004 020E             nlcd_GotoXY(3,5);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x8
; 0004 020F             sprintf(buf, "k %1.4f мл", onePulseDose);
	CALL SUBOPT_0x2A
	__POINTW1FN _0x80000,574
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_onePulseDose
	LDS  R31,_onePulseDose+1
	LDS  R22,_onePulseDose+2
	LDS  R23,_onePulseDose+3
	CALL SUBOPT_0x48
; 0004 0210             nlcd_Print(buf);
	CALL SUBOPT_0x9
; 0004 0211             nlcd_GotoXY(3,6);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(6)
	CALL SUBOPT_0x33
; 0004 0212             sprintf(buf, "i %i имп.", impulseCounter);
	__POINTW1FN _0x80000,585
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x43
	CALL SUBOPT_0x48
; 0004 0213             nlcd_Print(buf);
	CALL SUBOPT_0x9
; 0004 0214             nlcd_GotoXY(3,7);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x29
; 0004 0215             sprintf(buf, "ТЭН%3i%%", heater_power);
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x35
	CALL SUBOPT_0x7
; 0004 0216             nlcd_Print(buf);
	CALL SUBOPT_0x9
; 0004 0217         }
_0x8004A:
; 0004 0218     }
_0x80048:
; 0004 0219 }
	RET

	.DSEG
_0x80047:
	.BYTE 0x49
;
;
;//*****************************************************************************
;// обработчики событий
;//*****************************************************************************
;void HandlerEventTimer_10s(void) {
; 0004 021F void HandlerEventTimer_10s(void) {

	.CSEG
_HandlerEventTimer_10s:
; 0004 0220 
; 0004 0221     switch(mode) {
	CALL SUBOPT_0x49
; 0004 0222         case RUN_RECT:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x8004D
; 0004 0223                     if (startStop) {
	LDS  R30,_startStop
	CPI  R30,0
	BREQ _0x8004F
; 0004 0224                         t_kuba_avg = t_kuba_sum / (float)t_kuba_count;
	MOV  R30,R11
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x4B
	CALL __DIVF21
	CALL SUBOPT_0x4C
; 0004 0225                         t_kuba_sum = 0.0;
; 0004 0226                         t_kuba_count = 0;
; 0004 0227                         CalculateBodySpeed();
; 0004 0228                     }
; 0004 0229                     break;
_0x8004F:
; 0004 022A     }
_0x8004D:
; 0004 022B }
	RET
;
;
;void HandlerEventTimer_1Hz(void)
; 0004 022F {
_HandlerEventTimer_1Hz:
; 0004 0230    switch(mode) {
	CALL SUBOPT_0x49
; 0004 0231         case RUN_DIST:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x80053
; 0004 0232                         t_kuba_old = t_kuba;
	CALL SUBOPT_0x4D
; 0004 0233                         t_kolona_up_old = t_kolona_up;
	CALL SUBOPT_0x4E
; 0004 0234                         t_kuba = GetTemperatureMatchRom(t_rom_codes[0].id, BUS);
; 0004 0235                         t_kolona_up = GetTemperatureMatchRom(t_rom_codes[2].id, BUS);
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x4F
; 0004 0236                         break;
	RJMP _0x80052
; 0004 0237         case RUN_RECT:
_0x80053:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x80052
; 0004 0238                         t_kuba_old = t_kuba;
	CALL SUBOPT_0x4D
; 0004 0239                         t_kolona_down_old = t_kolona_down;
	CALL SUBOPT_0x34
	STS  _t_kolona_down_old,R30
	STS  _t_kolona_down_old+1,R31
	STS  _t_kolona_down_old+2,R22
	STS  _t_kolona_down_old+3,R23
; 0004 023A                         t_kolona_up_old = t_kolona_up;
	CALL SUBOPT_0x4E
; 0004 023B                         t_kuba = GetTemperatureMatchRom(t_rom_codes[0].id, BUS);
; 0004 023C                         t_kolona_down = GetTemperatureMatchRom(t_rom_codes[1].id, BUS);
	__POINTW1MN _t_rom_codes,8
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(8)
	CALL _GetTemperatureMatchRom
	STS  _t_kolona_down,R30
	STS  _t_kolona_down+1,R31
	STS  _t_kolona_down+2,R22
	STS  _t_kolona_down+3,R23
; 0004 023D                         t_kolona_up = GetTemperatureMatchRom(t_rom_codes[2].id, BUS);
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x4F
; 0004 023E 
; 0004 023F                         t_kuba_sum += t_kuba;
	CALL SUBOPT_0x50
	CALL SUBOPT_0x4B
	CALL __ADDF12
	STS  _t_kuba_sum,R30
	STS  _t_kuba_sum+1,R31
	STS  _t_kuba_sum+2,R22
	STS  _t_kuba_sum+3,R23
; 0004 0240                         t_kuba_count ++;
	INC  R11
; 0004 0241                         break;
; 0004 0242    }
_0x80052:
; 0004 0243    StartAllConvert_T(BUS);
	LDI  R26,LOW(8)
	CALL _StartAllConvert_T
; 0004 0244 }
	RET
;
;
;void HandlerEventTimer_1s(void)
; 0004 0248 {
_HandlerEventTimer_1s:
; 0004 0249     /*
; 0004 024A     if ((heater_watchdog < 90) && heater_power != 0) {
; 0004 024B         HEATER_OFF; // Выключаем ТЭН на случай обрыва детектора нуля
; 0004 024C     }
; 0004 024D     heater_watchdog = 0;
; 0004 024E     */
; 0004 024F 
; 0004 0250     switch(mode) {
	CALL SUBOPT_0x49
; 0004 0251         case RUN_DIST:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x80058
; 0004 0252 
; 0004 0253                         if ((t_kuba >= dis_t_kuba) || timer_off >= 20*60) {  // 20 минут
	LDS  R30,_dis_t_kuba
	LDS  R31,_dis_t_kuba+1
	LDS  R22,_dis_t_kuba+2
	LDS  R23,_dis_t_kuba+3
	CALL SUBOPT_0x51
	CALL __CMPF12
	BRSH _0x8005A
	LDS  R26,_timer_off
	LDS  R27,_timer_off+1
	CPI  R26,LOW(0x4B0)
	LDI  R30,HIGH(0x4B0)
	CPC  R27,R30
	BRLO _0x80059
_0x8005A:
; 0004 0254                         // end process
; 0004 0255                             StopProcess();
	RCALL _StopProcess
; 0004 0256                         }
; 0004 0257                         // управление клапаном
; 0004 0258                         switch(distValveMode){
_0x80059:
	LDS  R30,_distValveMode
	CALL SUBOPT_0x52
; 0004 0259                             case DIST_VLV_MODE_CLS: {
	BRNE _0x8005F
; 0004 025A                                pwmOn = 0;
	CALL SUBOPT_0x45
; 0004 025B                                VALVE_CLS;
; 0004 025C                             break;
	RJMP _0x8005E
; 0004 025D                             }
; 0004 025E 
; 0004 025F                             case DIST_VLV_MODE_REG: {
_0x8005F:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x80060
; 0004 0260                                pwmOn = 1;
	LDI  R30,LOW(1)
	STS  _pwmOn,R30
; 0004 0261                             break;
	RJMP _0x8005E
; 0004 0262                             }
; 0004 0263 
; 0004 0264                             case DIST_VLV_MODE_OPN: {
_0x80060:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x8005E
; 0004 0265                                 pwmOn = 0;
	LDI  R30,LOW(0)
	STS  _pwmOn,R30
; 0004 0266                                 VALVE_OPN;
	SBI  0x1B,3
; 0004 0267                             break;
; 0004 0268                             }
; 0004 0269                         }
_0x8005E:
; 0004 026A 
; 0004 026B                         break;
	RJMP _0x80057
; 0004 026C         case RUN_RECT:
_0x80058:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x80062
; 0004 026D 
; 0004 026E                         if (t_kuba > 60.0) {
	CALL SUBOPT_0x51
	__GETD1N 0x42700000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x80063
; 0004 026F                             heater_power = rect_p_ten_min;
	LDS  R30,_rect_p_ten_min
	STS  _heater_power,R30
; 0004 0270                             #ifdef P_SENS_ON
; 0004 0271                                 if ((p_kolona > rect_p_kol_max) || pressureOver) {
; 0004 0272                                     heater_power -= 10;
; 0004 0273                                     pressureOver = 1;
; 0004 0274                                 }
; 0004 0275                             #endif
; 0004 0276                             if ((fabs(t_kolona_up_old - t_kolona_up) <= 2.0*DELTA) && !startStop && t_kuba > 75.0 && !pwmOn) { // Сигнализация по температуре
	LDS  R26,_t_kolona_up
	LDS  R27,_t_kolona_up+1
	LDS  R24,_t_kolona_up+2
	LDS  R25,_t_kolona_up+3
	LDS  R30,_t_kolona_up_old
	LDS  R31,_t_kolona_up_old+1
	LDS  R22,_t_kolona_up_old+2
	LDS  R23,_t_kolona_up_old+3
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	CALL _fabs
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3E800000
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x80065
	LDS  R30,_startStop
	CPI  R30,0
	BRNE _0x80065
	CALL SUBOPT_0x51
	__GETD1N 0x42960000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x80065
	LDS  R30,_pwmOn
	CPI  R30,0
	BREQ _0x80066
_0x80065:
	RJMP _0x80064
_0x80066:
; 0004 0277                                 if ((timerSign >= 600) && !timerSignOn) { // 10 min
	LDS  R26,_timerSign
	LDS  R27,_timerSign+1
	CPI  R26,LOW(0x258)
	LDI  R30,HIGH(0x258)
	CPC  R27,R30
	BRLO _0x80068
	TST  R13
	BREQ _0x80069
_0x80068:
	RJMP _0x80067
_0x80069:
; 0004 0278                                     timerSignOn = 1;
	LDI  R30,LOW(1)
	MOV  R13,R30
; 0004 0279                                     BEEP_ON;
	LDI  R30,LOW(127)
	OUT  0x31,R30
; 0004 027A                                 } else {
	RJMP _0x8006A
_0x80067:
; 0004 027B                                     timerSign ++;
	LDI  R26,LOW(_timerSign)
	LDI  R27,HIGH(_timerSign)
	CALL SUBOPT_0x1
; 0004 027C                                 }
_0x8006A:
; 0004 027D                             } else {
	RJMP _0x8006B
_0x80064:
; 0004 027E                                 timerSign = 0;
	LDI  R30,LOW(0)
	STS  _timerSign,R30
	STS  _timerSign+1,R30
; 0004 027F                             }
_0x8006B:
; 0004 0280                         }
; 0004 0281 
; 0004 0282                         if (!startStop) { // считаем количество голов
_0x80063:
	LDS  R30,_startStop
	CPI  R30,0
	BRNE _0x8006C
; 0004 0283                             //headDisp = (float)impulseCounter * onePulseDose * (float)valvePulse * 0.65;  // 0.65 попытка скорректировать пропуски открытия клапана при опросе датчиков  температуры
; 0004 0284                             headDisp = (float)impulseCounter * onePulseDose * (float)valvePulse;
	CALL SUBOPT_0x53
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x40
	CALL SUBOPT_0x54
; 0004 0285                         } else {
	RJMP _0x8006D
_0x8006C:
; 0004 0286                             headDisp = 0.0;
	LDI  R30,LOW(0)
	STS  _headDisp,R30
	STS  _headDisp+1,R30
	STS  _headDisp+2,R30
	STS  _headDisp+3,R30
; 0004 0287                         }
_0x8006D:
; 0004 0288                         // оключаем клапан по кокнчанию отбора голов
; 0004 0289                         if ((headDisp >= (float)(rect_head_val)) && !startStop && pwmOn) {
	LDS  R30,_rect_head_val
	LDS  R31,_rect_head_val+1
	CALL SUBOPT_0x42
	LDS  R26,_headDisp
	LDS  R27,_headDisp+1
	LDS  R24,_headDisp+2
	LDS  R25,_headDisp+3
	CALL __CMPF12
	BRLO _0x8006F
	LDS  R30,_startStop
	CPI  R30,0
	BRNE _0x8006F
	LDS  R30,_pwmOn
	CPI  R30,0
	BRNE _0x80070
_0x8006F:
	RJMP _0x8006E
_0x80070:
; 0004 028A                             pwmOn = 0;
	CALL SUBOPT_0x45
; 0004 028B                             VALVE_CLS;
; 0004 028C                         }
; 0004 028D 
; 0004 028E                         // StartStop
; 0004 028F                         if (startStop) {
_0x8006E:
	LDS  R30,_startStop
	CPI  R30,0
	BRNE PC+3
	JMP _0x80071
; 0004 0290 
; 0004 0291                             if (t_kolona_down >= rect_dt_otbora + rect_t_otbora ) {
	LDS  R30,_rect_t_otbora
	LDS  R31,_rect_t_otbora+1
	LDS  R22,_rect_t_otbora+2
	LDS  R23,_rect_t_otbora+3
	LDS  R26,_rect_dt_otbora
	LDS  R27,_rect_dt_otbora+1
	LDS  R24,_rect_dt_otbora+2
	LDS  R25,_rect_dt_otbora+3
	CALL __ADDF12
	CALL SUBOPT_0x55
	CALL __CMPF12
	BRLO _0x80072
; 0004 0292                                 timer = 0;
	LDI  R30,LOW(0)
	STS  _timer,R30
	STS  _timer+1,R30
; 0004 0293                                 VALVE_CLS;
	CBI  0x1B,3
; 0004 0294                                 pwmOn = 0;
	STS  _pwmOn,R30
; 0004 0295                                 timerOn = 0;
	STS  _timerOn,R30
; 0004 0296                                 if (ssTrig == 0) {
	TST  R12
	BRNE _0x80073
; 0004 0297                                     ssTrig = 1;
	LDI  R30,LOW(1)
	MOV  R12,R30
; 0004 0298                                     ssCounter ++;
	LDI  R26,LOW(_ssCounter)
	LDI  R27,HIGH(_ssCounter)
	CALL SUBOPT_0x1
; 0004 0299                                     //уменьшаем скорость отбора на 3% при каждой остановке колоны (Защита от Буратин!!!)
; 0004 029A                                     rect_body_speed =(int)((float)rect_body_speed * 0.97);
	CALL SUBOPT_0x3A
	__GETD2N 0x3F7851EC
	CALL __MULF12
	CALL __CFD1
	STS  _rect_body_speed,R30
	STS  _rect_body_speed+1,R31
; 0004 029B                                 }
; 0004 029C                             } else {
_0x80073:
	RJMP _0x80074
_0x80072:
; 0004 029D                                 timer_off = 0;
	LDI  R30,LOW(0)
	STS  _timer_off,R30
	STS  _timer_off+1,R30
; 0004 029E                                 if (timerOn) {
	LDS  R30,_timerOn
	CPI  R30,0
	BREQ _0x80075
; 0004 029F                                     //VALVE_OPN;
; 0004 02A0                                     pwmOn = 1;
	LDI  R30,LOW(1)
	STS  _pwmOn,R30
; 0004 02A1                                     ssTrig = 0;
	CLR  R12
; 0004 02A2                                     //timer = 0;
; 0004 02A3                                 } else {
	RJMP _0x80076
_0x80075:
; 0004 02A4                                     if (t_kuba > rect_t_kuba_valve) {
	LDS  R30,_rect_t_kuba_valve
	LDS  R31,_rect_t_kuba_valve+1
	LDS  R22,_rect_t_kuba_valve+2
	LDS  R23,_rect_t_kuba_valve+3
	CALL SUBOPT_0x51
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x80077
; 0004 02A5                                         if (timer >= rect_T2_valve * 60) {
	LDS  R26,_rect_T2_valve
	LDS  R27,_rect_T2_valve+1
	CALL SUBOPT_0x56
	BRLO _0x80078
; 0004 02A6                                             timerOn = 1;
	LDI  R30,LOW(1)
	STS  _timerOn,R30
; 0004 02A7                                         }
; 0004 02A8                                     } else {
_0x80078:
	RJMP _0x80079
_0x80077:
; 0004 02A9                                         if (timer >= rect_T1_valve * 60) {
	LDS  R26,_rect_T1_valve
	LDS  R27,_rect_T1_valve+1
	CALL SUBOPT_0x56
	BRLO _0x8007A
; 0004 02AA                                             timerOn = 1;
	LDI  R30,LOW(1)
	STS  _timerOn,R30
; 0004 02AB                                         }
; 0004 02AC                                     }
_0x8007A:
_0x80079:
; 0004 02AD                                 }
_0x80076:
; 0004 02AE                             }
_0x80074:
; 0004 02AF                         }
; 0004 02B0 
; 0004 02B1                         if (t_kuba >= rect_t_kuba_off) {
_0x80071:
	LDS  R30,_rect_t_kuba_off
	LDS  R31,_rect_t_kuba_off+1
	LDS  R22,_rect_t_kuba_off+2
	LDS  R23,_rect_t_kuba_off+3
	CALL SUBOPT_0x51
	CALL __CMPF12
	BRLO _0x8007B
; 0004 02B2                         // end process
; 0004 02B3                             StopProcess();
	RCALL _StopProcess
; 0004 02B4                             return;
	RET
; 0004 02B5                         }
; 0004 02B6                         break;
_0x8007B:
	RJMP _0x80057
; 0004 02B7 
; 0004 02B8         case CALIBRATE_RUN:
_0x80062:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x80057
; 0004 02B9                         //Calibrate_View();
; 0004 02BA                         headDisp = (float)impulseCounter * onePulseDose * (float)valvePulse;
	CALL SUBOPT_0x53
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x40
	CALL SUBOPT_0x54
; 0004 02BB                         break;
; 0004 02BC     }
_0x80057:
; 0004 02BD 
; 0004 02BE     //StartAllConvert_T(BUS);
; 0004 02BF }
	RET
;
;//обработчик события - таймер 250 ms  обновление экрана
;void HandlerEventTimer_250ms(void)
; 0004 02C3 {
_HandlerEventTimer_250ms:
; 0004 02C4       switch (mode) {
	CALL SUBOPT_0x49
; 0004 02C5         case MENU:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x80080
; 0004 02C6                         print_menu();
	RCALL _print_menu
; 0004 02C7                         break;
	RJMP _0x8007F
; 0004 02C8 
; 0004 02C9         case SETTINGS:
_0x80080:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ _0x8010A
; 0004 02CA                         ViewSettings();
; 0004 02CB                         break;
; 0004 02CC 
; 0004 02CD         case RUN_RECT_SET:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ _0x8010A
; 0004 02CE                         ViewSettings();
; 0004 02CF                         break;
; 0004 02D0 
; 0004 02D1         case RUN_DIST:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x80083
; 0004 02D2                         ViewDistilation();
	RCALL _ViewDistilation
; 0004 02D3                         break;
	RJMP _0x8007F
; 0004 02D4 
; 0004 02D5         case RUN_RECT:
_0x80083:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x80084
; 0004 02D6                         ViewRectification();
	RCALL _ViewRectification
; 0004 02D7                         break;
	RJMP _0x8007F
; 0004 02D8 
; 0004 02D9         case CALIBRATE_RUN:
_0x80084:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x80085
; 0004 02DA                         CalibrateView();
	RCALL _CalibrateView
; 0004 02DB                         break;
	RJMP _0x8007F
; 0004 02DC 
; 0004 02DD         case CALIBRATE_MOD:
_0x80085:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x8007F
; 0004 02DE                         ViewSettings();
_0x8010A:
	CALL _ViewSettings
; 0004 02DF                         break;
; 0004 02E0 
; 0004 02E1     }
_0x8007F:
; 0004 02E2 }
	RET
;
;//обработчик события - таймер 10 ms
;void HandlerEventTimer_10ms(void){
; 0004 02E5 void HandlerEventTimer_10ms(void){
_HandlerEventTimer_10ms:
; 0004 02E6     uint8_t but, code;
; 0004 02E7     BUT_Poll();
	ST   -Y,R17
	ST   -Y,R16
;	but -> R17
;	code -> R16
	CALL _BUT_Poll
; 0004 02E8     but = BUT_GetBut();
	CALL _BUT_GetBut
	MOV  R17,R30
; 0004 02E9     if (but){
	CPI  R17,0
	BREQ _0x80087
; 0004 02EA         code = BUT_GetBut();
	CALL _BUT_GetBut
	MOV  R16,R30
; 0004 02EB       if (code == 1) {
	CPI  R16,1
	BRNE _0x80088
; 0004 02EC         //DEBUG_LED_XOR;
; 0004 02ED         switch(but) {
	CALL SUBOPT_0x10
; 0004 02EE             case BUT_1_ID:{
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x8008C
; 0004 02EF                    ES_PlaceEvent(KEY_DOWN);
	LDI  R26,LOW(2)
	CALL _ES_PlaceEvent
; 0004 02F0                    cod = 'd';
	LDI  R30,LOW(100)
	RJMP _0x8010B
; 0004 02F1                    break;
; 0004 02F2                    }
; 0004 02F3 
; 0004 02F4             case BUT_2_ID:{
_0x8008C:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x8008D
; 0004 02F5                    ES_PlaceEvent(KEY_UP);
	LDI  R26,LOW(1)
	CALL _ES_PlaceEvent
; 0004 02F6                    cod = 'u';
	LDI  R30,LOW(117)
	RJMP _0x8010B
; 0004 02F7                    break;
; 0004 02F8                    }
; 0004 02F9             case BUT_3_ID:{
_0x8008D:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x8008E
; 0004 02FA                    ES_PlaceEvent(KEY_ENTER);
	LDI  R26,LOW(3)
	CALL _ES_PlaceEvent
; 0004 02FB                    cod = 'e';
	LDI  R30,LOW(101)
	RJMP _0x8010B
; 0004 02FC                    break;
; 0004 02FD                    }
; 0004 02FE             case BUT_4_ID:{
_0x8008E:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x8008B
; 0004 02FF                    ES_PlaceEvent(KEY_ESC);
	LDI  R26,LOW(4)
	CALL _ES_PlaceEvent
; 0004 0300                    cod = 'b';
	LDI  R30,LOW(98)
_0x8010B:
	STS  _cod,R30
; 0004 0301                    break;
; 0004 0302                    }
; 0004 0303         }
_0x8008B:
; 0004 0304       } else {
	RJMP _0x80090
_0x80088:
; 0004 0305         switch(but) {
	CALL SUBOPT_0x10
; 0004 0306             case BUT_1_ID:{
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x80094
; 0004 0307                    ES_PlaceEvent(KEY_L_DOWN);
	LDI  R26,LOW(9)
	RJMP _0x8010C
; 0004 0308                    //cod = 'd';
; 0004 0309                    break;
; 0004 030A                    }
; 0004 030B 
; 0004 030C             case BUT_2_ID:{
_0x80094:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x80093
; 0004 030D                    ES_PlaceEvent(KEY_L_UP);
	LDI  R26,LOW(8)
_0x8010C:
	CALL _ES_PlaceEvent
; 0004 030E                    //cod = 'u';
; 0004 030F                    break;
; 0004 0310                    }
; 0004 0311         }
_0x80093:
; 0004 0312       }
_0x80090:
; 0004 0313     }
; 0004 0314 }
_0x80087:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;//обработчик кнопки Enter
;void HandlerEventButEnter(void) {
; 0004 0317 void HandlerEventButEnter(void) {
_HandlerEventButEnter:
; 0004 0318   switch (mode) {
	CALL SUBOPT_0x49
; 0004 0319         case MENU:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x80099
; 0004 031A                         menu[current_menu].items_submenu[current_pos].function();
	CALL SUBOPT_0x57
	CALL SUBOPT_0x58
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ICALL
; 0004 031B                         if (mode == MENU){
	LDS  R26,_mode
	CPI  R26,LOW(0x1)
	BRNE _0x8009A
; 0004 031C                             print_menu();
	RCALL _print_menu
; 0004 031D                         }
; 0004 031E                         break;
_0x8009A:
	RJMP _0x80098
; 0004 031F 
; 0004 0320         case SETTINGS:
_0x80099:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x8009B
; 0004 0321                         SetNewParams();
	CALL _SetNewParams
; 0004 0322                         SaveParam();
	CALL _SaveParam
; 0004 0323                         nlcd_Clear();
	CALL SUBOPT_0x59
; 0004 0324                         mode = MENU;
; 0004 0325                         break;
	RJMP _0x80098
; 0004 0326         case INIT:
_0x8009B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x8009C
; 0004 0327                         SetSensors();
	CALL _SetSensors
; 0004 0328                         nlcd_Clear();
	CALL SUBOPT_0x59
; 0004 0329                         mode = MENU;
; 0004 032A                         break;
	RJMP _0x80098
; 0004 032B         case END_PROC:
_0x8009C:
	SBIW R30,0
	BRNE _0x8009D
; 0004 032C                         mode = MENU;
	LDI  R30,LOW(1)
	STS  _mode,R30
; 0004 032D                         BEEP_OFF;
	LDI  R30,LOW(0)
	OUT  0x31,R30
; 0004 032E                         nlcd_Clear();
	RJMP _0x8010D
; 0004 032F                         print_menu();
; 0004 0330                         break;
; 0004 0331         case RUN_DIST:
_0x8009D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x8009E
; 0004 0332                         if (abortProcess) {
	LDS  R30,_abortProcess
	CPI  R30,0
	BREQ _0x8009F
; 0004 0333                             StopProcess();
	CALL SUBOPT_0x5A
; 0004 0334                             BEEP_OFF;
; 0004 0335                             mode = MENU;
; 0004 0336                             nlcd_Clear();
; 0004 0337                             print_menu();
; 0004 0338                         } else { // перебираем параметры для изменения
	RJMP _0x800A0
_0x8009F:
; 0004 0339                             distSettingMode ++;
	LDS  R30,_distSettingMode
	SUBI R30,-LOW(1)
	STS  _distSettingMode,R30
; 0004 033A                             distSettingMode %= 3;
	LDS  R26,_distSettingMode
	CLR  R27
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __MODW21
	STS  _distSettingMode,R30
; 0004 033B                         }
_0x800A0:
; 0004 033C                         break;
	RJMP _0x80098
; 0004 033D         case RUN_RECT:
_0x8009E:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x800A1
; 0004 033E                         if (abortProcess) {
	LDS  R30,_abortProcess
	CPI  R30,0
	BREQ _0x800A2
; 0004 033F                             StopProcess();
	CALL SUBOPT_0x5A
; 0004 0340                             BEEP_OFF;
; 0004 0341                             mode = MENU;
; 0004 0342                             nlcd_Clear();
; 0004 0343                             print_menu();
; 0004 0344                         } else {
	RJMP _0x800A3
_0x800A2:
; 0004 0345                         // Вызов параметров отбора
; 0004 0346                             nlcd_Clear();
	CALL _nlcd_Clear
; 0004 0347                             mode = RUN_RECT_SET;
	LDI  R30,LOW(6)
	STS  _mode,R30
; 0004 0348                             param_id = 4;
	LDI  R30,LOW(4)
	CALL SUBOPT_0x46
; 0004 0349                             params[param_id].value = t_kolona_down * 100;
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x55
	CALL SUBOPT_0x5B
	CALL __MULF12
	POP  R26
	POP  R27
	CALL __CFD1U
	ST   X+,R30
	ST   X,R31
; 0004 034A                             last_menu = current_menu;
	CALL SUBOPT_0x47
; 0004 034B                             last_pos = current_pos;
; 0004 034C                             current_menu = MENU_RECT;
; 0004 034D                             current_pos = 2; // Температура отбора тела
	LDI  R30,LOW(2)
	STS  _current_pos,R30
; 0004 034E                             ViewSettings();
	CALL _ViewSettings
; 0004 034F                         }
_0x800A3:
; 0004 0350                         break;
	RJMP _0x80098
; 0004 0351 
; 0004 0352         case RUN_RECT_SET:
_0x800A1:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x800A4
; 0004 0353                         SetNewParams();
	CALL _SetNewParams
; 0004 0354                         SaveParam();
	CALL _SaveParam
; 0004 0355                         current_menu = last_menu;
	CALL SUBOPT_0x5C
; 0004 0356                         current_pos = last_pos;
; 0004 0357                         startStop = 1;       // Запускаем ШИМ отбор
	STS  _startStop,R30
; 0004 0358                         ssCounter = 0;
	CALL SUBOPT_0x30
; 0004 0359                         ssTrig = 0;
; 0004 035A                         impulseCounter = 0;
	CALL SUBOPT_0x2F
; 0004 035B                         pwmOn = 1;
	LDI  R30,LOW(1)
	STS  _pwmOn,R30
; 0004 035C                         t_kuba_avg = t_kuba;
	CALL SUBOPT_0x50
	CALL SUBOPT_0x4C
; 0004 035D                         t_kuba_sum = 0.0;
; 0004 035E                         t_kuba_count = 0;
; 0004 035F                         CalculateBodySpeed();
; 0004 0360                         //VALVE_OPN;
; 0004 0361                         nlcd_Clear();
	CALL _nlcd_Clear
; 0004 0362                         mode = RUN_RECT;
	LDI  R30,LOW(5)
	STS  _mode,R30
; 0004 0363                         break;
	RJMP _0x80098
; 0004 0364 
; 0004 0365        case CALIBRATE:
_0x800A4:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x800A5
; 0004 0366                        // mode = CALIBRATE_RUN;   // Запус процесса калибровки
; 0004 0367                         nlcd_Clear();
	CALL _nlcd_Clear
; 0004 0368                         CalibrateRun();
	RCALL _CalibrateRun
; 0004 0369                         CalibrateView();
	RCALL _CalibrateView
; 0004 036A                         break;
	RJMP _0x80098
; 0004 036B 
; 0004 036C        case CALIBRATE_RUN:                      // Дозируем 50 мл для калибровки
_0x800A5:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x800A6
; 0004 036D                         if (abortProcess) {    // прерываем процесс
	LDS  R30,_abortProcess
	CPI  R30,0
	BREQ _0x800A7
; 0004 036E                             VALVE_CLS;
	CBI  0x1B,3
; 0004 036F                             pwmOn = 0;
	LDI  R30,LOW(0)
	STS  _pwmOn,R30
; 0004 0370                             heater_power = 0;
	STS  _heater_power,R30
; 0004 0371                             abortProcess = 0;
	STS  _abortProcess,R30
; 0004 0372                             mode = MENU;
	LDI  R30,LOW(1)
	STS  _mode,R30
; 0004 0373                             nlcd_Clear();
	CALL SUBOPT_0x2E
; 0004 0374                             print_menu();
; 0004 0375                         }
; 0004 0376                         break;
_0x800A7:
	RJMP _0x80098
; 0004 0377 
; 0004 0378        case CALIBRATE_MOD:
_0x800A6:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x80098
; 0004 0379                         SetNewParams();                 // закончили калибровку, сохраняем параметры и выходим в меню
	CALL _SetNewParams
; 0004 037A                         CalibrateStop();
	RCALL _CalibrateStop
; 0004 037B                         current_menu = last_menu;
	CALL SUBOPT_0x5C
; 0004 037C                         current_pos = last_pos;
; 0004 037D                         mode = MENU;
	STS  _mode,R30
; 0004 037E                         nlcd_Clear();
_0x8010D:
	CALL _nlcd_Clear
; 0004 037F                         print_menu();
	RCALL _print_menu
; 0004 0380                         break;
; 0004 0381     }
_0x80098:
; 0004 0382 }
	RET
;
;//обработчик кнопки Esc
;void HandlerEventButEsc(void) {
; 0004 0385 void HandlerEventButEsc(void) {
_HandlerEventButEsc:
; 0004 0386   switch (mode) {
	CALL SUBOPT_0x49
; 0004 0387 
; 0004 0388         case SETTINGS:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x800AC
; 0004 0389                         nlcd_Clear();
	CALL SUBOPT_0x59
; 0004 038A                         mode = MENU;
; 0004 038B                         break;
	RJMP _0x800AB
; 0004 038C         case INIT:
_0x800AC:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x800AD
; 0004 038D                         nlcd_Clear();
	CALL SUBOPT_0x59
; 0004 038E                         mode = MENU;
; 0004 038F                         break;
	RJMP _0x800AB
; 0004 0390 
; 0004 0391         case MENU:
_0x800AD:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x800AE
; 0004 0392                         if (current_menu != 0) {
	LDS  R30,_current_menu
	CPI  R30,0
	BREQ _0x800AF
; 0004 0393                             goto_menu();
	RCALL _goto_menu
; 0004 0394                             print_menu();
	RJMP _0x8010E
; 0004 0395                         } else if (current_menu == 0){
_0x800AF:
	LDS  R30,_current_menu
	CPI  R30,0
	BRNE _0x800B1
; 0004 0396                            // mode = GENERAL;
; 0004 0397                             nlcd_Clear();
	CALL _nlcd_Clear
; 0004 0398                             print_menu();
_0x8010E:
	RCALL _print_menu
; 0004 0399                            // ES_PlaceEvent(EVENT_TIMER_1S);
; 0004 039A                         }
; 0004 039B                         break;
_0x800B1:
	RJMP _0x800AB
; 0004 039C 
; 0004 039D         case END_PROC:
_0x800AE:
	SBIW R30,0
	BRNE _0x800B2
; 0004 039E                         mode = MENU;
	LDI  R30,LOW(1)
	STS  _mode,R30
; 0004 039F                         BEEP_OFF;
	LDI  R30,LOW(0)
	OUT  0x31,R30
; 0004 03A0                         nlcd_Clear();
	CALL SUBOPT_0x2E
; 0004 03A1                         print_menu();
; 0004 03A2                         break;
	RJMP _0x800AB
; 0004 03A3         case RUN_DIST:
_0x800B2:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ _0x8010F
; 0004 03A4                         abortProcess = !abortProcess;
; 0004 03A5                         nlcd_Clear();
; 0004 03A6                         break;
; 0004 03A7 
; 0004 03A8         case RUN_RECT:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x800B4
; 0004 03A9                         if (timerSignOn) {
	TST  R13
	BREQ _0x800B5
; 0004 03AA                             BEEP_OFF;
	LDI  R30,LOW(0)
	OUT  0x31,R30
; 0004 03AB                             timerSignOn = 0;
	CLR  R13
; 0004 03AC                             timerSign = 0;
	STS  _timerSign,R30
	STS  _timerSign+1,R30
; 0004 03AD                         } else {
	RJMP _0x800B6
_0x800B5:
; 0004 03AE                             abortProcess = !abortProcess;
	LDS  R30,_abortProcess
	CALL SUBOPT_0x5D
; 0004 03AF                             nlcd_Clear();
; 0004 03B0                         }
_0x800B6:
; 0004 03B1                         break;
	RJMP _0x800AB
; 0004 03B2 
; 0004 03B3         case RUN_RECT_SET:
_0x800B4:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x800B7
; 0004 03B4                         current_menu = last_menu;
	LDS  R30,_last_menu
	STS  _current_menu,R30
; 0004 03B5                         current_pos = last_pos;
	LDS  R30,_last_pos
	STS  _current_pos,R30
; 0004 03B6                         nlcd_Clear();
	CALL _nlcd_Clear
; 0004 03B7                         mode = RUN_RECT;
	LDI  R30,LOW(5)
	STS  _mode,R30
; 0004 03B8                         break;
	RJMP _0x800AB
; 0004 03B9 
; 0004 03BA         case CALIBRATE_RUN:
_0x800B7:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x800AB
; 0004 03BB                         abortProcess = !abortProcess;
_0x8010F:
	LDS  R30,_abortProcess
	CALL SUBOPT_0x5D
; 0004 03BC                         nlcd_Clear();
; 0004 03BD                         //Calibrate_View();
; 0004 03BE                         break;
; 0004 03BF 
; 0004 03C0      }
_0x800AB:
; 0004 03C1 }
	RET
;
;//обработчик кнопки Up
;void HandlerEventButUp(void) {
; 0004 03C4 void HandlerEventButUp(void) {
_HandlerEventButUp:
; 0004 03C5    switch (mode) {
	CALL SUBOPT_0x49
; 0004 03C6         case MENU:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x800BC
; 0004 03C7                         if (current_pos <= 0) {
	LDS  R26,_current_pos
	CPI  R26,0
	BRNE _0x800BD
; 0004 03C8                                 current_pos=menu[current_menu].num_selections-1;
	CALL SUBOPT_0x57
	CALL SUBOPT_0x5E
	RJMP _0x80110
; 0004 03C9                         } else {
_0x800BD:
; 0004 03CA                                 current_pos--;
	LDS  R30,_current_pos
_0x80110:
	SUBI R30,LOW(1)
	STS  _current_pos,R30
; 0004 03CB                         }
; 0004 03CC                         nlcd_Clear();
	CALL SUBOPT_0x2E
; 0004 03CD                         print_menu();
; 0004 03CE                         break;
	RJMP _0x800BB
; 0004 03CF 
; 0004 03D0         case SETTINGS:
_0x800BC:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x800BF
; 0004 03D1                         nlcd_Clear();
	RJMP _0x80111
; 0004 03D2                         ParamInc();
; 0004 03D3                         break;
; 0004 03D4 
; 0004 03D5         case RUN_RECT_SET:
_0x800BF:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x800C0
; 0004 03D6                         nlcd_Clear();
	RJMP _0x80111
; 0004 03D7                         ParamInc();
; 0004 03D8                         break;
; 0004 03D9 
; 0004 03DA         case RUN_DIST:
_0x800C0:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x800C1
; 0004 03DB                         switch(distSettingMode) {
	CALL SUBOPT_0x5F
; 0004 03DC                             case DIST_SET_MODE_PWR:
	BRNE _0x800C5
; 0004 03DD                                 {
; 0004 03DE                                     heater_power += 1;   //5
	LDS  R30,_heater_power
	SUBI R30,-LOW(1)
	CALL SUBOPT_0x60
; 0004 03DF                                     if (heater_power > 100){
	CPI  R26,LOW(0x65)
	BRLO _0x800C6
; 0004 03E0                                         heater_power = 100;
	LDI  R30,LOW(100)
	STS  _heater_power,R30
; 0004 03E1                                     }
; 0004 03E2                                     break;
_0x800C6:
	RJMP _0x800C4
; 0004 03E3                                 }
; 0004 03E4                             case DIST_SET_MODE_VALV:
_0x800C5:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x800C7
; 0004 03E5                                 {
; 0004 03E6                                     distValveMode ++;
	LDS  R30,_distValveMode
	SUBI R30,-LOW(1)
	STS  _distValveMode,R30
; 0004 03E7                                     distValveMode %= 3;
	LDS  R26,_distValveMode
	CLR  R27
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __MODW21
	STS  _distValveMode,R30
; 0004 03E8                                     break;
	RJMP _0x800C4
; 0004 03E9                                 }
; 0004 03EA                             case DIST_SET_MODE_FLOW:
_0x800C7:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x800C4
; 0004 03EB                                 {
; 0004 03EC                                     if (Votb < 2000.0) {
	CALL SUBOPT_0x61
	BRSH _0x800C9
; 0004 03ED                                         Votb += 10;
	CALL SUBOPT_0x28
	CALL SUBOPT_0x38
	CALL __ADDF12
	CALL SUBOPT_0x15
; 0004 03EE                                     }
; 0004 03EF                                     CalculateDistBodySpeed();
_0x800C9:
	RCALL _CalculateDistBodySpeed
; 0004 03F0                                     break;
; 0004 03F1                                 }
; 0004 03F2 
; 0004 03F3                         }
_0x800C4:
; 0004 03F4                         break;
	RJMP _0x800BB
; 0004 03F5         case RUN_RECT:
_0x800C1:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x800CA
; 0004 03F6                         if (!startStop) {
	LDS  R30,_startStop
	CPI  R30,0
	BRNE _0x800CB
; 0004 03F7                             VALVE_OPN;
	SBI  0x1B,3
; 0004 03F8                         }
; 0004 03F9                         break;
_0x800CB:
	RJMP _0x800BB
; 0004 03FA 
; 0004 03FB         case CALIBRATE_MOD:                 // вводим реальное значение объема
_0x800CA:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x800BB
; 0004 03FC                         nlcd_Clear();
_0x80111:
	CALL _nlcd_Clear
; 0004 03FD                         ParamInc();
	CALL _ParamInc
; 0004 03FE                         break;
; 0004 03FF     }
_0x800BB:
; 0004 0400 }
	RET
;
;//обработчик кнопки Down
;void HandlerEventButDown(void) {
; 0004 0403 void HandlerEventButDown(void) {
_HandlerEventButDown:
; 0004 0404   switch (mode) {
	CALL SUBOPT_0x49
; 0004 0405        case MENU:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x800D0
; 0004 0406                          if(current_pos>=menu[current_menu].num_selections-1) {
	CALL SUBOPT_0x57
	CALL SUBOPT_0x5E
	LDI  R31,0
	SBIW R30,1
	LDS  R26,_current_pos
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x800D1
; 0004 0407                              current_pos=0;
	LDI  R30,LOW(0)
	RJMP _0x80112
; 0004 0408                          } else {
_0x800D1:
; 0004 0409                              current_pos++;
	LDS  R30,_current_pos
	SUBI R30,-LOW(1)
_0x80112:
	STS  _current_pos,R30
; 0004 040A                          }
; 0004 040B                          nlcd_Clear();
	CALL SUBOPT_0x2E
; 0004 040C                          print_menu();
; 0004 040D                          break;
	RJMP _0x800CF
; 0004 040E 
; 0004 040F        case SETTINGS:
_0x800D0:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x800D3
; 0004 0410                          nlcd_Clear();
	RJMP _0x80113
; 0004 0411                          ParamDec();
; 0004 0412                          break;
; 0004 0413 
; 0004 0414        case RUN_RECT_SET:
_0x800D3:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x800D4
; 0004 0415                         nlcd_Clear();
	RJMP _0x80113
; 0004 0416                         ParamDec();
; 0004 0417                         break;
; 0004 0418 
; 0004 0419        case RUN_DIST:
_0x800D4:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x800D5
; 0004 041A                         switch(distSettingMode) {
	CALL SUBOPT_0x5F
; 0004 041B                             case DIST_SET_MODE_PWR:
	BRNE _0x800D9
; 0004 041C                                 {
; 0004 041D                                     heater_power -= 1; //5
	LDS  R30,_heater_power
	SUBI R30,LOW(1)
	CALL SUBOPT_0x60
; 0004 041E                                     if (heater_power < 1){
	CPI  R26,LOW(0x1)
	BRSH _0x800DA
; 0004 041F                                         heater_power = 1;
	LDI  R30,LOW(1)
	STS  _heater_power,R30
; 0004 0420                                     }
; 0004 0421                                     break;
_0x800DA:
	RJMP _0x800D8
; 0004 0422                                 }
; 0004 0423                             case DIST_SET_MODE_VALV:
_0x800D9:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x800DB
; 0004 0424                                 {
; 0004 0425                                     if (distValveMode > 0) {
	LDS  R26,_distValveMode
	CPI  R26,LOW(0x1)
	BRLO _0x800DC
; 0004 0426                                         distValveMode --;
	LDS  R30,_distValveMode
	SUBI R30,LOW(1)
	RJMP _0x80114
; 0004 0427                                     } else {
_0x800DC:
; 0004 0428                                         distValveMode = 2;
	LDI  R30,LOW(2)
_0x80114:
	STS  _distValveMode,R30
; 0004 0429                                     }
; 0004 042A                                     break;
	RJMP _0x800D8
; 0004 042B                                 }
; 0004 042C                             case DIST_SET_MODE_FLOW:
_0x800DB:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x800D8
; 0004 042D                                 {
; 0004 042E                                     if (Votb >= 20.0) {
	CALL SUBOPT_0x3B
	__GETD1N 0x41A00000
	CALL __CMPF12
	BRLO _0x800DF
; 0004 042F                                         Votb -= 10;
	CALL SUBOPT_0x28
	CALL SUBOPT_0x38
	CALL __SUBF12
	CALL SUBOPT_0x15
; 0004 0430                                     }
; 0004 0431                                     CalculateDistBodySpeed();
_0x800DF:
	RCALL _CalculateDistBodySpeed
; 0004 0432                                     break;
; 0004 0433                                 }
; 0004 0434 
; 0004 0435                         }
_0x800D8:
; 0004 0436                         break;
	RJMP _0x800CF
; 0004 0437        case RUN_RECT:
_0x800D5:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x800E0
; 0004 0438                         if (!startStop) {
	LDS  R30,_startStop
	CPI  R30,0
	BRNE _0x800E1
; 0004 0439                             VALVE_CLS;
	CBI  0x1B,3
; 0004 043A                         }
; 0004 043B                         break;
_0x800E1:
	RJMP _0x800CF
; 0004 043C 
; 0004 043D        case CALIBRATE_MOD:                 // вводим реальное значение объема
_0x800E0:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x800CF
; 0004 043E                         nlcd_Clear();
_0x80113:
	CALL _nlcd_Clear
; 0004 043F                         ParamDec();
	CALL _ParamDec
; 0004 0440                         break;
; 0004 0441     }
_0x800CF:
; 0004 0442 }
	RET
;
;
;
;void HandlerEventButLUp(void){
; 0004 0446 void HandlerEventButLUp(void){
_HandlerEventButLUp:
; 0004 0447    switch (mode) {
	CALL SUBOPT_0x49
; 0004 0448 
; 0004 0449         case SETTINGS:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ _0x80115
; 0004 044A                         nlcd_Clear();
; 0004 044B                         ParamDec();
; 0004 044C                         Param10Inc();
; 0004 044D                         break;
; 0004 044E 
; 0004 044F         case RUN_RECT_SET:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ _0x80115
; 0004 0450                         nlcd_Clear();
; 0004 0451                         ParamDec();
; 0004 0452                         Param10Inc();
; 0004 0453                         break;
; 0004 0454         case RUN_RECT:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x800E8
; 0004 0455                         if (!startStop) {
	LDS  R30,_startStop
	CPI  R30,0
	BRNE _0x800E9
; 0004 0456                             CalculateHead();
	RCALL _CalculateHead
; 0004 0457                             pwmOn = 1;
	LDI  R30,LOW(1)
	STS  _pwmOn,R30
; 0004 0458                         }
; 0004 0459                         break;
_0x800E9:
	RJMP _0x800E5
; 0004 045A         case RUN_DIST:
_0x800E8:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x800EA
; 0004 045B                         switch(distSettingMode) {
	CALL SUBOPT_0x5F
; 0004 045C                             case DIST_SET_MODE_PWR:
	BRNE _0x800EE
; 0004 045D                                 {
; 0004 045E                                     heater_power += 4;
	LDS  R30,_heater_power
	SUBI R30,-LOW(4)
	CALL SUBOPT_0x60
; 0004 045F                                     if (heater_power > 100){
	CPI  R26,LOW(0x65)
	BRLO _0x800EF
; 0004 0460                                         heater_power = 100;
	LDI  R30,LOW(100)
	STS  _heater_power,R30
; 0004 0461                                     }
; 0004 0462                                     break;
_0x800EF:
	RJMP _0x800ED
; 0004 0463                                 }
; 0004 0464 
; 0004 0465                             case DIST_SET_MODE_FLOW:
_0x800EE:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x800ED
; 0004 0466                                 {
; 0004 0467                                     if (Votb < 2000.0) {
	CALL SUBOPT_0x61
	BRSH _0x800F1
; 0004 0468                                         Votb += 90;
	CALL SUBOPT_0x62
	CALL __ADDF12
	CALL SUBOPT_0x15
; 0004 0469                                     }
; 0004 046A                                     CalculateDistBodySpeed();
_0x800F1:
	RCALL _CalculateDistBodySpeed
; 0004 046B                                     break;
; 0004 046C                                 }
; 0004 046D 
; 0004 046E                         }
_0x800ED:
; 0004 046F                         break;
	RJMP _0x800E5
; 0004 0470 
; 0004 0471         case CALIBRATE_MOD:                 // вводим реальное значение объема
_0x800EA:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x800E5
; 0004 0472                         nlcd_Clear();
_0x80115:
	CALL _nlcd_Clear
; 0004 0473                         ParamDec();
	CALL _ParamDec
; 0004 0474                         Param10Inc();
	CALL _Param10Inc
; 0004 0475                         break;
; 0004 0476     }
_0x800E5:
; 0004 0477 
; 0004 0478 }
	RET
;
;void HandlerEventButLDown(void){
; 0004 047A void HandlerEventButLDown(void){
_HandlerEventButLDown:
; 0004 047B    switch (mode) {
	CALL SUBOPT_0x49
; 0004 047C 
; 0004 047D        case SETTINGS:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ _0x80116
; 0004 047E                          nlcd_Clear();
; 0004 047F                          ParamInc();
; 0004 0480                          Param10Dec();
; 0004 0481                          break;
; 0004 0482 
; 0004 0483        case RUN_RECT_SET:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ _0x80116
; 0004 0484                          nlcd_Clear();
; 0004 0485                          ParamInc();
; 0004 0486                          Param10Dec();
; 0004 0487                          break;
; 0004 0488        case RUN_RECT:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x800F8
; 0004 0489                         if (!startStop) {
	LDS  R30,_startStop
	CPI  R30,0
	BRNE _0x800F9
; 0004 048A                             VALVE_CLS;
	CBI  0x1B,3
; 0004 048B                         }
; 0004 048C                         pwmOn = 0;
_0x800F9:
	LDI  R30,LOW(0)
	STS  _pwmOn,R30
; 0004 048D                         break;
	RJMP _0x800F5
; 0004 048E        case RUN_DIST:
_0x800F8:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x800FA
; 0004 048F 
; 0004 0490                         switch(distSettingMode) {
	CALL SUBOPT_0x5F
; 0004 0491                             case DIST_SET_MODE_PWR:
	BRNE _0x800FE
; 0004 0492                                 {
; 0004 0493                                     heater_power -= 4;
	LDS  R30,_heater_power
	SUBI R30,LOW(4)
	CALL SUBOPT_0x60
; 0004 0494                                     if (heater_power < 5){
	CPI  R26,LOW(0x5)
	BRSH _0x800FF
; 0004 0495                                         heater_power = 1;
	LDI  R30,LOW(1)
	STS  _heater_power,R30
; 0004 0496                                     }
; 0004 0497                                     break;
_0x800FF:
	RJMP _0x800FD
; 0004 0498                                 }
; 0004 0499 
; 0004 049A                             case DIST_SET_MODE_FLOW:
_0x800FE:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x800FD
; 0004 049B                                 {
; 0004 049C                                     if (Votb >= 100.0) {
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x5B
	CALL __CMPF12
	BRLO _0x80101
; 0004 049D                                         Votb -= 90;
	CALL SUBOPT_0x62
	CALL __SUBF12
	CALL SUBOPT_0x15
; 0004 049E                                     }
; 0004 049F                                     CalculateDistBodySpeed();
_0x80101:
	RCALL _CalculateDistBodySpeed
; 0004 04A0                                     break;
; 0004 04A1                                 }
; 0004 04A2 
; 0004 04A3                         }
_0x800FD:
; 0004 04A4                         break;
	RJMP _0x800F5
; 0004 04A5 
; 0004 04A6        case CALIBRATE_MOD:                 // вводим реальное значение объема
_0x800FA:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x800F5
; 0004 04A7                         nlcd_Clear();
_0x80116:
	CALL _nlcd_Clear
; 0004 04A8                         ParamInc();
	CALL _ParamInc
; 0004 04A9                         Param10Dec();
	CALL _Param10Dec
; 0004 04AA                         break;
; 0004 04AB     }
_0x800F5:
; 0004 04AC }
	RET
;#include <menu.h>
;#include <handlers.h>
;#include <stdio.h>
;#include <delay.h>
;#include <string.h>
;#include <nokia1100_lcd_lib.h>
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
;#include <settings.h>
;
;char cod;
;char current_menu=0; //Переменная указывает на текущее меню
;char current_pos=0; //Переменная указывает на текущий пункт меню/подменю
;
;char last_menu;
;char last_pos;
;
;//Имена пунктов
;flash unsigned char distilation[] =       {"Дистиляция"};
;flash unsigned char rectification[] =     {"Ректификация"};
;flash unsigned char settings[] =          {"Параметры"};
;
;// Настройки
;flash unsigned char set_dist[] =          {"Дистиляции"};
;flash unsigned char set_rectif[] =        {"Ректификации"};
;flash unsigned char set_temp_sensors[] =  {"Датчиков темп"};
;flash unsigned char set_calibrate_vlv[] = {"Калибровка кл."};
;
;// Настройки -> Дистиляции
;flash unsigned char set_dis_t[] =         {"t куба откл."};
;flash unsigned char set_dis_pten[] =      {"Ртэн начальная"};
;
;// Настройки -> Ректификация
;flash unsigned char set_rect_pten_min[] =   {"Ртэн мин t>60"};
;flash unsigned char set_rect_Pkol_max[] =   {"P колоны макс"};
;flash unsigned char set_rect_t_otbor[] =    {"t отбора"};
;flash unsigned char set_rect_dt_otbor[] =   {"dt отбора"};
;flash unsigned char set_rect_T1_valve[] =   {"T1 зад. клап."};
;flash unsigned char set_rect_T2_valve[] =   {"T2 зад. клап."};
;flash unsigned char set_rect_t_kuba_v[] =   {"t куба зад. кл"};
;flash unsigned char set_rect_t_kuba_off[] = {"t куба откл."};
;flash unsigned char set_rect_head_val[] =   {"Объем голов"};
;flash unsigned char set_rect_body_spd[] =   {"Скорость отб."};
;flash unsigned char set_rect_pulse_d[] =    {"Длит. импульса"};
;flash unsigned char set_rect_fact_q[] =     {"Факт объем отб"};
;flash unsigned char set_rect_k_factor[] =   {"Коэфф. расхода"};
;
;// Настройки -> Датчики температуры
;flash unsigned char set_sens_tkub[] =          {"Т куба"};
;flash unsigned char set_sens_tkolona_down[] =  {"Т колоны низ"};
;flash unsigned char set_sens_tkolona_up[] =    {"Т колоны верх"};
;
;//===========================================================================
;
;//Массив хранящий пункты главного меню (структура SELECTION)
;static SELECTION menu_[]= {
;  {distilation, RunDistilation, 0, MAIN_MENU, 0}, // Дистиляция
;  {rectification, RunRectification, 0, MAIN_MENU, 0}, // Ректификация
;  {settings, goto_menu, MENU_SET, MAIN_MENU, 0} // Настройки
;};

	.DSEG
;
;//Массив хранящий пункты меню Настройки (структура SELECTION)
;static SELECTION menu_settings[]={
;  {set_dist, goto_menu, MENU_DIST, MAIN_MENU, 2}, //Настройки дистиляции
;  {set_rectif, goto_menu, MENU_RECT, MAIN_MENU, 2}, //Настройки ректификации
;  {set_temp_sensors, goto_menu, MENU_INIT, MAIN_MENU, 2}, //Настройки датчиков
;  {set_calibrate_vlv, CalibrateValve, 0, MAIN_MENU, 2} //Калибровка клапана
;};
;
;//Массив хранящий пункты меню Настройки-> Дистиляции (структура SELECTION)
;static SELECTION menu_set_dist[]={
;  {set_dis_t, SetParam, 0, MENU_SET, 0}, //t куба откл.
;  {set_dis_pten, SetParam, 0, MENU_SET, 0} //Ртэн начальная
;};
;
;//Массив хранящий пункты меню Настройки->Ректификации (структура SELECTION)
;static SELECTION menu_set_rect[]={
;  {set_rect_pten_min, SetParam, 0, MENU_SET, 1},  //Ртэн мин t>60
;  {set_rect_Pkol_max, SetParam, 0, MENU_SET, 1},  //P колоны макс
;  {set_rect_t_otbor, SetParam, 0, MENU_SET, 1},   //t отбора
;  {set_rect_dt_otbor, SetParam, 0, MENU_SET, 1},  //dt отбора
;  {set_rect_T1_valve, SetParam, 0, MENU_SET, 1},  //T1 зад. клап.
;  {set_rect_T2_valve, SetParam, 0, MENU_SET, 1},  //T2 зад. клап.
;  {set_rect_t_kuba_v, SetParam, 0, MENU_SET, 1},  //t куба зад. кл
;  {set_rect_t_kuba_off, SetParam, 0, MENU_SET, 1},//t куба откл.
;  {set_rect_head_val, SetParam, 0, MENU_SET, 1},  //Объем голов
;  {set_rect_body_spd, SetParam, 0, MENU_SET, 1},  //Скорость отбора
;  {set_rect_pulse_d, SetParam, 0, MENU_SET, 1},   //Длит. импульса
;  {set_rect_fact_q, SetParam, 0, MENU_SET, 1},    //Фактически отобранный объем
;  {set_rect_k_factor, SetParam, 0, MENU_SET, 1}   //Коэффициент расхода клапана (k)
;};
;
;//Массив хранящий пункты меню Настройки->Датчиков (структура SELECTION)
;static SELECTION menu_set_init[]={
;  {set_sens_tkub, InitSensors, 0, MENU_SET, 2},         //Т куба
;  {set_sens_tkolona_down, InitSensors, 0, MENU_SET, 2}, //Т колоны низ
;  {set_sens_tkolona_up, InitSensors, 0, MENU_SET, 2}    //Т колоны верх
;};
;
;
;//Главный массив хранит в себе все меню/подменю
;//Все меню/подменю должны описываться в таком же порядке как и в   enum __menu__id ...
;static _MENU menu[] = {
;  {MAIN_MENU, 3, menu_}, //Меню
;  {MENU_DIST, 2, menu_set_dist}, //Дистиляция
;  {MENU_RECT, 13, menu_set_rect}, // Ректификация
;  {MENU_SET,  4, menu_settings}, //Настройки
;  {MENU_INIT, 3, menu_set_init} // Датчики
;};
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;void goto_menu() {
; 0005 006D void goto_menu() {

	.CSEG
_goto_menu:
; 0005 006E   switch (cod) {
	LDS  R30,_cod
	LDI  R31,0
; 0005 006F     case 'e': {current_menu=menu[current_menu].items_submenu[current_pos].ent_f; break;};//enter
	CPI  R30,LOW(0x65)
	LDI  R26,HIGH(0x65)
	CPC  R31,R26
	BRNE _0xA000C
	CALL SUBOPT_0x57
	CALL SUBOPT_0x58
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,4
	RJMP _0xA0019
; 0005 0070     case 'b': {current_menu=menu[current_menu].items_submenu[current_pos].esc_f; break;};//escape
_0xA000C:
	CPI  R30,LOW(0x62)
	LDI  R26,HIGH(0x62)
	CPC  R31,R26
	BRNE _0xA000B
	CALL SUBOPT_0x57
	CALL SUBOPT_0x58
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,5
_0xA0019:
	LD   R30,X
	STS  _current_menu,R30
; 0005 0071   }
_0xA000B:
; 0005 0072   nlcd_Clear();
	CALL _nlcd_Clear
; 0005 0073   current_pos = 0;
	LDI  R30,LOW(0)
	STS  _current_pos,R30
; 0005 0074 }
	RET
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;void print_menu()
; 0005 0077 {
_print_menu:
; 0005 0078 unsigned char tmp[17];
; 0005 0079 signed char i, s, f, t, c;
; 0005 007A     if (current_menu != 0){
	SBIW R28,17
	CALL __SAVELOCR6
;	tmp -> Y+6
;	i -> R17
;	s -> R16
;	f -> R19
;	t -> R18
;	c -> R21
	LDS  R30,_current_menu
	CPI  R30,0
	BREQ _0xA000E
; 0005 007B         strcpyf(tmp, menu[0].items_submenu[menu[current_menu].items_submenu[current_pos].parent].name_item);
	CALL SUBOPT_0x63
	CALL SUBOPT_0x58
	CALL SUBOPT_0x64
; 0005 007C         sprintf(buf,"-%s-", tmp);
	__POINTW1FN _0xA0000,0
	CALL SUBOPT_0x65
; 0005 007D         nlcd_GotoXY(7 - strlen(buf)/2, 1);
	CALL SUBOPT_0x66
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	SUB  R26,R30
	SBC  R27,R31
	ST   -Y,R26
	RJMP _0xA001A
; 0005 007E         nlcd_Print(buf);
; 0005 007F     } else {
_0xA000E:
; 0005 0080         sprintf(buf,"-=Меню=-");
	CALL SUBOPT_0x2A
	__POINTW1FN _0xA0000,5
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
; 0005 0081         nlcd_GotoXY(3, 1);
	LDI  R30,LOW(3)
	ST   -Y,R30
_0xA001A:
	LDI  R26,LOW(1)
	CALL SUBOPT_0x67
; 0005 0082         nlcd_Print(buf);
; 0005 0083     }
; 0005 0084     c = 5;
	LDI  R21,LOW(5)
; 0005 0085     t = 2;
	LDI  R18,LOW(2)
; 0005 0086     if (menu[current_menu].num_selections > c) {
	CALL SUBOPT_0x57
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,1
	LD   R26,X
	MOV  R30,R21
	CALL SUBOPT_0x68
	BRGE _0xA0010
; 0005 0087         if (current_pos - (c - (signed char)1) > 0){
	CALL SUBOPT_0x69
	SUB  R26,R30
	SBC  R27,R31
	CALL __CPW02
	BRGE _0xA0011
; 0005 0088          s = current_pos - (c - (signed char)1);
	CALL SUBOPT_0x69
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOV  R16,R30
; 0005 0089          f = current_pos + 1;
	CALL SUBOPT_0x6A
	ADIW R30,1
	MOV  R19,R30
; 0005 008A         } else {
	RJMP _0xA0012
_0xA0011:
; 0005 008B          s = 0;
	LDI  R16,LOW(0)
; 0005 008C          f = c;
	MOV  R19,R21
; 0005 008D         }
_0xA0012:
; 0005 008E     } else {
	RJMP _0xA0013
_0xA0010:
; 0005 008F        f = menu[current_menu].num_selections;
	CALL SUBOPT_0x57
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,1
	LD   R19,X
; 0005 0090        s = 0;
	LDI  R16,LOW(0)
; 0005 0091     }
_0xA0013:
; 0005 0092     for (i = s; i < f; i++) {
	MOV  R17,R16
_0xA0015:
	CP   R17,R19
	BRGE _0xA0016
; 0005 0093         if (i == current_pos) {
	LDS  R30,_current_pos
	MOV  R26,R17
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRNE _0xA0017
; 0005 0094             strcpyf(tmp, menu[current_menu].items_submenu[i].name_item);
	CALL SUBOPT_0x63
	CALL SUBOPT_0x6B
	CALL SUBOPT_0x6C
; 0005 0095             sprintf(buf,"[%s]", tmp);
	__POINTW1FN _0xA0000,14
	CALL SUBOPT_0x65
; 0005 0096             nlcd_GotoXY(0, t++);
	LDI  R30,LOW(0)
	RJMP _0xA001B
; 0005 0097         } else {
_0xA0017:
; 0005 0098             strcpyf(tmp, menu[current_menu].items_submenu[i].name_item);
	CALL SUBOPT_0x63
	CALL SUBOPT_0x6B
	CALL SUBOPT_0x6C
; 0005 0099             sprintf(buf,"%s", tmp);
	__POINTW1FN _0xA0000,19
	CALL SUBOPT_0x65
; 0005 009A             nlcd_GotoXY(1, t++);
	LDI  R30,LOW(1)
_0xA001B:
	ST   -Y,R30
	MOV  R26,R18
	SUBI R18,-1
	CALL _nlcd_GotoXY
; 0005 009B         }
; 0005 009C         nlcd_Print(buf);
	CALL SUBOPT_0x9
; 0005 009D     }
	SUBI R17,-1
	RJMP _0xA0015
_0xA0016:
; 0005 009E     cod='k';
	LDI  R30,LOW(107)
	STS  _cod,R30
; 0005 009F }
	CALL __LOADLOCR6
	ADIW R28,23
	RET
;#include <settings.h>
;#include <handlers.h>
;#include <menu.h>
;#include <nokia1100_lcd_lib.h>
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
;#include <stdio.h>
;#include <string.h>
;#include <general.h>
;#include <hwinit.h>
;
;#include <OWIPolled.h>
;#include <OWIHighLevelFunctions.h>
;#include <OWIBitFunctions.h>
;#include <OWIcrc.h>
;
;extern OWI_device ds1820_rom_codes[MAX_DS1820];
;extern OWI_device t_rom_codes[MAX_DS1820];
;
;flash unsigned char set_on[] = {"Вкл."};
;flash unsigned char set_off[] ={"Выкл."};
;
;flash unsigned char label_grad[] =    {"С"};
;flash unsigned char label_min[] =     {"мин"};
;flash unsigned char label_mmhb[] =    {"мм.рт.ст"};
;flash unsigned char label_percent[] = {"%"};
;flash unsigned char label_ml[] =      {"мл."};
;flash unsigned char label_mlph[] =    {"мл./ч"};
;flash unsigned char label_ms[] =      {"*10 мс"};
;
;
;flash unsigned char * flash yesno[] = {set_off, set_on};
;flash unsigned char * flash labels[] = {label_min, label_grad, label_mmhb, label_percent, label_ml, label_mlph, label_ms};
;
;unsigned char param_id;
;
;float dis_t_kuba;
;unsigned int dis_p_ten;
;unsigned int rect_p_ten_min;
;unsigned int rect_p_kol_max;
;float rect_t_otbora;
;float rect_dt_otbora;
;unsigned int rect_T1_valve;
;unsigned int rect_T2_valve;
;float rect_t_kuba_valve;
;float rect_t_kuba_off;
;unsigned int rect_head_val;
;unsigned int rect_body_speed;
;unsigned char rect_pulse_delay;
;float onePulseDose;
;unsigned int factCalibrateQ;
;
;PARAM params[SET_COUNT];
;
;eeprom PARAM params_eeprom[SET_COUNT] = {
;//v     |min    |max    |lab    |type
;{9800,  0,      11000,  1,      PT_FLOAT}, // Дистиляция -> t куба откл.
;{80,    0,      100,    3,      PT_DIGIT}, // Дистиляция -> Ртэн средняя
;{70,    0,      100,    3,      PT_DIGIT}, // Ректификация -> Ртэн мин t>=60C
;{20,    0,      100,    2,      PT_DIGIT}, // Ректификация -> Рколоны макс
;{7880,  0,      11000,  1,      PT_FLOAT}, // Ректификация -> t отбора
;{45,    0,      1500,   1,      PT_FLOAT}, // Ректификация -> dt отбора
;{1,     0,      5,      0,      PT_DIGIT}, // Ректификация -> T1 задержки клапана
;{2,     0,      5,      0,      PT_DIGIT}, // Ректификация -> T2 задержки клапана
;{9200,  0,      11000,  1,      PT_FLOAT}, // Ректификация -> t куба задержки
;{9800,  0,      11000,  1,      PT_FLOAT}, // Ректификация -> t куба откл.
;{100,   10,     1500,   4,      PT_DIGIT}, // Ректификация -> Объем голов
;{2100,  10,     3000,   5,      PT_DIGIT}, // Ректификация -> Скорость отбора
;{4,     1,      10,     6,      PT_DIGIT}, // Ректификация -> Длительность импульса
;{50,    1,      500,    4,      PT_DIGIT}, // Ректификация -> Отобранный объем
;{HEADDOZA,   1,      900,    4,      PT_DOUBLE}  // Ректификация -> Коэффициент расхода клапана
;};
;
;eeprom OWI_device t_sens_eeprom_code[MAX_DS1820];
;
;//eeprom float onePulseDose_eeprom = HEADDOZA;
;
;
;void ParamInc() {
; 0006 004D void ParamInc() {

	.CSEG
_ParamInc:
; 0006 004E     if (++params[param_id].value > params[param_id].max_value) {
	CALL SUBOPT_0x6D
	SUBI R30,LOW(-_params)
	SBCI R31,HIGH(-_params)
	MOVW R26,R30
	CALL SUBOPT_0x1
	MOVW R22,R30
	MOVW R30,R0
	__ADDW1MN _params,4
	MOVW R26,R30
	CALL SUBOPT_0x6E
	BRSH _0xC0003
; 0006 004F         params[param_id].value = params[param_id].min_value;
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x70
; 0006 0050     }
; 0006 0051 }
_0xC0003:
	RET
;
;void ParamDec() {
; 0006 0053 void ParamDec() {
_ParamDec:
; 0006 0054     if (params[param_id].value > params[param_id].min_value) {
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x71
	__ADDW2MN _params,2
	CALL SUBOPT_0x6E
	BRSH _0xC0004
; 0006 0055         params[param_id].value--;
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x72
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0006 0056     } else {
	RJMP _0xC0005
_0xC0004:
; 0006 0057         params[param_id].value = params[param_id].max_value;
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x73
; 0006 0058     }
_0xC0005:
; 0006 0059 }
	RET
;
;
;void Param10Inc() {
; 0006 005C void Param10Inc() {
_Param10Inc:
; 0006 005D     params[param_id].value += 100;
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x72
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	ST   -X,R31
	ST   -X,R30
; 0006 005E     if (params[param_id].value > params[param_id].max_value) {
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x71
	__ADDW2MN _params,4
	CALL SUBOPT_0x6E
	BRSH _0xC0006
; 0006 005F         params[param_id].value = params[param_id].min_value;
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x70
; 0006 0060     }
; 0006 0061 }
_0xC0006:
	RET
;
;void Param10Dec() {
; 0006 0063 void Param10Dec() {
_Param10Dec:
; 0006 0064     if (params[param_id].value > (params[param_id].min_value + 100)) {
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x71
	__ADDW2MN _params,2
	CALL __GETW1P
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	CP   R30,R22
	CPC  R31,R23
	BRSH _0xC0007
; 0006 0065         params[param_id].value -= 100;
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x72
	SUBI R30,LOW(100)
	SBCI R31,HIGH(100)
	ST   -X,R31
	ST   -X,R30
; 0006 0066     } else {
	RJMP _0xC0008
_0xC0007:
; 0006 0067         params[param_id].value = params[param_id].max_value;
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x73
; 0006 0068     }
_0xC0008:
; 0006 0069 }
	RET
;
;void SetParam(void){
; 0006 006B void SetParam(void){
_SetParam:
; 0006 006C     char i;
; 0006 006D     mode = SETTINGS;
	ST   -Y,R17
;	i -> R17
	LDI  R30,LOW(2)
	CALL SUBOPT_0x74
; 0006 006E     nlcd_Clear();
; 0006 006F     param_id = 0;
	LDI  R30,LOW(0)
	STS  _param_id,R30
; 0006 0070     for (i = 1; i < current_menu; i++) {
	LDI  R17,LOW(1)
_0xC000A:
	LDS  R30,_current_menu
	CP   R17,R30
	BRSH _0xC000B
; 0006 0071         param_id += menu[i].num_selections;
	LDS  R0,_param_id
	CLR  R1
	MOV  R30,R17
	LDI  R26,LOW(_menu)
	LDI  R27,HIGH(_menu)
	LDI  R31,0
	CALL __LSLW2
	CALL SUBOPT_0x5E
	LDI  R31,0
	ADD  R30,R0
	ADC  R31,R1
	STS  _param_id,R30
; 0006 0072     }
	SUBI R17,-1
	RJMP _0xC000A
_0xC000B:
; 0006 0073     param_id += current_pos;
	LDS  R26,_param_id
	CLR  R27
	LDS  R30,_current_pos
	CALL SUBOPT_0xC
	STS  _param_id,R30
; 0006 0074 };
	RJMP _0x20A000E
;
;
;void ViewSettings(){
; 0006 0077 void ViewSettings(){
_ViewSettings:
; 0006 0078     unsigned char tmp[17];
; 0006 0079     strcpyf(tmp, menu[0].items_submenu[menu[current_menu].items_submenu[current_pos].parent].name_item);
	SBIW R28,17
;	tmp -> Y+0
	CALL SUBOPT_0x75
	CALL SUBOPT_0x58
	CALL SUBOPT_0x64
; 0006 007A     sprintf(buf,"-%s-", tmp);
	__POINTW1FN _0xC0000,0
	CALL SUBOPT_0x36
	CALL SUBOPT_0x7
; 0006 007B     nlcd_GotoXY(8 - strlen(buf)/2, 1);
	CALL SUBOPT_0x66
	CALL SUBOPT_0x76
	LDI  R26,LOW(1)
	CALL SUBOPT_0x67
; 0006 007C     nlcd_Print(buf);
; 0006 007D     strcpyf(tmp, menu[current_menu].items_submenu[current_pos].name_item);
	CALL SUBOPT_0x75
	CALL SUBOPT_0x58
	CALL SUBOPT_0x77
; 0006 007E     sprintf(buf,"*%s*", tmp);
	__POINTW1FN _0xC0000,5
	CALL SUBOPT_0x36
	CALL SUBOPT_0x7
; 0006 007F     nlcd_GotoXY(8 - strlen(buf)/2, 2);
	CALL SUBOPT_0x66
	CALL SUBOPT_0x76
	LDI  R26,LOW(2)
	CALL SUBOPT_0x67
; 0006 0080     nlcd_Print(buf);
; 0006 0081 
; 0006 0082     if (params[param_id].type == PT_DOUBLE){  // for k-factor
	CALL SUBOPT_0x6D
	__ADDW1MN _params,8
	LD   R26,Z
	CPI  R26,LOW(0x3)
	BRNE _0xC000C
; 0006 0083         strcpyf(tmp, labels[params[param_id].units]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0x79
; 0006 0084         sprintf(buf,"%1.4f %s", params[param_id].value / 10000.0, tmp);
	__POINTW1FN _0xC0000,10
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x7C
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x2C
; 0006 0085     } else
	RJMP _0xC000D
_0xC000C:
; 0006 0086     if (params[param_id].type == PT_FLOAT){  // for tempreture
	CALL SUBOPT_0x6D
	__ADDW1MN _params,8
	LD   R26,Z
	CPI  R26,LOW(0x2)
	BRNE _0xC000E
; 0006 0087         strcpyf(tmp, labels[params[param_id].units]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0x79
; 0006 0088         sprintf(buf,"%3.2f %s", params[param_id].value / 100.0, tmp);
	__POINTW1FN _0xC0000,19
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x2C
; 0006 0089     } else
	RJMP _0xC000F
_0xC000E:
; 0006 008A     if (params[param_id].type == PT_DIGIT) {
	CALL SUBOPT_0x6D
	__ADDW1MN _params,8
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BRNE _0xC0010
; 0006 008B         strcpyf(tmp, labels[params[param_id].units]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0x79
; 0006 008C         sprintf(buf,"%u %s", params[param_id].value, tmp);
	__POINTW1FN _0xC0000,28
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x7E
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	CALL SUBOPT_0x27
	CALL SUBOPT_0x2C
; 0006 008D     } else
	RJMP _0xC0011
_0xC0010:
; 0006 008E         if(params[param_id].type == PT_YESNO) {
	CALL SUBOPT_0x6D
	__ADDW1MN _params,8
	LD   R30,Z
	CPI  R30,0
	BRNE _0xC0012
; 0006 008F             strcpyf(tmp, yesno[params[param_id].value]);
	CALL SUBOPT_0x78
	CALL SUBOPT_0x7E
	LDI  R26,LOW(_yesno*2)
	LDI  R27,HIGH(_yesno*2)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETW2PF
	CALL _strcpyf
; 0006 0090             sprintf(buf,"<%s>", tmp);
	CALL SUBOPT_0x2A
	__POINTW1FN _0xC0000,34
	CALL SUBOPT_0x36
	CALL SUBOPT_0x7
; 0006 0091     }
; 0006 0092     nlcd_GotoXY(7 - strlen(buf)/2, 4);
_0xC0012:
_0xC0011:
_0xC000F:
_0xC000D:
	CALL SUBOPT_0x66
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	SUB  R26,R30
	SBC  R27,R31
	ST   -Y,R26
	LDI  R26,LOW(4)
	RJMP _0x20A000F
; 0006 0093     nlcd_Print(buf);
; 0006 0094 };
;
;void SetNewParams(){
; 0006 0096 void SetNewParams(){
_SetNewParams:
; 0006 0097     unsigned char j,k;
; 0006 0098     dis_t_kuba = params[0].value / 100.0;
	ST   -Y,R17
	ST   -Y,R16
;	j -> R17
;	k -> R16
	LDS  R30,_params
	LDS  R31,_params+1
	CALL SUBOPT_0x7F
	STS  _dis_t_kuba,R30
	STS  _dis_t_kuba+1,R31
	STS  _dis_t_kuba+2,R22
	STS  _dis_t_kuba+3,R23
; 0006 0099     dis_p_ten = params[1].value;
	__GETW1MN _params,9
	STS  _dis_p_ten,R30
	STS  _dis_p_ten+1,R31
; 0006 009A     rect_p_ten_min = params[2].value;
	__GETW1MN _params,18
	STS  _rect_p_ten_min,R30
	STS  _rect_p_ten_min+1,R31
; 0006 009B     rect_p_kol_max = params[3].value;
	__GETW1MN _params,27
	STS  _rect_p_kol_max,R30
	STS  _rect_p_kol_max+1,R31
; 0006 009C     rect_t_otbora = params[4].value / 100.0;
	__GETW1MN _params,36
	CALL SUBOPT_0x7F
	STS  _rect_t_otbora,R30
	STS  _rect_t_otbora+1,R31
	STS  _rect_t_otbora+2,R22
	STS  _rect_t_otbora+3,R23
; 0006 009D     rect_dt_otbora = params[5].value / 100.0;
	__GETW1MN _params,45
	CALL SUBOPT_0x7F
	STS  _rect_dt_otbora,R30
	STS  _rect_dt_otbora+1,R31
	STS  _rect_dt_otbora+2,R22
	STS  _rect_dt_otbora+3,R23
; 0006 009E     rect_T1_valve = params[6].value;
	__GETW1MN _params,54
	STS  _rect_T1_valve,R30
	STS  _rect_T1_valve+1,R31
; 0006 009F     rect_T2_valve = params[7].value;
	__GETW1MN _params,63
	STS  _rect_T2_valve,R30
	STS  _rect_T2_valve+1,R31
; 0006 00A0     rect_t_kuba_valve = params[8].value / 100.0;
	__GETW1MN _params,72
	CALL SUBOPT_0x7F
	STS  _rect_t_kuba_valve,R30
	STS  _rect_t_kuba_valve+1,R31
	STS  _rect_t_kuba_valve+2,R22
	STS  _rect_t_kuba_valve+3,R23
; 0006 00A1     rect_t_kuba_off = params[9].value / 100.0;
	__GETW1MN _params,81
	CALL SUBOPT_0x7F
	STS  _rect_t_kuba_off,R30
	STS  _rect_t_kuba_off+1,R31
	STS  _rect_t_kuba_off+2,R22
	STS  _rect_t_kuba_off+3,R23
; 0006 00A2     rect_head_val = params[10].value;
	__GETW1MN _params,90
	STS  _rect_head_val,R30
	STS  _rect_head_val+1,R31
; 0006 00A3     rect_body_speed = params[11].value;
	__GETW1MN _params,99
	STS  _rect_body_speed,R30
	STS  _rect_body_speed+1,R31
; 0006 00A4     rect_pulse_delay = params[12].value;
	__GETB1MN _params,108
	STS  _rect_pulse_delay,R30
; 0006 00A5     factCalibrateQ =  params[13].value;
	__GETW1MN _params,117
	STS  _factCalibrateQ,R30
	STS  _factCalibrateQ+1,R31
; 0006 00A6     onePulseDose = (float)params[14].value / 10000.0;
	CALL SUBOPT_0x80
; 0006 00A7     //onePulseDose = onePulseDose_eeprom;
; 0006 00A8 
; 0006 00A9     for (j=0; j<MAX_DS1820; j++){
	LDI  R17,LOW(0)
_0xC0014:
	CPI  R17,3
	BRSH _0xC0015
; 0006 00AA         for (k=0; k<8; k++){
	LDI  R16,LOW(0)
_0xC0017:
	CPI  R16,8
	BRSH _0xC0018
; 0006 00AB             t_rom_codes[j].id[k] = t_sens_eeprom_code[j].id[k];
	CALL SUBOPT_0x10
	CALL __LSLW3
	MOVW R22,R30
	SUBI R30,LOW(-_t_rom_codes)
	SBCI R31,HIGH(-_t_rom_codes)
	MOVW R26,R30
	MOV  R30,R16
	CALL SUBOPT_0xC
	MOVW R0,R30
	MOVW R26,R22
	SUBI R26,LOW(-_t_sens_eeprom_code)
	SBCI R27,HIGH(-_t_sens_eeprom_code)
	CLR  R30
	ADD  R26,R16
	ADC  R27,R30
	CALL __EEPROMRDB
	MOVW R26,R0
	ST   X,R30
; 0006 00AC         }
	SUBI R16,-1
	RJMP _0xC0017
_0xC0018:
; 0006 00AD     }
	SUBI R17,-1
	RJMP _0xC0014
_0xC0015:
; 0006 00AE };
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;void LoadParam(){
; 0006 00B0 void LoadParam(){
_LoadParam:
; 0006 00B1    unsigned char j;
; 0006 00B2    for (j=0; j<SET_COUNT; j++) {
	ST   -Y,R17
;	j -> R17
	LDI  R17,LOW(0)
_0xC001A:
	CPI  R17,15
	BRSH _0xC001B
; 0006 00B3         params[j]= params_eeprom[j];
	LDI  R26,LOW(9)
	MUL  R17,R26
	MOVW R30,R0
	CALL SUBOPT_0x6F
	MOVW R30,R26
	SUBI R30,LOW(-_params_eeprom)
	SBCI R31,HIGH(-_params_eeprom)
	MOVW R26,R22
	LDI  R24,9
	CALL __COPYMEL
; 0006 00B4    }
	SUBI R17,-1
	RJMP _0xC001A
_0xC001B:
; 0006 00B5    //onePulseDose = onePulseDose_eeprom;
; 0006 00B6    onePulseDose = params[14].value / 10000.0;
	CALL SUBOPT_0x80
; 0006 00B7 }
	RJMP _0x20A000E
;
;void SaveParam(){
; 0006 00B9 void SaveParam(){
_SaveParam:
; 0006 00BA     unsigned char j;
; 0006 00BB 
; 0006 00BC     params[14].value = (unsigned int) (onePulseDose * 10000.0);
	ST   -Y,R17
;	j -> R17
	LDS  R26,_onePulseDose
	LDS  R27,_onePulseDose+1
	LDS  R24,_onePulseDose+2
	LDS  R25,_onePulseDose+3
	CALL SUBOPT_0x7C
	CALL __MULF12
	CALL __CFD1U
	__PUTW1MN _params,126
; 0006 00BD 
; 0006 00BE     for (j=0; j<SET_COUNT; j++) {
	LDI  R17,LOW(0)
_0xC001D:
	CPI  R17,15
	BRSH _0xC001E
; 0006 00BF         params_eeprom[j].value = params[j].value;
	LDI  R26,LOW(9)
	MUL  R17,R26
	MOVW R30,R0
	MOVW R26,R30
	SUBI R30,LOW(-_params_eeprom)
	SBCI R31,HIGH(-_params_eeprom)
	MOVW R22,R30
	MOVW R30,R26
	CALL SUBOPT_0x7E
	MOVW R26,R22
	CALL __EEPROMWRW
; 0006 00C0     }
	SUBI R17,-1
	RJMP _0xC001D
_0xC001E:
; 0006 00C1     //onePulseDose_eeprom = onePulseDose;
; 0006 00C2 }
	RJMP _0x20A000E
;
;void InitSensors(){
; 0006 00C4 void InitSensors(){
_InitSensors:
; 0006 00C5     char tmp[17];
; 0006 00C6     mode = INIT;
	SBIW R28,17
;	tmp -> Y+0
	LDI  R30,LOW(3)
	CALL SUBOPT_0x74
; 0006 00C7     nlcd_Clear();
; 0006 00C8     nlcd_GotoXY(1,0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x1C
; 0006 00C9     nlcd_PrintF("Инициализация");
	__POINTW2MN _0xC001F,0
	CALL _nlcd_PrintF
; 0006 00CA     strcpyf(tmp, menu[current_menu].items_submenu[current_pos].name_item);
	CALL SUBOPT_0x75
	CALL SUBOPT_0x58
	CALL SUBOPT_0x77
; 0006 00CB     sprintf(buf,"%s", tmp);
	__POINTW1FN _0xC0000,16
	CALL SUBOPT_0x36
	CALL SUBOPT_0x7
; 0006 00CC     nlcd_GotoXY(8 - strlen(buf)/2, 1);
	CALL SUBOPT_0x66
	CALL SUBOPT_0x76
	LDI  R26,LOW(1)
	CALL SUBOPT_0x67
; 0006 00CD     nlcd_Print(buf);
; 0006 00CE     nlcd_GotoXY(0,2);
	CALL SUBOPT_0x3
; 0006 00CF     nlcd_PrintF("Подключите один");
	__POINTW2MN _0xC001F,14
	CALL _nlcd_PrintF
; 0006 00D0     nlcd_GotoXY(3,3);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x3E
; 0006 00D1     nlcd_PrintF("датчик !!!");
	__POINTW2MN _0xC001F,30
	CALL _nlcd_PrintF
; 0006 00D2     nlcd_GotoXY(2,4);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x3F
; 0006 00D3     nlcd_PrintF("нажмите <ENT>");
	__POINTW2MN _0xC001F,41
	CALL _nlcd_PrintF
; 0006 00D4     //sprintf(buf,"ID:%X", t_sens_eeprom_code[current_pos].id[7]);
; 0006 00D5     sprintf(buf,"ID:%2X%2X",t_rom_codes[current_pos].id[6], t_rom_codes[current_pos].id[7] );
	CALL SUBOPT_0x2A
	__POINTW1FN _0xC0000,94
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x6A
	CALL __LSLW3
	__ADDW1MN _t_rom_codes,6
	LD   R30,Z
	CALL SUBOPT_0x26
	CALL SUBOPT_0x6A
	CALL __LSLW3
	__ADDW1MN _t_rom_codes,7
	LD   R30,Z
	CALL SUBOPT_0x26
	CALL SUBOPT_0x2C
; 0006 00D6     nlcd_GotoXY(8 - strlen(buf)/2, 5);
	CALL SUBOPT_0x66
	CALL SUBOPT_0x76
	LDI  R26,LOW(5)
_0x20A000F:
	CALL _nlcd_GotoXY
; 0006 00D7     nlcd_Print(buf);
	CALL SUBOPT_0x9
; 0006 00D8 };
	ADIW R28,17
	RET

	.DSEG
_0xC001F:
	.BYTE 0x37
;
;void SetSensors(){
; 0006 00DA void SetSensors(){

	.CSEG
_SetSensors:
; 0006 00DB     char k;
; 0006 00DC     nlcd_Clear();
	ST   -Y,R17
;	k -> R17
	CALL _nlcd_Clear
; 0006 00DD     // OWI_SearchDevices(ds1820_rom_codes, MAX_DS1820, BUS, &ds1820_devices);
; 0006 00DE     if (OWI_SearchDevices(ds1820_rom_codes, MAX_DS1820, BUS, &ds1820_devices) == SEARCH_SUCCESSFUL) {
	CALL SUBOPT_0x5
	CPI  R30,0
	BRNE _0xC0020
; 0006 00DF 
; 0006 00E0     //}
; 0006 00E1     //if (ds1820_devices == 1) {
; 0006 00E2         for (k=0; k<9; k++){
	LDI  R17,LOW(0)
_0xC0022:
	CPI  R17,9
	BRSH _0xC0023
; 0006 00E3             t_sens_eeprom_code[current_pos].id[k] = ds1820_rom_codes[0].id[k];
	CALL SUBOPT_0x6A
	CALL __LSLW3
	SUBI R30,LOW(-_t_sens_eeprom_code)
	SBCI R31,HIGH(-_t_sens_eeprom_code)
	MOVW R26,R30
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	CALL SUBOPT_0x10
	SUBI R30,LOW(-_ds1820_rom_codes)
	SBCI R31,HIGH(-_ds1820_rom_codes)
	LD   R30,Z
	CALL __EEPROMWRB
; 0006 00E4         }
	SUBI R17,-1
	RJMP _0xC0022
_0xC0023:
; 0006 00E5         SetNewParams();
	RCALL _SetNewParams
; 0006 00E6         nlcd_GotoXY(0,2);
	CALL SUBOPT_0x3
; 0006 00E7         nlcd_PrintF(" Инициализация ");
	__POINTW2MN _0xC0024,0
	CALL _nlcd_PrintF
; 0006 00E8         nlcd_GotoXY(3,3);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x3E
; 0006 00E9         nlcd_PrintF(" прошла");
	__POINTW2MN _0xC0024,16
	CALL _nlcd_PrintF
; 0006 00EA         nlcd_GotoXY(2,4);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x3F
; 0006 00EB         nlcd_PrintF(" успешно!");
	__POINTW2MN _0xC0024,24
	CALL _nlcd_PrintF
; 0006 00EC         SetNewParams();
	RCALL _SetNewParams
; 0006 00ED         delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0006 00EE         mode = MENU;
	LDI  R30,LOW(1)
	STS  _mode,R30
; 0006 00EF     } else {
	RJMP _0xC0025
_0xC0020:
; 0006 00F0         nlcd_GotoXY(0,2);
	CALL SUBOPT_0x3
; 0006 00F1         nlcd_PrintF(" Инициализация ");
	__POINTW2MN _0xC0024,34
	CALL SUBOPT_0x17
; 0006 00F2         nlcd_GotoXY(0,3);
	LDI  R26,LOW(3)
	CALL _nlcd_GotoXY
; 0006 00F3         nlcd_PrintF(" не прошла. Для");
	__POINTW2MN _0xC0024,50
	CALL SUBOPT_0x17
; 0006 00F4         nlcd_GotoXY(0,4);
	LDI  R26,LOW(4)
	CALL _nlcd_GotoXY
; 0006 00F5         nlcd_PrintF("повтора нажмите");
	__POINTW2MN _0xC0024,66
	CALL _nlcd_PrintF
; 0006 00F6         nlcd_GotoXY(0,5);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x8
; 0006 00F7         nlcd_PrintF("<ENT>. <ESC>");
	__POINTW2MN _0xC0024,82
	CALL SUBOPT_0x17
; 0006 00F8         nlcd_GotoXY(0,6);
	LDI  R26,LOW(6)
	CALL _nlcd_GotoXY
; 0006 00F9         nlcd_PrintF("для выхода.");
	__POINTW2MN _0xC0024,95
	CALL _nlcd_PrintF
; 0006 00FA     }
_0xC0025:
; 0006 00FB }
_0x20A000E:
	LD   R17,Y+
	RET

	.DSEG
_0xC0024:
	.BYTE 0x6B
;
;
;void CalibrateValve() {
; 0006 00FE void CalibrateValve() {

	.CSEG
_CalibrateValve:
; 0006 00FF     mode = CALIBRATE;
	LDI  R30,LOW(7)
	CALL SUBOPT_0x74
; 0006 0100     nlcd_Clear();
; 0006 0101     nlcd_GotoXY(0,1);
	CALL SUBOPT_0x16
; 0006 0102     nlcd_PrintF("   Калибровка   ");
	__POINTW2MN _0xC0026,0
	CALL _nlcd_PrintF
; 0006 0103     nlcd_PrintF(" дозир. клапана ");
	__POINTW2MN _0xC0026,17
	CALL _nlcd_PrintF
; 0006 0104     nlcd_PrintF("  Отбор 50 мл.  ");
	__POINTW2MN _0xC0026,34
	CALL _nlcd_PrintF
; 0006 0105     nlcd_PrintF("   Для начала   ");
	__POINTW2MN _0xC0026,51
	CALL _nlcd_PrintF
; 0006 0106     nlcd_PrintF(" нажмите <ENT>  ");
	__POINTW2MN _0xC0026,68
	CALL _nlcd_PrintF
; 0006 0107 }
	RET

	.DSEG
_0xC0026:
	.BYTE 0x55
;#include <hwinit.h>
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
;#include <nokia1100_lcd_lib.h>
;#include <general.h>
;
;void HW_Init(){
; 0007 0007 void HW_Init(){

	.CSEG
_HW_Init:
; 0007 0008 // Input/Output Ports initialization
; 0007 0009 // Port A initialization
; 0007 000A // Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=In Func0=In
; 0007 000B // State7=T State6=T State5=T State4=T State3=0 State2=0 State1=T State0=T
; 0007 000C PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0007 000D DDRA=0x0C;
	LDI  R30,LOW(12)
	OUT  0x1A,R30
; 0007 000E 
; 0007 000F // Port B initialization
; 0007 0010 // Func7=In Func6=In Func5=In Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0007 0011 // State7=T State6=T State5=T State4=0 State3=T State2=T State1=T State0=T
; 0007 0012 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0007 0013 DDRB=0x10;
	LDI  R30,LOW(16)
	OUT  0x17,R30
; 0007 0014 
; 0007 0015 // Port C initialization
; 0007 0016 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0007 0017 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0007 0018 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0007 0019 DDRC=0x00;
	OUT  0x14,R30
; 0007 001A 
; 0007 001B // Port D initialization
; 0007 001C // Func7=Out Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0007 001D // State7=0 State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0007 001E PORTD=0x00;
	OUT  0x12,R30
; 0007 001F DDRD=0x80;
	LDI  R30,LOW(128)
	OUT  0x11,R30
; 0007 0020 
; 0007 0021 // Port E initialization
; 0007 0022 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0007 0023 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0007 0024 PORTE=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0007 0025 DDRE=0x00;
	OUT  0x2,R30
; 0007 0026 
; 0007 0027 // Port F initialization
; 0007 0028 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0007 0029 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0007 002A PORTF=0x00;
	STS  98,R30
; 0007 002B DDRF=0x00;
	STS  97,R30
; 0007 002C 
; 0007 002D // Port G initialization
; 0007 002E // Func4=In Func3=In Func2=In Func1=In Func0=In
; 0007 002F // State4=T State3=T State2=T State1=T State0=T
; 0007 0030 PORTG=0x00;
	STS  101,R30
; 0007 0031 DDRG=0x00;
	STS  100,R30
; 0007 0032 /*
; 0007 0033 // Timer/Counter 0 initialization
; 0007 0034 // Clock source: TOSC1 pin
; 0007 0035 // Clock value: TOSC1
; 0007 0036 // Mode: Fast PWM top=0xFF
; 0007 0037 // OC0 output: Non-Inverted PWM
; 0007 0038 ASSR=0x08;
; 0007 0039 TCCR0=0x69;
; 0007 003A TCNT0=0x00;
; 0007 003B OCR0=0x00;
; 0007 003C */
; 0007 003D 
; 0007 003E // Timer/Counter 0 initialization
; 0007 003F // Clock source: System Clock
; 0007 0040 // Clock value: 460,800 kHz
; 0007 0041 // Mode: Phase correct PWM top=0xFF
; 0007 0042 // OC0 output: Non-Inverted PWM
; 0007 0043 ASSR=0x00;
	OUT  0x30,R30
; 0007 0044 TCCR0=0x63;
	LDI  R30,LOW(99)
	OUT  0x33,R30
; 0007 0045 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0007 0046 OCR0=0x00;
	OUT  0x31,R30
; 0007 0047 
; 0007 0048 // Timer/Counter 1 initialization
; 0007 0049 // Clock source: System Clock
; 0007 004A // Clock value: 14,400 kHz
; 0007 004B // Mode: Normal top=0xFFFF
; 0007 004C // OC1A output: Discon.
; 0007 004D // OC1B output: Discon.
; 0007 004E // OC1C output: Discon.
; 0007 004F // Noise Canceler: Off
; 0007 0050 // Input Capture on Falling Edge
; 0007 0051 // Timer1 Overflow Interrupt: On
; 0007 0052 // Input Capture Interrupt: Off
; 0007 0053 // Compare A Match Interrupt: Off
; 0007 0054 // Compare B Match Interrupt: Off
; 0007 0055 // Compare C Match Interrupt: Off
; 0007 0056 TCCR1A=0x00;
	OUT  0x2F,R30
; 0007 0057 TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0007 0058 TCNT1H=0xC7;
	LDI  R30,LOW(199)
	OUT  0x2D,R30
; 0007 0059 TCNT1L=0xB1;
	LDI  R30,LOW(177)
	OUT  0x2C,R30
; 0007 005A ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0007 005B ICR1L=0x00;
	OUT  0x26,R30
; 0007 005C OCR1AH=0x00;
	OUT  0x2B,R30
; 0007 005D OCR1AL=0x00;
	OUT  0x2A,R30
; 0007 005E OCR1BH=0x00;
	OUT  0x29,R30
; 0007 005F OCR1BL=0x00;
	OUT  0x28,R30
; 0007 0060 OCR1CH=0x00;
	STS  121,R30
; 0007 0061 OCR1CL=0x00;
	STS  120,R30
; 0007 0062 
; 0007 0063 // Timer/Counter 2 initialization
; 0007 0064 // Clock source: System Clock
; 0007 0065 // Clock value: 14,400 kHz
; 0007 0066 // Mode: Normal top=0xFF
; 0007 0067 // OC2 output: Disconnected
; 0007 0068 TCCR2=0x05;
	LDI  R30,LOW(5)
	OUT  0x25,R30
; 0007 0069 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0007 006A OCR2=0x00;
	OUT  0x23,R30
; 0007 006B 
; 0007 006C // Timer/Counter 3 initialization
; 0007 006D // Clock source: System Clock
; 0007 006E // Clock value: Timer3 Stopped
; 0007 006F // Mode: Normal top=0xFFFF
; 0007 0070 // OC3A output: Discon.
; 0007 0071 // OC3B output: Discon.
; 0007 0072 // OC3C output: Discon.
; 0007 0073 // Noise Canceler: Off
; 0007 0074 // Input Capture on Falling Edge
; 0007 0075 // Timer3 Overflow Interrupt: Off
; 0007 0076 // Input Capture Interrupt: Off
; 0007 0077 // Compare A Match Interrupt: Off
; 0007 0078 // Compare B Match Interrupt: Off
; 0007 0079 // Compare C Match Interrupt: Off
; 0007 007A TCCR3A=0x00;
	STS  139,R30
; 0007 007B TCCR3B=0x00;
	STS  138,R30
; 0007 007C TCNT3H=0x00;
	STS  137,R30
; 0007 007D TCNT3L=0x00;
	STS  136,R30
; 0007 007E ICR3H=0x00;
	STS  129,R30
; 0007 007F ICR3L=0x00;
	STS  128,R30
; 0007 0080 OCR3AH=0x00;
	STS  135,R30
; 0007 0081 OCR3AL=0x00;
	STS  134,R30
; 0007 0082 OCR3BH=0x00;
	STS  133,R30
; 0007 0083 OCR3BL=0x00;
	STS  132,R30
; 0007 0084 OCR3CH=0x00;
	STS  131,R30
; 0007 0085 OCR3CL=0x00;
	STS  130,R30
; 0007 0086 /*
; 0007 0087 // External Interrupt(s) initialization
; 0007 0088 // INT0: Off
; 0007 0089 // INT1: Off
; 0007 008A // INT2: On
; 0007 008B // INT2 Mode: Falling Edge
; 0007 008C // INT3: Off
; 0007 008D // INT4: Off
; 0007 008E // INT5: Off
; 0007 008F // INT6: Off
; 0007 0090 // INT7: Off
; 0007 0091 EICRA=0x20;
; 0007 0092 EICRB=0x00;
; 0007 0093 EIMSK=0x04;
; 0007 0094 EIFR=0x04;
; 0007 0095 */
; 0007 0096 
; 0007 0097 // External Interrupt(s) initialization
; 0007 0098 // INT0: Off
; 0007 0099 // INT1: Off
; 0007 009A // INT2: On
; 0007 009B // INT2 Mode: Rising Edge
; 0007 009C // INT3: Off
; 0007 009D // INT4: Off
; 0007 009E // INT5: Off
; 0007 009F // INT6: Off
; 0007 00A0 // INT7: Off
; 0007 00A1 EICRA=0x30;
	LDI  R30,LOW(48)
	STS  106,R30
; 0007 00A2 EICRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x3A,R30
; 0007 00A3 EIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0007 00A4 EIFR=0x04;
	OUT  0x38,R30
; 0007 00A5 
; 0007 00A6 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0007 00A7 TIMSK=0x45;
	LDI  R30,LOW(69)
	OUT  0x37,R30
; 0007 00A8 
; 0007 00A9 ETIMSK=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0007 00AA 
; 0007 00AB // USART0 initialization
; 0007 00AC // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0007 00AD // USART0 Receiver: On
; 0007 00AE // USART0 Transmitter: On
; 0007 00AF // USART0 Mode: Asynchronous
; 0007 00B0 // USART0 Baud Rate: 9600
; 0007 00B1 UCSR0A=0x00;
	OUT  0xB,R30
; 0007 00B2 UCSR0B=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0007 00B3 UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  149,R30
; 0007 00B4 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0007 00B5 UBRR0L=0x5F;
	LDI  R30,LOW(95)
	OUT  0x9,R30
; 0007 00B6 
; 0007 00B7 // USART1 initialization
; 0007 00B8 // USART1 disabled
; 0007 00B9 UCSR1B=0x00;
	LDI  R30,LOW(0)
	STS  154,R30
; 0007 00BA 
; 0007 00BB // Analog Comparator initialization
; 0007 00BC // Analog Comparator: Off
; 0007 00BD // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0007 00BE ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0007 00BF SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0007 00C0 
; 0007 00C1 // ADC initialization
; 0007 00C2 // ADC Clock frequency: 921,600 kHz
; 0007 00C3 // ADC Voltage Reference: AVCC pin
; 0007 00C4 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0007 00C5 ADCSRA=0x8C;
	LDI  R30,LOW(140)
	OUT  0x6,R30
; 0007 00C6 
; 0007 00C7 // SPI initialization
; 0007 00C8 // SPI disabled
; 0007 00C9 SPCR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0007 00CA 
; 0007 00CB // TWI initialization
; 0007 00CC // TWI disabled
; 0007 00CD TWCR=0x00;
	STS  116,R30
; 0007 00CE 
; 0007 00CF VALVE_CLS;
	CBI  0x1B,3
; 0007 00D0 HEATER_OFF;
	CBI  0x1B,2
; 0007 00D1 
; 0007 00D2 };
	RET
;
;#ifdef HW1_P
;void PresureInit(){
;    p_offset = read_adc(0);
;    nlcd_GotoXY(0,1);
;    nlcd_PrintF("   Калибровка   ");
;    nlcd_PrintF("    датчика     ");
;    nlcd_PrintF("  давления...   ");
;    delay_ms(2000);
;    nlcd_Clear();
;    p_offset = read_adc(0);
;};
;#endif
;// This file has been prepared for Doxygen automatic documentation generation.
;/*! \file ********************************************************************
;*
;* Atmel Corporation
;*
;* \li File:               OWIcrc.c
;* \li Compiler:           IAR EWAAVR 3.20a
;* \li Support mail:       avr@atmel.com
;*
;* \li Supported devices:  All AVRs.
;*
;* \li Application Note:   AVR318 - Dallas 1-Wire(R) master.
;*
;*
;* \li Description:        CRC algorithms typically used in a 1-Wire(R)
;*                         environment.
;*
;*                         $Revision: 1.7 $
;*                         $Date: Thursday, August 19, 2004 14:27:16 UTC $
;****************************************************************************/
;
;#include "OWIcrc.h"
;#include "OWIdefs.h"
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
;
;
;/*! \brief  Compute the CRC8 value of a data set.
; *
; *  This function will compute the CRC8 or DOW-CRC of inData using seed
; *  as inital value for the CRC.
; *
; *  \param  inData  One byte of data to compute CRC from.
; *
; *  \param  seed    The starting value of the CRC.
; *
; *  \return The CRC8 of inData with seed as initial value.
; *
; *  \note   Setting seed to 0 computes the crc8 of the inData.
; *
; *  \note   Constantly passing the return value of this function
; *          As the seed argument computes the CRC8 value of a
; *          longer string of data.
; */
;unsigned char OWI_ComputeCRC8(unsigned char inData, unsigned char seed)
; 0008 002C {

	.CSEG
_OWI_ComputeCRC8:
; 0008 002D     unsigned char bitsLeft;
; 0008 002E     unsigned char temp;
; 0008 002F 
; 0008 0030     for (bitsLeft = 8; bitsLeft > 0; bitsLeft--)
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	inData -> Y+3
;	seed -> Y+2
;	bitsLeft -> R17
;	temp -> R16
	LDI  R17,LOW(8)
_0x100004:
	CPI  R17,1
	BRLO _0x100005
; 0008 0031     {
; 0008 0032         temp = ((seed ^ inData) & 0x01);
	LDD  R30,Y+3
	LDD  R26,Y+2
	EOR  R26,R30
	LDI  R30,LOW(1)
	AND  R30,R26
	MOV  R16,R30
; 0008 0033         if (temp == 0)
	CPI  R16,0
	BRNE _0x100006
; 0008 0034         {
; 0008 0035             seed >>= 1;
	LDD  R30,Y+2
	LSR  R30
	RJMP _0x100011
; 0008 0036         }
; 0008 0037         else
_0x100006:
; 0008 0038         {
; 0008 0039             seed ^= 0x18;
	LDD  R26,Y+2
	LDI  R30,LOW(24)
	EOR  R30,R26
	STD  Y+2,R30
; 0008 003A             seed >>= 1;
	LSR  R30
	STD  Y+2,R30
; 0008 003B             seed |= 0x80;
	ORI  R30,0x80
_0x100011:
	STD  Y+2,R30
; 0008 003C         }
; 0008 003D         inData >>= 1;
	LDD  R30,Y+3
	LSR  R30
	STD  Y+3,R30
; 0008 003E     }
	SUBI R17,1
	RJMP _0x100004
_0x100005:
; 0008 003F     return seed;
	LDD  R30,Y+2
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A000D
; 0008 0040 }
;
;
;/*! \brief  Compute the CRC16 value of a data set.
; *
; *  This function will compute the CRC16 of inData using seed
; *  as inital value for the CRC.
; *
; *  \param  inData  One byte of data to compute CRC from.
; *
; *  \param  seed    The starting value of the CRC.
; *
; *  \return The CRC16 of inData with seed as initial value.
; *
; *  \note   Setting seed to 0 computes the crc16 of the inData.
; *
; *  \note   Constantly passing the return value of this function
; *          As the seed argument computes the CRC16 value of a
; *          longer string of data.
; */
;unsigned int OWI_ComputeCRC16(unsigned char inData, unsigned int seed)
; 0008 0055 {
; 0008 0056     unsigned char bitsLeft;
; 0008 0057     unsigned char temp;
; 0008 0058 
; 0008 0059     for (bitsLeft = 8; bitsLeft > 0; bitsLeft--)
;	inData -> Y+4
;	seed -> Y+2
;	bitsLeft -> R17
;	temp -> R16
; 0008 005A     {
; 0008 005B         temp = ((seed ^ inData) & 0x01);
; 0008 005C         if (temp == 0)
; 0008 005D         {
; 0008 005E             seed >>= 1;
; 0008 005F         }
; 0008 0060         else
; 0008 0061         {
; 0008 0062             seed ^= 0x4002;
; 0008 0063             seed >>= 1;
; 0008 0064             seed |= 0x8000;
; 0008 0065         }
; 0008 0066         inData >>= 1;
; 0008 0067     }
; 0008 0068     return seed;
; 0008 0069 }
;
;
;/*! \brief  Calculate and check the CRC of a 64 bit ROM identifier.
; *
; *  This function computes the CRC8 value of the first 56 bits of a
; *  64 bit identifier. It then checks the calculated value against the
; *  CRC value stored in ROM.
; *
; *  \param  romvalue    A pointer to an array holding a 64 bit identifier.
; *
; *  \retval OWI_CRC_OK      The CRC's matched.
; *  \retval OWI_CRC_ERROR   There was a discrepancy between the calculated and the stored CRC.
; */
;unsigned char OWI_CheckRomCRC(unsigned char * romValue)
; 0008 0078 {
_OWI_CheckRomCRC:
; 0008 0079     unsigned char i;
; 0008 007A     unsigned char crc8 = 0;
; 0008 007B 
; 0008 007C     for (i = 0; i < 7; i++)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*romValue -> Y+2
;	i -> R17
;	crc8 -> R16
	LDI  R16,0
	LDI  R17,LOW(0)
_0x10000E:
	CPI  R17,7
	BRSH _0x10000F
; 0008 007D     {
; 0008 007E         crc8 = OWI_ComputeCRC8(*romValue, crc8);
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X
	ST   -Y,R30
	MOV  R26,R16
	RCALL _OWI_ComputeCRC8
	MOV  R16,R30
; 0008 007F         romValue++;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,1
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0008 0080     }
	SUBI R17,-1
	RJMP _0x10000E
_0x10000F:
; 0008 0081     if (crc8 == (*romValue))
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X
	CP   R30,R16
	BRNE _0x100010
; 0008 0082     {
; 0008 0083         return OWI_CRC_OK;
	LDI  R30,LOW(0)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A000D
; 0008 0084     }
; 0008 0085     return OWI_CRC_ERROR;
_0x100010:
	LDI  R30,LOW(1)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A000D
; 0008 0086 }
;// This file has been prepared for Doxygen automatic documentation generation.
;/*! \file ********************************************************************
;*
;* Atmel Corporation
;*
;* \li File:               OWIHighLevelFunctions.c
;* \li Compiler:           IAR EWAAVR 3.20a
;* \li Support mail:       avr@atmel.com
;*
;* \li Supported devices:  All AVRs.
;*
;* \li Application Note:   AVR318 - Dallas 1-Wire(R) master.
;*
;*
;* \li Description:        High level functions for transmission of full bytes
;*                         on the 1-Wire(R) bus and implementations of ROM
;*                         commands.
;*
;*                         $Revision: 1.7 $
;*                         $Date: Thursday, August 19, 2004 14:27:18 UTC $
;****************************************************************************/
;#include "compilers.h"
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
;#include "OWIHighLevelFunctions.h"
;#include "OWIBitFunctions.h"
;#include "OWIPolled.h"
;#include "OWIcrc.h"
;
;/*! \brief  Sends one byte of data on the 1-Wire(R) bus(es).
; *
; *  This function automates the task of sending a complete byte
; *  of data on the 1-Wire bus(es).
; *
; *  \param  data    The data to send on the bus(es).
; *
; *  \param  pins    A bitmask of the buses to send the data to.
; */
;void OWI_SendByte(unsigned char data, unsigned char pin)
; 0009 0026 {

	.CSEG
_OWI_SendByte:
; 0009 0027     unsigned char temp;
; 0009 0028     unsigned char i;
; 0009 0029 
; 0009 002A     // Do once for each bit
; 0009 002B     for (i = 0; i < 8; i++)
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	data -> Y+3
;	pin -> Y+2
;	temp -> R17
;	i -> R16
	LDI  R16,LOW(0)
_0x120004:
	CPI  R16,8
	BRSH _0x120005
; 0009 002C     {
; 0009 002D         // Determine if lsb is '0' or '1' and transmit corresponding
; 0009 002E         // waveform on the bus.
; 0009 002F         temp = data & 0x01;
	LDD  R30,Y+3
	ANDI R30,LOW(0x1)
	MOV  R17,R30
; 0009 0030         if (temp)
	CPI  R17,0
	BREQ _0x120006
; 0009 0031         {
; 0009 0032             OWI_WriteBit1(pin);
	LDD  R26,Y+2
	RCALL _OWI_WriteBit1
; 0009 0033         }
; 0009 0034         else
	RJMP _0x120007
_0x120006:
; 0009 0035         {
; 0009 0036             OWI_WriteBit0(pin);
	LDD  R26,Y+2
	RCALL _OWI_WriteBit0
; 0009 0037         }
_0x120007:
; 0009 0038         // Right shift the data to get next bit.
; 0009 0039         data >>= 1;
	LDD  R30,Y+3
	LSR  R30
	STD  Y+3,R30
; 0009 003A     }
	SUBI R16,-1
	RJMP _0x120004
_0x120005:
; 0009 003B }
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A000D
;
;
;/*! \brief  Receives one byte of data from the 1-Wire(R) bus.
; *
; *  This function automates the task of receiving a complete byte
; *  of data from the 1-Wire bus.
; *
; *  \param  pin     A bitmask of the bus to read from.
; *
; *  \return     The byte read from the bus.
; */
;unsigned char OWI_ReceiveByte(unsigned char pin)
; 0009 0048 {
_OWI_ReceiveByte:
; 0009 0049     unsigned char data;
; 0009 004A     unsigned char i;
; 0009 004B 
; 0009 004C     // Clear the temporary input variable.
; 0009 004D     data = 0x00;
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	pin -> Y+2
;	data -> R17
;	i -> R16
	LDI  R17,LOW(0)
; 0009 004E 
; 0009 004F     // Do once for each bit
; 0009 0050     for (i = 0; i < 8; i++)
	LDI  R16,LOW(0)
_0x120009:
	CPI  R16,8
	BRSH _0x12000A
; 0009 0051     {
; 0009 0052         // Shift temporary input variable right.
; 0009 0053         data >>= 1;
	LSR  R17
; 0009 0054         // Set the msb if a '1' value is read from the bus.
; 0009 0055         // Leave as it is ('0') else.
; 0009 0056         if (OWI_ReadBit(pin))
	LDD  R26,Y+2
	RCALL _OWI_ReadBit
	CPI  R30,0
	BREQ _0x12000B
; 0009 0057         {
; 0009 0058             // Set msb
; 0009 0059             data |= 0x80;
	ORI  R17,LOW(128)
; 0009 005A         }
; 0009 005B     }
_0x12000B:
	SUBI R16,-1
	RJMP _0x120009
_0x12000A:
; 0009 005C     return data;
	MOV  R30,R17
	JMP  _0x20A0008
; 0009 005D }
;
;
;/*! \brief  Sends the SKIP ROM command to the 1-Wire bus(es).
; *
; *  \param  pins    A bitmask of the buses to send the SKIP ROM command to.
; */
;void OWI_SkipRom(unsigned char pin)
; 0009 0065 {
_OWI_SkipRom:
; 0009 0066     // Send the SKIP ROM command on the bus.
; 0009 0067     OWI_SendByte(OWI_ROM_SKIP, pin);
	ST   -Y,R26
;	pin -> Y+0
	LDI  R30,LOW(204)
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _OWI_SendByte
; 0009 0068 }
	RJMP _0x20A000A
;
;
;/*! \brief  Sends the READ ROM command and reads back the ROM id.
; *
; *  \param  romValue    A pointer where the id will be placed.
; *
; *  \param  pin     A bitmask of the bus to read from.
; */
;void OWI_ReadRom(unsigned char * romValue, unsigned char pin)
; 0009 0072 {
; 0009 0073     unsigned char bytesLeft = 8;
; 0009 0074 
; 0009 0075     // Send the READ ROM command on the bus.
; 0009 0076     OWI_SendByte(OWI_ROM_READ, pin);
;	*romValue -> Y+2
;	pin -> Y+1
;	bytesLeft -> R17
; 0009 0077 
; 0009 0078     // Do 8 times.
; 0009 0079     while (bytesLeft > 0)
; 0009 007A     {
; 0009 007B         // Place the received data in memory.
; 0009 007C         *romValue++ = OWI_ReceiveByte(pin);
; 0009 007D         bytesLeft--;
; 0009 007E     }
; 0009 007F }
;
;
;/*! \brief  Sends the MATCH ROM command and the ROM id to match against.
; *
; *  \param  romValue    A pointer to the ID to match against.
; *
; *  \param  pins    A bitmask of the buses to perform the MATCH ROM command on.
; */
;void OWI_MatchRom(unsigned char * romValue, unsigned char pin)
; 0009 0089 {
_OWI_MatchRom:
; 0009 008A     unsigned char bytesLeft = 8;
; 0009 008B 
; 0009 008C     // Send the MATCH ROM command.
; 0009 008D     OWI_SendByte(OWI_ROM_MATCH, pin);
	ST   -Y,R26
	ST   -Y,R17
;	*romValue -> Y+2
;	pin -> Y+1
;	bytesLeft -> R17
	LDI  R17,8
	LDI  R30,LOW(85)
	ST   -Y,R30
	LDD  R26,Y+2
	RCALL _OWI_SendByte
; 0009 008E 
; 0009 008F     // Do once for each byte.
; 0009 0090     while (bytesLeft > 0)
_0x12000F:
	CPI  R17,1
	BRLO _0x120011
; 0009 0091     {
; 0009 0092         // Transmit 1 byte of the ID to match.
; 0009 0093         OWI_SendByte(*romValue++, pin);
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X+
	STD  Y+2,R26
	STD  Y+2+1,R27
	ST   -Y,R30
	LDD  R26,Y+2
	RCALL _OWI_SendByte
; 0009 0094         bytesLeft--;
	SUBI R17,1
; 0009 0095     }
	RJMP _0x12000F
_0x120011:
; 0009 0096 }
	LDD  R17,Y+0
_0x20A000D:
	ADIW R28,4
	RET
;
;
;/*! \brief  Sends the SEARCH ROM command and returns 1 id found on the
; *          1-Wire(R) bus.
; *
; *  \param  bitPattern      A pointer to an 8 byte char array where the
; *                          discovered identifier will be placed. When
; *                          searching for several slaves, a copy of the
; *                          last found identifier should be supplied in
; *                          the array, or the search will fail.
; *
; *  \param  lastDeviation   The bit position where the algorithm made a
; *                          choice the last time it was run. This argument
; *                          should be 0 when a search is initiated. Supplying
; *                          the return argument of this function when calling
; *                          repeatedly will go through the complete slave
; *                          search.
; *
; *  \param  pin             A bit-mask of the bus to perform a ROM search on.
; *
; *  \return The last bit position where there was a discrepancy between slave addresses the last time this function was run. Returns OWI_ROM_SEARCH_FAILED if an error was detected (e.g. a device was connected to the bus during the search), or OWI_ROM_SEARCH_FINISHED when there are no more devices to be discovered.
; *
; *  \note   See main.c for an example of how to utilize this function.
; */
;unsigned char OWI_SearchRom(unsigned char * bitPattern, unsigned char lastDeviation, unsigned char pin)
; 0009 00B0 {
_OWI_SearchRom:
; 0009 00B1     unsigned char currentBit = 1;
; 0009 00B2     unsigned char newDeviation = 0;
; 0009 00B3     unsigned char bitMask = 0x01;
; 0009 00B4     unsigned char bitA;
; 0009 00B5     unsigned char bitB;
; 0009 00B6 
; 0009 00B7     // Send SEARCH ROM command on the bus.
; 0009 00B8     OWI_SendByte(OWI_ROM_SEARCH, pin);
	ST   -Y,R26
	CALL __SAVELOCR6
;	*bitPattern -> Y+8
;	lastDeviation -> Y+7
;	pin -> Y+6
;	currentBit -> R17
;	newDeviation -> R16
;	bitMask -> R19
;	bitA -> R18
;	bitB -> R21
	LDI  R17,1
	LDI  R16,0
	LDI  R19,1
	LDI  R30,LOW(240)
	ST   -Y,R30
	LDD  R26,Y+7
	RCALL _OWI_SendByte
; 0009 00B9 
; 0009 00BA     // Walk through all 64 bits.
; 0009 00BB     while (currentBit <= 64)
_0x120012:
	CPI  R17,65
	BRLO PC+3
	JMP _0x120014
; 0009 00BC     {
; 0009 00BD         // Read bit from bus twice.
; 0009 00BE         bitA = OWI_ReadBit(pin);
	LDD  R26,Y+6
	RCALL _OWI_ReadBit
	MOV  R18,R30
; 0009 00BF         bitB = OWI_ReadBit(pin);
	LDD  R26,Y+6
	RCALL _OWI_ReadBit
	MOV  R21,R30
; 0009 00C0 
; 0009 00C1         if (bitA && bitB)
	CPI  R18,0
	BREQ _0x120016
	CPI  R21,0
	BRNE _0x120017
_0x120016:
	RJMP _0x120015
_0x120017:
; 0009 00C2         {
; 0009 00C3             // Both bits 1 (Error).
; 0009 00C4             newDeviation = OWI_ROM_SEARCH_FAILED;
	LDI  R16,LOW(255)
; 0009 00C5             return SEARCH_ERROR;
	LDI  R30,LOW(255)
	RJMP _0x20A000C
; 0009 00C6         }
; 0009 00C7         else if (bitA ^ bitB)
_0x120015:
	MOV  R30,R21
	EOR  R30,R18
	BREQ _0x120019
; 0009 00C8         {
; 0009 00C9             // Bits A and B are different. All devices have the same bit here.
; 0009 00CA             // Set the bit in bitPattern to this value.
; 0009 00CB             if (bitA)
	CPI  R18,0
	BREQ _0x12001A
; 0009 00CC             {
; 0009 00CD                 (*bitPattern) |= bitMask;
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LD   R30,X
	OR   R30,R19
	RJMP _0x120046
; 0009 00CE             }
; 0009 00CF             else
_0x12001A:
; 0009 00D0             {
; 0009 00D1                 (*bitPattern) &= ~bitMask;
	CALL SUBOPT_0x81
_0x120046:
	ST   X,R30
; 0009 00D2             }
; 0009 00D3         }
; 0009 00D4         else // Both bits 0
	RJMP _0x12001C
_0x120019:
; 0009 00D5         {
; 0009 00D6             // If this is where a choice was made the last time,
; 0009 00D7             // a '1' bit is selected this time.
; 0009 00D8             if (currentBit == lastDeviation)
	LDD  R30,Y+7
	CP   R30,R17
	BRNE _0x12001D
; 0009 00D9             {
; 0009 00DA                 (*bitPattern) |= bitMask;
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LD   R30,X
	OR   R30,R19
	ST   X,R30
; 0009 00DB             }
; 0009 00DC             // For the rest of the id, '0' bits are selected when
; 0009 00DD             // discrepancies occur.
; 0009 00DE             else if (currentBit > lastDeviation)
	RJMP _0x12001E
_0x12001D:
	LDD  R30,Y+7
	CP   R30,R17
	BRSH _0x12001F
; 0009 00DF             {
; 0009 00E0                 (*bitPattern) &= ~bitMask;
	CALL SUBOPT_0x81
	ST   X,R30
; 0009 00E1                 newDeviation = currentBit;
	MOV  R16,R17
; 0009 00E2             }
; 0009 00E3             // If current bit in bit pattern = 0, then this is
; 0009 00E4             // out new deviation.
; 0009 00E5             else if ( !(*bitPattern & bitMask))
	RJMP _0x120020
_0x12001F:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LD   R30,X
	AND  R30,R19
	BRNE _0x120021
; 0009 00E6             {
; 0009 00E7                 newDeviation = currentBit;
	MOV  R16,R17
; 0009 00E8             }
; 0009 00E9             // IF the bit is already 1, do nothing.
; 0009 00EA             else
_0x120021:
; 0009 00EB             {
; 0009 00EC 
; 0009 00ED             }
_0x120020:
_0x12001E:
; 0009 00EE         }
_0x12001C:
; 0009 00EF 
; 0009 00F0 
; 0009 00F1         // Send the selected bit to the bus.
; 0009 00F2         if ((*bitPattern) & bitMask)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LD   R30,X
	AND  R30,R19
	BREQ _0x120023
; 0009 00F3         {
; 0009 00F4             OWI_WriteBit1(pin);
	LDD  R26,Y+6
	RCALL _OWI_WriteBit1
; 0009 00F5         }
; 0009 00F6         else
	RJMP _0x120024
_0x120023:
; 0009 00F7         {
; 0009 00F8             OWI_WriteBit0(pin);
	LDD  R26,Y+6
	RCALL _OWI_WriteBit0
; 0009 00F9         }
_0x120024:
; 0009 00FA 
; 0009 00FB         // Increment current bit.
; 0009 00FC         currentBit++;
	SUBI R17,-1
; 0009 00FD 
; 0009 00FE         // Adjust bitMask and bitPattern pointer.
; 0009 00FF         bitMask <<= 1;
	LSL  R19
; 0009 0100         if (!bitMask)
	CPI  R19,0
	BRNE _0x120025
; 0009 0101         {
; 0009 0102             bitMask = 0x01;
	LDI  R19,LOW(1)
; 0009 0103             bitPattern++;
	CALL SUBOPT_0x82
; 0009 0104         }
; 0009 0105     }
_0x120025:
	RJMP _0x120012
_0x120014:
; 0009 0106     return newDeviation;
	MOV  R30,R16
_0x20A000C:
	CALL __LOADLOCR6
	ADIW R28,10
	RET
; 0009 0107 }
;
;/*! \brief  Perform a 1-Wire search
; *
; *  This function shows how the OWI_SearchRom function can be used to
; *  discover all slaves on the bus. It will also CRC check the 64 bit
; *  identifiers.
; *
; *  \param  devices Pointer to an array of type OWI_device. The discovered
; *                  devices will be placed from the beginning of this array.
; *
; *  \param  len     The length of the device array. (Max. number of elements).
; *
; *  \param  buses   Bitmask of the buses to perform search on.
; *
; *  \retval SEARCH_SUCCESSFUL   Search completed successfully.
; *  \retval SEARCH_CRC_ERROR    A CRC error occured. Probably because of noise
; *                              during transmission.
; */
;unsigned char OWI_SearchDevices(OWI_device * devices, unsigned char numDevices, unsigned char pin, unsigned char *num)
; 0009 011B {
_OWI_SearchDevices:
; 0009 011C     unsigned char i, j;
; 0009 011D     unsigned char * newID;
; 0009 011E     unsigned char * currentID;
; 0009 011F     unsigned char lastDeviation;
; 0009 0120     unsigned char numFoundDevices;
; 0009 0121     unsigned char flag = SEARCH_SUCCESSFUL;
; 0009 0122 
; 0009 0123     //сбрасываем адреса 1Wire устройств
; 0009 0124     for (i = 0; i < numDevices; i++)
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	LDI  R30,LOW(0)
	ST   Y,R30
	CALL __SAVELOCR6
;	*devices -> Y+13
;	numDevices -> Y+12
;	pin -> Y+11
;	*num -> Y+9
;	i -> R17
;	j -> R16
;	*newID -> R18,R19
;	*currentID -> R20,R21
;	lastDeviation -> Y+8
;	numFoundDevices -> Y+7
;	flag -> Y+6
	LDI  R17,LOW(0)
_0x120027:
	LDD  R30,Y+12
	CP   R17,R30
	BRSH _0x120028
; 0009 0125     {
; 0009 0126         for (j = 0; j < 8; j++)
	LDI  R16,LOW(0)
_0x12002A:
	CPI  R16,8
	BRSH _0x12002B
; 0009 0127         {
; 0009 0128             devices[i].id[j] = 0x00;
	CALL SUBOPT_0x10
	CALL SUBOPT_0x83
	ADD  R26,R30
	ADC  R27,R31
	CLR  R30
	ADD  R26,R16
	ADC  R27,R30
	ST   X,R30
; 0009 0129         }
	SUBI R16,-1
	RJMP _0x12002A
_0x12002B:
; 0009 012A     }
	SUBI R17,-1
	RJMP _0x120027
_0x120028:
; 0009 012B 
; 0009 012C     numFoundDevices = 0;
	LDI  R30,LOW(0)
	STD  Y+7,R30
; 0009 012D     newID = devices[0].id;
	__GETWRS 18,19,13
; 0009 012E     lastDeviation = 0;
	STD  Y+8,R30
; 0009 012F     currentID = newID;
	MOVW R20,R18
; 0009 0130     *num = 0;
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
; 0009 0131 
; 0009 0132     do
_0x12002D:
; 0009 0133     {
; 0009 0134       memcpy(newID, currentID, 8);
	ST   -Y,R19
	ST   -Y,R18
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(8)
	LDI  R27,0
	CALL _memcpy
; 0009 0135       if (!OWI_DetectPresence(pin)){
	LDD  R26,Y+11
	RCALL _OWI_DetectPresence
	CPI  R30,0
	BRNE _0x12002F
; 0009 0136         return SEARCH_ERROR;
	LDI  R30,LOW(255)
	RJMP _0x20A000B
; 0009 0137       };
_0x12002F:
; 0009 0138       lastDeviation = OWI_SearchRom(newID, lastDeviation, pin);
	ST   -Y,R19
	ST   -Y,R18
	LDD  R30,Y+10
	ST   -Y,R30
	LDD  R26,Y+14
	RCALL _OWI_SearchRom
	STD  Y+8,R30
; 0009 0139       currentID = newID;
	MOVW R20,R18
; 0009 013A       numFoundDevices++;
	LDD  R30,Y+7
	SUBI R30,-LOW(1)
	STD  Y+7,R30
; 0009 013B       newID=devices[numFoundDevices].id;
	LDI  R31,0
	CALL SUBOPT_0x83
	ADD  R30,R26
	ADC  R31,R27
	MOVW R18,R30
; 0009 013C     } while(lastDeviation != OWI_ROM_SEARCH_FINISHED);
	LDD  R30,Y+8
	CPI  R30,0
	BRNE _0x12002D
; 0009 013D 
; 0009 013E 
; 0009 013F     // Go through all the devices and do CRC check.
; 0009 0140     for (i = 0; i < numFoundDevices; i++)
	LDI  R17,LOW(0)
_0x120031:
	LDD  R30,Y+7
	CP   R17,R30
	BRSH _0x120032
; 0009 0141     {
; 0009 0142         // If any id has a crc error, return error.
; 0009 0143         if(OWI_CheckRomCRC(devices[i].id) != OWI_CRC_OK)
	CALL SUBOPT_0x10
	CALL SUBOPT_0x83
	ADD  R26,R30
	ADC  R27,R31
	RCALL _OWI_CheckRomCRC
	CPI  R30,0
	BREQ _0x120033
; 0009 0144         {
; 0009 0145             flag = SEARCH_CRC_ERROR;
	LDI  R30,LOW(1)
	STD  Y+6,R30
; 0009 0146         }
; 0009 0147         else
	RJMP _0x120034
_0x120033:
; 0009 0148         {
; 0009 0149            (*num)++;
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
; 0009 014A         }
_0x120034:
; 0009 014B     }
	SUBI R17,-1
	RJMP _0x120031
_0x120032:
; 0009 014C     // Else, return Successful.
; 0009 014D     return flag;
	LDD  R30,Y+6
_0x20A000B:
	CALL __LOADLOCR6
	ADIW R28,15
	RET
; 0009 014E }
;
;/*! \brief  Find the first device of a family based on the family id
; *
; *  This function returns a pointer to a device in the device array
; *  that matches the specified family.
; *
; *  \param  familyID    The 8 bit family ID to search for.
; *
; *  \param  devices     An array of devices to search through.
; *
; *  \param  size        The size of the array 'devices'
; *
; *  \return A pointer to a device of the family.
; *  \retval NULL    if no device of the family was found.
; */
;unsigned char FindFamily(unsigned char familyID, OWI_device * devices, unsigned char numDevices, unsigned char lastNum)
; 0009 015F {
; 0009 0160     unsigned char i;
; 0009 0161 
; 0009 0162     if (lastNum == AT_FIRST){
;	familyID -> Y+5
;	*devices -> Y+3
;	numDevices -> Y+2
;	lastNum -> Y+1
;	i -> R17
; 0009 0163       i = 0;
; 0009 0164     }
; 0009 0165     else{
; 0009 0166       i = lastNum + 1;
; 0009 0167     }
; 0009 0168 
; 0009 0169     // Search through the array.
; 0009 016A     while (i < numDevices)
; 0009 016B     {
; 0009 016C         // Return the pointer if there is a family id match.
; 0009 016D         if ((*devices).id[0] == familyID)
; 0009 016E         {
; 0009 016F             return i;
; 0009 0170         }
; 0009 0171         devices++;
; 0009 0172         i++;
; 0009 0173     }
; 0009 0174     return SEARCH_ERROR;
; 0009 0175 }
;
;
;/*! \brief  Start temperature convert for all devicec on bus
; *
; *  This function
; *
; *  \param  pin    Bitmask of the buses to perform search on.
; *
; */
;
;void StartAllConvert_T(unsigned char pin)
; 0009 0181 {
_StartAllConvert_T:
; 0009 0182     OWI_DetectPresence(pin);
	ST   -Y,R26
;	pin -> Y+0
	LD   R26,Y
	RCALL _OWI_DetectPresence
; 0009 0183     OWI_SkipRom(pin);
	LD   R26,Y
	RCALL _OWI_SkipRom
; 0009 0184     OWI_SendByte(DS18B20_CONVERT_T, pin);
	LDI  R30,LOW(68)
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _OWI_SendByte
; 0009 0185 }
	RJMP _0x20A000A
;
;
;float GetTemperatureSkipRom(unsigned char pin)
; 0009 0189 {
; 0009 018A     unsigned int tmp = 0, sig = 0;
; 0009 018B     float temperature;
; 0009 018C     unsigned char scratchpad[9];
; 0009 018D     OWI_DetectPresence(pin);
;	pin -> Y+17
;	tmp -> R16,R17
;	sig -> R18,R19
;	temperature -> Y+13
;	scratchpad -> Y+4
; 0009 018E     OWI_SkipRom(pin);
; 0009 018F     OWI_SendByte(DS18B20_READ_SCRATCHPAD, pin);
; 0009 0190     scratchpad[0] = OWI_ReceiveByte(pin);
; 0009 0191     scratchpad[1] = OWI_ReceiveByte(pin);
; 0009 0192 
; 0009 0193     if ((scratchpad[1]&128) != 0){
; 0009 0194       tmp = ((unsigned int)scratchpad[1]<<8)|scratchpad[0];
; 0009 0195       tmp = ~tmp + 1;
; 0009 0196       scratchpad[0] = tmp;
; 0009 0197       scratchpad[1] = tmp>>8;
; 0009 0198       sig = 1;
; 0009 0199     }
; 0009 019A     /*целое знач. температуры*/
; 0009 019B     temperature = (float)((scratchpad[0]>>4)|((scratchpad[1]&7)<<4));
; 0009 019C     /*выводим дробную часть знач. температуры*/
; 0009 019D     temperature += ((float)(scratchpad[0]&15) * 0.0625);
; 0009 019E     if (sig) {
; 0009 019F         temperature *= -1.0;
; 0009 01A0     }
; 0009 01A1     return temperature;
; 0009 01A2 }
;
;float GetTemperatureMatchRom(unsigned char * romValue, unsigned char pin)
; 0009 01A5 {
_GetTemperatureMatchRom:
; 0009 01A6     unsigned int tmp = 0, sig = 0;
; 0009 01A7     float temperature;
; 0009 01A8     unsigned char scratchpad[9];
; 0009 01A9     OWI_DetectPresence(pin);
	ST   -Y,R26
	SBIW R28,13
	CALL __SAVELOCR4
;	*romValue -> Y+18
;	pin -> Y+17
;	tmp -> R16,R17
;	sig -> R18,R19
;	temperature -> Y+13
;	scratchpad -> Y+4
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	LDD  R26,Y+17
	RCALL _OWI_DetectPresence
; 0009 01AA     OWI_MatchRom(romValue, pin);
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+19
	RCALL _OWI_MatchRom
; 0009 01AB     OWI_SendByte(DS18B20_READ_SCRATCHPAD, pin);
	LDI  R30,LOW(190)
	ST   -Y,R30
	LDD  R26,Y+18
	RCALL _OWI_SendByte
; 0009 01AC     scratchpad[0] = OWI_ReceiveByte(pin);
	LDD  R26,Y+17
	RCALL _OWI_ReceiveByte
	STD  Y+4,R30
; 0009 01AD     scratchpad[1] = OWI_ReceiveByte(pin);
	LDD  R26,Y+17
	RCALL _OWI_ReceiveByte
	STD  Y+5,R30
; 0009 01AE 
; 0009 01AF     if ((scratchpad[1]&128) != 0){
	ANDI R30,LOW(0x80)
	BREQ _0x12003D
; 0009 01B0       tmp = ((unsigned int)scratchpad[1]<<8)|scratchpad[0];
	LDI  R30,0
	LDD  R31,Y+5
	MOVW R26,R30
	LDD  R30,Y+4
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	MOVW R16,R30
; 0009 01B1       tmp = ~tmp + 1;
	MOVW R30,R16
	COM  R30
	COM  R31
	ADIW R30,1
	MOVW R16,R30
; 0009 01B2       scratchpad[0] = tmp;
	__PUTBSR 16,4
; 0009 01B3       scratchpad[1] = tmp>>8;
	__PUTBSR 17,5
; 0009 01B4       sig = 1;
	__GETWRN 18,19,1
; 0009 01B5     }
; 0009 01B6     temperature = (float)((scratchpad[0]>>4)|((scratchpad[1]&7)<<4));
_0x12003D:
	LDD  R30,Y+4
	LDI  R31,0
	CALL __ASRW4
	MOVW R26,R30
	LDD  R30,Y+5
	ANDI R30,LOW(0x7)
	LDI  R31,0
	CALL __LSLW4
	OR   R30,R26
	OR   R31,R27
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x84
; 0009 01B7     temperature += ((float)(scratchpad[0]&15) * 0.0625);
	LDD  R30,Y+4
	ANDI R30,LOW(0xF)
	CALL SUBOPT_0x4A
	__GETD2N 0x3D800000
	CALL __MULF12
	__GETD2S 13
	CALL __ADDF12
	CALL SUBOPT_0x84
; 0009 01B8 
; 0009 01B9     if (sig) {
	MOV  R0,R18
	OR   R0,R19
	BREQ _0x12003E
; 0009 01BA         temperature *= -1.0;
	__GETD2S 13
	__GETD1N 0xBF800000
	CALL __MULF12
	CALL SUBOPT_0x84
; 0009 01BB     }
; 0009 01BC     return temperature;
_0x12003E:
	__GETD1S 13
	CALL __LOADLOCR4
	ADIW R28,20
	RET
; 0009 01BD }
;
;
;unsigned char InitSensor(unsigned char * romValue, unsigned char pin, signed char lowAlm, signed char hiAlm, unsigned char resolution)
; 0009 01C1 {
_InitSensor:
; 0009 01C2      unsigned char scratchpad[9];
; 0009 01C3      unsigned char i;
; 0009 01C4      OWI_DetectPresence(pin);
	ST   -Y,R26
	SBIW R28,9
	ST   -Y,R17
;	*romValue -> Y+14
;	pin -> Y+13
;	lowAlm -> Y+12
;	hiAlm -> Y+11
;	resolution -> Y+10
;	scratchpad -> Y+1
;	i -> R17
	CALL SUBOPT_0x85
; 0009 01C5      OWI_MatchRom(romValue, pin);
; 0009 01C6      OWI_SendByte(DS18B20_WRITE_SCRATCHPAD, pin);
	LDI  R30,LOW(78)
	CALL SUBOPT_0x86
; 0009 01C7      OWI_SendByte(hiAlm, pin);
	LDD  R30,Y+11
	CALL SUBOPT_0x86
; 0009 01C8      OWI_SendByte(lowAlm, pin);
	LDD  R30,Y+12
	CALL SUBOPT_0x86
; 0009 01C9      OWI_SendByte(resolution, pin);
	LDD  R30,Y+10
	CALL SUBOPT_0x86
; 0009 01CA 
; 0009 01CB      // check settings
; 0009 01CC      OWI_DetectPresence(pin);
	CALL SUBOPT_0x85
; 0009 01CD      OWI_MatchRom(romValue, pin);
; 0009 01CE      OWI_SendByte(DS18B20_READ_SCRATCHPAD, pin);
	LDI  R30,LOW(190)
	CALL SUBOPT_0x86
; 0009 01CF      for (i=0; i<8; i++) {
	LDI  R17,LOW(0)
_0x120040:
	CPI  R17,8
	BRSH _0x120041
; 0009 01D0         scratchpad[i] = OWI_ReceiveByte(pin);
	CALL SUBOPT_0x10
	MOVW R26,R28
	ADIW R26,1
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDD  R26,Y+13
	RCALL _OWI_ReceiveByte
	POP  R26
	POP  R27
	ST   X,R30
; 0009 01D1      }
	SUBI R17,-1
	RJMP _0x120040
_0x120041:
; 0009 01D2 
; 0009 01D3      if (scratchpad[2] == hiAlm && scratchpad[3] == lowAlm && scratchpad[4] == resolution) {
	LDD  R30,Y+11
	LDD  R26,Y+3
	CALL SUBOPT_0x68
	BRNE _0x120043
	LDD  R30,Y+12
	LDD  R26,Y+4
	CALL SUBOPT_0x68
	BRNE _0x120043
	LDD  R30,Y+10
	LDD  R26,Y+5
	CP   R30,R26
	BREQ _0x120044
_0x120043:
	RJMP _0x120042
_0x120044:
; 0009 01D4         return SET_SETTINGS_SUCCESSFUL;
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	JMP  _0x20A0006
; 0009 01D5      } else {
_0x120042:
; 0009 01D6         return SET_SETTINGS_ERROR;
	LDI  R30,LOW(16)
	LDD  R17,Y+0
	JMP  _0x20A0006
; 0009 01D7      }
; 0009 01D8 }
;// This file has been prepared for Doxygen automatic documentation generation.
;/*! \file ********************************************************************
;*
;* Atmel Corporation
;*
;* \li File:               OWISWBitFunctions.c
;* \li Compiler:           IAR EWAAVR 3.20a
;* \li Support mail:       avr@atmel.com
;*
;* \li Supported devices:  All AVRs.
;*
;* \li Application Note:   AVR318 - Dallas 1-Wire(R) master.
;*
;*
;* \li Description:        Polled software only implementation of the basic
;*                         bit-level signalling in the 1-Wire(R) protocol.
;*
;*                         $Revision: 1.7 $
;*                         $Date: Thursday, August 19, 2004 14:27:18 UTC $
;****************************************************************************/
;
;#include "OWIPolled.h"
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
;
;#ifdef OWI_SOFTWARE_DRIVER
;
;#include "compilers.h"
;
;#include "OWIBitFunctions.h"
;
;
;/*! \brief Initialization of the one wire bus(es). (Software only driver)
; *
; *  This function initializes the 1-Wire bus(es) by releasing it and
; *  waiting until any presence sinals are finished.
; *
; *  \param  pins    A bitmask of the buses to initialize.
; */
;void OWI_Init(unsigned char pins)
; 000A 0027 {

	.CSEG
_OWI_Init:
; 000A 0028     OWI_RELEASE_BUS(pins);
	ST   -Y,R26
;	pins -> Y+0
	IN   R30,0x11
	MOV  R26,R30
	LD   R30,Y
	CALL SUBOPT_0x87
	LD   R30,Y
	CALL SUBOPT_0x88
; 000A 0029     // The first rising edge can be interpreted by a slave as the end of a
; 000A 002A     // Reset pulse. Delay for the required reset recovery time (H) to be
; 000A 002B     // sure that the real reset is interpreted correctly.
; 000A 002C     __delay_cycles(OWI_DELAY_H_STD_MODE);
; 000A 002D }
_0x20A000A:
	ADIW R28,1
	RET
;
;
;/*! \brief  Write a '1' bit to the bus(es). (Software only driver)
; *
; *  Generates the waveform for transmission of a '1' bit on the 1-Wire
; *  bus.
; *
; *  \param  pins    A bitmask of the buses to write to.
; */
;void OWI_WriteBit1(unsigned char pins)
; 000A 0038 {
_OWI_WriteBit1:
; 000A 0039     unsigned char intState;
; 000A 003A 
; 000A 003B     // Disable interrupts.
; 000A 003C     intState = __save_interrupt();
	ST   -Y,R26
	ST   -Y,R17
;	pins -> Y+1
;	intState -> R17
	IN   R17,63
; 000A 003D     __disable_interrupt();
	cli
; 000A 003E 
; 000A 003F     // Drive bus low and delay.
; 000A 0040     OWI_PULL_BUS_LOW(pins);
	CALL SUBOPT_0x89
; 000A 0041     __delay_cycles(OWI_DELAY_A_STD_MODE);
	__DELAY_USB 25
; 000A 0042 
; 000A 0043     // Release bus and delay.
; 000A 0044     OWI_RELEASE_BUS(pins);
	IN   R30,0x11
	MOV  R26,R30
	LDD  R30,Y+1
	CALL SUBOPT_0x87
	LDD  R30,Y+1
	COM  R30
	AND  R30,R26
	OUT  0x12,R30
; 000A 0045     __delay_cycles(OWI_DELAY_B_STD_MODE);
	__DELAY_USW 243
; 000A 0046 
; 000A 0047     // Restore interrupts.
; 000A 0048     __restore_interrupt(intState);
	RJMP _0x20A0009
; 000A 0049 }
;
;
;/*! \brief  Write a '0' to the bus(es). (Software only driver)
; *
; *  Generates the waveform for transmission of a '0' bit on the 1-Wire(R)
; *  bus.
; *
; *  \param  pins    A bitmask of the buses to write to.
; */
;void OWI_WriteBit0(unsigned char pins)
; 000A 0054 {
_OWI_WriteBit0:
; 000A 0055     unsigned char intState;
; 000A 0056 
; 000A 0057     // Disable interrupts.
; 000A 0058     intState = __save_interrupt();
	ST   -Y,R26
	ST   -Y,R17
;	pins -> Y+1
;	intState -> R17
	IN   R17,63
; 000A 0059     __disable_interrupt();
	cli
; 000A 005A 
; 000A 005B     // Drive bus low and delay.
; 000A 005C     OWI_PULL_BUS_LOW(pins);
	CALL SUBOPT_0x89
; 000A 005D     __delay_cycles(OWI_DELAY_C_STD_MODE);
	__DELAY_USW 229
; 000A 005E 
; 000A 005F     // Release bus and delay.
; 000A 0060     OWI_RELEASE_BUS(pins);
	IN   R30,0x11
	MOV  R26,R30
	LDD  R30,Y+1
	CALL SUBOPT_0x87
	LDD  R30,Y+1
	COM  R30
	AND  R30,R26
	OUT  0x12,R30
; 000A 0061     __delay_cycles(OWI_DELAY_D_STD_MODE);
	__DELAY_USB 44
; 000A 0062 
; 000A 0063     // Restore interrupts.
; 000A 0064     __restore_interrupt(intState);
_0x20A0009:
	OUT  0x3F,R17
; 000A 0065 }
	LDD  R17,Y+0
	ADIW R28,2
	RET
;
;
;/*! \brief  Read a bit from the bus(es). (Software only driver)
; *
; *  Generates the waveform for reception of a bit on the 1-Wire(R) bus(es).
; *
; *  \param  pins    A bitmask of the bus(es) to read from.
; *
; *  \return A bitmask of the buses where a '1' was read.
; */
;unsigned char OWI_ReadBit(unsigned char pins)
; 000A 0071 {
_OWI_ReadBit:
; 000A 0072     unsigned char intState;
; 000A 0073     unsigned char bitsRead;
; 000A 0074 
; 000A 0075     // Disable interrupts.
; 000A 0076     intState = __save_interrupt();
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	pins -> Y+2
;	intState -> R17
;	bitsRead -> R16
	IN   R17,63
; 000A 0077     __disable_interrupt();
	cli
; 000A 0078 
; 000A 0079     // Drive bus low and delay.
; 000A 007A     OWI_PULL_BUS_LOW(pins);
	CALL SUBOPT_0x8A
	COM  R30
	AND  R30,R26
	OUT  0x12,R30
; 000A 007B     __delay_cycles(OWI_DELAY_A_STD_MODE);
	__DELAY_USB 25
; 000A 007C 
; 000A 007D     // Release bus and delay.
; 000A 007E     OWI_RELEASE_BUS(pins);
	IN   R30,0x11
	MOV  R26,R30
	LDD  R30,Y+2
	CALL SUBOPT_0x87
	LDD  R30,Y+2
	COM  R30
	AND  R30,R26
	OUT  0x12,R30
; 000A 007F     __delay_cycles(OWI_DELAY_E_STD_MODE);
	__DELAY_USB 39
; 000A 0080 
; 000A 0081     // Sample bus and delay.
; 000A 0082     bitsRead = OWI_PIN & pins;
	IN   R30,0x10
	LDD  R26,Y+2
	AND  R30,R26
	MOV  R16,R30
; 000A 0083     __delay_cycles(OWI_DELAY_F_STD_MODE);
	__DELAY_USW 210
; 000A 0084 
; 000A 0085     // Restore interrupts.
; 000A 0086     __restore_interrupt(intState);
	RJMP _0x20A0007
; 000A 0087 
; 000A 0088     return bitsRead;
; 000A 0089 }
;
;
;/*! \brief  Send a Reset signal and listen for Presence signal. (software
; *  only driver)
; *
; *  Generates the waveform for transmission of a Reset pulse on the
; *  1-Wire(R) bus and listens for presence signals.
; *
; *  \param  pins    A bitmask of the buses to send the Reset signal on.
; *
; *  \return A bitmask of the buses where a presence signal was detected.
; */
;unsigned char OWI_DetectPresence(unsigned char pins)
; 000A 0097 {
_OWI_DetectPresence:
; 000A 0098     unsigned char intState;
; 000A 0099     unsigned char presenceDetected;
; 000A 009A 
; 000A 009B     // Disable interrupts.
; 000A 009C     intState = __save_interrupt();
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	pins -> Y+2
;	intState -> R17
;	presenceDetected -> R16
	IN   R17,63
; 000A 009D     __disable_interrupt();
	cli
; 000A 009E 
; 000A 009F     // Drive bus low and delay.
; 000A 00A0     OWI_PULL_BUS_LOW(pins);
	CALL SUBOPT_0x8A
	CALL SUBOPT_0x88
; 000A 00A1     __delay_cycles(OWI_DELAY_H_STD_MODE);
; 000A 00A2 
; 000A 00A3     // Release bus and delay.
; 000A 00A4     OWI_RELEASE_BUS(pins);
	IN   R30,0x11
	MOV  R26,R30
	LDD  R30,Y+2
	CALL SUBOPT_0x87
	LDD  R30,Y+2
	COM  R30
	AND  R30,R26
	OUT  0x12,R30
; 000A 00A5     __delay_cycles(OWI_DELAY_I_STD_MODE);
	__DELAY_USW 265
; 000A 00A6 
; 000A 00A7     // Sample bus to detect presence signal and delay.
; 000A 00A8     presenceDetected = ((~OWI_PIN) & pins);
	IN   R30,0x10
	COM  R30
	LDD  R26,Y+2
	AND  R30,R26
	MOV  R16,R30
; 000A 00A9     __delay_cycles(OWI_DELAY_J_STD_MODE);
	__DELAY_USW 1585
; 000A 00AA 
; 000A 00AB     // Restore interrupts.
; 000A 00AC     __restore_interrupt(intState);
_0x20A0007:
	OUT  0x3F,R17
; 000A 00AD 
; 000A 00AE     return presenceDetected;
	MOV  R30,R16
_0x20A0008:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; 000A 00AF }
;
;
;#endif
;// This file has been prepared for Doxygen automatic documentation generation.
;/*! \file ********************************************************************
;*
;* Atmel Corporation
;*
;* \li File:               OWIUARTFunctions.c
;* \li Compiler:           IAR EWAAVR 3.20a
;* \li Support mail:       avr@atmel.com
;*
;* \li Supported devices:  All AVRs.
;*
;* \li Application Note:   AVR318 - Dallas 1-Wire(R) master.
;*
;*
;* \li Description:        Polled UART implementation of the basic bit-level
;*                         signalling in the 1-Wire(R) protocol.
;*
;*                         $Revision: 1.7 $
;*                         $Date: Thursday, August 19, 2004 14:27:18 UTC $
;****************************************************************************/
;
;/*****************************************************************************
;*
;* Atmel Corporation
;*
;* File              : OWIUARTFunctions.c
;* Compiler          : IAR EWAAVR 3.20a
;* Revision          : $Revision: 1.7 $
;* Date              : $Date: Thursday, August 19, 2004 14:27:18 UTC $
;* Updated by        : $Author: tsundre $
;*
;* Support mail      : avr@atmel.com
;*
;* Supported devices : All AVRs with UART or USART module.
;*
;* AppNote           : AVR318 - 1-Wire(R) interface Master Implementation
;*
;* Description       : Polled UART implementation of the basic bit-level
;*                     signalling in the 1-Wire(R) protocol.
;*
;****************************************************************************/
;
;#include "OWIPolled.h"
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
;
;#ifdef OWI_UART_DRIVER
;
;#include "compilers.h"
;#include "OWIBitFunctions.h"
;
;
;
;/*! \brief Initialization of the one wire bus. (Polled UART driver)
; *
; *  This function initializes the 1-Wire bus by configuring the UART.
; */
;void OWI_Init()
;{
;    // Choose single or double UART speed.
;    OWI_UART_STATCTRL_REG_A = (OWI_UART_2X << OWI_U2X);
;
;    // Enable UART transmitter and receiver.
;    OWI_UART_STATCTRL_REG_B = (1 << OWI_TXEN) | (1 << OWI_RXEN);
;
;    // Set up asynchronous mode, 8 data bits, no parity, 1 stop bit.
;    // (Initial value, can be removed)
;#ifdef URSEL
;    OWI_UART_STATCTRL_REG_C = (1 << OWI_URSEL) | (1 << OWI_UCSZ1) | (1 << OWI_UCSZ0);
;#else
;    OWI_UART_STATCTRL_REG_C = (1 << OWI_UCSZ1) | (1 << OWI_UCSZ0);
;#endif
;
;    OWI_UART_BAUD_RATE_REG_L = OWI_UBRR_115200;
;}
;
;
;/*! \brief  Write and read one bit to/from the 1-Wire bus. (Polled UART driver)
; *
; *  Writes one bit to the bus and returns the value read from the bus.
; *
; *  \param  outValue    The value to transmit on the bus.
; *
; *  \return The value received by the UART from the bus.
; */
;unsigned char OWI_TouchBit(unsigned char outValue)
;{
;    // Place the output value in the UART transmit buffer, and wait
;    // until it is received by the UART receiver.
;    OWI_UART_DATA_REGISTER = outValue;
;    while(!(OWI_UART_STATCTRL_REG_A & (1 << OWI_RXC)))
;    {
;
;    }
;    // Set the UART Baud Rate back to 115200kbps when finished.
;    OWI_UART_BAUD_RATE_REG_L = OWI_UBRR_115200;
;    return OWI_UART_DATA_REGISTER;
;}
;
;/*! \brief Write a '1' bit to the bus(es). (Polled UART DRIVER)
; *
; *  Generates the waveform for transmission of a '1' bit on the 1-Wire
; *  bus.
; */
;void OWI_WriteBit1()
;{
;    OWI_TouchBit(OWI_UART_WRITE1);
;}
;
;
;/*! \brief  Write a '0' to the bus(es). (Polled UART DRIVER)
; *
; *  Generates the waveform for transmission of a '0' bit on the 1-Wire(R)
; *  bus.
; */
;void OWI_WriteBit0()
;{
;    OWI_TouchBit(OWI_UART_WRITE0);
;}
;
;
;/*! \brief  Read a bit from the bus(es). (Polled UART DRIVER)
; *
; *  Generates the waveform for reception of a bit on the 1-Wire(R) bus(es).
; *
; *  \return The value read from the bus (0 or 1).
; */
;unsigned char OWI_ReadBit()
;{
;     // Return 1 if the value received matches the value sent.
;     // Return 0 else. (A slave held the bus low).
;     return (OWI_TouchBit(OWI_UART_READ_BIT) == OWI_UART_READ_BIT);
;}
;
;
;/*! \brief  Send a Reset signal and listen for Presence signal. (Polled
; *  UART DRIVER)
; *
; *  Generates the waveform for transmission of a Reset pulse on the
; *  1-Wire(R) bus and listens for presence signals.
; *
; *  \return A bitmask of the buses where a presence signal was detected.
; */
;unsigned char OWI_DetectPresence()
;{
;    // Reset UART receiver to clear RXC register.
;    OWI_UART_STATCTRL_REG_B &= ~(1 << OWI_RXEN);
;    OWI_UART_STATCTRL_REG_B |= (1 << OWI_RXEN);
;
;    // Set UART Baud Rate to 9600 for Reset/Presence signalling.
;    OWI_UART_BAUD_RATE_REG_L = OWI_UBRR_9600;
;
;    // Return 0 if the value received matches the value sent.
;    // return 1 else. (Presence detected)
;    return (OWI_TouchBit(OWI_UART_RESET) != OWI_UART_RESET);
;}
;
;
;#endif

	.CSEG
_memcpy:
	ST   -Y,R27
	ST   -Y,R26
    ldd  r25,y+1
    ld   r24,y
    adiw r24,0
    breq memcpy1
    ldd  r27,y+5
    ldd  r26,y+4
    ldd  r31,y+3
    ldd  r30,y+2
memcpy0:
    ld   r22,z+
    st   x+,r22
    sbiw r24,1
    brne memcpy0
memcpy1:
    ldd  r31,y+5
    ldd  r30,y+4
	ADIW R28,6
	RET
_strcpyf:
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
_strlen:
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
_strlenf:
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
_put_buff_G101:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x1
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	CALL SUBOPT_0x1
_0x2020014:
_0x2020013:
	RJMP _0x2020015
_0x2020010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
__ftoe_G101:
	CALL SUBOPT_0x8B
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
	BRNE _0x2020019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2020000,0
	CALL _strcpyf
	RJMP _0x20A0005
_0x2020019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2020018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2020000,1
	CALL _strcpyf
	RJMP _0x20A0005
_0x2020018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x202001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x202001B:
	LDD  R17,Y+11
_0x202001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x202001E
	CALL SUBOPT_0x8C
	RJMP _0x202001C
_0x202001E:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x202001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0x8C
	RJMP _0x2020020
_0x202001F:
	LDD  R19,Y+11
	CALL SUBOPT_0x8D
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2020021
	CALL SUBOPT_0x8C
_0x2020022:
	CALL SUBOPT_0x8D
	BRLO _0x2020024
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x8F
	RJMP _0x2020022
_0x2020024:
	RJMP _0x2020025
_0x2020021:
_0x2020026:
	CALL SUBOPT_0x8D
	BRSH _0x2020028
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x90
	CALL SUBOPT_0x91
	SUBI R19,LOW(1)
	RJMP _0x2020026
_0x2020028:
	CALL SUBOPT_0x8C
_0x2020025:
	__GETD1S 12
	CALL SUBOPT_0x92
	CALL SUBOPT_0x91
	CALL SUBOPT_0x8D
	BRLO _0x2020029
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x8F
_0x2020029:
_0x2020020:
	LDI  R17,LOW(0)
_0x202002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x202002C
	__GETD2S 4
	CALL SUBOPT_0x93
	CALL SUBOPT_0x92
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	__PUTD1S 4
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x41
	MOV  R16,R30
	CALL SUBOPT_0x94
	CALL SUBOPT_0x95
	CALL SUBOPT_0x4A
	__GETD2S 4
	CALL __MULF12
	CALL SUBOPT_0x8E
	CALL SUBOPT_0x39
	CALL SUBOPT_0x91
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x202002A
	CALL SUBOPT_0x94
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x202002A
_0x202002C:
	CALL SUBOPT_0x82
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x202002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x202010E
_0x202002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x202010E:
	ST   X,R30
	CALL SUBOPT_0x82
	CALL SUBOPT_0x82
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x82
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
_0x20A0006:
	ADIW R28,16
	RET
__print_G101:
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
_0x2020030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x1
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2020032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2020036
	CPI  R18,37
	BRNE _0x2020037
	LDI  R17,LOW(1)
	RJMP _0x2020038
_0x2020037:
	CALL SUBOPT_0x96
_0x2020038:
	RJMP _0x2020035
_0x2020036:
	CPI  R30,LOW(0x1)
	BRNE _0x2020039
	CPI  R18,37
	BRNE _0x202003A
	CALL SUBOPT_0x96
	RJMP _0x202010F
_0x202003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x202003B
	LDI  R16,LOW(1)
	RJMP _0x2020035
_0x202003B:
	CPI  R18,43
	BRNE _0x202003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2020035
_0x202003C:
	CPI  R18,32
	BRNE _0x202003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2020035
_0x202003D:
	RJMP _0x202003E
_0x2020039:
	CPI  R30,LOW(0x2)
	BRNE _0x202003F
_0x202003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020040
	ORI  R16,LOW(128)
	RJMP _0x2020035
_0x2020040:
	RJMP _0x2020041
_0x202003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2020042
_0x2020041:
	CPI  R18,48
	BRLO _0x2020044
	CPI  R18,58
	BRLO _0x2020045
_0x2020044:
	RJMP _0x2020043
_0x2020045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2020035
_0x2020043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2020046
	LDI  R17,LOW(4)
	RJMP _0x2020035
_0x2020046:
	RJMP _0x2020047
_0x2020042:
	CPI  R30,LOW(0x4)
	BRNE _0x2020049
	CPI  R18,48
	BRLO _0x202004B
	CPI  R18,58
	BRLO _0x202004C
_0x202004B:
	RJMP _0x202004A
_0x202004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2020035
_0x202004A:
_0x2020047:
	CPI  R18,108
	BRNE _0x202004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2020035
_0x202004D:
	RJMP _0x202004E
_0x2020049:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x2020035
_0x202004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2020053
	CALL SUBOPT_0x97
	CALL SUBOPT_0x98
	CALL SUBOPT_0x97
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x99
	RJMP _0x2020054
_0x2020053:
	CPI  R30,LOW(0x45)
	BREQ _0x2020057
	CPI  R30,LOW(0x65)
	BRNE _0x2020058
_0x2020057:
	RJMP _0x2020059
_0x2020058:
	CPI  R30,LOW(0x66)
	BREQ PC+3
	JMP _0x202005A
_0x2020059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x9A
	CALL __GETD1P
	CALL SUBOPT_0x9B
	CALL SUBOPT_0x9C
	LDD  R26,Y+13
	TST  R26
	BRMI _0x202005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x202005D
	RJMP _0x202005E
_0x202005B:
	CALL SUBOPT_0x9D
	CALL __ANEGF1
	CALL SUBOPT_0x9B
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x202005D:
	SBRS R16,7
	RJMP _0x202005F
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x99
	RJMP _0x2020060
_0x202005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2020060:
_0x202005E:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2020062
	CALL SUBOPT_0x9D
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CALL _ftoa
	RJMP _0x2020063
_0x2020062:
	CALL SUBOPT_0x9D
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G101
_0x2020063:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x9E
	RJMP _0x2020064
_0x202005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2020066
	CALL SUBOPT_0x9C
	CALL SUBOPT_0x9F
	CALL SUBOPT_0x9E
	RJMP _0x2020067
_0x2020066:
	CPI  R30,LOW(0x70)
	BRNE _0x2020069
	CALL SUBOPT_0x9C
	CALL SUBOPT_0x9F
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020067:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x202006B
	CP   R20,R17
	BRLO _0x202006C
_0x202006B:
	RJMP _0x202006A
_0x202006C:
	MOV  R17,R20
_0x202006A:
_0x2020064:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x202006D
_0x2020069:
	CPI  R30,LOW(0x64)
	BREQ _0x2020070
	CPI  R30,LOW(0x69)
	BRNE _0x2020071
_0x2020070:
	ORI  R16,LOW(4)
	RJMP _0x2020072
_0x2020071:
	CPI  R30,LOW(0x75)
	BRNE _0x2020073
_0x2020072:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2020074
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0xA0
	LDI  R17,LOW(10)
	RJMP _0x2020075
_0x2020074:
	__GETD1N 0x2710
	CALL SUBOPT_0xA0
	LDI  R17,LOW(5)
	RJMP _0x2020075
_0x2020073:
	CPI  R30,LOW(0x58)
	BRNE _0x2020077
	ORI  R16,LOW(8)
	RJMP _0x2020078
_0x2020077:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x20200B6
_0x2020078:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x202007A
	__GETD1N 0x10000000
	CALL SUBOPT_0xA0
	LDI  R17,LOW(8)
	RJMP _0x2020075
_0x202007A:
	__GETD1N 0x1000
	CALL SUBOPT_0xA0
	LDI  R17,LOW(4)
_0x2020075:
	CPI  R20,0
	BREQ _0x202007B
	ANDI R16,LOW(127)
	RJMP _0x202007C
_0x202007B:
	LDI  R20,LOW(1)
_0x202007C:
	SBRS R16,1
	RJMP _0x202007D
	CALL SUBOPT_0x9C
	CALL SUBOPT_0x9A
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2020110
_0x202007D:
	SBRS R16,2
	RJMP _0x202007F
	CALL SUBOPT_0x9C
	CALL SUBOPT_0x9F
	CALL __CWD1
	RJMP _0x2020110
_0x202007F:
	CALL SUBOPT_0x9C
	CALL SUBOPT_0x9F
	CLR  R22
	CLR  R23
_0x2020110:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2020081
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2020082
	CALL SUBOPT_0x9D
	CALL __ANEGD1
	CALL SUBOPT_0x9B
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2020082:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2020083
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2020084
_0x2020083:
	ANDI R16,LOW(251)
_0x2020084:
_0x2020081:
	MOV  R19,R20
_0x202006D:
	SBRC R16,0
	RJMP _0x2020085
_0x2020086:
	CP   R17,R21
	BRSH _0x2020089
	CP   R19,R21
	BRLO _0x202008A
_0x2020089:
	RJMP _0x2020088
_0x202008A:
	SBRS R16,7
	RJMP _0x202008B
	SBRS R16,2
	RJMP _0x202008C
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x202008D
_0x202008C:
	LDI  R18,LOW(48)
_0x202008D:
	RJMP _0x202008E
_0x202008B:
	LDI  R18,LOW(32)
_0x202008E:
	CALL SUBOPT_0x96
	SUBI R21,LOW(1)
	RJMP _0x2020086
_0x2020088:
_0x2020085:
_0x202008F:
	CP   R17,R20
	BRSH _0x2020091
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2020092
	CALL SUBOPT_0xA1
	BREQ _0x2020093
	SUBI R21,LOW(1)
_0x2020093:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2020092:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x99
	CPI  R21,0
	BREQ _0x2020094
	SUBI R21,LOW(1)
_0x2020094:
	SUBI R20,LOW(1)
	RJMP _0x202008F
_0x2020091:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2020095
_0x2020096:
	CPI  R19,0
	BREQ _0x2020098
	SBRS R16,3
	RJMP _0x2020099
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x202009A
_0x2020099:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x202009A:
	CALL SUBOPT_0x96
	CPI  R21,0
	BREQ _0x202009B
	SUBI R21,LOW(1)
_0x202009B:
	SUBI R19,LOW(1)
	RJMP _0x2020096
_0x2020098:
	RJMP _0x202009C
_0x2020095:
_0x202009E:
	CALL SUBOPT_0xA2
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20200A0
	SBRS R16,3
	RJMP _0x20200A1
	SUBI R18,-LOW(55)
	RJMP _0x20200A2
_0x20200A1:
	SUBI R18,-LOW(87)
_0x20200A2:
	RJMP _0x20200A3
_0x20200A0:
	SUBI R18,-LOW(48)
_0x20200A3:
	SBRC R16,4
	RJMP _0x20200A5
	CPI  R18,49
	BRSH _0x20200A7
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20200A6
_0x20200A7:
	RJMP _0x20200A9
_0x20200A6:
	CP   R20,R19
	BRSH _0x2020111
	CP   R21,R19
	BRLO _0x20200AC
	SBRS R16,0
	RJMP _0x20200AD
_0x20200AC:
	RJMP _0x20200AB
_0x20200AD:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20200AE
_0x2020111:
	LDI  R18,LOW(48)
_0x20200A9:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20200AF
	CALL SUBOPT_0xA1
	BREQ _0x20200B0
	SUBI R21,LOW(1)
_0x20200B0:
_0x20200AF:
_0x20200AE:
_0x20200A5:
	CALL SUBOPT_0x96
	CPI  R21,0
	BREQ _0x20200B1
	SUBI R21,LOW(1)
_0x20200B1:
_0x20200AB:
	SUBI R19,LOW(1)
	CALL SUBOPT_0xA2
	CALL __MODD21U
	CALL SUBOPT_0x9B
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0xA0
	__GETD1S 16
	CALL __CPD10
	BREQ _0x202009F
	RJMP _0x202009E
_0x202009F:
_0x202009C:
	SBRS R16,0
	RJMP _0x20200B2
_0x20200B3:
	CPI  R21,0
	BREQ _0x20200B5
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x99
	RJMP _0x20200B3
_0x20200B5:
_0x20200B2:
_0x20200B6:
_0x2020054:
_0x202010F:
	LDI  R17,LOW(0)
_0x2020035:
	RJMP _0x2020030
_0x2020032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0xA3
	SBIW R30,0
	BRNE _0x20200B7
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0004
_0x20200B7:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0xA3
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20A0004:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET

	.CSEG
_fabs:
	CALL __PUTPARD2
    ld   r30,y+
    ld   r31,y+
    ld   r22,y+
    ld   r23,y+
    cbr  r23,0x80
    ret
_ftoa:
	CALL SUBOPT_0x8B
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
	BRNE _0x204000D
	CALL SUBOPT_0xA4
	__POINTW2FN _0x2040000,0
	CALL _strcpyf
	RJMP _0x20A0003
_0x204000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x204000C
	CALL SUBOPT_0xA4
	__POINTW2FN _0x2040000,1
	CALL _strcpyf
	RJMP _0x20A0003
_0x204000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x204000F
	__GETD1S 9
	CALL __ANEGF1
	CALL SUBOPT_0xA5
	CALL SUBOPT_0xA6
	LDI  R30,LOW(45)
	ST   X,R30
_0x204000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2040010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2040010:
	LDD  R17,Y+8
_0x2040011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2040013
	CALL SUBOPT_0xA7
	CALL SUBOPT_0x93
	CALL SUBOPT_0xA8
	RJMP _0x2040011
_0x2040013:
	CALL SUBOPT_0xA9
	CALL __ADDF12
	CALL SUBOPT_0xA5
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	CALL SUBOPT_0xA8
_0x2040014:
	CALL SUBOPT_0xA9
	CALL __CMPF12
	BRLO _0x2040016
	CALL SUBOPT_0xA7
	CALL SUBOPT_0x90
	CALL SUBOPT_0xA8
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2040017
	CALL SUBOPT_0xA4
	__POINTW2FN _0x2040000,5
	CALL _strcpyf
	RJMP _0x20A0003
_0x2040017:
	RJMP _0x2040014
_0x2040016:
	CPI  R17,0
	BRNE _0x2040018
	CALL SUBOPT_0xA6
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2040019
_0x2040018:
_0x204001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x204001C
	CALL SUBOPT_0xA7
	CALL SUBOPT_0x93
	CALL SUBOPT_0x92
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	CALL SUBOPT_0xA8
	CALL SUBOPT_0xA9
	CALL SUBOPT_0x41
	MOV  R16,R30
	CALL SUBOPT_0xA6
	CALL SUBOPT_0x95
	LDI  R31,0
	CALL SUBOPT_0xA7
	CALL SUBOPT_0x3C
	CALL __MULF12
	CALL SUBOPT_0xAA
	CALL SUBOPT_0x39
	CALL SUBOPT_0xA5
	RJMP _0x204001A
_0x204001C:
_0x2040019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20A0002
	CALL SUBOPT_0xA6
	LDI  R30,LOW(46)
	ST   X,R30
_0x204001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2040020
	CALL SUBOPT_0xAA
	CALL SUBOPT_0x90
	CALL SUBOPT_0xA5
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0xA6
	CALL SUBOPT_0x95
	LDI  R31,0
	CALL SUBOPT_0xAA
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x39
	CALL SUBOPT_0xA5
	RJMP _0x204001E
_0x2040020:
_0x20A0002:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20A0003:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET

	.DSEG

	.CSEG

	.CSEG

	.CSEG
_ftrunc:
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
_floor:
	CALL __PUTPARD2
	CALL __GETD2S0
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL __GETD1S0
	RJMP _0x20A0001
__floor1:
    brtc __floor0
	CALL __GETD1S0
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x20A0001:
	ADIW R28,4
	RET

	.DSEG
_buf:
	.BYTE 0x14
_mode:
	.BYTE 0x1
_abortProcess:
	.BYTE 0x1
_timerOn:
	.BYTE 0x1
_startStop:
	.BYTE 0x1
_timer:
	.BYTE 0x2
_timer_off:
	.BYTE 0x2
_ds1820_devices:
	.BYTE 0x1
_sec:
	.BYTE 0x1
_minutes:
	.BYTE 0x1
_hours:
	.BYTE 0x1
_heater_power:
	.BYTE 0x1
_pwmOn:
	.BYTE 0x1
_valvePulse:
	.BYTE 0x1
_impulseCounter:
	.BYTE 0x2
_pwmPeriod:
	.BYTE 0x2
_onePulseDose:
	.BYTE 0x4
_factCalibrateQ:
	.BYTE 0x2
_dis_t_kuba:
	.BYTE 0x4
_dis_p_ten:
	.BYTE 0x2
_rect_p_ten_min:
	.BYTE 0x2
_rect_p_kol_max:
	.BYTE 0x2
_rect_t_otbora:
	.BYTE 0x4
_rect_dt_otbora:
	.BYTE 0x4
_rect_T1_valve:
	.BYTE 0x2
_rect_T2_valve:
	.BYTE 0x2
_rect_t_kuba_valve:
	.BYTE 0x4
_rect_t_kuba_off:
	.BYTE 0x4
_rect_head_val:
	.BYTE 0x2
_rect_body_speed:
	.BYTE 0x2
_rect_pulse_delay:
	.BYTE 0x1
_param_id:
	.BYTE 0x1

	.ESEG
_params_eeprom:
	.DB  0x48,0x26,0x0,0x0
	.DB  0xF8,0x2A,0x1,0x0
	.DB  0x2,0x50,0x0,0x0
	.DB  0x0,0x64,0x0,0x3
	.DB  0x0,0x1,0x46,0x0
	.DB  0x0,0x0,0x64,0x0
	.DB  0x3,0x0,0x1,0x14
	.DB  0x0,0x0,0x0,0x64
	.DB  0x0,0x2,0x0,0x1
	.DB  0xC8,0x1E,0x0,0x0
	.DB  0xF8,0x2A,0x1,0x0
	.DB  0x2,0x2D,0x0,0x0
	.DB  0x0,0xDC,0x5,0x1
	.DB  0x0,0x2,0x1,0x0
	.DB  0x0,0x0,0x5,0x0
	.DB  0x0,0x0,0x1,0x2
	.DB  0x0,0x0,0x0,0x5
	.DB  0x0,0x0,0x0,0x1
	.DB  0xF0,0x23,0x0,0x0
	.DB  0xF8,0x2A,0x1,0x0
	.DB  0x2,0x48,0x26,0x0
	.DB  0x0,0xF8,0x2A,0x1
	.DB  0x0,0x2,0x64,0x0
	.DB  0xA,0x0,0xDC,0x5
	.DB  0x4,0x0,0x1,0x34
	.DB  0x8,0xA,0x0,0xB8
	.DB  0xB,0x5,0x0,0x1
	.DB  0x4,0x0,0x1,0x0
	.DB  0xA,0x0,0x6,0x0
	.DB  0x1,0x32,0x0,0x1
	.DB  0x0,0xF4,0x1,0x4
	.DB  0x0,0x1,0x81,0x0
	.DB  0x1,0x0,0x84,0x3
	.DB  0x4,0x0
	.DB  0x3

	.DSEG
_params:
	.BYTE 0x87
_menu:
	.BYTE 0x14
_cod:
	.BYTE 0x1
_current_menu:
	.BYTE 0x1
_current_pos:
	.BYTE 0x1
_last_menu:
	.BYTE 0x1
_last_pos:
	.BYTE 0x1
_ds1820_rom_codes:
	.BYTE 0x18
_t_rom_codes:
	.BYTE 0x18
_halph_wave_counter_S0000000000:
	.BYTE 0x1
_halph_wave_counter3_S0000000000:
	.BYTE 0x1
_halph_wave_counter2_S0000000000:
	.BYTE 0x2
_rx_buffer0:
	.BYTE 0x8
_counter_S0000004000:
	.BYTE 0x1
_nlcd_memory_G001:
	.BYTE 0x357
_nlcd_xcurr_G001:
	.BYTE 0x1
_nlcd_ycurr_G001:
	.BYTE 0x1
_countDeb_G002:
	.BYTE 0x4
_countDebTmp_G002:
	.BYTE 0x1
_stateBut_G002:
	.BYTE 0x4
_buf_G002:
	.BYTE 0x8
_head_G002:
	.BYTE 0x1
_tail_G002:
	.BYTE 0x1
_count_G002:
	.BYTE 0x1
_cycleBuf_G003:
	.BYTE 0x20
_tailBuf_G003:
	.BYTE 0x1
_headBuf_G003:
	.BYTE 0x1
_countBuf_G003:
	.BYTE 0x1
_FuncAr:
	.BYTE 0x16
_t_kuba:
	.BYTE 0x4
_t_kolona_down:
	.BYTE 0x4
_t_kolona_up:
	.BYTE 0x4
_t_kuba_old:
	.BYTE 0x4
_t_kolona_down_old:
	.BYTE 0x4
_t_kolona_up_old:
	.BYTE 0x4
_headDisp:
	.BYTE 0x4
_t_kuba_avg:
	.BYTE 0x4
_t_kuba_sum:
	.BYTE 0x4
_timerSign:
	.BYTE 0x2
_impulseCounterCalibrate:
	.BYTE 0x2
_Votb:
	.BYTE 0x4
_ssCounter:
	.BYTE 0x2
_distSettingMode:
	.BYTE 0x1
_distValveMode:
	.BYTE 0x1
_menu__G005:
	.BYTE 0x15
_menu_settings_G005:
	.BYTE 0x1C
_menu_set_dist_G005:
	.BYTE 0xE
_menu_set_rect_G005:
	.BYTE 0x5B
_menu_set_init_G005:
	.BYTE 0x15

	.ESEG
_t_sens_eeprom_code:
	.BYTE 0x18

	.DSEG
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x0:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x1:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _nlcd_GotoXY

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(2)
	JMP  _nlcd_GotoXY

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
	JMP  _nlcd_Clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(_ds1820_rom_codes)
	LDI  R31,HIGH(_ds1820_rom_codes)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R26,LOW(_ds1820_devices)
	LDI  R27,HIGH(_ds1820_devices)
	JMP  _OWI_SearchDevices

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(_buf)
	LDI  R31,HIGH(_buf)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,162
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x7:
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	ST   -Y,R30
	LDI  R26,LOW(5)
	JMP  _nlcd_GotoXY

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(_buf)
	LDI  R27,HIGH(_buf)
	JMP  _nlcd_Print

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0xA:
	CALL _nlcd_SendByte
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _nlcd_SendByte

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xD:
	LDD  R30,Y+2
	LDI  R31,0
	SBIW R30,30
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	CALL __MULW12U
	SUBI R30,LOW(-_nlcd_Font*2)
	SBCI R31,HIGH(-_nlcd_Font*2)
	MOVW R26,R30
	MOV  R30,R17
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDI  R31,0
	SUBI R30,LOW(-_buf_G002)
	SBCI R31,HIGH(-_buf_G002)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	LDD  R30,Y+3
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x10:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x11:
	LDS  R30,_headBuf_G003
	LDI  R31,0
	SUBI R30,LOW(-_cycleBuf_G003)
	SBCI R31,HIGH(-_cycleBuf_G003)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(_t_rom_codes)
	LDI  R31,HIGH(_t_rom_codes)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(25)
	ST   -Y,R30
	LDI  R30,LOW(35)
	ST   -Y,R30
	LDI  R26,LOW(95)
	CALL _InitSensor
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x13:
	__POINTW1MN _t_rom_codes,8
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(25)
	ST   -Y,R30
	LDI  R30,LOW(35)
	ST   -Y,R30
	LDI  R26,LOW(95)
	CALL _InitSensor
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(0)
	STS  _sec,R30
	STS  _minutes,R30
	STS  _hours,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x15:
	STS  _Votb,R30
	STS  _Votb+1,R31
	STS  _Votb+2,R22
	STS  _Votb+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _nlcd_GotoXY

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x17:
	CALL _nlcd_PrintF
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x18:
	LDS  R26,_t_kuba_old
	LDS  R27,_t_kuba_old+1
	LDS  R24,_t_kuba_old+2
	LDS  R25,_t_kuba_old+3
	LDS  R30,_t_kuba
	LDS  R31,_t_kuba+1
	LDS  R22,_t_kuba+2
	LDS  R23,_t_kuba+3
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x19:
	__GETD1N 0x3E000000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1A:
	__GETD1N 0xBE000000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x1B:
	LDS  R26,_t_kolona_up_old
	LDS  R27,_t_kolona_up_old+1
	LDS  R24,_t_kolona_up_old+2
	LDS  R25,_t_kolona_up_old+3
	LDS  R30,_t_kolona_up
	LDS  R31,_t_kolona_up+1
	LDS  R22,_t_kolona_up+2
	LDS  R23,_t_kolona_up+3
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _nlcd_GotoXY

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	CALL _nlcd_PrintF
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	LDI  R26,LOW(2)
	CALL _nlcd_GotoXY
	LDI  R30,LOW(_buf)
	LDI  R31,HIGH(_buf)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:55 WORDS
SUBOPT_0x1F:
	__POINTW1FN _0x80000,275
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_hours
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_minutes
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_sec
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x20:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(3)
	CALL _nlcd_GotoXY
	LDI  R30,LOW(_buf)
	LDI  R31,HIGH(_buf)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x21:
	__POINTW1FN _0x80000,293
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_t_kolona_up
	LDS  R31,_t_kolona_up+1
	LDS  R22,_t_kolona_up+2
	LDS  R23,_t_kolona_up+3
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x22:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(4)
	CALL _nlcd_GotoXY
	LDI  R30,LOW(_buf)
	LDI  R31,HIGH(_buf)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x80000,310
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_t_kuba
	LDS  R31,_t_kuba+1
	LDS  R22,_t_kuba+2
	LDS  R23,_t_kuba+3
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	ST   -Y,R30
	LDI  R26,LOW(6)
	CALL _nlcd_GotoXY
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x25:
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETW2PF
	CALL _strcpyf
	LDI  R30,LOW(_buf)
	LDI  R31,HIGH(_buf)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x26:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x27:
	MOVW R30,R28
	ADIW R30,8
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x28:
	LDS  R30,_Votb
	LDS  R31,_Votb+1
	LDS  R22,_Votb+2
	LDS  R23,_Votb+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	ST   -Y,R30
	LDI  R26,LOW(7)
	JMP  _nlcd_GotoXY

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x2A:
	LDI  R30,LOW(_buf)
	LDI  R31,HIGH(_buf)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	LDS  R30,_heater_power
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2C:
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	__POINTW1MN _t_rom_codes,16
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2E:
	CALL _nlcd_Clear
	JMP  _print_menu

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2F:
	LDI  R30,LOW(0)
	STS  _impulseCounter,R30
	STS  _impulseCounter+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	LDI  R30,LOW(0)
	STS  _ssCounter,R30
	STS  _ssCounter+1,R30
	CLR  R12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x31:
	CALL _nlcd_PrintF
	LDI  R30,LOW(4)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x32:
	LDS  R26,_t_kolona_down_old
	LDS  R27,_t_kolona_down_old+1
	LDS  R24,_t_kolona_down_old+2
	LDS  R25,_t_kolona_down_old+3
	LDS  R30,_t_kolona_down
	LDS  R31,_t_kolona_down+1
	LDS  R22,_t_kolona_down+2
	LDS  R23,_t_kolona_down+3
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x33:
	CALL _nlcd_GotoXY
	RJMP SUBOPT_0x2A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x34:
	LDS  R30,_t_kolona_down
	LDS  R31,_t_kolona_down+1
	LDS  R22,_t_kolona_down+2
	LDS  R23,_t_kolona_down+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	__POINTW1FN _0x80000,437
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x2B

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x36:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,4
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x37:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_headDisp
	LDS  R31,_headDisp+1
	LDS  R22,_headDisp+2
	LDS  R23,_headDisp+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	__GETD2N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x39:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3A:
	LDS  R30,_rect_body_speed
	LDS  R31,_rect_body_speed+1
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3B:
	LDS  R26,_Votb
	LDS  R27,_Votb+1
	LDS  R24,_Votb+2
	LDS  R25,_Votb+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3D:
	LDS  R26,_onePulseDose
	LDS  R27,_onePulseDose+1
	LDS  R24,_onePulseDose+2
	LDS  R25,_onePulseDose+3
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3E:
	ST   -Y,R30
	LDI  R26,LOW(3)
	JMP  _nlcd_GotoXY

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3F:
	ST   -Y,R30
	LDI  R26,LOW(4)
	JMP  _nlcd_GotoXY

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x40:
	LDS  R30,_valvePulse
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x41:
	CALL __DIVF21
	CALL __CFD1U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x42:
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	LDS  R30,_impulseCounter
	LDS  R31,_impulseCounter+1
	CLR  R22
	CLR  R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x44:
	CALL __DIVF21
	STS  _onePulseDose,R30
	STS  _onePulseDose+1,R31
	STS  _onePulseDose+2,R22
	STS  _onePulseDose+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x45:
	LDI  R30,LOW(0)
	STS  _pwmOn,R30
	CBI  0x1B,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x46:
	STS  _param_id,R30
	LDI  R26,LOW(9)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_params)
	SBCI R31,HIGH(-_params)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x47:
	LDS  R30,_current_menu
	STS  _last_menu,R30
	LDS  R30,_current_pos
	STS  _last_pos,R30
	LDI  R30,LOW(2)
	STS  _current_menu,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x48:
	CALL __PUTPARD1
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x49:
	LDS  R30,_mode
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4A:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4B:
	LDS  R26,_t_kuba_sum
	LDS  R27,_t_kuba_sum+1
	LDS  R24,_t_kuba_sum+2
	LDS  R25,_t_kuba_sum+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4C:
	STS  _t_kuba_avg,R30
	STS  _t_kuba_avg+1,R31
	STS  _t_kuba_avg+2,R22
	STS  _t_kuba_avg+3,R23
	LDI  R30,LOW(0)
	STS  _t_kuba_sum,R30
	STS  _t_kuba_sum+1,R30
	STS  _t_kuba_sum+2,R30
	STS  _t_kuba_sum+3,R30
	CLR  R11
	JMP  _CalculateBodySpeed

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x4D:
	LDS  R30,_t_kuba
	LDS  R31,_t_kuba+1
	LDS  R22,_t_kuba+2
	LDS  R23,_t_kuba+3
	STS  _t_kuba_old,R30
	STS  _t_kuba_old+1,R31
	STS  _t_kuba_old+2,R22
	STS  _t_kuba_old+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x4E:
	LDS  R30,_t_kolona_up
	LDS  R31,_t_kolona_up+1
	LDS  R22,_t_kolona_up+2
	LDS  R23,_t_kolona_up+3
	STS  _t_kolona_up_old,R30
	STS  _t_kolona_up_old+1,R31
	STS  _t_kolona_up_old+2,R22
	STS  _t_kolona_up_old+3,R23
	LDI  R30,LOW(_t_rom_codes)
	LDI  R31,HIGH(_t_rom_codes)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(8)
	CALL _GetTemperatureMatchRom
	STS  _t_kuba,R30
	STS  _t_kuba+1,R31
	STS  _t_kuba+2,R22
	STS  _t_kuba+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4F:
	LDI  R26,LOW(8)
	CALL _GetTemperatureMatchRom
	STS  _t_kolona_up,R30
	STS  _t_kolona_up+1,R31
	STS  _t_kolona_up+2,R22
	STS  _t_kolona_up+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x50:
	LDS  R30,_t_kuba
	LDS  R31,_t_kuba+1
	LDS  R22,_t_kuba+2
	LDS  R23,_t_kuba+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x51:
	LDS  R26,_t_kuba
	LDS  R27,_t_kuba+1
	LDS  R24,_t_kuba+2
	LDS  R25,_t_kuba+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x52:
	LDI  R31,0
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x53:
	LDS  R30,_impulseCounter
	LDS  R31,_impulseCounter+1
	RCALL SUBOPT_0x42
	RJMP SUBOPT_0x3D

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x54:
	CALL __MULF12
	STS  _headDisp,R30
	STS  _headDisp+1,R31
	STS  _headDisp+2,R22
	STS  _headDisp+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x55:
	LDS  R26,_t_kolona_down
	LDS  R27,_t_kolona_down+1
	LDS  R24,_t_kolona_down+2
	LDS  R25,_t_kolona_down+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x56:
	LDI  R30,LOW(60)
	CALL __MULB1W2U
	LDS  R26,_timer
	LDS  R27,_timer+1
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x57:
	LDS  R30,_current_menu
	LDI  R26,LOW(_menu)
	LDI  R27,HIGH(_menu)
	LDI  R31,0
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:87 WORDS
SUBOPT_0x58:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,2
	CALL __GETW1P
	MOVW R26,R30
	LDS  R30,_current_pos
	LDI  R31,0
	MOVW R22,R26
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __MULW12U
	MOVW R26,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x59:
	CALL _nlcd_Clear
	LDI  R30,LOW(1)
	STS  _mode,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5A:
	CALL _StopProcess
	LDI  R30,LOW(0)
	OUT  0x31,R30
	LDI  R30,LOW(1)
	STS  _mode,R30
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x5B:
	__GETD1N 0x42C80000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5C:
	LDS  R30,_last_menu
	STS  _current_menu,R30
	LDS  R30,_last_pos
	STS  _current_pos,R30
	LDI  R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5D:
	CALL __LNEGB1
	STS  _abortProcess,R30
	JMP  _nlcd_Clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5E:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,1
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5F:
	LDS  R30,_distSettingMode
	RJMP SUBOPT_0x52

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x60:
	STS  _heater_power,R30
	LDS  R26,_heater_power
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x61:
	RCALL SUBOPT_0x3B
	__GETD1N 0x44FA0000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x62:
	RCALL SUBOPT_0x28
	__GETD2N 0x42B40000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x63:
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x57

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x64:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,6
	LD   R30,X
	LDI  R26,LOW(7)
	MUL  R30,R26
	MOVW R30,R0
	__GETW2MN _menu,2
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	MOVW R26,R30
	CALL _strcpyf
	RJMP SUBOPT_0x2A

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x65:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	CLR  R22
	CLR  R23
	RJMP SUBOPT_0x48

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x66:
	LDI  R26,LOW(_buf)
	LDI  R27,HIGH(_buf)
	CALL _strlen
	LSR  R31
	ROR  R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x67:
	CALL _nlcd_GotoXY
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x68:
	LDI  R27,0
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x69:
	LDS  R26,_current_pos
	CLR  R27
	MOV  R30,R21
	LDI  R31,0
	SBRC R30,7
	SER  R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6A:
	LDS  R30,_current_pos
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6B:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,2
	CALL __GETW1P
	MOVW R26,R30
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x6C:
	MOVW R22,R26
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __MULW12U
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	MOVW R26,R30
	CALL _strcpyf
	RJMP SUBOPT_0x2A

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:60 WORDS
SUBOPT_0x6D:
	LDS  R30,_param_id
	LDI  R26,LOW(9)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6E:
	CALL __GETW1P
	CP   R30,R22
	CPC  R31,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6F:
	MOVW R26,R30
	SUBI R30,LOW(-_params)
	SBCI R31,HIGH(-_params)
	MOVW R22,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x70:
	__ADDW2MN _params,2
	CALL __GETW1P
	MOVW R26,R22
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x71:
	MOVW R26,R30
	SUBI R30,LOW(-_params)
	SBCI R31,HIGH(-_params)
	LD   R22,Z
	LDD  R23,Z+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x72:
	SUBI R30,LOW(-_params)
	SBCI R31,HIGH(-_params)
	MOVW R26,R30
	LD   R30,X+
	LD   R31,X+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x73:
	__ADDW2MN _params,4
	CALL __GETW1P
	MOVW R26,R22
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x74:
	STS  _mode,R30
	JMP  _nlcd_Clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x75:
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x57

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x76:
	LDI  R26,LOW(8)
	LDI  R27,HIGH(8)
	SUB  R26,R30
	SBC  R27,R31
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x77:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	MOVW R26,R30
	CALL _strcpyf
	RJMP SUBOPT_0x2A

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x78:
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x6D

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x79:
	__ADDW1MN _params,6
	MOVW R26,R30
	CALL __GETW1P
	LDI  R26,LOW(_labels*2)
	LDI  R27,HIGH(_labels*2)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETW2PF
	CALL _strcpyf
	RJMP SUBOPT_0x2A

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7A:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x6D

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7B:
	SUBI R30,LOW(-_params)
	SBCI R31,HIGH(-_params)
	MOVW R26,R30
	CALL __GETW1P
	RCALL SUBOPT_0x42
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7C:
	__GETD1N 0x461C4000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7D:
	CALL __DIVF21
	CALL __PUTPARD1
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7E:
	SUBI R30,LOW(-_params)
	SBCI R31,HIGH(-_params)
	MOVW R26,R30
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x7F:
	RCALL SUBOPT_0x42
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0x5B
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x80:
	__GETW1MN _params,126
	RCALL SUBOPT_0x42
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0x7C
	RJMP SUBOPT_0x44

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x81:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	MOV  R0,R26
	LD   R26,X
	MOV  R30,R19
	COM  R30
	AND  R30,R26
	MOV  R26,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x82:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x83:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	CALL __LSLW3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x84:
	__PUTD1S 13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x85:
	LDD  R26,Y+13
	CALL _OWI_DetectPresence
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+15
	JMP  _OWI_MatchRom

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x86:
	ST   -Y,R30
	LDD  R26,Y+14
	JMP  _OWI_SendByte

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x87:
	COM  R30
	AND  R30,R26
	OUT  0x11,R30
	IN   R30,0x12
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x88:
	COM  R30
	AND  R30,R26
	OUT  0x12,R30
	__DELAY_USW 1858
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x89:
	IN   R30,0x11
	LDD  R26,Y+1
	OR   R30,R26
	OUT  0x11,R30
	IN   R30,0x12
	MOV  R26,R30
	LDD  R30,Y+1
	COM  R30
	AND  R30,R26
	OUT  0x12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8A:
	IN   R30,0x11
	LDD  R26,Y+2
	OR   R30,R26
	OUT  0x11,R30
	IN   R30,0x12
	MOV  R26,R30
	LDD  R30,Y+2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8B:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x8C:
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x8D:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8E:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x8F:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x90:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x91:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x92:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x93:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x94:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x95:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x96:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x97:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x98:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x99:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x9A:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9B:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9C:
	RCALL SUBOPT_0x97
	RJMP SUBOPT_0x98

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9D:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9E:
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x9F:
	RCALL SUBOPT_0x9A
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA0:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xA1:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA2:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA3:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA4:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA5:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xA6:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA7:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA8:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA9:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xAA:
	__GETD2S 9
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xE66
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

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
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

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
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

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
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

__GETW2PF:
	LPM  R26,Z+
	LPM  R27,Z
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

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__COPYMEL:
	CLR  R25
__COPYME:
	PUSH R30
	PUSH R31
__COPYME0:
	WDR
	SBIC EECR,EEWE
	RJMP __COPYME0
	IN   R23,SREG
	CLI
	OUT  EEARL,R30
	OUT  EEARH,R31
	SBI  EECR,EERE
	IN   R22,EEDR
	OUT  SREG,R23
	ADIW R30,1
	ST   X+,R22
	SBIW R24,1
	BRNE __COPYME0
	POP  R31
	POP  R30
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
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
