//+------------------------------------------------------------------+
//|                                                     NewCount.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+

#ifndef NEWCOUNT_INCLUDED
#define NEWCOUNT_INCLUDED

#include "Base/CheckTimer.mqh"

// clang-format off
class CNewCount : public CCheckTimer
{
  private:
    // Variables
    ulong _saveValue;
    
    // Propertie
    uint _ticksToValidate;

  public:
    CNewCount(uint ticksToValidate=0);
    ~CNewCount();

    // Methods
    bool IsOverpass() override;
    
    // Properties
    //- GET
    uint GetTicksToValidate() { return(_ticksToValidate); };
    
    //- SET
    void SetTicksToValidate(uint ticksToValidate) { _ticksToValidate = ticksToValidate; };
};
// clang-format on

/**
 * Contrutores e Destrutores
 */
CNewCount::CNewCount(uint ticksToValidate = 0)
    : _ticksToValidate(0)
{
}
CNewCount::~CNewCount()
{
}

/**
 * Verificações
 */
bool CNewCount::IsOverpass()
{
  _saveValue++;
  if(_saveValue > _ticksToValidate)
    {
      _saveValue = 0;
      return (true);
    }
  return (false);
}

#endif /* NEWCOUNT_INCLUDED */
