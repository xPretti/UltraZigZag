//+------------------------------------------------------------------+
//|                                                    NewCandle.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+

#ifndef NEWCANDLE_INCLUDED
#define NEWCANDLE_INCLUDED

#include "Base/CheckTimer.mqh"

// clang-format off
class CNewCandle : public CCheckTimer
{
  private:
    // Variables
    datetime _saveValue;
    
  public:
    CNewCandle(string symbol="", ENUM_TIMEFRAMES timeFrame=0);
    ~CNewCandle();

    // Methods
    bool IsOverpass() override;
};
// clang-format on

/**
 * Contrutores e Destrutores
 */
CNewCandle::CNewCandle(string symbol = "", ENUM_TIMEFRAMES timeFrame = 0)
{
  SetSymbol(symbol == "" ? Symbol() : symbol);
  SetTimeFrame(timeFrame);
}
CNewCandle::~CNewCandle()
{
}

/**
 * Verificações
 */
bool CNewCandle::IsOverpass()
{
  datetime lastDate = CTime::GetLastCandleTime(GetSymbol(), GetTimeFrame());
  if(_saveValue == 0)
    {
      _saveValue = lastDate;
      return (false);
    }
  if(_saveValue != lastDate)
    {
      _saveValue = lastDate;
      return (true);
    }
  return (false);
}

#endif /* NEWCANDLE_INCLUDED */
