//+------------------------------------------------------------------+
//|                                       ZigZagAverageIndicator.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+

#ifndef ZIGZAGAVERAGEINDICATOR_INCLUDED
#define ZIGZAGAVERAGEINDICATOR_INCLUDED

#include "Base/Buffer.mqh"
#include "Base/Indicator.mqh"
#include "ZigZagIndicator.mqh"

// clang-format off
class CZigZagAverageIndicator : public CIndicator
{
  private:
    // Variables
    CRotaryTable<double>* tableTop;
    CRotaryTable<double>* tableBottom;
    double _averagePrice;
    double _openPrice;
    int _spread;
    int _zigZagDirection;
    
    // Properties
    bool _enabledZigZagAverage;
    int _topBottomAveragePeriod;
    
    // Array buffers
    CBuffer bZigZagAverage;
    CBuffer bZigZagAverageColor;
    
    
    //ZigZag main buffers
    CBuffer* bZigZagDirection;
  
  private:
    bool IsValidTables() { return (IsValidTable(tableTop) && IsValidTable(tableBottom)); };
    bool IsValidTable(CRotaryTable<double>* ref) { return (CheckPointer(ref) != POINTER_INVALID); };
    
  public:
    CZigZagAverageIndicator(CZigZagIndicator* zigZagRef);
    ~CZigZagAverageIndicator();
    
    // Events
    void OnStart() override;
    void OnStop() override;
    void OnCalculate(const int total, const int pos, const datetime& time[], const double& open[], const double& high[], const double& low[], const double& close[],
                     const long& tick_volume[], const long& volume[], const int& spread[]) override;
    // Properties
    //- GET
    bool GetEnabledZigZagAverage() { return (_enabledZigZagAverage); };
    int GetTopBottomAveragePeriod() { return (_topBottomAveragePeriod); };
    
    //- SET
    void SetEnabledZigZagAverage(bool v) { _enabledZigZagAverage = v; };
    void SetTopBottomAveragePeriod(int v) { _topBottomAveragePeriod = v; };
    
    // References
    CBuffer* GetZigZagAverageBuffer() { return (GetPointer(bZigZagAverage)); };
    CBuffer* GetZigZagAverageColorBuffer() { return (GetPointer(bZigZagAverageColor)); };
  
  private:
    bool UseAvarege() { return (GetEnabledZigZagAverage() && IsValidTables()); };
    double GetTopAndBottomAverage(int period);
    double GetTopOrBottomPrice(CRotaryTable<double>* table, int start, int total, int &copies);
    int GetColorDirection();
    
    // Verificações
    bool IsPriceBottom();
    bool IsPriceTop();
};
// clang-format on

/**
 * Contrutores e Destrutores
 */
CZigZagAverageIndicator::CZigZagAverageIndicator(CZigZagIndicator* zigZagRef)
    : _enabledZigZagAverage(false),
      _topBottomAveragePeriod(4)
{
  if(CheckPointer(zigZagRef) != POINTER_INVALID)
    {
      tableTop         = zigZagRef.GetTableTop();
      tableBottom      = zigZagRef.GetTableBottom();
      bZigZagDirection = zigZagRef.GetZigZagDirectionBuffer();
    }
}
CZigZagAverageIndicator::~CZigZagAverageIndicator()
{
}

/**
 * Métodos de inicialização
 */
void CZigZagAverageIndicator::OnStart()
{
  if(UseAvarege())
    {
      // Data
      bZigZagAverage.SetBufferParams(3, INDICATOR_DATA);
      // Color
      bZigZagAverageColor.SetBufferParams(4, INDICATOR_COLOR_INDEX);
    }
}
void CZigZagAverageIndicator::OnStop()
{
}

/**
 * Cálculo
 */
void CZigZagAverageIndicator::OnCalculate(const int total, const int pos, const datetime& time[], const double& open[], const double& high[], const double& low[], const double& close[],
                                          const long& tick_volume[], const long& volume[], const int& spread[])
{
  if(UseAvarege())
    {
      int i = pos;

      if(i >= 1)
        {
          _spread          = spread[i];
          _openPrice       = open[i];
          _zigZagDirection = (int)bZigZagDirection.GetValue(i);

          _averagePrice = GetTopAndBottomAverage(_topBottomAveragePeriod);

          bZigZagAverage.SetValue(i, _averagePrice);
          bZigZagAverageColor.SetValue(i, 2);
          bZigZagAverageColor.SetValue(i, GetColorDirection());
        }
    }
}

