#include <handlers.h>
#include <circlebuffer.h>
#include <nokia1100_lcd_lib.h>
#include <buttons.h>
#include <stdio.h>
#include <menu.h>
#include <settings.h>
#include <general.h>
#include <hwinit.h>

#include <OWIPolled.h>
#include <OWIHighLevelFunctions.h>
#include <OWIBitFunctions.h>
#include <OWIcrc.h>
#include <stdlib.h>

extern OWI_device ds1820_rom_codes[MAX_DS1820];
extern OWI_device t_rom_codes[MAX_DS1820];

char buf[20]; //17
float t_kuba, t_kolona_down, t_kolona_up;
float t_kuba_old, t_kolona_down_old, t_kolona_up_old;
#ifdef HW1_P
float p_kolona;
#endif 
float headDisp;
float t_kuba_avg, t_kuba_sum;
char t_kuba_count;
char abortProcess = 0;
char startStop = 0;
char pressureOver = 0;
char timerOn = 0;
char timerSignOn = 0;
unsigned int timer = 0;
unsigned int timer_off = 0;
unsigned int timerSign = 0;
unsigned int impulseCounterCalibrate;
unsigned char mode = MENU;
float Votb;
unsigned int ssCounter = 0;
unsigned char ssTrig = 0;
unsigned char distSettingMode = DIST_SET_MODE_PWR;
unsigned char distValveMode = DIST_VLV_MODE_CLS;

flash unsigned char valve_cls_lbs[] = {"З"};
flash unsigned char valve_reg_lbs[] = {"Р"};
flash unsigned char valve_opn_lbs[] = {"О"};
flash unsigned char * flash valve_lbs[3] = {valve_cls_lbs, valve_reg_lbs, valve_opn_lbs};

void CalculateDistBodySpeed();

//*****************************************************************************
// основные подпрограммы  Дистиляции
//*****************************************************************************
void RunDistilation(){
    nlcd_Clear();
    if ((t_rom_codes[0].id[0] == 0xFF) || (t_rom_codes[0].id[0] == 0x00)) {
        nlcd_GotoXY(0,0);
        nlcd_PrintF("Нет назначенных");
        nlcd_PrintF("   датчиков    ");
        nlcd_PrintF("    t куба!    ");
        delay_ms(5000);
        nlcd_Clear();
        print_menu();
        return;
    }
     // t колоны верх
    if ((t_rom_codes[2].id[0] == 0xFF) || (t_rom_codes[2].id[0] == 0x00)) {
        nlcd_GotoXY(0,0);
        nlcd_PrintF("Нет назначенных");
        nlcd_PrintF("   датчиков    ");
        nlcd_PrintF("t колоны верх! ");
        delay_ms(5000);
        nlcd_Clear();
        print_menu();
        return;
    }
    
    OWI_SearchDevices(ds1820_rom_codes, MAX_DS1820, BUS, &ds1820_devices);
    if (ds1820_devices < 2) { // < 3
        nlcd_GotoXY(0,0);
        nlcd_PrintF(" Подключены не ");
        nlcd_PrintF("  все датчики  ");
        nlcd_PrintF(" или отключены ");
        nlcd_PrintF(" полностью все!");
        delay_ms(5000);
        nlcd_Clear();
        print_menu();
        return;
    } 
    /*
    if (ds1820_devices == 0) {
        nlcd_GotoXY(0,0);
        nlcd_PrintF("Нет подключенных");
        nlcd_PrintF(" датчиков !!!");
        delay_ms(5000);
        nlcd_Clear();
        print_menu();
        return;
    }
     */
    if (InitSensor(t_rom_codes[0].id, BUS, 25, 35, DS18B20_11BIT_RES)) {
        nlcd_GotoXY(0,0);
        nlcd_PrintF("   Не верный   ");
        nlcd_PrintF("    датчик     ");
        nlcd_PrintF("    t куба!    ");
        delay_ms(5000);
        nlcd_Clear();
        print_menu();
        return;
    } 
    
    if (InitSensor(t_rom_codes[1].id, BUS, 25, 35, DS18B20_11BIT_RES)) {
        nlcd_GotoXY(0,0);
        nlcd_PrintF("    Не верный   ");
        nlcd_PrintF("     датчик     ");
        nlcd_PrintF(" t колоны верх! ");
        delay_ms(5000);
        nlcd_Clear();
        print_menu();
        return;
    }
     
   // if (!InitSensor(t_rom_codes[0].id, BUS, 25, 35, DS18B20_11BIT_RES)) {
        sec = 0;
        minutes = 0;
        hours = 0;
        Votb = 1200.0; //  мл/ч
        CalculateDistBodySpeed();
        heater_power = dis_p_ten;
        VALVE_CLS; 
        mode = RUN_DIST; 
   /* } else { 
        nlcd_GotoXY(0,0);
        nlcd_PrintF(" Не верный ");
        nlcd_PrintF(" датчик !!!");
        delay_ms(5000);
        nlcd_Clear();
        print_menu();
    }   */
    
}

