//Bibliotecas
#include "Enumerators.mqh"
#include "Version.mqh"

/**
 * INPUTS
*/
//------------------------------                                                     
input int inputPeriod = 12;                            //[1] - Period:
input int inputTopBottomTotal = 40;                    //[2] - Total tops and bottoms:
input ENUM_BOOL_TYPE inputEnableTopBottomAverage = 1;  //[3] - Enable average tops and bottoms?
input int inputTopBottomAveragePeriod = 2;             //[4] - Average period:
