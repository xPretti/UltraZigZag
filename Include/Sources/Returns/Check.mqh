//+------------------------------------------------------------------+
//|                                                        Check.mqh |
//|                                        Copyright 2023, Upcoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+

#ifndef CHECK_INCLUDED
#define CHECK_INCLUDED

#include "Count.mqh"

class CCheck
{
  private:
    static ulong _downTimeSeconds;

  public:
    CCheck();
    ~CCheck();

    // Methods
    static bool IsIdle();

    // Properties
    //- GET
    static ulong GetDowntime() { return (_downTimeSeconds); };
    
    //- SET (Não estátivas)
    void SetDowntime(ulong seconds) { _downTimeSeconds = seconds; };
};

/**
 * Declarações estáticas
 */
ulong CCheck::_downTimeSeconds = 0;

/**
 * Contrutor e destrutor
 */
CCheck::CCheck()
{
}
CCheck::~CCheck()
{
}

/**
 * Retorna se o robô esta ocioso
 */
bool CCheck::IsIdle()
{
  if(_downTimeSeconds > 0)
    {
      ulong downTime = CCount::GetSecondsIdle();
      return (downTime > _downTimeSeconds);
    }
  return (false);
}

#endif /* CHECK_INCLUDED */
