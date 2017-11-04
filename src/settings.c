#include <settings.h>
#include <handlers.h>
#include <menu.h>
#include <nokia1100_lcd_lib.h>
#include <stdio.h>
#include <string.h>
#include <general.h>
#include <hwinit.h>

#include <OWIPolled.h>
#include <OWIHighLevelFunctions.h>
#include <OWIBitFunctions.h>
#include <OWIcrc.h>

extern OWI_device ds1820_rom_codes[MAX_DS1820];
extern OWI_device t_rom_codes[MAX_DS1820];

flash unsigned char set_on[] = {"Вкл."};
flash unsigned char set_off[] ={"Выкл."};

flash unsigned char label_grad[] =    {"С"};
flash unsigned char label_min[] =     {"мин"};
flash unsigned char label_mmhb[] =    {"мм.рт.ст"};
flash unsigned char label_percent[] = {"%"};
flash unsigned char label_ml[] =      {"мл."};
flash unsigned char label_mlph[] =    {"мл./ч"};
flash unsigned char label_ms[] =      {"*10 мс"};


flash unsigned char * flash yesno[] = {set_off, set_on};
flash unsigned char * flash labels[] = {label_min, label_grad, label_mmhb, label_percent, label_ml, label_mlph, label_ms};

unsigned char param_id;

float dis_t_kuba;
unsigned int dis_p_ten;
unsigned int rect_p_ten_min;
unsigned int rect_p_kol_max;
float rect_t_otbora;
float rect_dt_otbora;
unsigned int rect_T1_valve;
unsigned int rect_T2_valve;
float rect_t_kuba_valve;
float rect_t_kuba_off;
unsigned int rect_head_val;
unsigned int rect_body_speed;
unsigned char rect_pulse_delay;
float onePulseDose;
unsigned int factCalibrateQ;

PARAM params[SET_COUNT];

eeprom PARAM params_eeprom[SET_COUNT] = {
//v     |min    |max    |lab    |type
{9800,  0,      11000,  1,      PT_FLOAT}, // Дистиляция -> t куба откл.
{80,    0,      100,    3,      PT_DIGIT}, // Дистиляция -> Ртэн средняя 
{70,    0,      100,    3,      PT_DIGIT}, // Ректификация -> Ртэн мин t>=60C
{20,    0,      100,    2,      PT_DIGIT}, // Ректификация -> Рколоны макс
{7880,  0,      11000,  1,      PT_FLOAT}, // Ректификация -> t отбора
{45,    0,      1500,   1,      PT_FLOAT}, // Ректификация -> dt отбора
{1,     0,      5,      0,      PT_DIGIT}, // Ректификация -> T1 задержки клапана
{2,     0,      5,      0,      PT_DIGIT}, // Ректификация -> T2 задержки клапана
{9200,  0,      11000,  1,      PT_FLOAT}, // Ректификация -> t куба задержки
{9800,  0,      11000,  1,      PT_FLOAT}, // Ректификация -> t куба откл.
{100,   10,     1500,   4,      PT_DIGIT}, // Ректификация -> Объем голов
{2100,  10,     3000,   5,      PT_DIGIT}, // Ректификация -> Скорость отбора
{4,     1,      10,     6,      PT_DIGIT}, // Ректификация -> Длительность импульса
{50,    1,      500,    4,      PT_DIGIT}, // Ректификация -> Отобранный объем
{HEADDOZA,   1,      900,    4,      PT_DOUBLE}  // Ректификация -> Коэффициент расхода клапана
};

eeprom OWI_device t_sens_eeprom_code[MAX_DS1820];

//eeprom float onePulseDose_eeprom = HEADDOZA; 


void ParamInc() { 
    if (++params[param_id].value > params[param_id].max_value) {
        params[param_id].value = params[param_id].min_value;
    }   
}

void ParamDec() {
    if (params[param_id].value > params[param_id].min_value) {
        params[param_id].value--;
    } else {
        params[param_id].value = params[param_id].max_value;
    }    
}


void Param10Inc() {
    params[param_id].value += 100; 
    if (params[param_id].value > params[param_id].max_value) {
        params[param_id].value = params[param_id].min_value;
    }   
}

void Param10Dec() {
    if (params[param_id].value > (params[param_id].min_value + 100)) {
        params[param_id].value -= 100;
    } else {
        params[param_id].value = params[param_id].max_value;
    }    
}

void SetParam(void){
    char i;
    mode = SETTINGS;
    nlcd_Clear();
    param_id = 0;
    for (i = 1; i < current_menu; i++) {
        param_id += menu[i].num_selections;
    }
    param_id += current_pos;
};