void ViewDistilation(){
unsigned char tkuba_c[2] = {" "};
unsigned char tkol_up_c[2] = {" "};
unsigned char tmp[3];
   if (abortProcess) {
      //nlcd_Clear();
      nlcd_GotoXY(0,1);
      nlcd_PrintF("   Дистиляция   ");
      nlcd_GotoXY(0,2);
      nlcd_PrintF("Прервать");
      nlcd_GotoXY(0,3);
      nlcd_PrintF("процесс?");
      nlcd_GotoXY(0,4);
      nlcd_PrintF("<ENT>Да <ESC>Нет");
   } else {
       if (t_kuba - t_kuba_old >= DELTA){ // Температура растет
        tkuba_c[0] = 30;   // up
      } else if (t_kuba - t_kuba_old <= -DELTA){  // Температура падает
        tkuba_c[0] = 31;   // down
      } else {
        tkuba_c[0] = ' ';
      }
      
      if (t_kolona_up - t_kolona_up_old >= DELTA){ // Температура растет
        tkol_up_c[0] = 30; // up
      } else if (t_kolona_up - t_kolona_up_old <= -DELTA){  // Температура падает
        tkol_up_c[0] = 31;; // down
      } else {
        tkol_up_c[0] = ' ';
      } 
      
      #ifdef P_SENS_ON
        p_kolona = ((signed int)(read_adc(0)) - p_offset) * 4.88 / 7.511 / 13.5954348;
      #endif
      
      nlcd_GotoXY(3,0);
      nlcd_PrintF("Дистилляция");
      nlcd_GotoXY(1,2);
      sprintf(buf, "Время:%2i:%2i:%2i", hours, minutes, sec);
      nlcd_Print(buf);
      nlcd_GotoXY(1,3); 
      sprintf(buf,"tкол в %-3.2f %s", t_kolona_up, tkol_up_c);
      nlcd_Print(buf);
      nlcd_GotoXY(1,4); 
      sprintf(buf,"tкуба  %-3.2f %s", t_kuba, tkuba_c);
      nlcd_Print(buf);
      #ifdef P_SENS_ON
          nlcd_GotoXY(1,5);
          sprintf(buf, "P%+3.1f", p_kolona);
          nlcd_Print(buf);
      #endif
      //------ Состояние клапана
      nlcd_GotoXY(0,6);
      strcpyf(tmp, valve_lbs[distValveMode]); 
      sprintf(buf, "%cКл-%s %c%4.0f мл/ч",(distSettingMode == DIST_SET_MODE_VALV)?'>':' ',tmp,(distSettingMode == DIST_SET_MODE_FLOW)?'>':' ', Votb);
      nlcd_Print(buf);
      // ТЭН
      nlcd_GotoXY(0,7); 
      sprintf(buf,"%cТЭН %3i%%", (distSettingMode == DIST_SET_MODE_PWR)?'>':' ', heater_power);
      nlcd_Print(buf);
     
    }
}
//*****************************************************************************
// основные подпрограммы  Ректификации
//*****************************************************************************
void RunRectification(){
    nlcd_Clear(); 
    // t куба
    if ((t_rom_codes[0].id[0] == 0xFF) || (t_rom_codes[0].id[0] == 0x00)) {
        nlcd_GotoXY(0,0);
        nlcd_PrintF("Нет назначенных");
        nlcd_PrintF("   датчиков    ");
        nlcd_PrintF("    t куба!    ");
        delay_ms(5000);
        nlcd_Clear();
        print_menu();
        return;
    } 
    // t колоны низ
    if ((t_rom_codes[1].id[0] == 0xFF) || (t_rom_codes[1].id[0] == 0x00)) {
        nlcd_GotoXY(0,0);
        nlcd_PrintF("Нет назначенных");
        nlcd_PrintF("   датчиков    ");
        nlcd_PrintF(" t колоны низ! ");
        delay_ms(5000);
        nlcd_Clear();
        print_menu();
        return;
    }
    // t колоны верх
    if ((t_rom_codes[2].id[0] == 0xFF) || (t_rom_codes[2].id[0] == 0x00)) {
        nlcd_GotoXY(0,0);
        nlcd_PrintF("Нет назначенных");
        nlcd_PrintF("   датчиков    ");
        nlcd_PrintF("t колоны верх! ");
        delay_ms(5000);
        nlcd_Clear();
        print_menu();
        return;
    }
    OWI_SearchDevices(ds1820_rom_codes, MAX_DS1820, BUS, &ds1820_devices);
    if (ds1820_devices < 3) { // < 3
        nlcd_GotoXY(0,0);
        nlcd_PrintF(" Подключены не ");
        nlcd_PrintF("  все датчики  ");
        nlcd_PrintF(" или отключены ");
        nlcd_PrintF(" полностью все!");
        delay_ms(5000);
        nlcd_Clear();
        print_menu();
        return;
    } 
    
    if (InitSensor(t_rom_codes[0].id, BUS, 25, 35, DS18B20_11BIT_RES)) {
        nlcd_GotoXY(0,0);
        nlcd_PrintF("   Не верный   ");
        nlcd_PrintF("    датчик     ");
        nlcd_PrintF("    t куба!    ");
        delay_ms(5000);
        nlcd_Clear();
        print_menu();
        return;
    } 
    
    if (InitSensor(t_rom_codes[1].id, BUS, 25, 35, DS18B20_11BIT_RES)) {
        nlcd_GotoXY(0,0);
        nlcd_PrintF("    Не верный   ");
        nlcd_PrintF("     датчик     ");
        nlcd_PrintF(" t колоны верх! ");
        delay_ms(5000);
        nlcd_Clear();
        print_menu();
        return;
    }
    
    if (InitSensor(t_rom_codes[2].id, BUS, 25, 35, DS18B20_11BIT_RES)) {
        nlcd_GotoXY(0,0);
        nlcd_PrintF("   Не верный   ");
        nlcd_PrintF("    датчик     ");
        nlcd_PrintF(" t колоны низ! ");
        delay_ms(5000);
        nlcd_Clear();
        print_menu();
        return;
    }
    
    sec = 0;
    minutes = 0;
    hours = 0;
    heater_power = 100;
    VALVE_CLS;
    impulseCounter = 0;
    ssCounter = 0;
    ssTrig = 0;
    startStop = 0; 
    mode = RUN_RECT;   
}

