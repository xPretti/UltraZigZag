//+------------------------------------------------------------------+
//|                                                         Time.mqh |
//|                                        Copyright 2023, Upcoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+

#ifndef TIME_INCLUDED
#define TIME_INCLUDED

#include "../Enumerators/DatetimeEnum.mqh"

class CTime
{
  private:
    static MqlTick _candleTicks;
    static MqlRates _candleRates[];

  private:
    static datetime _startTime;

  public:
    CTime();
    ~CTime();

    // Methods
    //- GET
    static bool GetTimeHasChanged(datetime time1, datetime time2);
    static datetime GetRoundTime(datetime time, ENUM_TIMEFRAMES timeFrame=PERIOD_CURRENT);
    static datetime GetSymbolTime(string symbol);
    static datetime GetLastCandleTime(string symbol, ENUM_TIMEFRAMES timeFrame);
    static int GetDayOfWeek(string symbol);
    static int GetMonth(string symbol);
    static int GetYear(string symbol);
    static datetime GetStartTime(string symbol, ENUM_TIME_TYPE type);
    static datetime GetDayTime(string symbol);
    static datetime GetWeekTime(string symbol);
    static datetime GetMonthTime(string symbol);
    static datetime GetYearTime(string symbol);
    static bool GetSelectTimes(string symbol, ENUM_TIME_TYPE type, datetime& getStartTime, datetime& getEndTime);
    static bool GetSelectTimes(string symbol, ENUM_TIME_TYPE startType, ENUM_TIME_TYPE endType, datetime& getStartTime, datetime& getEndTime);
    static bool IsValidDay(datetime dayTime, string symbol);
    static datetime GetStartTime(int day, string symbol);
    static datetime GetValidStartTime(int day, string symbol);
    static datetime GetValidEndTime(int day, string symbol);
    static int GetValidStartCandle(int day, string symbol);
    static int GetValidEndCandle(int day, string symbol);
    static datetime GetTime(string symbol, int c, ENUM_TIMEFRAMES time);
    static bool IsTime(datetime timeRef, int hour, int min, int sec);

    // converts
    static datetime GetChangedDatetime(datetime date, int hour = 0, int min = 0, int sec = 0);
    static datetime GetChangedDatetimeComplex(datetime date, int day = 1, int month = 1, int hour = 0, int min = 0, int sec = 0);
    static datetime GetStringToTime(string txt, datetime dateRef);

  private:
    static bool UseFixer() { return ((datetime)SymbolInfoInteger(Symbol(), SYMBOL_TIME) < _startTime); };
};

/**
 * Declarações estáticas
 */
MqlTick CTime::_candleTicks;
MqlRates CTime::_candleRates[];
datetime CTime::_startTime;

/**
 * Contrutor e destrutor
 */
CTime::CTime()
{
  _startTime = (datetime)SymbolInfoInteger(Symbol(), SYMBOL_TIME) + 1;
}
CTime::~CTime()
{
}

/**
 * Retorna se o dia alterou
 */
bool CTime::GetTimeHasChanged(datetime time1, datetime time2)
{
  return (GetRoundTime(time1) != GetRoundTime(time2));
}

/**
 * Arredonda o horário
 */
datetime CTime::GetRoundTime(datetime time, ENUM_TIMEFRAMES timeFrame=PERIOD_CURRENT)
{
  int periodSeconds = MathMax(PeriodSeconds(timeFrame), 60);
  int seconds = (int)time;
  seconds /= periodSeconds;
  seconds = (int)MathFloor(seconds);
  seconds *= periodSeconds;
  return ((datetime)seconds);
}

/**
 * Retornos de horários
 */
datetime CTime::GetSymbolTime(string symbol)
{
  if(SymbolInfoTick(symbol, _candleTicks))
    {
      return (UseFixer() ? _candleTicks.time + 1 : _candleTicks.time);
    }
  return (0);
}

