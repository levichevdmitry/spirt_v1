#ifndef _MENU_H_
#define _MENU_H_

//��������� ��������� ����� ����
typedef struct _selection
{
  flash unsigned char *name_item; // ��������� �� �������� ������    (mas)
  void (*function)(void); //��������� �� ������� ������������� �� ������� �� enter/escape
  unsigned char ent_f; //���� ����� 8 ��� - ������ ID ���� � ������� ���� �����
  unsigned char esc_f; //���� ������ 8 ��� - ������ ID ���� � ������� ���� ���������
  unsigned char parent;
}SELECTION;

//��������� ��������� ����/�������
typedef struct _menu {
  unsigned char id; //����� ����/�������
  unsigned char num_selections; //���������� ������� ������� ����/�������
  SELECTION *items_submenu; //��������� �� ������ ������� ������� ����/�������    (m)
} _MENU;

//������ ����/�������
enum __menu__id {
  MAIN_MENU,   // ������� ����
  MENU_DIST,   // ����������
  MENU_RECT,   // ������������
  MENU_SET,    // ���������
  MENU_INIT    // ������������� �������� 
};         


void print_menu();
void goto_menu();

extern  _MENU menu[];
extern char cod; 
extern char current_menu; //���������� ��������� �� ������� ����
extern char current_pos; //���������� ��������� �� ������� ����� ����/�������
extern char last_menu; 
extern char last_pos;

#endif
