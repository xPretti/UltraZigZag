//+------------------------------------------------------------------+
//|                                                 IndicatorModule.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+

#ifndef INDICATORMODULE_INCLUDED
#define INDICATORMODULE_INCLUDED

#include "../Initializer/IndicatorModuleInitializer.mqh"
#include "../Module.mqh"

// clang-format off
class CIndicatorModule : public CModule
{
  private:
    // Initializer class
    CIndicatorModuleInitializer initializer;
    
    // Classes
    CIndicatorManager bufferManager;
  
  public:
    CIndicatorModule();
    ~CIndicatorModule();

    // Methods
    bool Start() override;
    bool Stop() override;
    
    // References
    CIndicatorManager* GetIndicatorManagerPointer() { return (GetPointer(bufferManager)); };
};
// clang-format on

/**
 * Contrutores e Destrutores
 */
CIndicatorModule::CIndicatorModule()
    : initializer(GetIndicatorManagerPointer()),
      CModule(GetPointer(initializer))
{
}
CIndicatorModule::~CIndicatorModule()
{
}

/**
 * Métodos de inicialização
 */
bool CIndicatorModule::Start()
{
  CModule::Start();

  bufferManager.OnStart();
  return (true);
}
bool CIndicatorModule::Stop()
{
  CModule::Stop();

  bufferManager.OnStop();
  return (true);
}

#endif /* INDICATORMODULE_INCLUDED */