void ViewRectification(){
unsigned char tkuba_c[2] = {" "};
unsigned char tkol_up_c[2] = {" "}; 
unsigned char tkol_down_c[2] = {" "};
unsigned char tmp[17];

   if (abortProcess) {
      //nlcd_Clear();
      nlcd_GotoXY(2,1);
      nlcd_PrintF("Ректификация");
      nlcd_GotoXY(4,2);
      nlcd_PrintF("Прервать");
      nlcd_GotoXY(4,3);
      nlcd_PrintF("процесс?");
      nlcd_GotoXY(0,4);
      nlcd_PrintF("<ENT>Да <ESC>Нет");
   } else { 
   
      if (t_kuba - t_kuba_old >= DELTA){ // Температура растет
        tkuba_c[0] = 30;   // up
      } else if (t_kuba - t_kuba_old <= -DELTA){  // Температура падает
        tkuba_c[0] = 31;   // down
      } else {
        tkuba_c[0] = ' ';
      } 
      
      if (t_kolona_down - t_kolona_down_old >= DELTA){ // Температура растет
        tkol_down_c[0] = 30; // up
      } else if (t_kolona_down - t_kolona_down_old <= -DELTA){  // Температура падает
        tkol_down_c[0] = 31; // down
      } else {
        tkol_down_c[0] = ' ';
      } 
      
      if (t_kolona_up - t_kolona_up_old >= DELTA){ // Температура растет
        tkol_up_c[0] = 30; // up
      } else if (t_kolona_up - t_kolona_up_old <= -DELTA){  // Температура падает
        tkol_up_c[0] = 31;; // down
      } else {
        tkol_up_c[0] = ' ';
      }   
      
      #ifdef P_SENS_ON
        p_kolona = ((signed int)(read_adc(0)) - p_offset) * 4.88 / 7.511 / 13.5954348;
      #endif
      
      //nlcd_GotoXY(1,0);
     // nlcd_PrintF("  Процесс");
      nlcd_GotoXY(1,0);
      nlcd_PrintF(" Ректификация");
      nlcd_GotoXY(1,1);
      sprintf(buf, "Время:%2i:%2i:%2i", hours, minutes, sec);
      nlcd_Print(buf);
      nlcd_GotoXY(1,2); 
      sprintf(buf,"tкол в %-3.2f %s", t_kolona_up, tkol_up_c);
      nlcd_Print(buf);
      nlcd_GotoXY(1,3); 
      sprintf(buf,"tкол н %-3.2f %s", t_kolona_down, tkol_down_c);
      nlcd_Print(buf);
      nlcd_GotoXY(1,4); 
      sprintf(buf,"tкуба  %-3.2f %s", t_kuba, tkuba_c); //t_kuba_avg
      nlcd_Print(buf);
      nlcd_GotoXY(0,5);
      nlcd_PrintF("                "); // clear line :) it's not good 
      #ifdef P_SENS_ON
          nlcd_GotoXY(1,5);
          sprintf(buf, "P%+3.1f", p_kolona);
          nlcd_Print(buf);
      #endif
      nlcd_GotoXY(8,5);
      sprintf(buf, "ТЭН%3i%%", heater_power);
      nlcd_Print(buf);
      
      nlcd_GotoXY(1,6);
      strcpyf(tmp, yesno[startStop]);
      //sprintf(buf, "СтартСтоп %s", tmp);
      sprintf(buf, "С\\С %s К %i", tmp, ssCounter);
      nlcd_Print(buf);
      nlcd_GotoXY(1,7);
      if (startStop) {
          sprintf(buf, "Vт %4.0f мл/ч", Votb);
      } else {
          sprintf(buf, "Qг %4.2f мл", headDisp);
      }
      nlcd_Print(buf);
      
      // Debug 
      /*
      nlcd_GotoXY(1,6);
      sprintf(buf, "SS %i PWM %i", startStop, pwmOn);
      nlcd_Print(buf);
      nlcd_GotoXY(1,7);
      sprintf(buf, "P%i T%i", valvePulse, pwmPeriod);
      nlcd_Print(buf);
       */       
    }
}
//*****************************************************************************
// Расчет параметров ШИМ
//*****************************************************************************
void CalculateHead() {
   float Votb_fact;
   valvePulse = DEFAUL_VALVE_PULSE; // смотри параметр в general.h
   impulseCounter = 0;
   Votb_fact = -0.000163  *HEADSPEED * HEADSPEED + 1.156 * HEADSPEED + 1.198;
   pwmPeriod = ((float)valvePulse * onePulseDose) / (Votb_fact / 3600.0) * 100.0 ; // расчет периода ШИМ  
}

