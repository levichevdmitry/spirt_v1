#ifndef _CERCLEBUFER_H_
#define _CERCLEBUFER_H_

#define SIZE_BUF 32       //����������� ������/������� �������

unsigned char ES_GetCount(void);  //����� ����� ������� � ������/�������
void ES_FlushBuf(void);            //�������� �����
unsigned char ES_GetEvent(void);   //����� ��� �������  
void ES_PlaceEvent(unsigned char event);   //���������� �������
void ES_PlaceHeadEvent(unsigned char event);   //���������� ������� � ������ �������
void ES_Dispatch(unsigned char event);     //����� ����������


#endif
