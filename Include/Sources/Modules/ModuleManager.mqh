//+------------------------------------------------------------------+
//|                                                ModuleManager.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+

#ifndef MODULEMANAGER_INCLUDED
#define MODULEMANAGER_INCLUDED

// Bibliotecas
#include "../Databases/Tables/TableTemplate.mqh"
#include "Module.mqh"

//- modulos
// #include "Modules/TestModule.mqh"

// clang-format off
class CModuleManager
{
  private:
    CTableTemplate<CModule> modules;

  public:
    CModuleManager();
    ~CModuleManager();
    
    // Pointers
    //CTestModule* GetTestModulePointer() { return (GetPointer(cTestModule)); };
    
    // Methods
    bool Start();
    bool Stop();
    
  private:
    bool ValidSweep()
    {
      if(modules.GetSize() > 0)
        {
          modules.ResetSequenceCount();
          return (true);
        }
      return (false);
    };
};
// clang-format on

/**
 * Contrutores e Destrutores
 */
CModuleManager::CModuleManager()
{
  // Modules
  // modules.Add(GetTestModulePointer());
}
CModuleManager::~CModuleManager()
{
}

/**
 * Métodos de inicialização e finalização
 */
bool CModuleManager::Start()
{
  if(ValidSweep())
    {
      ENUM_TABLE_GET_TYPE getType = 0;
      CModule* getRef             = NULL;
      while((getType = modules.GetNextValue(getRef)) != TABLE_GET_TYPE_END)
        {
          if(getType == TABLE_GET_TYPE_GET)
            {
              if(!getRef.Start())
                {
                  return (false);
                }
            }
        }
    }
  return (true);
}
bool CModuleManager::Stop()
{
  bool success = true;
  if(ValidSweep())
    {
      ENUM_TABLE_GET_TYPE getType = 0;
      CModule* getRef             = NULL;
      while((getType = modules.GetNextValue(getRef)) != TABLE_GET_TYPE_END)
        {
          if(getType == TABLE_GET_TYPE_GET)
            {
              if(!getRef.Stop())
                {
                  success = false; // Para informar que nem todos os modules foram descarregados com sucess.
                }
            }
        }
    }
  return (success);
}

#endif /* MODULEMANAGER_INCLUDED */
