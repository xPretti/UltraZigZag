//+------------------------------------------------------------------+
//|                                   IndicatorModuleInitializer.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+

#ifndef INDICATORMODULEINITIALIZER_INCLUDED
#define INDICATORMODULEINITIALIZER_INCLUDED

#include "ModuleInitializer.mqh"
#include "../../Indicator/IndicatorManager.mqh"

// clang-format off
class CIndicatorModuleInitializer : public CModuleInitializer
{
  private:
    // Variables
    CIndicatorManager* indicatorManager;
    
  public:
    CIndicatorModuleInitializer(CIndicatorManager* bufferManagerRef);
    ~CIndicatorModuleInitializer();

    // Methods
    void Initializer() override;
};
// clang-format on

/**
 * Contrutores e Destrutores
 */
CIndicatorModuleInitializer::CIndicatorModuleInitializer(CIndicatorManager* bufferManagerRef)
    : indicatorManager(bufferManagerRef)
{
}
CIndicatorModuleInitializer::~CIndicatorModuleInitializer()
{
}

/**
 * Inicialização
 */
void CIndicatorModuleInitializer::Initializer()
{
  CZigZagIndicator* zigZag = indicatorManager.GetZigZagIndicator();
  zigZag.SetPeriod(inputPeriod);
}

#endif /* INDICATORMODULEINITIALIZER_INCLUDED */
