//+------------------------------------------------------------------+
//|                                                 ZigZagBuffer.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+

#ifndef ZIGZAGBUFFER_INCLUDED
#define ZIGZAGBUFFER_INCLUDED

#include "Base/Buffer.mqh"

// clang-format off
class CZigZagBuffer : public CBuffer
{
  private:
    // Properties
    int _period;
    
    // Variables
    double tops[];  //Trocar para a tabela
    double funds[]; //Trocar para a tabela
    
    // Array buffers
    double ZigZagLine1[];
    double ZigZagLine2[];
    double ZigZagLineColor[];
    double ZigZagPrice[];
    double ZigZagTop[];
    double ZigZagFound[];
    double ZigZagDirection[];
    double ZigZagDirectionDynamic[];
    double ZigZagLastHighBar[];
    double ZigZagLastLowBar[];

  public:
    CZigZagBuffer();
    ~CZigZagBuffer();

    // Events
    void OnStart() override;
    void OnStop() override;
    void OnCalculate(const int total, const int pos, const datetime& time[], const double& open[], const double& high[], const double& low[], const double& close[],
                             const long& tick_volume[], const long& volume[], const int& spread[]) override;
    
    // Properties
    //- GET
    int GetPeriod() { return (_period); };
    
    //- SET
    void SetPeriod(int v) { _period = v; };
  
  private:
    void ZigZagDirectionCalculate(int i, const double &high[], const double &low[]);
    void TopAndFundUpdate(int pos, int type, double price, double &array[], double &arrayBuffer[]);
    void TopAndFundUpdateBuffer(int pos, double &array[], double &arrayBuffer[]);
    
};
// clang-format on

/**
 * Contrutores e Destrutores
 */
CZigZagBuffer::CZigZagBuffer()
    : _period(12)
{
  ArrayResize(tops, 20);
  ArrayInitialize(tops, 0.0);
  ArrayResize(funds, 20);
  ArrayInitialize(funds, 0.0);
}
CZigZagBuffer::~CZigZagBuffer()
{
  ArrayFree(tops);
  ArrayFree(funds);
}

/**
 * Métodos de inicialização
 */
void CZigZagBuffer::OnStart()
{
  // Buffers de desenho
  SetIndexBuffer(0, ZigZagLine1, INDICATOR_DATA);
  SetIndexBuffer(1, ZigZagLine2, INDICATOR_DATA);
  SetIndexBuffer(2, ZigZagLineColor, INDICATOR_COLOR_INDEX);
  // Buffers de cálculos
  SetIndexBuffer(3, ZigZagPrice, INDICATOR_CALCULATIONS);
  SetIndexBuffer(4, ZigZagTop, INDICATOR_CALCULATIONS);
  SetIndexBuffer(5, ZigZagFound, INDICATOR_CALCULATIONS);
  SetIndexBuffer(6, ZigZagDirection, INDICATOR_CALCULATIONS);
  SetIndexBuffer(7, ZigZagDirectionDynamic, INDICATOR_CALCULATIONS);
  //
  SetIndexBuffer(8, ZigZagLastHighBar, INDICATOR_CALCULATIONS);
  SetIndexBuffer(9, ZigZagLastLowBar, INDICATOR_CALCULATIONS);
}
void CZigZagBuffer::OnStop()
{
}

/**
 * Cálculo
 */
void CZigZagBuffer::OnCalculate(const int total, const int pos, const datetime& time[], const double& open[], const double& high[], const double& low[], const double& close[],
                                const long& tick_volume[], const long& volume[], const int& spread[])
{
  int i = pos;
  int startCalc = 0;
  int endCalc   = 0;
  int highValue = 0;
  int lowValue  = 0;

  ZigZagDirectionDynamic[i] = 0;
  ZigZagDirection[i]        = ZigZagDirection[i - 1];
  startCalc                 = (i - GetPeriod()) + 1;
  highValue                 = ArrayMaximum(high, startCalc, GetPeriod());
  lowValue                  = ArrayMinimum(low, startCalc, GetPeriod());
  if(highValue == i && lowValue != i)
    {
      ZigZagDirectionDynamic[i] = 1;
      ZigZagDirection[i]        = 1; // Subindo
    }
  else if(lowValue == i && highValue != i)
    {
      ZigZagDirectionDynamic[i] = -1;
      ZigZagDirection[i]        = -1; // Descendo
    }
  ZigZagLastHighBar[i] = ZigZagLastHighBar[i - 1];
  ZigZagLastLowBar[i]  = ZigZagLastLowBar[i - 1];
  ZigZagDirectionCalculate(i, high, low);

  //--
  static int oldTurn = i;
  if(oldTurn != i)
    {
      oldTurn = i;
      TopAndFundUpdateBuffer(i, tops, ZigZagTop);
      TopAndFundUpdateBuffer(i, funds, ZigZagFound);
    }
}