void CalculateBodySpeed() {
    float Votb_fact;
    valvePulse = rect_pulse_delay;  // Длительность импульса берем из параметров
    if (t_kuba_avg >= 84.3F) {
        Votb = ((980.0 - 10.0 * t_kuba_avg) / 137.0) * (float)rect_body_speed ;   //Считаем скорость отбора в зависимости от темпеартуры в кубе
    } else {
        Votb = (float)rect_body_speed;  //Считаем скорость отбора
    }
    //pwmPeriod =  ((float)valvePulse * onePulseDose) / ((Votb * 1.35F) / 3600.0) * 100.0;   // считаем период, исходя из скорости отбора, 1.35F для корректировки
    //pwmPeriod =  ((float)valvePulse * onePulseDose) / (Votb / 3600.0) * 100.0;   // считаем период, исходя из скорости отбора
    Votb_fact = -0.000163 * Votb * Votb + 1.156 * Votb + 1.198;
    pwmPeriod =  ((float)valvePulse * onePulseDose) / (Votb_fact / 3600.0) * 100.0;   // считаем период, исходя из скорости отбора
    /*
    if (pwmPeriod < valvePulse) // если период ШИМ меньше длительности импульса, то просто открываем клапан
    {
       pwmPeriod = valvePulse;
    } 
    */
}

void CalculateDistBodySpeed() {
  float Votb_fact;  
  Votb_fact = -0.000163 * Votb * Votb + 1.156 * Votb + 1.198;
  pwmPeriod =  ((float)valvePulse * onePulseDose) / (Votb_fact / 3600.0) * 100.0;   // считаем период, исходя из скорости отбора
}

//*****************************************************************************
// Подпрограмма остановки процесса
//*****************************************************************************

void StopProcess() {
     nlcd_Clear();
     if (mode == RUN_DIST) {
        nlcd_GotoXY(0,1);
        nlcd_PrintF("   Дистилляция   ");
     }
     if (mode == RUN_RECT) {
        nlcd_GotoXY(0,1);
        nlcd_PrintF("  Ректификация  ");
     }
     nlcd_GotoXY(1,3);
     nlcd_PrintWideF("Процесс");
     nlcd_GotoXY(1,4);
     nlcd_PrintWideF("окончен!");
     BEEP_ON;
     mode = END_PROC;
     VALVE_CLS;         // закрываем клапан 
     heater_power = 0; // выключаем ТЭН
     startStop = 0;
     pressureOver = 0;
     abortProcess = 0;
     pwmOn = 0;  
}
//*****************************************************************************
//                              Калибровка
//*****************************************************************************

void CalibrateRun() {
//  предварительные настройки
    pwmPeriod = 100; // 1 sec
    valvePulse = DEFAUL_VALVE_PULSE; // смотри параметр в general.h
    impulseCounter = 0;
    sec = 0;
    minutes = 0;
    hours = 0;
    abortProcess = 0;
    mode = CALIBRATE_RUN;
    impulseCounterCalibrate = (unsigned int)(CALIBRATE_Q / ((float)valvePulse * onePulseDose));
    pwmOn = 1;
}

