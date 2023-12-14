//+------------------------------------------------------------------+
//|                                                      Buffers.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+

#ifndef BUFFERS_INCLUDED
#define BUFFERS_INCLUDED

#include "../../Databases/Tables/TableTemplate.mqh"
#include "Buffer.mqh"

// clang-format off
class CBuffers
{
  private:
    // Buffers
    CTableTemplate<CBuffer> buffers;

  public:
    CBuffers();
    ~CBuffers();
    
    // Events
    virtual void OnStart();
    virtual void OnStop();
    virtual void OnCalculate(const int total, const int pos, const datetime& time[], const double& open[], const double& high[], const double& low[], const double& close[],
                     const long& tick_volume[], const long& volume[], const int& spread[]);
  
  protected:
    bool Add(CBuffer *buffer) { return (buffers.Add(buffer)); };
  
  private:
    bool ValidSweep();
    
};
// clang-format on

/**
 * Contrutores e Destrutores
 */
CBuffers::CBuffers()
{
}
CBuffers::~CBuffers()
{
}

/**
 * Métodos de sincronização
 */
void CBuffers::OnStart()
{
  if(ValidSweep())
    {
      ENUM_TABLE_GET_TYPE getType = 0;
      CBuffer* getRef             = NULL;
      while((getType = buffers.GetNextValue(getRef)) != TABLE_GET_TYPE_END)
        {
          if(getType == TABLE_GET_TYPE_GET)
            {
              getRef.OnStart();
            }
        }
    }
}
void CBuffers::OnStop()
{
  if(ValidSweep())
    {
      ENUM_TABLE_GET_TYPE getType = 0;
      CBuffer* getRef             = NULL;
      while((getType = buffers.GetNextValue(getRef)) != TABLE_GET_TYPE_END)
        {
          if(getType == TABLE_GET_TYPE_GET)
            {
              getRef.OnStop();
            }
        }
    }
}
void CBuffers::OnCalculate(const int total, const int pos, const datetime& time[], const double& open[], const double& high[], const double& low[], const double& close[], const long& tick_volume[],
                           const long& volume[], const int& spread[])
{
  if(ValidSweep())
    {
      ENUM_TABLE_GET_TYPE getType = 0;
      CBuffer* getRef             = NULL;
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
bool CBuffers::ValidSweep()
{
  if(buffers.GetSize() > 0)
    {
      buffers.ResetSequenceCount();
      return (true);
    }
  return (false);
};

#endif /* BUFFERS_INCLUDED */
