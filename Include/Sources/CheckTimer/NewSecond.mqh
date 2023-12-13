//+------------------------------------------------------------------+
//|                                                    NewSecond.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+


#ifndef NEWSECOND_INCLUDED
#define NEWSECOND_INCLUDED

#include "Base/CheckTimer.mqh"

// clang-format off
class CNewSecond : public CCheckTimer
{
  private:
    // Variables
    ulong _saveValue;
    uint _msDelay;
    
    // Propertie
    uint _delay;

  public:
    CNewSecond(uint delay=1);
    ~CNewSecond();

    // Methods
    bool IsOverpass() override;
    
    // Properties
    //- GET
    uint GetDelay() { return(_delay); };
    uint GetDelayMS() { return(_msDelay); };
    
    //- SET
    void SetDelay(uint delay) { _delay = delay; _msDelay = 1000*(int)delay; };
};
// clang-format on

/**
 * Contrutores e Destrutores
 */
CNewSecond::CNewSecond(uint delay = 1)
{
  SetDelay(delay);
}
CNewSecond::~CNewSecond()
{
}

/**
 * Verificações
 */
bool CNewSecond::IsOverpass()
{
  return (IsTickExceed64(_saveValue, GetDelayMS()));
}


#endif /* NEWSECOND_INCLUDED */