void CalibrateStop(){
// расчет нового коэффициента и его сохранение
    onePulseDose =  (float)factCalibrateQ / (float)((long)valvePulse * (long)impulseCounter);
    SaveParam();
    abortProcess = 0;
}

void CalibrateView() {
    if (abortProcess) {
        nlcd_GotoXY(3,1);
        nlcd_PrintF("Калибровка");
        nlcd_GotoXY(4,2);
        nlcd_PrintF("Прервать");
        nlcd_GotoXY(4,3);
        nlcd_PrintF("процесс?");
        nlcd_GotoXY(0,4);
        nlcd_PrintF("<ENT>Да <ESC>Нет");
    } else {
        if (impulseCounter >= impulseCounterCalibrate) {     // если закончили калибровку просим ввести реальное значение 
            pwmOn = 0;
            VALVE_CLS; 
            factCalibrateQ =  CALIBRATE_Q;
            param_id = 13;  
            params[param_id].value = factCalibrateQ;
            last_menu = current_menu;
            last_pos = current_pos;
            current_menu = MENU_RECT;
            current_pos = 11; // Фактический объем
            nlcd_Clear();
            mode = CALIBRATE_MOD;
        } else {
            nlcd_GotoXY(3,0);
            nlcd_PrintF("Калибровка");
            nlcd_GotoXY(1,1);
            sprintf(buf,"Время:%2i:%2i:%2i", hours, minutes, sec);
            nlcd_Print(buf);
            nlcd_GotoXY(1,3);
            nlcd_PrintF("Отдозированно: ");
            nlcd_GotoXY(3,4);  
            sprintf(buf, "Q %4.2f мл", headDisp);
            nlcd_Print(buf);
            nlcd_GotoXY(3,5);
            sprintf(buf, "k %1.4f мл", onePulseDose);
            nlcd_Print(buf);
            nlcd_GotoXY(3,6);
            sprintf(buf, "i %i имп.", impulseCounter);
            nlcd_Print(buf);
        } 
    }
}


//*****************************************************************************
// обработчики событий
//*****************************************************************************
void HandlerEventTimer_10s(void) {

    switch(mode) {
        case RUN_RECT:
                    if (startStop) {
                        t_kuba_avg = t_kuba_sum / (float)t_kuba_count;
                        t_kuba_sum = 0.0;
                        t_kuba_count = 0;  
                        CalculateBodySpeed();
                    }
                    break;
    }
}


void HandlerEventTimer_1Hz(void)
{
   switch(mode) {
        case RUN_DIST:
                        t_kuba_old = t_kuba;
                        t_kolona_up_old = t_kolona_up;     
                        t_kuba = GetTemperatureMatchRom(t_rom_codes[0].id, BUS);
                        t_kolona_up = GetTemperatureMatchRom(t_rom_codes[2].id, BUS);
                        break;
        case RUN_RECT:
                        t_kuba_old = t_kuba;
                        t_kolona_down_old = t_kolona_down;
                        t_kolona_up_old = t_kolona_up;         
                        t_kuba = GetTemperatureMatchRom(t_rom_codes[0].id, BUS);
                        t_kolona_down = GetTemperatureMatchRom(t_rom_codes[1].id, BUS);
                        t_kolona_up = GetTemperatureMatchRom(t_rom_codes[2].id, BUS);                       
                        
                        t_kuba_sum += t_kuba;
                        t_kuba_count ++;
                        break;   
   }
   StartAllConvert_T(BUS);
}


