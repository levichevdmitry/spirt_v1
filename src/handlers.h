#ifndef _HANDLERS_H_
#define _HANDLERS_H_

//коды событий
#define EVENT_NULL        0
#define KEY_UP            1
#define KEY_DOWN          2
#define KEY_ENTER         3
#define KEY_ESC           4
#define EVENT_TIMER_1S    5
#define EVENT_TIMER_250MS 6
#define EVENT_TIMER_10MS  7
#define KEY_L_UP          8
#define KEY_L_DOWN        9
#define EVENT_TIMER_10S   10
#define EVENT_TIMER_1Hz   11

//коды состояний
#define END_PROC          0
#define MENU              1
#define SETTINGS          2
#define INIT              3
#define RUN_DIST          4
#define RUN_RECT          5
#define RUN_RECT_SET      6
#define CALIBRATE         7
#define CALIBRATE_RUN     8
#define CALIBRATE_MOD     9



#define ALARM_TIMEOUT     120

void HandlerEventButUp(void);
void HandlerEventButDown(void);
void HandlerEventButEsc(void);
void HandlerEventButEnter(void);

void HandlerEventButLUp(void);
void HandlerEventButLDown(void);

void HandlerEventTimer_10s(void);
void HandlerEventTimer_1s(void);
void HandlerEventTimer_1Hz(void);
void HandlerEventTimer_250ms(void);
void HandlerEventTimer_10ms(void);

void RunDistilation();
void RunRectification();
void StopProcess();
void ViewDistilation();

extern char buf[20]; //17
extern unsigned char mode;
extern char abortProcess;
extern char timerOn,startStop;
extern unsigned int timer, timer_off;

#endif
