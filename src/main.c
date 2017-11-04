/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 06.03.2015
Author  : PerTic@n
Company : If You Like This Software,Buy It
Comments: 


Chip type               : ATmega128
Program type            : Application
AVR Core Clock frequency: 14,745600 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 1024
*****************************************************/
#include <mega128.h>
#include <delay.h>
#include <nokia1100_lcd_lib.h>
#include <circlebuffer.h>
#include <handlers.h>
#include <buttons.h>
#include <general.h>
#include <hwinit.h>
#include <settings.h>
#include <menu.h>

#include <OWIPolled.h>
#include <OWIHighLevelFunctions.h>
#include <OWIBitFunctions.h>
#include <OWIcrc.h>

unsigned char ds1820_devices;
OWI_device ds1820_rom_codes[MAX_DS1820];
OWI_device t_rom_codes[MAX_DS1820];

// External Interrupt 2 service routine
interrupt [EXT_INT2] void ext_int2_isr(void)
{
// Place your code here
static  char halph_wave_counter = 0, halph_wave_counter3 = 0;
static  unsigned int halph_wave_counter2 = 0;

if (++halph_wave_counter3 >= 99) { //100 
    ES_PlaceHeadEvent(EVENT_TIMER_1Hz);
    halph_wave_counter3 = 0;
}

 if (heater_power == 100) { 
    HEATER_ON;
    halph_wave_counter = 0;
 } else if (heater_power > 0) {
   
    if (++halph_wave_counter >= heater_power) {
        HEATER_OFF;
    } else { 
        HEATER_ON;
    } 
        
    if (halph_wave_counter >= 99) { //100 
        halph_wave_counter = 0;
    }
 } else {
    HEATER_OFF;
    halph_wave_counter = 0;
 }
 
 //////////   valve pwm control ////
 halph_wave_counter2 ++;
 if (halph_wave_counter2 >= pwmPeriod - 1) {  
     halph_wave_counter2 = 0;
     if (pwmOn) {
         impulseCounter++; 
     }
 }
 if (pwmOn) {
    if (halph_wave_counter2 < valvePulse) {
        VALVE_OPN;        
    } else {
        VALVE_CLS; 
    } 
 }
 
// heater_watchdog++;
}

#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART0 Receiver buffer
#define RX_BUFFER_SIZE0 8
char rx_buffer0[RX_BUFFER_SIZE0];

#if RX_BUFFER_SIZE0 <= 256
unsigned char rx_wr_index0,rx_rd_index0,rx_counter0;
#else
unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;
#endif

unsigned char counter_ms = 0;

// This flag is set on USART0 Receiver buffer overflow
bit rx_buffer_overflow0;

// USART0 Receiver interrupt service routine
interrupt [USART0_RXC] void usart0_rx_isr(void)
{
char status,data;
status=UCSR0A;
data=UDR0;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer0[rx_wr_index0++]=data;
#if RX_BUFFER_SIZE0 == 256
   // special case for receiver buffer size=256
   if (++rx_counter0 == 0) rx_buffer_overflow0=1;
#else
   if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
   if (++rx_counter0 == RX_BUFFER_SIZE0)
      {
      rx_counter0=0;
      rx_buffer_overflow0=1;
      }
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART0 Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter0==0);
data=rx_buffer0[rx_rd_index0++];
#if RX_BUFFER_SIZE0 != 256
if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
#endif
#asm("cli")
--rx_counter0;
#asm("sei")
return data;
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Place your code here

}

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{

static unsigned char counter = 0;
// Reinitialize Timer1 value
TCNT1H=0xC7B1 >> 8;
TCNT1L=0xC7B1 & 0xff;
// Place your code here

ES_PlaceEvent(EVENT_TIMER_1S);
counter ++;
if (counter >= 10) {
    ES_PlaceEvent(EVENT_TIMER_10S);
    counter = 0;
}

if (mode == RUN_DIST || mode == RUN_RECT || mode == RUN_RECT_SET || mode == CALIBRATE_RUN) {
    sec ++;
    if (sec >= 60) {
        minutes ++;
        sec = 0;
        if (minutes >= 60) {
            minutes = 0;
            hours ++;
        }
    }
}

if (mode == RUN_RECT || mode == RUN_RECT_SET) {
        if (!timerOn){
            timer ++;
        } 
        if (!timerOn && startStop){
            timer_off ++;
        }
}
}

