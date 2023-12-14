//+------------------------------------------------------------------+
//|                                                BufferManager.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+

#ifndef BUFFERMANAGER_INCLUDED
#define BUFFERMANAGER_INCLUDED

// Base
#include "Base/Buffers.mqh"

// Buffers
#include "ZigZagBuffer.mqh"

// clang-format off
class CBufferManager : public CBuffers
{
  private:
    // Buffers
    CZigZagBuffer zigZag;

  public:
    CBufferManager();
    ~CBufferManager();
    
    // Events
    void OnStart() override;
    
    // References
    CZigZagBuffer* GetZigZagBuffer() { return (GetPointer(zigZag)); }; 
  
  private:
    void IndicatorConfig();
    
};
// clang-format on

/**
 * Contrutores e Destrutores
 */
CBufferManager::CBufferManager()
{
  Add(GetZigZagBuffer());
}
CBufferManager::~CBufferManager()
{
}

/**
 * Implementação dos eventos
 */
void CBufferManager::OnStart()
{
  CBuffers::OnStart();
  IndicatorConfig();
}

/**
 * Configurações do inciador
 */
void CBufferManager::IndicatorConfig()
{
  // Configs loader
  string indicatorName = StringFormat("UltraZigZag(%d)", zigZag.GetPeriod());
  IndicatorSetString(INDICATOR_SHORTNAME, indicatorName);
}

#endif /* BUFFERMANAGER_INCLUDED */
