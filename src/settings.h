#ifndef _SETTINGS_H_
#define _SETTINGS_H_

typedef enum _param_type 
{
    PT_YESNO,
    PT_DIGIT,
    PT_FLOAT,
    PT_DOUBLE
} PARAM_TYPE;

typedef struct _param
{
  unsigned int value;       // Значение пераметра 
  unsigned int min_value;   // Минимальное значение
  unsigned int max_value;   // Максимальное значение
  unsigned int units;       // Единицы измерения
  PARAM_TYPE type;          // Тип параметра
} PARAM;

#define SET_COUNT       15 // 14

extern unsigned char param_id;
extern eeprom PARAM params_eeprom[SET_COUNT];
extern PARAM params[SET_COUNT];
extern flash unsigned char * flash yesno[];
extern flash unsigned char * flash labels[];
// 0 - t куба
// 1 - t колоны низ
// 2 - t колоны верх
//--------------------------------------------------------------

void ParamInc();
void ParamDec();
void SetParam();

void Param10Inc();
void Param10Dec();

void ViewSettings();
void SetNewParams();
void LoadParam();
void SaveParam();
void InitSensors();
void SetSensors();
void CalibrateValve();

#endif
