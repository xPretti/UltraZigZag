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

// clang-format off
class CIndicatorManager : public CIndicators
{
  private:
    // Indicators
    CZigZagIndicator zigZag;

  public:
    CIndicatorManager();
    ~CIndicatorManager();
    
    // Events
    void OnStart() override;
    
    // References
    CZigZagIndicator* GetZigZagIndicator() { return (GetPointer(zigZag)); }; 
  
  private:
    void IndicatorConfig();
    
};
// clang-format on

/**
 * Contrutores e Destrutores
 */
CIndicatorManager::CIndicatorManager()
{
  Add(GetZigZagIndicator());
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
  string indicatorName = StringFormat("UltraZigZag(%d)", zigZag.GetPeriod());
  IndicatorSetString(INDICATOR_SHORTNAME, indicatorName);
}

#endif /* INDICATORMANAGER_INCLUDED */
