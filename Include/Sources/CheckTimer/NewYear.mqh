//+------------------------------------------------------------------+
//|                                                      NewYear.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+


#ifndef NEWYEAR_INCLUDED
#define NEWYEAR_INCLUDED

#include "Base/CheckTimer.mqh"

// clang-format off
class CNewYear : public CCheckTimer
{
  private:
    // Variables
    int _saveValue;
    
  public:
    CNewYear(string symbol="");
    ~CNewYear();

    // Methods
    bool IsOverpass() override;
};
// clang-format on

/**
 * Contrutores e Destrutores
 */
CNewYear::CNewYear(string symbol = "")
{
  SetSymbol(symbol == "" ? Symbol() : symbol);
}
CNewYear::~CNewYear()
{
}

/**
 * Verificações
 */
bool CNewYear::IsOverpass()
{
  int lastYear = CTime::GetYear(GetSymbol());
  if(_saveValue <= -1)
    {
      _saveValue = lastYear;
      return (false);
    }
  if(_saveValue != lastYear)
    {
      _saveValue = lastYear;
      return (true);
    }
  return (false);
}

#endif /* NEWYEAR_INCLUDED */

