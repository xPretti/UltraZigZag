//+------------------------------------------------------------------+
//|                                                     Terminal.mqh |
//|                                        Copyright 2023, Upcoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+

#ifndef TERMINAL_INCLUDED
#define TERMINAL_INCLUDED

class CTerminal
{
  public:
    CTerminal();
    ~CTerminal();

    // Methods
    static string GetAccountTypeName();
    static bool IsHedge();
    static bool IsLiveMarket();
    static string GetTerminalName();
    static bool SymbolIsOperable(string symbol);
    static bool IsVisualMode();
    static bool AlgoTradingIsEnable();
    static bool IsDemo();
    static int GetPing();
    static string GetClient();
    static long GetClientLogin();
};

/**
 * Construtores e Destrutores
 */
CTerminal::CTerminal()
{
}
CTerminal::~CTerminal()
{
}

// Nome da conta
string CTerminal::GetAccountTypeName()
{
  if(AccountInfoInteger(ACCOUNT_TRADE_MODE) == ACCOUNT_TRADE_MODE_REAL)
    {
      return ("REAL");
    }
  if(AccountInfoInteger(ACCOUNT_TRADE_MODE) == ACCOUNT_TRADE_MODE_DEMO)
    {
      return ("DEMO");
    }
  return ("TOURNAMENT");
}
// Retorna se a conta é hedge
bool CTerminal::IsHedge()
{
  return (AccountInfoInteger(ACCOUNT_MARGIN_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_HEDGING);
}
// Retorna se é uma conta demo
bool CTerminal::IsDemo()
{
  return (AccountInfoInteger(ACCOUNT_TRADE_MODE) != ACCOUNT_TRADE_MODE_REAL);
}
// Retorna o ping
int CTerminal::GetPing()
{
  return (TerminalInfoInteger(TERMINAL_PING_LAST));
}
// Retorna o nome do cliente
string CTerminal::GetClient()
{
  return (AccountInfoString(ACCOUNT_NAME));
}
// Retorna o nome do cliente
long CTerminal::GetClientLogin()
{
  return (AccountInfoInteger(ACCOUNT_LOGIN));
}
// Retorna o nome do terminal
string CTerminal::GetTerminalName()
{
  return (TerminalInfoString(TERMINAL_NAME));
}
// Retorna se é mercado ao vivo
bool CTerminal::IsLiveMarket()
{
  return (MQLInfoInteger(MQL_TESTER) == 0);
}
// Retorna se o testador esta no modo visual
bool CTerminal::IsVisualMode()
{
  if(!IsLiveMarket())
    {
      return (MQLInfoInteger(MQL_VISUAL_MODE) == 1);
    }
  return (true);
}

// Retorna se é possível operar no ativo
bool CTerminal::SymbolIsOperable(string symbol)
{
  ENUM_SYMBOL_TRADE_MODE mode = (ENUM_SYMBOL_TRADE_MODE)SymbolInfoInteger(symbol, SYMBOL_TRADE_MODE);
  if(mode != SYMBOL_TRADE_MODE_DISABLED || !IsLiveMarket())
    {
      return (true);
    }
  return (false);
}

// Retorna se o algotrading esta ativado
bool CTerminal::AlgoTradingIsEnable()
{
  return (MQLInfoInteger(MQL_TRADE_ALLOWED) == 1);
}

#endif /* TERMINAL_INCLUDED */
