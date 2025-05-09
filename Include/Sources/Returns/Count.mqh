//+------------------------------------------------------------------+
//|                                                        Count.mqh |
//|                                        Copyright 2023, Upcoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+

#ifndef COUNT_INCLUDED
#define COUNT_INCLUDED

#include "Terminal.mqh"

class CCount
{
  private:
    static ulong _tickCount;
    static ulong _tickCount64;
    static MqlTick _mqlTick;
    static ulong _lastOnTick;
    static ulong _onTickCount64;
    static ulong _onTickMicrosecondCount;

  public:
    CCount();
    ~CCount();

    // Methods
    static void Update();
    static void OnTick();

    //- GET
    static ulong GetTickCount() { return (_tickCount); };
    static ulong GetTickCount64() { return (_tickCount64); };
    static ulong GetSecondsIdle() { return (::GetTickCount() - _lastOnTick) / 1000; };
    static ulong GetOnTickCount64() { return (_onTickCount64); };
    static ulong GetOnTickMicrosecondCount() { return (_onTickMicrosecondCount); };
};

/**
 * Declarações estáticas
 */
MqlTick CCount::_mqlTick;
ulong CCount::_tickCount              = 0;
ulong CCount::_tickCount64            = 0;
ulong CCount::_lastOnTick             = 0;
ulong CCount::_onTickCount64          = 0;
ulong CCount::_onTickMicrosecondCount = 0;

/**
 * Contrutor e destrutor
 */
CCount::CCount()
{
  OnTick();
}
CCount::~CCount()
{
}

/**
 * Atualiza as contagem de tick
 */
void CCount::OnTick()
{
  _lastOnTick             = ::GetTickCount();
  _onTickCount64          = ::GetTickCount64();
  _onTickMicrosecondCount = ::GetMicrosecondCount();
}
void CCount::Update()
{
  _tickCount = ::GetTickCount();
  if(CTerminal::IsLiveMarket())
    {
      _tickCount64 = ::GetTickCount64();
    }
  else
    {
      SymbolInfoTick(Symbol(), _mqlTick);
      _tickCount64 = _mqlTick.time_msc;
    }
}

#endif /* COUNT_INCLUDED */
