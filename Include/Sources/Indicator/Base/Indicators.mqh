//+------------------------------------------------------------------+
//|                                                   Indicators.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+

#ifndef BUFFERS_INCLUDED
#define BUFFERS_INCLUDED

#include "../../Databases/Tables/TableTemplate.mqh"
#include "Indicator.mqh"

// clang-format off
class CIndicators
{
  private:
    // Indicators
    CTableTemplate<CIndicator> buffers;

  public:
    CIndicators();
    ~CIndicators();
    
    // Events
    virtual void OnStart();
    virtual void OnStop();
    virtual void OnCalculate(const int total, const int pos, const datetime& time[], const double& open[], const double& high[], const double& low[], const double& close[],
                     const long& tick_volume[], const long& volume[], const int& spread[]);
  
  protected:
    bool Add(CIndicator *buffer) { return (buffers.Add(buffer)); };
  
  private:
    bool ValidSweep();
    
};
// clang-format on

/**
 * Contrutores e Destrutores
 */
CIndicators::CIndicators()
{
}
CIndicators::~CIndicators()
{
}

/**
 * Métodos de sincronização
 */
void CIndicators::OnStart()
{
  if(ValidSweep())
    {
      ENUM_TABLE_GET_TYPE getType = 0;
      CIndicator* getRef             = NULL;
      while((getType = buffers.GetNextValue(getRef)) != TABLE_GET_TYPE_END)
        {
          if(getType == TABLE_GET_TYPE_GET)
            {
              getRef.OnStart();
            }
        }
    }
}
void CIndicators::OnStop()
{
  if(ValidSweep())
    {
      ENUM_TABLE_GET_TYPE getType = 0;
      CIndicator* getRef             = NULL;
      while((getType = buffers.GetNextValue(getRef)) != TABLE_GET_TYPE_END)
        {
          if(getType == TABLE_GET_TYPE_GET)
            {
              getRef.OnStop();
            }
        }
    }
}
void CIndicators::OnCalculate(const int total, const int pos, const datetime& time[], const double& open[], const double& high[], const double& low[], const double& close[], const long& tick_volume[],
                           const long& volume[], const int& spread[])
{
  if(ValidSweep())
    {
      ENUM_TABLE_GET_TYPE getType = 0;
      CIndicator* getRef             = NULL;
      while((getType = buffers.GetNextValue(getRef)) != TABLE_GET_TYPE_END)
        {
          if(getType == TABLE_GET_TYPE_GET)
            {
              getRef.OnCalculate(total, pos, time, open, high, low, close, tick_volume, volume, spread);
            }
        }
    }
}

/**
 * Verificações
 */
bool CIndicators::ValidSweep()
{
  if(buffers.GetSize() > 0)
    {
      buffers.ResetSequenceCount();
      return (true);
    }
  return (false);
};

#endif /* BUFFERS_INCLUDED */
