//+------------------------------------------------------------------+
//|                                            ModuleInitializer.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+


#ifndef MODULEINITIALIZER_INCLUDED
#define MODULEINITIALIZER_INCLUDED

#include "../../../Inputs/InputsLoader.mqh"

// clang-format off
class CModuleInitializer
{
  public:
    CModuleInitializer();
    ~CModuleInitializer();

    // Methods
    virtual void Initializer() {};
};
// clang-format on

/**
 * Contrutores e Destrutores
 */
CModuleInitializer::CModuleInitializer()
{
}
CModuleInitializer::~CModuleInitializer()
{  
}


#endif /* MODULEINITIALIZER_INCLUDED */

