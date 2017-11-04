
#include <circlebuffer.h>
#include <handlers.h>

//кольцевой буфер
static volatile unsigned char cycleBuf[SIZE_BUF];
static unsigned char tailBuf = 0;
static unsigned char headBuf = 0;
static volatile unsigned char countBuf = 0;


//возвращает колличество событий находящихся в буфере
unsigned char ES_GetCount(void)
{
  return countBuf;  
}

//"очищает" буфер
void ES_FlushBuf(void)
{
  tailBuf = 0;
  headBuf = 0;
  countBuf = 0;
}

//взять событие
unsigned char ES_GetEvent(void)
{
  unsigned char event;
  if (countBuf > 0){                    //если приемный буфер не пустой  
    event = cycleBuf[headBuf];          //считать из него событие    
    countBuf--;                         //уменьшить счетчик 
    headBuf++;                          //инкрементировать индекс головы буфера  
    if (headBuf == SIZE_BUF) headBuf = 0;
    return event;                         //вернуть событие
  }
  return 0;
}

//положить событие
void ES_PlaceEvent(unsigned char event) 
{
  if (countBuf < SIZE_BUF){                    //если в буфере еще есть место                     
      cycleBuf[tailBuf] = event;               //кинуть событие в буфер
      tailBuf++;                               //увеличить индекс хвоста буфера 
      if (tailBuf == SIZE_BUF) tailBuf = 0;  
      countBuf++;                              //увеличить счетчик 
  }
} 

void ES_PlaceHeadEvent(unsigned char event)
{
  if (countBuf < SIZE_BUF){                    //если в буфере еще есть место                     
      if (headBuf == 0){
        headBuf = SIZE_BUF - 1;
      }else {
        headBuf --;
      }
      cycleBuf[headBuf] = event;               //кинуть событие в начало буфера 
      countBuf++;                              //увеличить счетчик 
  }
}

//массив указателей на функции-обработчики
void (*FuncAr[])(void) = 
{
  HandlerEventButUp,  
  HandlerEventButDown,
  HandlerEventButEnter,
  HandlerEventButEsc,
  HandlerEventTimer_1s,
  HandlerEventTimer_250ms,
  HandlerEventTimer_10ms,
  HandlerEventButLUp,
  HandlerEventButLDown,
  HandlerEventTimer_10s,
  HandlerEventTimer_1Hz
};

//++++++++++++++++++++++++++++++++++++++++++
void ES_Dispatch(unsigned char event)
{
  void (*pFunc)(void);
  pFunc = FuncAr[event-1];
  pFunc();
}