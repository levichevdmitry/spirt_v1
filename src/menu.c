#include <menu.h>
#include <handlers.h>
#include <stdio.h>
#include <delay.h>
#include <string.h>
#include <nokia1100_lcd_lib.h>
#include <settings.h>

char cod; 
char current_menu=0; //Переменная указывает на текущее меню
char current_pos=0; //Переменная указывает на текущий пункт меню/подменю 

char last_menu; 
char last_pos;  

//Имена пунктов
flash unsigned char distilation[] =       {"Дистиляция"};
flash unsigned char rectification[] =     {"Ректификация"};
flash unsigned char settings[] =          {"Параметры"};

// Настройки
flash unsigned char set_dist[] =          {"Дистиляции"};
flash unsigned char set_rectif[] =        {"Ректификации"};
flash unsigned char set_temp_sensors[] =  {"Датчиков темп"};
flash unsigned char set_calibrate_vlv[] = {"Калибровка кл."};

// Настройки -> Дистиляции
flash unsigned char set_dis_t[] =         {"t куба откл."};
flash unsigned char set_dis_pten[] =      {"Ртэн начальная"};

// Настройки -> Ректификация
flash unsigned char set_rect_pten_min[] =   {"Ртэн мин t>60"};
flash unsigned char set_rect_Pkol_max[] =   {"P колоны макс"};
flash unsigned char set_rect_t_otbor[] =    {"t отбора"};
flash unsigned char set_rect_dt_otbor[] =   {"dt отбора"};
flash unsigned char set_rect_T1_valve[] =   {"T1 зад. клап."};
flash unsigned char set_rect_T2_valve[] =   {"T2 зад. клап."};
flash unsigned char set_rect_t_kuba_v[] =   {"t куба зад. кл"};    
flash unsigned char set_rect_t_kuba_off[] = {"t куба откл."};
flash unsigned char set_rect_head_val[] =   {"Объем голов"};
flash unsigned char set_rect_body_spd[] =   {"Скорость отб."};
flash unsigned char set_rect_pulse_d[] =    {"Длит. импульса"};
flash unsigned char set_rect_fact_q[] =     {"Факт объем отб"};
flash unsigned char set_rect_k_factor[] =   {"Коэфф. расхода"};

// Настройки -> Датчики температуры
flash unsigned char set_sens_tkub[] =          {"Т куба"};
flash unsigned char set_sens_tkolona_down[] =  {"Т колоны низ"};
flash unsigned char set_sens_tkolona_up[] =    {"Т колоны верх"};

//===========================================================================

//Массив хранящий пункты главного меню (структура SELECTION)
static SELECTION menu_[]= {
  {distilation, RunDistilation, 0, MAIN_MENU, 0}, // Дистиляция
  {rectification, RunRectification, 0, MAIN_MENU, 0}, // Ректификация
  {settings, goto_menu, MENU_SET, MAIN_MENU, 0} // Настройки  
};

//Массив хранящий пункты меню Настройки (структура SELECTION)
static SELECTION menu_settings[]={
  {set_dist, goto_menu, MENU_DIST, MAIN_MENU, 2}, //Настройки дистиляции
  {set_rectif, goto_menu, MENU_RECT, MAIN_MENU, 2}, //Настройки ректификации
  {set_temp_sensors, goto_menu, MENU_INIT, MAIN_MENU, 2}, //Настройки датчиков
  {set_calibrate_vlv, CalibrateValve, 0, MAIN_MENU, 2} //Калибровка клапана
};                     

//Массив хранящий пункты меню Настройки-> Дистиляции (структура SELECTION)
static SELECTION menu_set_dist[]={
  {set_dis_t, SetParam, 0, MENU_SET, 0}, //t куба откл.
  {set_dis_pten, SetParam, 0, MENU_SET, 0} //Ртэн начальная
};        