// Retorna o horário da candle
datetime CTime::GetLastCandleTime(string symbol, ENUM_TIMEFRAMES timeFrame)
{
  return ((datetime)SeriesInfoInteger(symbol, timeFrame, SERIES_LASTBAR_DATE));
}

// Retorna o dia da semana
int CTime::GetDayOfWeek(string symbol)
{
  MqlDateTime date;
  TimeToStruct(GetSymbolTime(symbol), date);
  int value = date.day_of_week;
  return (value);
}
// Retorna o mês
int CTime::GetMonth(string symbol)
{
  MqlDateTime date;
  TimeToStruct(GetSymbolTime(symbol), date);
  int value = date.mon;
  return (value);
}
// Retorna o ano
int CTime::GetYear(string symbol)
{
  MqlDateTime date;
  TimeToStruct(GetSymbolTime(symbol), date);
  int value = date.year;
  return (value);
}

/**
 * Conversores
 */
// Retorna um datetime convertido para ano e dia de hoje porem com horário diferente
datetime CTime::GetChangedDatetime(datetime date, int hour = 0, int min = 0, int sec = 0)
{
  MqlDateTime mqlDateCurrent;
  TimeToStruct(date, mqlDateCurrent);
  mqlDateCurrent.hour = hour;
  mqlDateCurrent.min  = min;
  mqlDateCurrent.sec  = sec;
  datetime newDate    = StructToTime(mqlDateCurrent);
  return (newDate);
}
// Retorna um datetime convertido para ano e dia de hoje porem com horário diferente
datetime CTime::GetChangedDatetimeComplex(datetime date, int day = 1, int month = 1, int hour = 0, int min = 0, int sec = 0)
{
  MqlDateTime mqlDateCurrent;
  TimeToStruct(date, mqlDateCurrent);
  mqlDateCurrent.day  = day;
  mqlDateCurrent.mon  = month;
  mqlDateCurrent.hour = hour;
  mqlDateCurrent.min  = min;
  mqlDateCurrent.sec  = sec;
  datetime newDate    = StructToTime(mqlDateCurrent);
  return (newDate);
}

// Retorna horário "01:25" para datetime
datetime CTime::GetStringToTime(string txt, datetime dateRef)
{
  datetime time = StringToTime(txt);
  MqlDateTime getStruct;
  TimeToStruct(time, getStruct);
  return (GetChangedDatetime(dateRef, getStruct.hour, getStruct.min, getStruct.sec));
}

/**
 * Datas de inicio
 */
datetime CTime::GetStartTime(string symbol, ENUM_TIME_TYPE type)
{
  switch(type)
    {
    case TIME_TYPE_DAY:
      return (GetDayTime(symbol));
    case TIME_TYPE_WEEK:
      return (GetWeekTime(symbol));
    case TIME_TYPE_MONTH:
      return (GetMonthTime(symbol));
    case TIME_TYPE_YEAR:
      return (GetYearTime(symbol));
    default:
      return (0);
    }
}
// inicio do dia
datetime CTime::GetDayTime(string symbol)
{
  datetime timeCurrent = GetSymbolTime(symbol);
  return (GetChangedDatetime(timeCurrent));
}
// inicio da semana
datetime CTime::GetWeekTime(string symbol)
{
  datetime timeCurrent = GetSymbolTime(symbol);
  timeCurrent -= 86400 * (GetDayOfWeek(symbol) - 1);
  return (GetChangedDatetime(timeCurrent));
}
// inicio do mês
datetime CTime::GetMonthTime(string symbol)
{
  datetime timeCurrent = GetSymbolTime(symbol);
  return (GetChangedDatetimeComplex(timeCurrent, 1, GetMonth(symbol)));
}
// inicio do ano
datetime CTime::GetYearTime(string symbol)
{
  datetime timeCurrent = GetSymbolTime(symbol);
  return (GetChangedDatetimeComplex(timeCurrent));
}
// selecionando um periodo
bool CTime::GetSelectTimes(string symbol, ENUM_TIME_TYPE type, datetime& getStartTime, datetime& getEndTime)
{
  getStartTime = GetStartTime(symbol, type);
  getEndTime   = GetSymbolTime(symbol);
  return (getStartTime != 0 && getEndTime != 0);
}
// selecionando um periodo
bool CTime::GetSelectTimes(string symbol, ENUM_TIME_TYPE startType, ENUM_TIME_TYPE endType, datetime& getStartTime, datetime& getEndTime)
{
  getStartTime = GetStartTime(symbol, startType);
  if(startType == TIME_TYPE_YEAR && endType == TIME_TYPE_MONTH)
    {
      if(GetStartTime(symbol, TIME_TYPE_MONTH) > GetStartTime(symbol, TIME_TYPE_WEEK))
        {
          endType = TIME_TYPE_WEEK;
        }
    }
  getEndTime = endType == TIME_TYPE_ALL ? GetSymbolTime(symbol) : GetStartTime(symbol, endType) - 1;
  return (getStartTime < getEndTime);
}
/**
 * Retorna se o dia é válido
 */