/**
 * Retorna o preço da médias dos topos e fundos
 */
double CZigZagAverageIndicator::GetTopAndBottomAverage(int period)
{
  if(UseAvarege())
    {
      int copies         = 0;
      double topPrice    = GetTopOrBottomPrice(tableTop, 1, period, copies);
      double bottomPrice = GetTopOrBottomPrice(tableBottom, 1, period, copies);
      return ((topPrice + bottomPrice) / copies);
    }
  return (0);
}

/**
 * Retornos
 */
double CZigZagAverageIndicator::GetTopOrBottomPrice(CRotaryTable<double>* table, int start, int total, int& copies)
{
  if(IsValidTable(table))
    {
      double price = 0;
      int index    = 0;
      for(int i = (start + 1); i <= total; i++)
        {
          index = table.GetSize() - i;
          if(index >= 0)
            {
              price += table.GetValueByRotary(index);
              copies++;
            }
          else
            {
              break;
            }
        }
      return (price);
    }
  return (0);
}

/**
 * Retorna a cor da direção
 */
int CZigZagAverageIndicator::GetColorDirection()
{
  bool bottom = IsPriceBottom();
  bool top    = IsPriceTop();
  if(bottom && !top)
    {
      return (0);
    }
  else if(!bottom && top)
    {
      return (1);
    }
  return (2);
}

/**
 * Verificações
 */
bool CZigZagAverageIndicator::IsPriceBottom()
{
  if(_openPrice <= _averagePrice)
    {
      int copies             = 0;
      double topAveragePrice = GetTopOrBottomPrice(tableTop, 1, 10, copies);
      topAveragePrice /= copies;
      if(_openPrice <= topAveragePrice)
        {
          if(_zigZagDirection == -1)
            {
              copies             = 0;
              double topPrice    = tableTop.GetValueByRotary(tableTop.GetSize() - 1);
              double buttomPrice = tableBottom.GetValueByRotary(tableBottom.GetSize() - 1);
              if(buttomPrice < _averagePrice && topPrice < _averagePrice)
                {
                  double bottomAveragePrice = GetTopOrBottomPrice(tableBottom, 1, 5, copies);
                  bottomAveragePrice /= copies;
                  if(buttomPrice < bottomAveragePrice)
                    {
                      double lastTopPrice    = tableTop.GetValueByRotary(tableTop.GetSize() - 2);
                      double lastBottomPrice = tableBottom.GetValueByRotary(tableBottom.GetSize() - 2);
                      double diference       = (lastBottomPrice-lastTopPrice) / 5;
                      if(_openPrice < (lastBottomPrice + diference))
                        {
                          return (true);
                        }
                    }
                }
            }
        }
    }
  return (false);
}
bool CZigZagAverageIndicator::IsPriceTop()
{
  if(_openPrice >= _averagePrice)
    {
      int copies                = 0;
      double bottomAveragePrice = GetTopOrBottomPrice(tableBottom, 1, 10, copies);
      bottomAveragePrice /= copies;
      if(_openPrice >= bottomAveragePrice)
        {
          if(_zigZagDirection == 1)
            {
              copies             = 0;
              double topPrice    = tableTop.GetValueByRotary(tableTop.GetSize() - 1);
              double buttomPrice = tableBottom.GetValueByRotary(tableBottom.GetSize() - 1);
              if(buttomPrice > _averagePrice && topPrice > _averagePrice)
                {
                  double topAveragePrice = GetTopOrBottomPrice(tableTop, 1, 5, copies);
                  topAveragePrice /= copies;
                  if(topPrice > topAveragePrice)
                    {
                      double lastTopPrice    = tableTop.GetValueByRotary(tableTop.GetSize() - 2);
                      double lastBottomPrice = tableBottom.GetValueByRotary(tableBottom.GetSize() - 2);
                      double diference       = (lastTopPrice - lastBottomPrice) / 5;
                      if(_openPrice > (lastTopPrice - diference))
                        {
                          return (true);
                        }
                    }
                }
            }
        }
    }
  return (false);
}

#endif /* ZIGZAGAVERAGEINDICATOR_INCLUDED */
