
#include <circlebuffer.h>
#include <handlers.h>

//��������� �����
static volatile unsigned char cycleBuf[SIZE_BUF];
static unsigned char tailBuf = 0;
static unsigned char headBuf = 0;
static volatile unsigned char countBuf = 0;


//���������� ����������� ������� ����������� � ������
unsigned char ES_GetCount(void)
{
  return countBuf;  
}

//"�������" �����
void ES_FlushBuf(void)
{
  tailBuf = 0;
  headBuf = 0;
  countBuf = 0;
}

//����� �������
unsigned char ES_GetEvent(void)
{
  unsigned char event;
  if (countBuf > 0){                    //���� �������� ����� �� ������  
    event = cycleBuf[headBuf];          //������� �� ���� �������    
    countBuf--;                         //��������� ������� 
    headBuf++;                          //���������������� ������ ������ ������  
    if (headBuf == SIZE_BUF) headBuf = 0;
    return event;                         //������� �������
  }
  return 0;
}

//�������� �������
void ES_PlaceEvent(unsigned char event) 
{
  if (countBuf < SIZE_BUF){                    //���� � ������ ��� ���� �����                     
      cycleBuf[tailBuf] = event;               //������ ������� � �����
      tailBuf++;                               //��������� ������ ������ ������ 
      if (tailBuf == SIZE_BUF) tailBuf = 0;  
      countBuf++;                              //��������� ������� 
  }
} 

void ES_PlaceHeadEvent(unsigned char event)
{
  if (countBuf < SIZE_BUF){                    //���� � ������ ��� ���� �����                     
      if (headBuf == 0){
        headBuf = SIZE_BUF - 1;
      }else {
        headBuf --;
      }
      cycleBuf[headBuf] = event;               //������ ������� � ������ ������ 
      countBuf++;                              //��������� ������� 
  }
}

//������ ���������� �� �������-�����������
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