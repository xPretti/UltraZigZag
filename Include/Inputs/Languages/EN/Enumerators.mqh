#include "../../../Sources/Enumerators/DatetimeEnum.mqh"

/**
 * Enumerators
 */
enum ENUM_BOOL_TYPE
{
  BOOL_TYPE_FALSE = 0, //[0] No
  BOOL_TYPE_TRUE  = 1, //[1] Yes
};

/**
 * Templates Enumerators
 */
enum ENUM_TIME_TYPE_TEMPLATE
{
  TIME_TYPE_TEMPLATE_DAY   = TIME_TYPE_DAY,   //[00] Diary
  TIME_TYPE_TEMPLATE_WEEK  = TIME_TYPE_WEEK,  //[01] Weekly
  TIME_TYPE_TEMPLATE_MONTH = TIME_TYPE_MONTH, //[02] Monthly
  TIME_TYPE_TEMPLATE_YEAR  = TIME_TYPE_YEAR,  //[03] Annual
  TIME_TYPE_TEMPLATE_ALL   = TIME_TYPE_ALL    //[04] Everything
};