//Массив хранящий пункты меню Настройки->Ректификации (структура SELECTION)
static SELECTION menu_set_rect[]={
  {set_rect_pten_min, SetParam, 0, MENU_SET, 1},  //Ртэн мин t>60
  {set_rect_Pkol_max, SetParam, 0, MENU_SET, 1},  //P колоны макс
  {set_rect_t_otbor, SetParam, 0, MENU_SET, 1},   //t отбора 
  {set_rect_dt_otbor, SetParam, 0, MENU_SET, 1},  //dt отбора
  {set_rect_T1_valve, SetParam, 0, MENU_SET, 1},  //T1 зад. клап.
  {set_rect_T2_valve, SetParam, 0, MENU_SET, 1},  //T2 зад. клап.
  {set_rect_t_kuba_v, SetParam, 0, MENU_SET, 1},  //t куба зад. кл
  {set_rect_t_kuba_off, SetParam, 0, MENU_SET, 1},//t куба откл.
  {set_rect_head_val, SetParam, 0, MENU_SET, 1},  //Объем голов
  {set_rect_body_spd, SetParam, 0, MENU_SET, 1},  //Скорость отбора
  {set_rect_pulse_d, SetParam, 0, MENU_SET, 1},   //Длит. импульса  
  {set_rect_fact_q, SetParam, 0, MENU_SET, 1},    //Фактически отобранный объем
  {set_rect_k_factor, SetParam, 0, MENU_SET, 1}   //Коэффициент расхода клапана (k) 
}; 

//Массив хранящий пункты меню Настройки->Датчиков (структура SELECTION)
static SELECTION menu_set_init[]={
  {set_sens_tkub, InitSensors, 0, MENU_SET, 2},         //Т куба
  {set_sens_tkolona_down, InitSensors, 0, MENU_SET, 2}, //Т колоны низ
  {set_sens_tkolona_up, InitSensors, 0, MENU_SET, 2}    //Т колоны верх
}; 


//Главный массив хранит в себе все меню/подменю
//Все меню/подменю должны описываться в таком же порядке как и в   enum __menu__id ...
static _MENU menu[] = {
  {MAIN_MENU, 3, menu_}, //Меню 
  {MENU_DIST, 2, menu_set_dist}, //Дистиляция  
  {MENU_RECT, 13, menu_set_rect}, // Ректификация 
  {MENU_SET,  4, menu_settings}, //Настройки
  {MENU_INIT, 3, menu_set_init} // Датчики
};
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void goto_menu() {
  switch (cod) {
    case 'e': {current_menu=menu[current_menu].items_submenu[current_pos].ent_f; break;};//enter
    case 'b': {current_menu=menu[current_menu].items_submenu[current_pos].esc_f; break;};//escape
  }
  nlcd_Clear();
  current_pos = 0;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void print_menu()
{
unsigned char tmp[17]; 
signed char i, s, f, t, c;
    if (current_menu != 0){
        strcpyf(tmp, menu[0].items_submenu[menu[current_menu].items_submenu[current_pos].parent].name_item);
        sprintf(buf,"-%s-", tmp);
        nlcd_GotoXY(7 - strlen(buf)/2, 1);
        nlcd_Print(buf);        
    } else {
        sprintf(buf,"-=Меню=-");     
        nlcd_GotoXY(3, 1);
        nlcd_Print(buf);
    }
    c = 5;
    t = 2; 
    if (menu[current_menu].num_selections > c) {
        if (current_pos - (c - (signed char)1) > 0){
         s = current_pos - (c - (signed char)1);
         f = current_pos + 1;
        } else {
         s = 0;
         f = c;
        }      
    } else {
       f = menu[current_menu].num_selections;
       s = 0;
    } 
    for (i = s; i < f; i++) {
        if (i == current_pos) {
            strcpyf(tmp, menu[current_menu].items_submenu[i].name_item);
            sprintf(buf,"[%s]", tmp);
            nlcd_GotoXY(0, t++);
        } else {
            strcpyf(tmp, menu[current_menu].items_submenu[i].name_item);
            sprintf(buf,"%s", tmp);
            nlcd_GotoXY(1, t++); 
        } 
        nlcd_Print(buf);        
    }
    cod='k';
}
