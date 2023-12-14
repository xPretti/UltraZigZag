//+------------------------------------------------------------------+
//|                                                       Module.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+

#ifndef MODULE_INCLUDED
#define MODULE_INCLUDED

#include "Initializer/ModuleInitializer.mqh"

// clang-format off
class CModule
{
  private:
    // Initializer class
    CModuleInitializer* classInitializer;
    
  private:
    // Inputs loader
    void StartInputs();
    
  private:
    bool IsValidInitializer() { return (CheckPointer(classInitializer) != POINTER_INVALID); };
    
  public:
    CModule(CModuleInitializer* initializer=NULL);
    ~CModule();

    // Methods
    virtual bool Start() { StartInputs(); return (true); };
    virtual bool Stop() { return (true); };
};
// clang-format on

/**
 * Contrutores e Destrutores
 */
CModule::CModule(CModuleInitializer* initializer = NULL)
    : classInitializer(initializer)
{
}
CModule::~CModule()
{
}

/**
 * Método de inicialização dos parâmetros quando necessário
 */
void CModule::StartInputs()
{
  if(IsValidInitializer())
    {
      classInitializer.Initializer();
    }
}

#endif /* MODULE_INCLUDED */
