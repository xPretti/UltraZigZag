//+------------------------------------------------------------------+
//|                                                      NewMS.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+

#ifndef NEWTICKDELAY_INCLUDED
#define NEWTICKDELAY_INCLUDED

#include "Base/CheckTimer.mqh"

// clang-format off
class CNewMS : public CCheckTimer
{
  private:
    // Variables
    ulong _saveValue;
    
    // Propertie
    uint _delay;

  public:
    CNewMS(uint delay=1);
    ~CNewMS();

    // Methods
    bool IsOverpass() override;
    
    // Properties
    //- GET
    uint GetDelay() { return(_delay); };
    
    //- SET
    void SetDelay(uint delay) { _delay = delay; };
};
// clang-format on

/**
 * Contrutores e Destrutores
 */
CNewMS::CNewMS(uint delay = 1)
    : _delay(delay)
{
}
CNewMS::~CNewMS()
{
}

/**
 * Verificações
 */
bool CNewMS::IsOverpass()
{
  return (IsTickExceed64(_saveValue, GetDelay()));
}

#endif /* NEWTICKDELAY_INCLUDED */
