#ifndef _MENU_H_
#define _MENU_H_

//Структура описывает пункт меню
typedef struct _selection
{
  flash unsigned char *name_item; // Указатель на название пункта    (mas)
  void (*function)(void); //Указатель на функцию выполняющуюся по нажатии на enter/escape
  unsigned char ent_f; //Флаг входа 8 бит - обычно ID меню в которое надо войти
  unsigned char esc_f; //Флаг выхода 8 бит - обычно ID меню в которое надо вернуться
  unsigned char parent;
}SELECTION;

//Структура описывает меню/подменю
typedef struct _menu {
  unsigned char id; //Номер меню/подменю
  unsigned char num_selections; //Количество пунктов данного меню/подменю
  SELECTION *items_submenu; //Указатель на массив пунктов данного меню/подменю    (m)
} _MENU;

//Номера меню/подменю
enum __menu__id {
  MAIN_MENU,   // Главное меню
  MENU_DIST,   // Дистиляция
  MENU_RECT,   // Ректификация
  MENU_SET,    // Настройки
  MENU_INIT    // Инициализация датчиков 
};         


void print_menu();
void goto_menu();

extern  _MENU menu[];
extern char cod; 
extern char current_menu; //Переменная указывает на текущее меню
extern char current_pos; //Переменная указывает на текущий пункт меню/подменю
extern char last_menu; 
extern char last_pos;

#endif
