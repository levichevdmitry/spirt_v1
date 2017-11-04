#ifndef _CERCLEBUFER_H_
#define _CERCLEBUFER_H_

#define SIZE_BUF 32       //вместимость буфера/очереди событий

unsigned char ES_GetCount(void);  //взять число событий в буфере/очереди
void ES_FlushBuf(void);            //очистить буфер
unsigned char ES_GetEvent(void);   //взять код собыитя  
void ES_PlaceEvent(unsigned char event);   //разместить событие
void ES_PlaceHeadEvent(unsigned char event);   //разместить событие в начало очереди
void ES_Dispatch(unsigned char event);     //вызов диспетчера


#endif
