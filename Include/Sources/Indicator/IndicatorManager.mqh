//+------------------------------------------------------------------+
//|                                             IndicatorManager.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+

#ifndef INDICATORMANAGER_INCLUDED
#define INDICATORMANAGER_INCLUDED

// Base
#include "Base/Indicators.mqh"

// Indicators
#include "ZigZagIndicator.mqh"
#include "ZigZagAverageIndicator.mqh"

// clang-format off
class CIndicatorManager : public CIndicators
{
  private:
    // Indicators
    CZigZagIndicator zigZag;
    CZigZagAverageIndicator zigZagAverage;

  public:
    CIndicatorManager();
    ~CIndicatorManager();
    
    // Events
    void OnStart() override;
    
    // References
    CZigZagIndicator* GetZigZagIndicator() { return (GetPointer(zigZag)); }; 
    CZigZagAverageIndicator* GetZigZagAverageIndicator() { return (GetPointer(zigZagAverage)); }; 
  
  private:
    void IndicatorConfig();
    
};
// clang-format on

/**
 * Contrutores e Destrutores
 */
CIndicatorManager::CIndicatorManager() : zigZagAverage(GetZigZagIndicator())
{
  Add(GetZigZagIndicator());
  Add(GetZigZagAverageIndicator());
}
CIndicatorManager::~CIndicatorManager()
{
}

/**
 * Implementação dos eventos
 */
void CIndicatorManager::OnStart()
{
  CIndicators::OnStart();
  IndicatorConfig();
}

/**
 * Configurações do inciador
 */
void CIndicatorManager::IndicatorConfig()
{
  // Configs loader
  string indicatorName = StringFormat("UltraZigZag(%d, %s)", zigZag.GetPeriod(), zigZagAverage.GetEnabledZigZagAverage() ? "true" : "false");
  IndicatorSetString(INDICATOR_SHORTNAME, indicatorName);
}

#endif /* INDICATORMANAGER_INCLUDED */
