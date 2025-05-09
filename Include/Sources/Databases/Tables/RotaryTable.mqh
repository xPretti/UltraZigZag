//+------------------------------------------------------------------+
//|                                                  RotaryTable.mqh |
//|                                        Copyright 2023, Upcoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+

#ifndef ROTARYTABLE_INCLUDED
#define ROTARYTABLE_INCLUDED

#include "Models/RotaryModel.mqh"
#include "Table.mqh"

template<typename T>
class CRotaryTable : public CRotaryModel<CTable<T>, T>
{
  public:
    CRotaryTable(uint maxIndex);
    ~CRotaryTable();

    // Methods
    //- GET
    ENUM_TABLE_GET_TYPE GetNextValue(T& getValue) override;
    ENUM_TABLE_GET_TYPE GetPreviousValue(T& getValue) override;
};

/**
 * Contrutores e Destrutores
 */
template<typename T>
CRotaryTable::CRotaryTable(uint maxIndex) : CRotaryModel(maxIndex)
{
}
template<typename T>
CRotaryTable::~CRotaryTable()
{
}

/**
 * Retorna os valores em sequencia
 */
template<typename T>
ENUM_TABLE_GET_TYPE CRotaryTable::GetNextValue(T& getValue)
{
  if(_currentIndex != _fistIndex)
    {
      if(_currentIndex == -1)
        {
          _currentIndex = (int)_startIndex;
          _fistIndex    = _currentIndex;
        }
      if(_currentIndex >= 0 && _currentIndex < GetSize())
        {
          getValue = GetValue(_currentIndex);
          IndexIncrease(_currentIndex);
          return (TABLE_GET_TYPE_GET);
        }
    }
  ResetSequenceCount();
  return (TABLE_GET_TYPE_END);
}
template<typename T>
ENUM_TABLE_GET_TYPE CRotaryTable::GetPreviousValue(T& getValue)
{
  if(_currentIndex != _fistIndex)
    {
      if(_currentIndex == -1)
        {
          _currentIndex = (int)_startIndex;
          IndexDecrease(_currentIndex);
          _fistIndex = _currentIndex;
        }
      if(_currentIndex >= 0 && _currentIndex < GetSize())
        {
          getValue = GetValue(_currentIndex);
          IndexDecrease(_currentIndex);
          return (TABLE_GET_TYPE_GET);
        }
    }
  ResetSequenceCount();
  return (TABLE_GET_TYPE_END);
}


#endif /* ROTARYTABLE_INCLUDED */
