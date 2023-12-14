//+------------------------------------------------------------------+
//|                                              ZigZagIndicator.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+

#ifndef ZIGZAGINDICATOR_INCLUDED
#define ZIGZAGINDICATOR_INCLUDED

#include "Base/Buffer.mqh"
#include "Base/Indicator.mqh"

// clang-format off
class CZigZagIndicator : public CIndicator
{
  private:
    // Properties
    int _period;
    
    // Variables
    double tops[];  //Trocar para a tabela
    double funds[]; //Trocar para a tabela
    
    // Array buffers
    CBuffer bZigZagLine1;
    CBuffer bZigZagLine2;
    CBuffer bZigZagLineColor;
    CBuffer bZigZagPrice;
    CBuffer bZigZagTop;
    CBuffer bZigZagFound;
    CBuffer bZigZagDirection;
    CBuffer bZigZagDirectionDynamic;
    CBuffer bZigZagLastHighBar;
    CBuffer bZigZagLastLowBar;

  public:
    CZigZagIndicator();
    ~CZigZagIndicator();

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
    
    // References
    CBuffer* GetZigZagLine1Buffer() { return (GetPointer(bZigZagLine1)); };
    CBuffer* GetZigZagLine2Buffer() { return (GetPointer(bZigZagLine2)); };
    CBuffer* GetZigZagLineColorBuffer() { return (GetPointer(bZigZagLineColor)); };
    CBuffer* GetZigZagPriceBuffer() { return (GetPointer(bZigZagPrice)); };
    CBuffer* GetZigZagTopBuffer() { return (GetPointer(bZigZagTop)); };
    CBuffer* GetZigZagFoundBuffer() { return (GetPointer(bZigZagFound)); };
    CBuffer* GetZigZagDirectionBuffer() { return (GetPointer(bZigZagDirection)); };
    CBuffer* GetZigZagDirectionDynamicBuffer() { return (GetPointer(bZigZagDirectionDynamic)); };
    CBuffer* GetZigZagLastHighBarBuffer() { return (GetPointer(bZigZagLastHighBar)); };
    CBuffer* GetZigZagLastLowBarBuffer() { return (GetPointer(bZigZagLastLowBar)); };
  
  private:
    void bZigZagDirectionCalculate(int i, const double &high[], const double &low[]);
    void TopAndBottomUpdate(int pos, int type, double price, double &array[], CBuffer* bufferRef);
    void TopAndBottomUpdateBuffer(int pos, double &array[], CBuffer* bufferRef);
    
};
// clang-format on

/**
 * Contrutores e Destrutores
 */
CZigZagIndicator::CZigZagIndicator()
    : _period(12)
{
  ArrayResize(tops, 20);
  ArrayInitialize(tops, 0.0);
  ArrayResize(funds, 20);
  ArrayInitialize(funds, 0.0);
}
CZigZagIndicator::~CZigZagIndicator()
{
  ArrayFree(tops);
  ArrayFree(funds);
}

/**
 * Métodos de inicialização
 */
void CZigZagIndicator::OnStart()
{
  // Buffers de desenho
  bZigZagLine1.SetBufferParams(0, INDICATOR_DATA);
  bZigZagLine2.SetBufferParams(1, INDICATOR_DATA);
  bZigZagLineColor.SetBufferParams(2, INDICATOR_COLOR_INDEX);

  // Buffers de cálculos
  bZigZagPrice.SetBufferParams(3, INDICATOR_CALCULATIONS);
  bZigZagTop.SetBufferParams(4, INDICATOR_CALCULATIONS);
  bZigZagFound.SetBufferParams(5, INDICATOR_CALCULATIONS);
  bZigZagDirection.SetBufferParams(6, INDICATOR_CALCULATIONS);
  bZigZagDirectionDynamic.SetBufferParams(7, INDICATOR_CALCULATIONS);
  //
  bZigZagLastHighBar.SetBufferParams(8, INDICATOR_CALCULATIONS);
  bZigZagLastLowBar.SetBufferParams(9, INDICATOR_CALCULATIONS);
}
void CZigZagIndicator::OnStop()
{
}

/**
 * Cálculo
 */
