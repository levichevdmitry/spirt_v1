// This file has been prepared for Doxygen automatic documentation generation.
/*! \file ********************************************************************
*
* Atmel Corporation
*
* \li File:               OWIHighLevelFunctions.h
* \li Compiler:           IAR EWAAVR 3.20a
* \li Support mail:       avr@atmel.com
*
* \li Supported devices:  All AVRs.
*
* \li Application Note:   AVR318 - Dallas 1-Wire(R) master.
*                         
*
* \li Description:        Header file for OWIHighLevelFunctions.c
*
*                         $Revision: 1.7 $
*                         $Date: Thursday, August 19, 2004 14:27:18 UTC $
*
*    Я немного дополнил этот файл. Добавил функцию поиска адресов 1Wire
*    устройств, имеющихся на шине, и функцию поиска конкретного устройства
*    среди обнаруженных. Функции я взял из демонстрационного проекта AVR318
*    и переделал их.
*                                    Pashgan  http://ChipEnable.Ru
*
****************************************************************************/

#ifndef _OWI_ROM_FUNCTIONS_H_
#define _OWI_ROM_FUNCTIONS_H_

#include <string.h> // Used for memcpy.

typedef struct
{
    unsigned char id[8];    //!< The 64 bit identifier.
} OWI_device;


#define SEARCH_SUCCESSFUL     0x00
#define SEARCH_CRC_ERROR      0x01
#define SEARCH_ERROR          0xff
#define AT_FIRST              0xff
#define SET_SETTINGS_SUCCESSFUL     0x00
#define SET_SETTINGS_ERROR    0x10

#define DS18B20_FAMILY_ID                0x28 
#define DS18B20_CONVERT_T                0x44
#define DS18B20_READ_SCRATCHPAD          0xbe
#define DS18B20_WRITE_SCRATCHPAD         0x4e
#define DS18B20_COPY_SCRATCHPAD          0x48
#define DS18B20_RECALL_E                 0xb8
#define DS18B20_READ_POWER_SUPPLY        0xb4

#define DS18B20_9BIT_RES      0x1F
#define DS18B20_10BIT_RES     0x3F
#define DS18B20_11BIT_RES     0x5F
#define DS18B20_12BIT_RES     0x7F

void OWI_SendByte(unsigned char data, unsigned char pin);
unsigned char OWI_ReceiveByte(unsigned char pin);
void OWI_SkipRom(unsigned char pin);
void OWI_ReadRom(unsigned char * romValue, unsigned char pin);
void OWI_MatchRom(unsigned char * romValue, unsigned char pin);
unsigned char OWI_SearchRom(unsigned char * bitPattern, unsigned char lastDeviation, unsigned char pin);
unsigned char OWI_SearchDevices(OWI_device * devices, unsigned char numDevices, unsigned char pin, unsigned char *num);
unsigned char FindFamily(unsigned char familyID, OWI_device * devices, unsigned char numDevices, unsigned char lastNum);
void StartAllConvert_T(unsigned char pin);
float GetTemperatureSkipRom(unsigned char pin);
float GetTemperatureMatchRom(unsigned char * romValue, unsigned char pin);
unsigned char InitSensor(unsigned char * romValue, unsigned char pin, signed char lowAlm, signed char hiAlm, unsigned char resolution);

#endif
