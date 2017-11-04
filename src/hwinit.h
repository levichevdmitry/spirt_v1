#ifndef _HWINIT_H_
#define _HWINIT_H_

#define VALVE_PIN       3
#define HEATER_PIN      2
#define DEBUG_LED_PIN   7

#define VALVE_OPN       PORTA |= (1<<VALVE_PIN)
#define VALVE_CLS       PORTA &= ~(1<<VALVE_PIN)

#define HEATER_ON       PORTA |= (1<<HEATER_PIN)
#define HEATER_OFF      PORTA &= ~(1<<HEATER_PIN)

#define DEBUG_LED_ON    PORTD |= (1<<DEBUG_LED_PIN)
#define DEBUG_LED_OFF   PORTD &= ~(1<<DEBUG_LED_PIN)
#define DEBUG_LED_XOR   PORTD ^= (1<<DEBUG_LED_PIN)

#define BEEP_ON  OCR0 = 0x7F;
#define BEEP_OFF OCR0 = 0x00;

//номер вывода, к которому подключен датчик  // PC1
#define BUS   OWI_PIN_3  

void HW_Init();
#ifdef HW1_P
void PresureInit();
#endif

#endif
