//+------------------------------------------------------------------+
//|                                                 BufferModule.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+

#ifndef BUFFERMODULE_INCLUDED
#define BUFFERMODULE_INCLUDED

#include "../Initializer/BufferModuleInitializer.mqh"
#include "../Module.mqh"

// clang-format off
class CBufferModule : public CModule
{
  private:
    // Initializer class
    CBufferModuleInitializer initializer;
    
    // Classes
    CBufferManager bufferManager;
  
  public:
    CBufferModule();
    ~CBufferModule();

    // Methods
    bool Start() override;
    bool Stop() override;
    
    // References
    CBufferManager* GetBufferManagerPointer() { return (GetPointer(bufferManager)); };
};
// clang-format on

/**
 * Contrutores e Destrutores
 */
CBufferModule::CBufferModule()
    : initializer(GetBufferManagerPointer()),
      CModule(GetPointer(initializer))
{
}
CBufferModule::~CBufferModule()
{
}

/**
 * Métodos de inicialização
 */
bool CBufferModule::Start()
{
  CModule::Start();

  bufferManager.OnStart();
  return (true);
}
bool CBufferModule::Stop()
{
  CModule::Stop();

  bufferManager.OnStop();
  return (true);
}

#endif /* BUFFERMODULE_INCLUDED */
