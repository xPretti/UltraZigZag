//+------------------------------------------------------------------+
//|                                                       NewDay.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+

#ifndef NEWDAY_INCLUDED
#define NEWDAY_INCLUDED

#include "Base/CheckTimer.mqh"

// clang-format off
class CNewDay : public CCheckTimer
{
  private:
    // Variables
    datetime _saveValue;
    
  public:
    CNewDay(string symbol="");
    ~CNewDay();

    // Methods
    bool IsOverpass() override;
};
// clang-format on

/**
 * Contrutores e Destrutores
 */
CNewDay::CNewDay(string symbol = "")
{
  SetSymbol(symbol == "" ? Symbol() : symbol);
}
CNewDay::~CNewDay()
{
}

/**
 * Verificações
 */
bool CNewDay::IsOverpass()
{
  datetime symbolTime = CTime::GetSymbolTime(GetSymbol());
  datetime lastDay    = CTime::GetChangedDatetime(symbolTime);
  if(_saveValue != lastDay)
    {
      _saveValue = lastDay;
      return (true);
    }
  return (false);
}

#endif /* NEWDAY_INCLUDED */