bool CTime::IsValidDay(datetime dayTime, string symbol)
{
  int totalCandles = Bars(symbol, PERIOD_CURRENT, GetChangedDatetime(dayTime), GetChangedDatetime(dayTime, 23, 59));
  return (totalCandles > 0);
}
/**
 * Retorna as datas com base no index do dia
 */
datetime CTime::GetStartTime(int day, string symbol)
{
  datetime dayTime = GetDayTime(symbol) - (86400 * day);
  return (dayTime);
}
datetime CTime::GetValidStartTime(int day, string symbol)
{
  datetime dayTime = GetStartTime(day, symbol);
  if(!IsValidDay(dayTime, symbol))
    {
      int decreaseDay = 1;
      do
        {
          dayTime = GetStartTime(day + decreaseDay, symbol);
          decreaseDay++;
        }
      while(!IsValidDay(dayTime, symbol) && decreaseDay < 30);
      if(!IsValidDay(dayTime, symbol))
        {
          dayTime = 0;
        }
    }
  return (dayTime);
}
datetime CTime::GetValidEndTime(int day, string symbol)
{
  int candle = GetValidEndCandle(day, symbol);
  return (GetTime(symbol, candle, PERIOD_CURRENT));
}

/**
 * Outros métodos
 */
int CTime::GetValidStartCandle(int day, string symbol)
{
  datetime validStarTime = GetValidStartTime(day, symbol);
  if(validStarTime > 0)
    {
      int totalCanldes = Bars(symbol, PERIOD_CURRENT, GetChangedDatetime(validStarTime), GetSymbolTime(symbol)) - 1;
      return (totalCanldes);
    }
  return (0);
}
int CTime::GetValidEndCandle(int day, string symbol)
{
  datetime validStarTime = GetValidStartTime(day, symbol);
  if(validStarTime > 0)
    {
      validStarTime    = GetChangedDatetime(validStarTime, 23, 59, 59) + 2;
      int totalCanldes = Bars(symbol, PERIOD_CURRENT, GetChangedDatetime(validStarTime), GetSymbolTime(symbol));
      return (totalCanldes);
    }
  return (0);
}
datetime CTime::GetTime(string symbol, int c, ENUM_TIMEFRAMES time)
{
  if(CopyRates(symbol, time, c, 1, _candleRates) <= 0)
    {
      return (0);
    }
  return (_candleRates[0].time);
}
bool CTime::IsTime(datetime timeRef, int hour, int min, int sec)
{
  MqlDateTime mqlDateCurrent;
  TimeToStruct(timeRef, mqlDateCurrent);
  if(mqlDateCurrent.hour == hour)
    {
      if(mqlDateCurrent.min == min)
        {
          if(mqlDateCurrent.sec == sec)
            {
              return (true);
            }
        }
    }
  return (false);
}

#endif /* TIME_INCLUDED */
