//+------------------------------------------------------------------+
//|                                                       Module.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+


#ifndef MODULE_INCLUDED
#define MODULE_INCLUDED

// clang-format off
class CModule
{
  protected:
    // Inputs
    virtual void StartInputs(){};
    
  private:
    // First priority
    //...
    // Normal priority
    //...
  public:
    CModule();
    ~CModule();

    // Methods
    virtual bool Start() { StartInputs(); return (true); };
    virtual bool Stop() { return (true); };
};
// clang-format on

/**
 * Contrutores e Destrutores
 */
CModule::CModule()
{
}
CModule::~CModule()
{  
}


#endif /* MODULE_INCLUDED */

