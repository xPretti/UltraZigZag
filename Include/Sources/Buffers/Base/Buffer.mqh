//+------------------------------------------------------------------+
//|                                                       Buffer.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+


#ifndef BUFFER_INCLUDED
#define BUFFER_INCLUDED

// clang-format off
class CBuffer
{
  public:
    CBuffer();
    ~CBuffer();
    
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
CBuffer::CBuffer()
{
}
CBuffer::~CBuffer()
{  
}


#endif /* BUFFER_INCLUDED */

