//+------------------------------------------------------------------+
//|                                                         Main.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+

#ifndef MAIN_INCLUDED
#define MAIN_INCLUDED

// Bibliotecas
#include "../Defines/Defines.mqh"
#include "../Inputs/InputsLoader.mqh"
#include "MainRefs.mqh"
#include "Modules/ModuleManager.mqh"

// clang-format off
class CMain : public CMainRefs
{
  private:
    // ModuleManager
    CModuleManager moduleManager;
    
    //Classes
    //..
    
  public:
    // References
    CModuleManager* GetModuleManagerRef() { return (GetPointer(moduleManager)); };
    
  public:
    CMain();
    ~CMain();

    // Events
    // Builders
    int OnStart() override;
    void OnStop(const int reason) override;

    // Updades
    //- Tick
    void OnTick() override;
    void OnLateTick() override;

    //- Timer
    void OnTimer() override;
    void OnLateTimer() override;

    //- Calculators
    void OnCalculate(const int total, const int pos, const datetime& time[], const double& open[], const double& high[], const double& low[], const double& close[],
                     const long& tick_volume[], const long& volume[], const int& spread[]) override;

    // Others
    void OnError(int error) override;
    void OnOnline() override;
    void OnOffline() override;

    // Orders and Objects
    void OnTrade() override;
    void OnTradeTransaction(const MqlTradeTransaction& trans, const MqlTradeRequest& request, const MqlTradeResult& result) override;
    void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam) override;
};
// clang-format on

/**
 * Contrutores e Destrutores
 */
CMain::CMain()
{
}
CMain::~CMain()
{
}

// Events
// Builders
int CMain::OnStart()
{
  // Start modules
  bool sucessStart = moduleManager.Start();
  return (sucessStart ? INIT_SUCCEEDED : INIT_FAILED);
}
void CMain::OnStop(const int reason)
{
  moduleManager.Stop();
}
// Updades
//- Tick
void CMain::OnTick()
{
}
void CMain::OnLateTick()
{
}
//- Timer
void CMain::OnTimer()
{
}
void CMain::OnLateTimer()
{
}
//- Calculators
void CMain::OnCalculate(const int total, const int pos, const datetime& time[], const double& open[], const double& high[], const double& low[], const double& close[], const long& tick_volume[],
                        const long& volume[], const int& spread[])
{
}
// Others
void CMain::OnError(int error)
{
}
void CMain::OnOnline()
{
}
void CMain::OnOffline()
{
}
// Orders and Objects
void CMain::OnTrade()
{
}
void CMain::OnTradeTransaction(const MqlTradeTransaction& trans, const MqlTradeRequest& request, const MqlTradeResult& result)
{
}
void CMain::OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
{
}

#endif /* MAIN_INCLUDED */
