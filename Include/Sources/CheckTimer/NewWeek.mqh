//+------------------------------------------------------------------+
//|                                                      NewWeek.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+


#ifndef NEWWEEK_INCLUDED
#define NEWWEEK_INCLUDED

#include "Base/CheckTimer.mqh"

// clang-format off
class CNewWeek : public CCheckTimer
{
  private:
    // Variables
    int _saveValue;
    
  public:
    CNewWeek(string symbol="");
    ~CNewWeek();

    // Methods
    bool IsOverpass() override;
};
// clang-format on

/**
 * Contrutores e Destrutores
 */
CNewWeek::CNewWeek(string symbol = "")
{
  SetSymbol(symbol == "" ? Symbol() : symbol);
}
CNewWeek::~CNewWeek()
{
}

/**
 * Verificações
 */
bool CNewWeek::IsOverpass()
{
  int lastWeekDay = CTime::GetDayOfWeek(GetSymbol());
  if(_saveValue <= -1)
    {
      _saveValue = lastWeekDay;
      return (false);
    }
  if(_saveValue != lastWeekDay)
    {
      _saveValue = lastWeekDay;
      if(lastWeekDay == 1)
        {
          return (true);
        }
    }
  return (false);
}

#endif /* NEWWEEK_INCLUDED */