void CZigZagIndicator::OnCalculate(const int total, const int pos, const datetime& time[], const double& open[], const double& high[], const double& low[], const double& close[],
                                   const long& tick_volume[], const long& volume[], const int& spread[])
{
  int i         = pos;
  int startCalc = 0;
  int endCalc   = 0;
  int highValue = 0;
  int lowValue  = 0;

  bZigZagDirectionDynamic.SetValue(i, 0);
  bZigZagDirection.SetValue(i, bZigZagDirection.GetValue(i - 1));
  startCalc = (i - GetPeriod()) + 1;
  highValue = ArrayMaximum(high, startCalc, GetPeriod());
  lowValue  = ArrayMinimum(low, startCalc, GetPeriod());
  if(highValue == i && lowValue != i)
    {
      bZigZagDirectionDynamic.SetValue(i, 1);
      bZigZagDirection.SetValue(i, 1);
    }
  else if(lowValue == i && highValue != i)
    {
      bZigZagDirectionDynamic.SetValue(i, -1);
      bZigZagDirection.SetValue(i, -1);
    }
  bZigZagLastHighBar.SetValue(i, bZigZagLastHighBar.GetValue(i - 1));
  bZigZagLastLowBar.SetValue(i, bZigZagLastLowBar.GetValue(i - 1));
  bZigZagDirectionCalculate(i, high, low);

  //--
  static int oldTurn = i;
  if(oldTurn != i)
    {
      oldTurn = i;
      TopAndBottomUpdateBuffer(i, tops, GetPointer(bZigZagTop));
      TopAndBottomUpdateBuffer(i, funds, GetPointer(bZigZagFound));
    }
}

/*
 * Atualiza os buffers de topos e fundos
 */
void CZigZagIndicator::TopAndBottomUpdate(int pos, int type, double price, double& array[], CBuffer* bufferRef)
{
  static int lastType = 1;
  int size            = ArraySize(array);
  if(lastType == type)
    {
      array[size - 1] = price;
      bufferRef.SetValue(pos, price);
    }
  else
    {
      lastType = type;
      ArrayRemove(array, 0, 1);
      ArrayResize(array, size);
      array[size - 1] = price;
    }
}

void CZigZagIndicator::TopAndBottomUpdateBuffer(int pos, double& array[], CBuffer* bufferRef)
{
  int size          = ArraySize(array);
  double arrayValue = 0;
  int getValue      = 0;
  for(int i = size - 1; i >= 0; i--)
    {
      getValue   = size - (i + 1);
      arrayValue = array[getValue];
      if(pos - i >= 0)
        {
          bufferRef.SetValue(pos - i, arrayValue);
        }
    }
}

/*
 * Cálcula a direção do zigzag e atualiza os buffers.
 */
void CZigZagIndicator::bZigZagDirectionCalculate(int i, const double& high[], const double& low[])
{
  bZigZagLine1.SetValue(i, EMPTY_VALUE);
  bZigZagLine2.SetValue(i, EMPTY_VALUE);

  bZigZagLineColor.SetValue(i, bZigZagLineColor.GetValue(i - 1));

  switch((int)bZigZagDirection.GetValue(i))
    {
    case 1:
      switch((int)bZigZagDirection.GetValue(i - 1))
        {
        case 1:
          if(high[i] > high[(int)bZigZagLastHighBar.GetValue(i)])
            {
              bZigZagLine1.SetValue((int)bZigZagLastHighBar.GetValue(i), EMPTY_VALUE);
              bZigZagLine1.SetValue(i, high[i]);
              bZigZagLastHighBar.SetValue(i, i);
              bZigZagLineColor.SetValue(i, 0);
              TopAndBottomUpdate(i, 1, high[i], tops, GetPointer(bZigZagTop));
            }
          break;
        case -1:
          bZigZagLine1.SetValue(i, high[i]);
          bZigZagLastHighBar.SetValue(i, i);
          bZigZagLineColor.SetValue(i, 0);
          TopAndBottomUpdate(i, 1, high[i], tops, GetPointer(bZigZagTop));
          break;
        }
      break;
    case -1:
      switch((int)bZigZagDirection.GetValue(i - 1))
        {
        case -1:
          if(low[i] < low[(int)bZigZagLastLowBar.GetValue(i)])
            {
              bZigZagLine2.SetValue((int)bZigZagLastLowBar.GetValue(i), EMPTY_VALUE);
              bZigZagLine2.SetValue(i, low[i]);
              bZigZagLastLowBar.SetValue(i, i);
              bZigZagLineColor.SetValue(i, 1);
              TopAndBottomUpdate(i, -1, low[i], funds, GetPointer(bZigZagFound));
            }
          break;
        case 1:
          bZigZagLine2.SetValue(i, low[i]);
          bZigZagLastLowBar.SetValue(i, i);
          bZigZagLineColor.SetValue(i, 1);
          TopAndBottomUpdate(i, -1, low[i], funds, GetPointer(bZigZagFound));
          break;
        }
      break;
    }
  if(bZigZagLine1.GetValue(i) != EMPTY_VALUE)
    {
      bZigZagPrice.SetValue(i, bZigZagLine1.GetValue(i));
    }
  else if(bZigZagLine2.GetValue(i) != EMPTY_VALUE)
    {
      bZigZagPrice.SetValue(i, bZigZagLine2.GetValue(i));
    }
  else
    {
      double newPrice = bZigZagPrice.GetValue(i - 1) != 0 ? bZigZagPrice.GetValue(i - 1) : bZigZagPrice.GetValue(i);
      bZigZagPrice.SetValue(i, newPrice);
    }
}

#endif /* ZIGZAGINDICATOR_INCLUDED */
