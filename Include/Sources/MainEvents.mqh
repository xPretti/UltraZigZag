//+------------------------------------------------------------------+
//|                                                   MainEvents.mqh |
//|                                        Copyright 2023, Upcoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+

#ifndef MAINEVENTS_INCLUDED
#define MAINEVENTS_INCLUDED

class CMainEvents
{
  public:
    CMainEvents();
    ~CMainEvents();

    // Builders
    virtual int OnStart() { return (INIT_SUCCEEDED); };
    virtual void OnStop(const int reason){};

    // Updades
    //- Tick
    virtual void OnTick(){};
    virtual void OnLateTick(){};

    //- Timer
    virtual void OnTimer(){};
    virtual void OnLateTimer(){};

    //- Calculators
    virtual void OnCalculate(const int total, const int pos, const datetime& time[], const double& open[], const double& high[], const double& low[], const double& close[],
                             const long& tick_volume[], const long& volume[], const int& spread[]){};

    // Others
    virtual void OnError(int error){};
    virtual void OnOnline(){};
    virtual void OnOffline(){};

    // Orders and Objects
    virtual void OnTrade(){};
    virtual void OnTradeTransaction(const MqlTradeTransaction& trans, const MqlTradeRequest& request, const MqlTradeResult& result){};
    virtual void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam){};
};

/**
 * Contrutores e Destrutores
 */
CMainEvents::CMainEvents()
{
}
CMainEvents::~CMainEvents()
{
}

#endif /* MAINEVENTS_INCLUDED */
