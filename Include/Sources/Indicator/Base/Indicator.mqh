//+------------------------------------------------------------------+
//|                                                    Indicator.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+


#ifndef INDICATOR_INCLUDED
#define INDICATOR_INCLUDED

// clang-format off
class CIndicator
{
  public:
    CIndicator();
    ~CIndicator();
    
    // Events
    virtual void OnStart() {};
    virtual void OnStop() {};
    virtual void OnCalculate(const int total, const int pos, const datetime& time[], const double& open[], const double& high[], const double& low[], const double& close[],
                             const long& tick_volume[], const long& volume[], const int& spread[]) {};
};
// clang-format on

/**
 * Contrutores e Destrutores
 */
CIndicator::CIndicator()
{
}
CIndicator::~CIndicator()
{  
}


#endif /* INDICATOR_INCLUDED */

