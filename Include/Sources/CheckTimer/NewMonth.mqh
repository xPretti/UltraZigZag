//+------------------------------------------------------------------+
//|                                                     NewMonth.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+


#ifndef NEWMONTH_INCLUDED
#define NEWMONTH_INCLUDED

#include "Base/CheckTimer.mqh"

// clang-format off
class CNewMonth : public CCheckTimer
{
  private:
    // Variables
    int _saveValue;
    
  public:
    CNewMonth(string symbol="");
    ~CNewMonth();

    // Methods
    bool IsOverpass() override;
};
// clang-format on

/**
 * Contrutores e Destrutores
 */
CNewMonth::CNewMonth(string symbol = "")
{
  SetSymbol(symbol == "" ? Symbol() : symbol);
}
CNewMonth::~CNewMonth()
{
}

/**
 * Verificações
 */
bool CNewMonth::IsOverpass()
{
  int lastMonth = CTime::GetMonth(GetSymbol());
  if(_saveValue <= -1)
    {
      _saveValue = lastMonth;
      return (false);
    }
  if(_saveValue != lastMonth)
    {
      _saveValue = lastMonth;
      return (true);
    }
  return (false);
}

#endif /* NEWMONTH_INCLUDED */