void HandlerEventTimer_1s(void) 
{
    /*
    if ((heater_watchdog < 90) && heater_power != 0) {
        HEATER_OFF; // Выключаем ТЭН на случай обрыва детектора нуля   
    }
    heater_watchdog = 0;
    */
        
    switch(mode) {
        case RUN_DIST:                                                 
                        
                        if ((t_kuba >= dis_t_kuba) || timer_off >= 20*60) {  // 20 минут
                        // end process
                            StopProcess();
                        }
                        // управление клапаном
                        switch(distValveMode){
                            case DIST_VLV_MODE_CLS: {
                               pwmOn = 0; 
                               VALVE_CLS;
                            break;
                            }
                            
                            case DIST_VLV_MODE_REG: {
                               pwmOn = 1;
                            break;
                            }
                            
                            case DIST_VLV_MODE_OPN: {
                                pwmOn = 0;
                                VALVE_OPN;
                            break;
                            }
                        }
                        
                        break;
        case RUN_RECT:  
                                    
                        if (t_kuba > 60.0) {
                            heater_power = rect_p_ten_min;
                            #ifdef P_SENS_ON
                                if ((p_kolona > rect_p_kol_max) || pressureOver) {
                                    heater_power -= 10;
                                    pressureOver = 1;
                                }
                            #endif
                            if ((fabs(t_kolona_up_old - t_kolona_up) <= 2.0*DELTA) && !startStop && t_kuba > 75.0 && !pwmOn) { // Сигнализация по температуре
                                if ((timerSign >= 600) && !timerSignOn) { // 10 min
                                    timerSignOn = 1;
                                    BEEP_ON;
                                } else {
                                    timerSign ++;
                                }
                            } else {
                                timerSign = 0;
                            }
                        }
                        
                        if (!startStop) { // считаем количество голов
                            //headDisp = (float)impulseCounter * onePulseDose * (float)valvePulse * 0.65;  // 0.65 попытка скорректировать пропуски открытия клапана при опросе датчиков  температуры
                            headDisp = (float)impulseCounter * onePulseDose * (float)valvePulse;
                        } else {
                            headDisp = 0.0;   
                        }
                        // оключаем клапан по кокнчанию отбора голов
                        if ((headDisp >= (float)(rect_head_val)) && !startStop && pwmOn) {
                            pwmOn = 0;
                            VALVE_CLS;
                        }
                                                 
                        // StartStop
                        if (startStop) {
                           
                            if (t_kolona_down >= rect_dt_otbora + rect_t_otbora ) {
                                timer = 0;
                                VALVE_CLS;
                                pwmOn = 0;
                                timerOn = 0;
                                if (ssTrig == 0) {
                                    ssTrig = 1;
                                    ssCounter ++;
                                    //уменьшаем скорость отбора на 3% при каждой остановке колоны (Защита от Буратин!!!)
                                    rect_body_speed =(int)((float)rect_body_speed * 0.97); 
                                }
                            } else {
                                timer_off = 0;
                                if (timerOn) {
                                    //VALVE_OPN;
                                    pwmOn = 1;
                                    ssTrig = 0;
                                    //timer = 0;
                                } else {
                                    if (t_kuba > rect_t_kuba_valve) {
                                        if (timer >= rect_T2_valve * 60) {
                                            timerOn = 1;
                                        }
                                    } else {
                                        if (timer >= rect_T1_valve * 60) {
                                            timerOn = 1;
                                        }
                                    }
                                }    
                            }
                        }
                        
                        if (t_kuba >= rect_t_kuba_off) {
                        // end process
                            StopProcess();
                            return;
                        }
                        break;  
                        
        case CALIBRATE_RUN: 
                        //Calibrate_View();
                        headDisp = (float)impulseCounter * onePulseDose * (float)valvePulse;
                        break;
    }
    
    //StartAllConvert_T(BUS);
}

//обработчик события - таймер 250 ms  обновление экрана
void HandlerEventTimer_250ms(void) 
{
      switch (mode) {
        case MENU:
                        print_menu();
                        break;
                   
        case SETTINGS:  
                        ViewSettings();
                        break;
                        
        case RUN_RECT_SET:
                        ViewSettings();
                        break;
                        
        case RUN_DIST:  
                        ViewDistilation();
                        break;
       
        case RUN_RECT:  
                        ViewRectification();
                        break;  
                        
        case CALIBRATE_RUN: 
                        CalibrateView();
                        break;
        
        case CALIBRATE_MOD: 
                        ViewSettings();
                        break;
                            
    } 
}

//обработчик события - таймер 10 ms
void HandlerEventTimer_10ms(void){
    uint8_t but, code;
    BUT_Poll();  
    but = BUT_GetBut();
    if (but){
        code = BUT_GetBut(); 
      if (code == 1) {
        //DEBUG_LED_XOR; 
        switch(but) {
            case BUT_1_ID:{
                   ES_PlaceEvent(KEY_DOWN);
                   cod = 'd';
                   break;
                   }
                   
            case BUT_2_ID:{
                   ES_PlaceEvent(KEY_UP);
                   cod = 'u';
                   break;
                   }
            case BUT_3_ID:{
                   ES_PlaceEvent(KEY_ENTER);
                   cod = 'e';
                   break;
                   }
            case BUT_4_ID:{
                   ES_PlaceEvent(KEY_ESC);
                   cod = 'b';
                   break;
                   }
        } 
      } else {
        switch(but) {
            case BUT_1_ID:{
                   ES_PlaceEvent(KEY_L_DOWN);
                   //cod = 'd';
                   break;
                   }
                   
            case BUT_2_ID:{
                   ES_PlaceEvent(KEY_L_UP);
                   //cod = 'u';
                   break;
                   }  
        }
      }
    }
}  

