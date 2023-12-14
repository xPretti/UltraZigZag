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
#include "Modules/BufferModule.mqh"

// clang-format off
class CModuleManager
{
  private:
    CTableTemplate<CModule> modules;
    
  private:
    // First priority
    //...
    // Normal priority
    CBufferModule bufferModule;
    
  public:
    CModuleManager();
    ~CModuleManager();
    
    // Pointers
    CBufferModule* GetBufferModulePointer() { return (GetPointer(bufferModule)); };
    
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
  modules.Add(GetBufferModulePointer());
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