void ViewSettings(){
    unsigned char tmp[17]; 
    strcpyf(tmp, menu[0].items_submenu[menu[current_menu].items_submenu[current_pos].parent].name_item);
    sprintf(buf,"-%s-", tmp);
    nlcd_GotoXY(8 - strlen(buf)/2, 1);
    nlcd_Print(buf);
    strcpyf(tmp, menu[current_menu].items_submenu[current_pos].name_item);     
    sprintf(buf,"*%s*", tmp);
    nlcd_GotoXY(8 - strlen(buf)/2, 2);
    nlcd_Print(buf);
        
    if (params[param_id].type == PT_DOUBLE){  // for k-factor
        strcpyf(tmp, labels[params[param_id].units]);
        sprintf(buf,"%1.4f %s", params[param_id].value / 10000.0, tmp);
    } else
    if (params[param_id].type == PT_FLOAT){  // for tempreture
        strcpyf(tmp, labels[params[param_id].units]);
        sprintf(buf,"%3.2f %s", params[param_id].value / 100.0, tmp);
    } else
    if (params[param_id].type == PT_DIGIT) {
        strcpyf(tmp, labels[params[param_id].units]);
        sprintf(buf,"%u %s", params[param_id].value, tmp);
    } else 
        if(params[param_id].type == PT_YESNO) {
            strcpyf(tmp, yesno[params[param_id].value]);
            sprintf(buf,"<%s>", tmp);
    }
    nlcd_GotoXY(7 - strlen(buf)/2, 4);
    nlcd_Print(buf);
};

void SetNewParams(){
    unsigned char j,k;
    dis_t_kuba = params[0].value / 100.0;
    dis_p_ten = params[1].value;
    rect_p_ten_min = params[2].value;
    rect_p_kol_max = params[3].value;
    rect_t_otbora = params[4].value / 100.0;
    rect_dt_otbora = params[5].value / 100.0;
    rect_T1_valve = params[6].value;
    rect_T2_valve = params[7].value;
    rect_t_kuba_valve = params[8].value / 100.0;
    rect_t_kuba_off = params[9].value / 100.0;
    rect_head_val = params[10].value;
    rect_body_speed = params[11].value;
    rect_pulse_delay = params[12].value;
    factCalibrateQ =  params[13].value;
    onePulseDose = (float)params[14].value / 10000.0;
    //onePulseDose = onePulseDose_eeprom;
    
    for (j=0; j<MAX_DS1820; j++){
        for (k=0; k<8; k++){
            t_rom_codes[j].id[k] = t_sens_eeprom_code[j].id[k];
        }
    }     
};

void LoadParam(){
   unsigned char j;
   for (j=0; j<SET_COUNT; j++) {
        params[j]= params_eeprom[j];
   }
   //onePulseDose = onePulseDose_eeprom;
   onePulseDose = params[14].value / 10000.0;
}

void SaveParam(){
    unsigned char j;
    
    params[14].value = (unsigned int) (onePulseDose * 10000.0);
    
    for (j=0; j<SET_COUNT; j++) {
        params_eeprom[j].value = params[j].value;
    } 
    //onePulseDose_eeprom = onePulseDose;
}

void InitSensors(){
    char tmp[17];
    mode = INIT;
    nlcd_Clear();
    nlcd_GotoXY(1,0);
    nlcd_PrintF("Инициализация");
    strcpyf(tmp, menu[current_menu].items_submenu[current_pos].name_item);
    sprintf(buf,"%s", tmp);
    nlcd_GotoXY(8 - strlen(buf)/2, 1);
    nlcd_Print(buf);
    nlcd_GotoXY(0,2);
    nlcd_PrintF("Подключите один");
    nlcd_GotoXY(3,3);
    nlcd_PrintF("датчик !!!");
    nlcd_GotoXY(2,4);
    nlcd_PrintF("нажмите <ENT>");
    //sprintf(buf,"ID:%X", t_sens_eeprom_code[current_pos].id[7]);  
    sprintf(buf,"ID:%2X%2X",t_rom_codes[current_pos].id[6], t_rom_codes[current_pos].id[7] );
    nlcd_GotoXY(8 - strlen(buf)/2, 5);
    nlcd_Print(buf);
};

void SetSensors(){
    char k;
    nlcd_Clear();
    // OWI_SearchDevices(ds1820_rom_codes, MAX_DS1820, BUS, &ds1820_devices);
    if (OWI_SearchDevices(ds1820_rom_codes, MAX_DS1820, BUS, &ds1820_devices) == SEARCH_SUCCESSFUL) {
         
    //}
    //if (ds1820_devices == 1) {
        for (k=0; k<9; k++){
            t_sens_eeprom_code[current_pos].id[k] = ds1820_rom_codes[0].id[k];
        }
        SetNewParams();
        nlcd_GotoXY(0,2);
        nlcd_PrintF(" Инициализация ");
        nlcd_GotoXY(3,3);
        nlcd_PrintF(" прошла");
        nlcd_GotoXY(2,4);
        nlcd_PrintF(" успешно!");
        SetNewParams();
        delay_ms(2000);
        mode = MENU;
    } else {
        nlcd_GotoXY(0,2);
        nlcd_PrintF(" Инициализация ");
        nlcd_GotoXY(0,3);
        nlcd_PrintF(" не прошла. Для");
        nlcd_GotoXY(0,4);
        nlcd_PrintF("повтора нажмите");
        nlcd_GotoXY(0,5);
        nlcd_PrintF("<ENT>. <ESC>");
        nlcd_GotoXY(0,6);
        nlcd_PrintF("для выхода.");
    }
}
  

void CalibrateValve() {
    mode = CALIBRATE;
    nlcd_Clear();
    nlcd_GotoXY(0,1);
    nlcd_PrintF("   Калибровка   ");
    nlcd_PrintF(" дозир. клапана ");
    nlcd_PrintF("  Отбор 50 мл.  ");
    nlcd_PrintF("   Для начала   ");
    nlcd_PrintF(" нажмите <ENT>  ");
}