//обработчик кнопки Enter
void HandlerEventButEnter(void) {
  switch (mode) {
        case MENU:
                        menu[current_menu].items_submenu[current_pos].function();
                        if (mode == MENU){
                            print_menu();
                        }
                        break;
                   
        case SETTINGS:
                        SetNewParams();
                        SaveParam();
                        nlcd_Clear();
                        mode = MENU;
                        break;
        case INIT:
                        SetSensors();
                        nlcd_Clear();
                        mode = MENU;
                        break;
        case END_PROC:
                        mode = MENU;
                        BEEP_OFF;
                        nlcd_Clear();
                        print_menu();
                        break;
        case RUN_DIST:
                        if (abortProcess) {
                            StopProcess();
                            BEEP_OFF;
                            mode = MENU;
                            nlcd_Clear();
                            print_menu();
                        } else { // перебираем параметры для изменения
                            distSettingMode ++;
                            distSettingMode %= 3;
                        }
                        break; 
        case RUN_RECT:
                        if (abortProcess) {
                            StopProcess();
                            BEEP_OFF;
                            mode = MENU;
                            nlcd_Clear();
                            print_menu();
                        } else {
                        // Вызов параметров отбора
                            nlcd_Clear();
                            mode = RUN_RECT_SET;
                            param_id = 4;
                            params[param_id].value = t_kolona_down * 100;
                            last_menu = current_menu;
                            last_pos = current_pos;
                            current_menu = MENU_RECT;
                            current_pos = 2; // Температура отбора тела 
                            ViewSettings();
                        }
                        break;
                        
        case RUN_RECT_SET:
                        SetNewParams();
                        SaveParam();
                        current_menu = last_menu;
                        current_pos = last_pos;
                        startStop = 1;       // Запускаем ШИМ отбор 
                        ssCounter = 0;
                        ssTrig = 0;
                        impulseCounter = 0;
                        pwmOn = 1;
                        t_kuba_avg = t_kuba;
                        t_kuba_sum = 0.0;
                        t_kuba_count = 0;
                        CalculateBodySpeed();
                        //VALVE_OPN;
                        nlcd_Clear();
                        mode = RUN_RECT;
                        break;
                        
       case CALIBRATE:  
                       // mode = CALIBRATE_RUN;   // Запус процесса калибровки
                        nlcd_Clear();
                        CalibrateRun();
                        CalibrateView();
                        break;
                        
       case CALIBRATE_RUN:                      // Дозируем 50 мл для калибровки
                        if (abortProcess) {    // прерываем процесс
                            VALVE_CLS;
                            pwmOn = 0;
                            abortProcess = 0;
                            mode = MENU;
                            nlcd_Clear();
                            print_menu();
                        }
                        break;
                        
       case CALIBRATE_MOD:
                        SetNewParams();                 // закончили калибровку, сохраняем параметры и выходим в меню
                        CalibrateStop();
                        current_menu = last_menu;
                        current_pos = last_pos;
                        mode = MENU;
                        nlcd_Clear();
                        print_menu();
                        break;                            
    } 
}

//обработчик кнопки Esc
void HandlerEventButEsc(void) {
  switch (mode) {
  
        case SETTINGS:  
                        nlcd_Clear();
                        mode = MENU;
                        break;
        case INIT:
                        nlcd_Clear();
                        mode = MENU;
                        break;
                        
        case MENU:       
                        if (current_menu != 0) {
                            goto_menu();
                            print_menu();  
                        } else if (current_menu == 0){
                           // mode = GENERAL;
                            nlcd_Clear();
                            print_menu();
                           // ES_PlaceEvent(EVENT_TIMER_1S);
                        }
                        break; 
                       
        case END_PROC:  
                        mode = MENU;
                        BEEP_OFF;
                        nlcd_Clear();
                        print_menu();
                        break;
        case RUN_DIST:  
                        abortProcess = !abortProcess;
                        nlcd_Clear();                
                        break;
                        
        case RUN_RECT:  
                        if (timerSignOn) {
                            BEEP_OFF;
                            timerSignOn = 0;
                            timerSign = 0;
                        } else {
                            abortProcess = !abortProcess;
                            nlcd_Clear();                
                        }  
                        break;
                        
        case RUN_RECT_SET:
                        current_menu = last_menu;
                        current_pos = last_pos;
                        nlcd_Clear();
                        mode = RUN_RECT;
                        break; 
                        
        case CALIBRATE_RUN:
                        abortProcess = !abortProcess;
                        nlcd_Clear();
                        //Calibrate_View();
                        break; 
                              
     } 
}

