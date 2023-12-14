//+------------------------------------------------------------------+
//|                                      BufferModuleInitializer.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+

#ifndef BUFFERMODULEINITIALIZER_INCLUDED
#define BUFFERMODULEINITIALIZER_INCLUDED

#include "ModuleInitializer.mqh"
#include "../../Buffers/BufferManager.mqh"

// clang-format off
class CBufferModuleInitializer : public CModuleInitializer
{
  private:
    // Variables
    CBufferManager* bufferManager;
    
  public:
    CBufferModuleInitializer(CBufferManager* bufferManagerRef);
    ~CBufferModuleInitializer();

    // Methods
    void Initializer() override;
};
// clang-format on

/**
 * Contrutores e Destrutores
 */
CBufferModuleInitializer::CBufferModuleInitializer(CBufferManager* bufferManagerRef)
    : bufferManager(bufferManagerRef)
{
}
CBufferModuleInitializer::~CBufferModuleInitializer()
{
}

/**
 * Inicialização
 */
void CBufferModuleInitializer::Initializer()
{
  CZigZagBuffer* zigZag = bufferManager.GetZigZagBuffer();
  zigZag.SetPeriod(inputPeriod);
}

#endif /* BUFFERMODULEINITIALIZER_INCLUDED */
