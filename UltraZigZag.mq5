//+------------------------------------------------------------------+
//|                                               IndicatorModel.mq5 |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+
/**
 * Propiedades do indicador
 */
#property indicator_chart_window
#property indicator_buffers 12
#property indicator_plots   2
// cores
#property indicator_label1  "ZigZag Line"
#property indicator_type1   DRAW_COLOR_ZIGZAG
#property indicator_color1  clrMediumSpringGreen, clrYellow
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2
//
#property indicator_label2  "Median Line"
#property indicator_type2   DRAW_COLOR_LINE
#property indicator_color2  clrLime, clrTomato, clrWhite
#property indicator_style2  STYLE_SOLID
#property indicator_width2  2

// Bibliotecas
#include "Include/Sources/Main.mqh"
#include "Include/Sources/MainProcess.mqh"

// Informações do robô
#property copyright Copyright
#property version Version
#property link Site
#property icon Icon
//- descrição
#ifdef Description01 #property description Description01 #endif
#ifdef Description02 #property description Description02 #endif
#ifdef Description03 #property description Description03 #endif
#ifdef Description04 #property description Description04 #endif
#ifdef Description05 #property description Description05 #endif
#ifdef Description06 #property description Description06 #endif
#ifdef Description07 #property description Description07 #endif
#ifdef Description08 #property description Description08 #endif

// Classes globais
CMain mainClass;

// Main process
CMainProcess mainProcess(GetMain(), 1);

/**
 * Evento de inicialização
 */
int OnInit()
{  
  return (mainProcess.OnInit());
}

/**
 * Evento de finalização
 */
void OnDeinit(const int reason)
{
  mainProcess.OnDeinit(reason);
}

/**
 * Evento dos cálculos
 */
int OnCalculate(const int rates_total, const int prev_calculated, const datetime& time[], const double& open[], const double& high[], const double& low[], const double& close[],
                const long& tick_volume[], const long& volume[], const int& spread[])
{
  return (mainProcess.OnCalculate(rates_total, prev_calculated, time, open, high, low, close, tick_volume, volume, spread));
}

/**
 * Evento de tempo predefinido
 */
void OnTimer()
{
  mainProcess.OnTimer();
}

/**
 * EVENTOS DO GRÁFICO
 * Evento de atualização do gráfico e objetos
 */
void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
{
  mainProcess.OnChartEvent(id, lparam, dparam, sparam);
}

/**
 * EVENTOS DE TRADE
 * - Eventos simples e avançados de atualização das ordens
 */
void OnTrade()
{
  mainProcess.OnTrade();
}
void OnTradeTransaction(const MqlTradeTransaction& trans, const MqlTradeRequest& request, const MqlTradeResult& result)
{
  mainProcess.OnTradeTransaction(trans, request, result);
}