//обработчик кнопки Up
void HandlerEventButUp(void) {
   switch (mode) {
        case MENU:
                        if (current_pos <= 0) {
                                current_pos=menu[current_menu].num_selections-1;
                        } else { 
                                current_pos--; 
                        }
                        nlcd_Clear();
                        print_menu();
                        break;
                   
        case SETTINGS:  
                        nlcd_Clear();
                        ParamInc();
                        break;
                        
        case RUN_RECT_SET:
                        nlcd_Clear();
                        ParamInc();
                        break;
                        
        case RUN_DIST:
                        switch(distSettingMode) {
                            case DIST_SET_MODE_PWR:  
                                {
                                    heater_power += 1;   //5
                                    if (heater_power > 100){
                                        heater_power = 100;
                                    }
                                    break;
                                }
                            case DIST_SET_MODE_VALV:  
                                {   
                                    distValveMode ++;
                                    distValveMode %= 3;
                                    break;
                                }
                            case DIST_SET_MODE_FLOW:  
                                {
                                    if (Votb < 2000.0) {
                                        Votb += 10;
                                    }
                                    CalculateDistBodySpeed();
                                    break;
                                }
                                
                        }
                        break; 
        case RUN_RECT:
                        if (!startStop) {
                            VALVE_OPN;
                        }
                        break;
                         
        case CALIBRATE_MOD:                 // вводим реальное значение объема
                        nlcd_Clear();
                        ParamInc();
                        break;     
    }  
}

//обработчик кнопки Down  
void HandlerEventButDown(void) {
  switch (mode) {
       case MENU:
                         if(current_pos>=menu[current_menu].num_selections-1) {
                             current_pos=0;
                         } else {
                             current_pos++;
                         }
                         nlcd_Clear();
                         print_menu();
                         break;
                         
       case SETTINGS:    
                         nlcd_Clear();
                         ParamDec();
                         break;
       
       case RUN_RECT_SET:
                        nlcd_Clear();
                        ParamDec();
                        break;
                         
       case RUN_DIST: 
                        switch(distSettingMode) {
                            case DIST_SET_MODE_PWR:  
                                {
                                    heater_power -= 1; //5
                                    if (heater_power < 1){
                                        heater_power = 1;
                                    }
                                    break;
                                }
                            case DIST_SET_MODE_VALV:  
                                {
                                    if (distValveMode > 0) {
                                        distValveMode --;
                                    } else {
                                        distValveMode = 2;
                                    }
                                    break;
                                }
                            case DIST_SET_MODE_FLOW:  
                                {
                                    if (Votb >= 20.0) {
                                        Votb -= 10;
                                    }
                                    CalculateDistBodySpeed();
                                    break;
                                }
                                
                        }
                        break;
       case RUN_RECT:
                        if (!startStop) {
                            VALVE_CLS;
                        }
                        break;
                        
       case CALIBRATE_MOD:                 // вводим реальное значение объема
                        nlcd_Clear();
                        ParamDec();
                        break;
    }     
}



void HandlerEventButLUp(void){
   switch (mode) {
                           
        case SETTINGS:
                        nlcd_Clear();
                        ParamDec();
                        Param10Inc();
                        break;
                        
        case RUN_RECT_SET:
                        nlcd_Clear();
                        ParamDec();
                        Param10Inc();
                        break;
        case RUN_RECT:
                        if (!startStop) {
                            CalculateHead();
                            pwmOn = 1;
                        }
                        break;
        case RUN_DIST:                                                   
                        switch(distSettingMode) {
                            case DIST_SET_MODE_PWR:  
                                {
                                    heater_power += 4; 
                                    if (heater_power > 100){
                                        heater_power = 100;
                                    }
                                    break;
                                }
                            
                            case DIST_SET_MODE_FLOW:  
                                {
                                    if (Votb < 2000.0) {
                                        Votb += 90;
                                    }
                                    CalculateDistBodySpeed();
                                    break;
                                }
                                
                        }
                        break;
        
        case CALIBRATE_MOD:                 // вводим реальное значение объема
                        nlcd_Clear();
                        ParamDec();
                        Param10Inc();
                        break; 
    }
      
}

void HandlerEventButLDown(void){ 
   switch (mode) {
                            
       case SETTINGS:    
                         nlcd_Clear();
                         ParamInc();
                         Param10Dec();
                         break;
       
       case RUN_RECT_SET:
                         nlcd_Clear();
                         ParamInc();
                         Param10Dec();
                         break;
       case RUN_RECT:
                        if (!startStop) {
                            VALVE_CLS;
                        } 
                        pwmOn = 0;
                        break;
       case RUN_DIST:
                        
                        switch(distSettingMode) {
                            case DIST_SET_MODE_PWR:  
                                {
                                    heater_power -= 4; 
                                    if (heater_power < 5){
                                        heater_power = 1;
                                    }
                                    break;
                                }
                            
                            case DIST_SET_MODE_FLOW:  
                                {
                                    if (Votb >= 100.0) {
                                        Votb -= 90;
                                    }
                                    CalculateDistBodySpeed();
                                    break;
                                }
                                
                        }
                        break;
       
       case CALIBRATE_MOD:                 // вводим реальное значение объема
                        nlcd_Clear();
                        ParamInc();
                        Param10Dec();
                        break;
    }  
}