// Timer2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
// Place your code here

if (++counter_ms >= 15) {
    ES_PlaceEvent(EVENT_TIMER_250MS);
    counter_ms = 0;
}

ES_PlaceEvent(EVENT_TIMER_10MS);    

}

unsigned int adc_data;


// ADC interrupt service routine
interrupt [ADC_INT] void adc_isr(void)
{
// Read the AD conversion result
adc_data=ADCW;

}

// Read the AD conversion result
// with noise canceling
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
#asm
    in   r30,mcucr
    cbr  r30,__sm_mask
    sbr  r30,__se_bit | __sm_adc_noise_red
    out  mcucr,r30
    sleep
    cbr  r30,__se_bit
    out  mcucr,r30
#endasm
return adc_data;
}

// Declare your global variables here
#ifdef HW1_P
signed int p_offset;
#endif
unsigned char sec = 0;
unsigned char minutes = 0;
unsigned char hours = 0;
char heater_power = 0;
char pwmOn = 0;
char valvePulse = DEFAUL_VALVE_PULSE; // // смотри параметр в general.h
unsigned int impulseCounter = 0;
unsigned int pwmPeriod = 400; // 4 s
//char heater_watchdog = 0;

void main(void)
{
// Declare your local variables here
unsigned char event = 0;

HW_Init();

BEEP_ON;
//DEBUG_LED_ON;

OWI_Init(BUS);
BUT_Init();  
nlcd_Init();
delay_ms(10);

nlcd_GotoXY(0,0);
nlcd_PrintF("----------------");
nlcd_PrintWideF(" Nikopol");
nlcd_GotoXY(0,2);
nlcd_PrintF("    present     ");
nlcd_PrintF("   -<СПИРТ>-    "); 
nlcd_PrintF("   контроллер   ");
#ifdef HW1_P
    nlcd_PrintF(" hw v.1.1d P sen");
#else
    nlcd_PrintF(" hw v.1.1d      ");
#endif

#ifdef SLOW_HEAD_SPEED
nlcd_PrintF(" sw v.0.31.s uni");
#else
nlcd_PrintF(" sw v.0.31.f uni");
#endif
BEEP_OFF;
delay_ms(2000); 
nlcd_Clear();

//DEBUG_LED_OFF;

nlcd_GotoXY(0,2);
nlcd_PrintF(" Инициализация  ");
nlcd_PrintF("  датчиков Т    "); 
nlcd_PrintF("    Найдено     ");

if (OWI_SearchDevices(ds1820_rom_codes, MAX_DS1820, BUS, &ds1820_devices) == SEARCH_SUCCESSFUL) { 
    sprintf(buf, "%i шт", ds1820_devices);
} else {
    sprintf(buf, "%i шт", 0);
}
nlcd_GotoXY(1,5); 
nlcd_Print(buf);
delay_ms(2000);  
nlcd_Clear();
LoadParam();
SetNewParams();  
// Global enable interrupts
#asm("sei")

/*
// Watchdog Timer initialization
// Watchdog Timer Prescaler: OSC/2048k
#pragma optsize-
WDTCR=0x1F;
WDTCR=0x0F;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif
*/
#ifdef HW1_P
    PresureInit();
#endif

while (1)
      {
      // Place your code here
      // #asm("wdr");
        event = ES_GetEvent();
        if (event)
            ES_Dispatch(event);
      }
}
