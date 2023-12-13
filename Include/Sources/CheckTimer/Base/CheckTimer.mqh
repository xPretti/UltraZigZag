//+------------------------------------------------------------------+
//|                                                   CheckTimer.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+


#ifndef CHECKTIMER_INCLUDED
#define CHECKTIMER_INCLUDED

#include "../../Returns/Time.mqh"
#include "../../Returns/Count.mqh"

// clang-format off
class CCheckTimer
{
  private:
    // Properties
    string _symbol;
    ENUM_TIMEFRAMES _timeFrame;

  public:
    CCheckTimer();
    ~CCheckTimer();

    // Methods
    virtual bool IsOverpass() { return (false); };

    // Properties
    //- GET
    string GetSymbol() { return (_symbol); };
    ENUM_TIMEFRAMES GetTimeFrame() { return (_timeFrame); };
    
    //- SET
    void SetSymbol(string v) { _symbol = v; };
    void SetTimeFrame(ENUM_TIMEFRAMES v) { _timeFrame = v; };
  
  protected:
    bool IsTickExceed64(ulong& saveTick, ulong delay);
    
};
// clang-format on

/**
 * Contrutores e Destrutores
 */
CCheckTimer::CCheckTimer()
{
  SetSymbol(Symbol());
}
CCheckTimer::~CCheckTimer()
{  
}

/**
 * MÉTODOS DE VERIFICAÇÃO:
 */
// Retorna se lastTick64 ultrapassou a contagem anterior
bool CCheckTimer::IsTickExceed64(ulong& saveTick, ulong delay)
{
  ulong lastTick = CCount::GetTickCount64();
  if(lastTick >= saveTick)
    {
      saveTick = lastTick + delay;
      return (true);
    }
  return (false);
}

#endif /* CHECKTIMER_INCLUDED */

