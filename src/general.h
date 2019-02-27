#ifndef _GENERAL_H_
#define _GENERAL_H_

//#define HW1_P  // define for Oleg hw version, comment for Alex hw
//#define SLOW_HEAD_SPEED

#define ADC_VREF_TYPE       0x40
#define MAX_DS1820          3
#define DELTA               0.125F
//#define HEADDOZA            0.0129F // расход за 20 мс открытого клапана (0.023F)
#define HEADDOZA            129 // расход за 10 мс открытого клапана (*10e-4 мл/10мс)
#define CALIBRATE_Q         50.0F // отбираемый объем для дозировки

#ifdef SLOW_HEAD_SPEED      // управление скоростью отбора голов
#define HEADSPEED           60.0F // скорость отбора голов мл/ч
#else
#define HEADSPEED           80.0F // скорость отбора голов мл/ч для спекулянтов
#endif

#define DEFAUL_VALVE_PULSE  4 // длительность импульса при калибровке и отборе голов, 2 sine periods

#ifdef HW1_P
    #define P_SENS_ON    // init pressure sensor for Oleg hw version
#endif
/*
#ifdef HW1_P
    #define LCD_DELAY_ON // add delay for Alex hw init
#endif
 */
#define LCD_DELAY_ON // add delay  hw init

unsigned int read_adc(unsigned char adc_input);

extern unsigned char ds1820_devices;

#ifdef HW1_P
extern signed int p_offset;
#endif
extern unsigned char sec;
extern unsigned char minutes;
extern unsigned char hours;
extern char heater_power;
extern char pwmOn;
extern char valvePulse; 
extern unsigned int impulseCounter;
extern unsigned int pwmPeriod;
extern float onePulseDose;
extern unsigned int factCalibrateQ; 
//extern char heater_watchdog;
extern float dis_t_kuba;
extern unsigned int dis_p_ten;
extern unsigned int rect_p_ten_min;
extern unsigned int rect_p_kol_max;
extern float rect_t_otbora;
extern float rect_dt_otbora;
extern unsigned int rect_T1_valve;
extern unsigned int rect_T2_valve;
extern float rect_t_kuba_valve;
extern float rect_t_kuba_off;
extern unsigned int rect_head_val;
extern unsigned int rect_body_speed;
extern unsigned char rect_pulse_delay;

#endif
