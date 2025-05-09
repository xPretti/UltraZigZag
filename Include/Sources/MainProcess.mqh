//+------------------------------------------------------------------+
//|                                                  MainProcess.mqh |
//|                                        Copyright 2023, Upcoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+

#ifndef MAINPROCESS_INCLUDED
#define MAINPROCESS_INCLUDED

#include "Returns/Check.mqh"
#include "Returns/Count.mqh"
#include "Returns/Terminal.mqh"
#include "MainEvents.mqh"

// Checks
#include "CheckTimer/NewMS.mqh"
#include "CheckTimer/NewSecond.mqh"

class CMainProcess
{
  private:
    CMainEvents* mainEvents;

  private:
    uint _milliSecondUpdate;

  private:
    bool _isOnline;
    bool _firstInit;

  private:
    // Checks
    CNewSecond onSecond;
    CNewMS onBacktestMs;

  public:
    CMainProcess(CMainEvents* main, uint millisecond);
    ~CMainProcess();

    // Eventos
    int OnInit();
    void OnDeinit(const int reason);
    void OnTick();
    void OnTimer();
    int OnCalculate(const int rates_total, const int prev_calculated, const datetime& time[], const double& open[], const double& high[], const double& low[], const double& close[],
                    const long& tick_volume[], const long& volume[], const int& spread[]);
    void OnTrade(void);
    void OnTradeTransaction(const MqlTradeTransaction& trans, const MqlTradeRequest& request, const MqlTradeResult& result);
    void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam);
  
  protected:
    int OnStart();
    void OnStop(const int reason);
    
  private:
    void BacktestTimer();
    void UpdateEvents();
    void UpdateTickEvents();
    void CheckError();
    void CheckDowntime();
    bool StartTimer();

  private:
    void OnSecond();
};

/**
 * Contrutores e Destrutores
 */
CMainProcess::CMainProcess(CMainEvents* main, uint millisecond)
    : _firstInit(true),
      _isOnline(true),
      onSecond(1),
      onBacktestMs(1)
{
  mainEvents         = main;
  _milliSecondUpdate = millisecond;
}
CMainProcess::~CMainProcess()
{
}

/**
 * Inicializadores padrão
 */
int CMainProcess::OnInit()
{
  return (OnStart());
}
void CMainProcess::OnDeinit(const int reason)
{
  OnStop(reason);
}

/**
 * Eventos de inicialização e finalização
 */
int CMainProcess::OnStart()
{
  StartTimer();
  return (mainEvents.OnStart());
}
void CMainProcess::OnStop(const int reason)
{
  EventKillTimer();
  mainEvents.OnStop(reason);
}

/**
 * Eventos de atualização
 */
void CMainProcess::OnTick()
{
  CCount::OnTick();
  BacktestTimer();
  mainEvents.OnTick();

  // Ultimo update
  mainEvents.OnLateTick();
}
void CMainProcess::OnTimer()
{
  if(CTerminal::IsLiveMarket())
    {
      CCount::Update();
    }
  UpdateEvents();

  // Ultimo update
  mainEvents.OnLateTimer();
}
int CMainProcess::OnCalculate(const int rates_total, const int prev_calculated, const datetime& time[], const double& open[], const double& high[], const double& low[], const double& close[],
                              const long& tick_volume[], const long& volume[], const int& spread[])
{
  int pos = prev_calculated == 0 ? 1 : prev_calculated - 1;
  for(int i = pos; i < rates_total; i++)
    {
      mainEvents.OnCalculate(rates_total, i, time, open, high, low, close, tick_volume, volume, spread);
    }
  OnTick();
  return (rates_total);
}
void CMainProcess::OnTrade()
{
  mainEvents.OnTrade();
}
void CMainProcess::OnTradeTransaction(const MqlTradeTransaction& trans, const MqlTradeRequest& request, const MqlTradeResult& result)
{
  mainEvents.OnTradeTransaction(trans, request, result);
}
void CMainProcess::OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
{
  mainEvents.OnChartEvent(id, lparam, dparam, sparam);
}

/**
 * Outros métodos
 */
void CMainProcess::UpdateEvents()
{
  mainEvents.OnTimer();
  if(onSecond.IsOverpass())
    {
      OnSecond();
    }
}
void CMainProcess::CheckError()
{
  if(GetLastError() != 0)
    {
      if(CTerminal::IsVisualMode())
        {
          mainEvents.OnError(GetLastError());
          ResetLastError();
        }
    }
}
void CMainProcess::CheckDowntime()
{
  if(CCheck::IsIdle() != _isOnline)
    {
      _isOnline = !_isOnline;
      if(!_isOnline)
        {
          mainEvents.OnOnline();
        }
      else
        {
          mainEvents.OnOffline();
        }
    }
}
bool CMainProcess::StartTimer()
{
  if(CTerminal::IsLiveMarket() && _milliSecondUpdate > 0)
    {
      return (EventSetMillisecondTimer(_milliSecondUpdate));
    }
  return (false);
}

/**
 * Eventos customizados
 */
void CMainProcess::OnSecond()
{
  CheckDowntime();
  CheckError();
}

/**
 * Correções para backtest
 */
void CMainProcess::BacktestTimer()
{
  if(!CTerminal::IsLiveMarket())
    {
      CCount::Update();
      if(onBacktestMs.IsOverpass())
        {
          OnTimer();
        }
    }
}

#endif /* MAINPROCESS_INCLUDED */