/*
 * Atualiza os buffers de topos e fundos
 */
void CZigZagBuffer::TopAndFundUpdate(int pos, int type, double price, double &array[], double &arrayBuffer[])
  {
   static int lastType = 1;
   int size = ArraySize(array);
   if(lastType==type)
     {
      array[size-1] = price;
      arrayBuffer[pos] = price;
     }
   else
     {
      lastType = type;
      ArrayRemove(array, 0, 1);
      ArrayResize(array, size);
      array[size-1] = price;
     }
  }

void CZigZagBuffer::TopAndFundUpdateBuffer(int pos, double &array[], double &arrayBuffer[])
  {
   int size = ArraySize(array);
   double arrayValue = 0;
   int getValue = 0;
   for(int i=size-1; i>=0; i--)
      {
       getValue = size-(i+1);
       arrayValue = array[getValue];
       if(pos-i>=0)
         {
          arrayBuffer[pos-i] = arrayValue;
         }
      }
  }

/*
 * Cálcula a direção do zigzag e atualiza os buffers.
 */
void CZigZagBuffer::ZigZagDirectionCalculate(int i, const double &high[], const double &low[])
   {
    ZigZagLine1[i] = EMPTY_VALUE;
    ZigZagLine2[i] = EMPTY_VALUE;
    ZigZagLineColor[i] = ZigZagLineColor[i-1];
    switch((int)ZigZagDirection[i])
      {
       case 1:
          switch((int)ZigZagDirection[i-1])
            {
             case 1:
                if(high[i]>high[(int)ZigZagLastHighBar[i]])
                  {
                   ZigZagLine1[(int)ZigZagLastHighBar[i]] = EMPTY_VALUE;
                   ZigZagLine1[i]              = high[i];
                   ZigZagLastHighBar[i]             = i;
                   ZigZagLineColor[i]         = 0;
                   TopAndFundUpdate(i, 1, high[i], tops, ZigZagTop);
                  }
                break;
             case -1:
                ZigZagLine1[i]      = high[i];
                ZigZagLastHighBar[i]       = i;
                ZigZagLineColor[i] = 0;
                TopAndFundUpdate(i, 1, high[i], tops, ZigZagTop);
                break;
            }
          break;
       case -1:
          switch((int)ZigZagDirection[i-1])
            {
             case -1:
                if(low[i]<low[(int)ZigZagLastLowBar[i]])
                  {                
                   ZigZagLine2[(int)ZigZagLastLowBar[i]] = EMPTY_VALUE;
                   ZigZagLine2[i]             = low[i];
                   ZigZagLastLowBar[i]               = i;
                   ZigZagLineColor[i]        = 1;
                   TopAndFundUpdate(i, -1, low[i], funds, ZigZagFound);
                  }
                break;
             case 1:  
                ZigZagLine2[i]      = low[i];
                ZigZagLastLowBar[i]      = i;
                ZigZagLineColor[i] = 1;
                TopAndFundUpdate(i, -1, low[i], funds, ZigZagFound);
                break;
            }
          break;
      }
    if(ZigZagLine1[i] != EMPTY_VALUE)
      {
       ZigZagPrice[i] = ZigZagLine1[i];
      }
    else if(ZigZagLine2[i] != EMPTY_VALUE)
      {
       ZigZagPrice[i] = ZigZagLine2[i];
      }
    else
      {
       ZigZagPrice[i] = ZigZagPrice[i-1] != 0 ? ZigZagPrice[i-1] : ZigZagPrice[i];
      }
   }

#endif /* ZIGZAGBUFFER_INCLUDED */
