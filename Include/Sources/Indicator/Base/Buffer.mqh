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
  private:
    // Properties
    uint _bufferId;
    ENUM_INDEXBUFFER_TYPE _bufferData;
    
    // Buffer
    double bufferValues[];
  
  private:
    bool IsValidRange(int candle) { return (candle>=0 && candle < GetSize()); };
    
  public:
    CBuffer();
    ~CBuffer();

    // Methods
    //- GET
    int GetSize() { return ((int)bufferValues.Size()); };
    double GetValue(int candle);
    bool GetValue(int candle, double &getValue);
    
    //- SET
    bool SetValue(int candle, double value);
    
    // Properties
    //- GET
    uint GetBuffer() { return (_bufferId); };
    ENUM_INDEXBUFFER_TYPE GetBufferType() { return (_bufferData); };
    
    //- SET
    void SetBufferParams(uint buffer, ENUM_INDEXBUFFER_TYPE data) { _bufferId = buffer; _bufferData = data; SaveParams(); };
    
  private:
    void SaveParams() { SetIndexBuffer(_bufferId, bufferValues, _bufferData); };
    
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

/**
 * Retorna o elemento dentro do array de dados
 */
double CBuffer::GetValue(int candle)
{
  if(IsValidRange(candle))
    {
      return (bufferValues[candle]);
    }
  return (0);
}
bool CBuffer::GetValue(int candle, double &getValue)
{
  if(IsValidRange(candle))
    {
      getValue = bufferValues[candle];
      return (true);
    }
  getValue = 0;
  return (false);
}

/**
 * Define o elemento dentro do array de dados
 */
bool CBuffer::SetValue(int candle, double value)
{
  if(IsValidRange(candle))
    {
      bufferValues[candle] = value;
      return (true);
    }
  return (false);
}

#endif /* BUFFER_INCLUDED */

