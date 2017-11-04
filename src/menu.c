#include <menu.h>
#include <handlers.h>
#include <stdio.h>
#include <delay.h>
#include <string.h>
#include <nokia1100_lcd_lib.h>
#include <settings.h>

char cod; 
char current_menu=0; //���������� ��������� �� ������� ����
char current_pos=0; //���������� ��������� �� ������� ����� ����/������� 

char last_menu; 
char last_pos;  

//����� �������
flash unsigned char distilation[] =       {"����������"};
flash unsigned char rectification[] =     {"������������"};
flash unsigned char settings[] =          {"���������"};

// ���������
flash unsigned char set_dist[] =          {"����������"};
flash unsigned char set_rectif[] =        {"������������"};
flash unsigned char set_temp_sensors[] =  {"�������� ����"};
flash unsigned char set_calibrate_vlv[] = {"���������� ��."};

// ��������� -> ����������
flash unsigned char set_dis_t[] =         {"t ���� ����."};
flash unsigned char set_dis_pten[] =      {"���� ���������"};

// ��������� -> ������������
flash unsigned char set_rect_pten_min[] =   {"���� ��� t>60"};
flash unsigned char set_rect_Pkol_max[] =   {"P ������ ����"};
flash unsigned char set_rect_t_otbor[] =    {"t ������"};
flash unsigned char set_rect_dt_otbor[] =   {"dt ������"};
flash unsigned char set_rect_T1_valve[] =   {"T1 ���. ����."};
flash unsigned char set_rect_T2_valve[] =   {"T2 ���. ����."};
flash unsigned char set_rect_t_kuba_v[] =   {"t ���� ���. ��"};    
flash unsigned char set_rect_t_kuba_off[] = {"t ���� ����."};
flash unsigned char set_rect_head_val[] =   {"����� �����"};
flash unsigned char set_rect_body_spd[] =   {"�������� ���."};
flash unsigned char set_rect_pulse_d[] =    {"����. ��������"};
flash unsigned char set_rect_fact_q[] =     {"���� ����� ���"};
flash unsigned char set_rect_k_factor[] =   {"�����. �������"};

// ��������� -> ������� �����������
flash unsigned char set_sens_tkub[] =          {"� ����"};
flash unsigned char set_sens_tkolona_down[] =  {"� ������ ���"};
flash unsigned char set_sens_tkolona_up[] =    {"� ������ ����"};

//===========================================================================

//������ �������� ������ �������� ���� (��������� SELECTION)
static SELECTION menu_[]= {
  {distilation, RunDistilation, 0, MAIN_MENU, 0}, // ����������
  {rectification, RunRectification, 0, MAIN_MENU, 0}, // ������������
  {settings, goto_menu, MENU_SET, MAIN_MENU, 0} // ���������  
};

//������ �������� ������ ���� ��������� (��������� SELECTION)
static SELECTION menu_settings[]={
  {set_dist, goto_menu, MENU_DIST, MAIN_MENU, 2}, //��������� ����������
  {set_rectif, goto_menu, MENU_RECT, MAIN_MENU, 2}, //��������� ������������
  {set_temp_sensors, goto_menu, MENU_INIT, MAIN_MENU, 2}, //��������� ��������
  {set_calibrate_vlv, CalibrateValve, 0, MAIN_MENU, 2} //���������� �������
};                     

//������ �������� ������ ���� ���������-> ���������� (��������� SELECTION)
static SELECTION menu_set_dist[]={
  {set_dis_t, SetParam, 0, MENU_SET, 0}, //t ���� ����.
  {set_dis_pten, SetParam, 0, MENU_SET, 0} //���� ���������
};        

//������ �������� ������ ���� ���������->������������ (��������� SELECTION)
static SELECTION menu_set_rect[]={
  {set_rect_pten_min, SetParam, 0, MENU_SET, 1},  //���� ��� t>60
  {set_rect_Pkol_max, SetParam, 0, MENU_SET, 1},  //P ������ ����
  {set_rect_t_otbor, SetParam, 0, MENU_SET, 1},   //t ������ 
  {set_rect_dt_otbor, SetParam, 0, MENU_SET, 1},  //dt ������
  {set_rect_T1_valve, SetParam, 0, MENU_SET, 1},  //T1 ���. ����.
  {set_rect_T2_valve, SetParam, 0, MENU_SET, 1},  //T2 ���. ����.
  {set_rect_t_kuba_v, SetParam, 0, MENU_SET, 1},  //t ���� ���. ��
  {set_rect_t_kuba_off, SetParam, 0, MENU_SET, 1},//t ���� ����.
  {set_rect_head_val, SetParam, 0, MENU_SET, 1},  //����� �����
  {set_rect_body_spd, SetParam, 0, MENU_SET, 1},  //�������� ������
  {set_rect_pulse_d, SetParam, 0, MENU_SET, 1},   //����. ��������  
  {set_rect_fact_q, SetParam, 0, MENU_SET, 1},    //���������� ���������� �����
  {set_rect_k_factor, SetParam, 0, MENU_SET, 1}   //����������� ������� ������� (k) 
}; 

//������ �������� ������ ���� ���������->�������� (��������� SELECTION)
static SELECTION menu_set_init[]={
  {set_sens_tkub, InitSensors, 0, MENU_SET, 2},         //� ����
  {set_sens_tkolona_down, InitSensors, 0, MENU_SET, 2}, //� ������ ���
  {set_sens_tkolona_up, InitSensors, 0, MENU_SET, 2}    //� ������ ����
}; 


//������� ������ ������ � ���� ��� ����/�������
//��� ����/������� ������ ����������� � ����� �� ������� ��� � �   enum __menu__id ...
static _MENU menu[] = {
  {MAIN_MENU, 3, menu_}, //���� 
  {MENU_DIST, 2, menu_set_dist}, //����������  
  {MENU_RECT, 13, menu_set_rect}, // ������������ 
  {MENU_SET,  4, menu_settings}, //���������
  {MENU_INIT, 3, menu_set_init} // �������
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
        sprintf(buf,"-=����=-");     
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
