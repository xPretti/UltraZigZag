//+------------------------------------------------------------------+
//|                                                       Table.mqh  |
//|                                       Copyright 2022, Upcoding.  |
//|                                       https://www.upcoding.net   |
//+------------------------------------------------------------------+

#ifndef TABLE_INCLUDED
#define TABLE_INCLUDED

#include "../../Enumerators/TableEnum.mqh"

template<typename T>
// clang-format off
class CTable
{
  protected:
    T _value[];

  private:
    int _lastSequenceIndex;
    int _selectIndex;
    int _lastAddIndex;
    bool _tableTableWasModified;
    int _startSequenceIndex;

  protected:
    int _count;

  public:
    CTable();
    ~CTable();
    
    //Methods
    bool IsValidRange(int index) { return (index >= 0 && index < GetSize()); }; 
    
    // GET
    int GetSize() { return (_count); };
    int GetSelectIndex() { return (_selectIndex); };
    int GetLastAddIndex() { return (_lastAddIndex); };
    virtual bool GetValidValue(int index, T& getValue);
    virtual T GetValue(int index);
    virtual ENUM_TABLE_GET_TYPE GetNextValue(T& getValue);
    virtual ENUM_TABLE_GET_TYPE GetPreviousValue(T& getValue);
    bool TableWasModified() { return (_tableTableWasModified); };
    bool TableWasModified(bool newValue) { bool v = _tableTableWasModified;SetTableModified(newValue); return (v); };
    int GetStartSequenceCount() { return (_startSequenceIndex); };

    // SET
    virtual bool Add(T value);
    virtual bool SetValue(int index, T value);
    virtual bool Replace(int index, T value);
    virtual bool Remove(int index);
    virtual bool SetSize(int v);
    virtual void Reset();
    virtual void ResetSequenceCount() { SetSequenceCount(_startSequenceIndex); };
    virtual bool SetSequenceCount(int v) { _lastSequenceIndex = IsValidRange(v) ? v : _startSequenceIndex; return (IsValidRange(v));};
    void SetTableModified(bool v) { _tableTableWasModified = v; };
    
};
// clang-format on

/**
 * Construtores e Destrutores
 */
template<typename T>
CTable::CTable()
{
  _startSequenceIndex = -2;
  _count        = 0;
  _selectIndex  = 0;
  _lastAddIndex = 0;
  ResetSequenceCount();
}
template<typename T>
CTable::~CTable()
{
  Reset();
}

/**
 * Adiciona um novo elemento
 */
template<typename T>
bool CTable::Add(T value)
{
  int lastSize = _count;
  _selectIndex = lastSize;
  _lastAddIndex = _selectIndex;
  if(SetSize(_count + 1))
    {
      _value[lastSize] = value;
      SetTableModified(true);
      return (true);
    }
  return (false);
}

/**
 * Retorna o valor armazenado neste elemento
 */
template<typename T>
bool CTable::GetValidValue(int index, T& getValue)
{
  if(IsValidRange(index))
    {
      _selectIndex = index;
      getValue = _value[index];
      return (true);
    }
  return (false);
}
template<typename T>
T CTable::GetValue(int index)
{
  if(IsValidRange(index))
    {
      _selectIndex = index;
      return (_value[index]);
    }
  return (NULL);
}


template<typename T>
ENUM_TABLE_GET_TYPE CTable::GetNextValue(T& getValue)
{
  if(_lastSequenceIndex == -2)
    {
      _lastSequenceIndex = 0;
    }
  if(_lastSequenceIndex >= 0 && _lastSequenceIndex < GetSize())
    {
      getValue = GetValue(_lastSequenceIndex);
      _lastSequenceIndex++;
      return (TABLE_GET_TYPE_GET);
    }
  ResetSequenceCount();
  return (TABLE_GET_TYPE_END);
}
template<typename T>
ENUM_TABLE_GET_TYPE CTable::GetPreviousValue(T& getValue)
{
  if(_lastSequenceIndex == -2)
    {
      _lastSequenceIndex = GetSize() - 1;
    }
  if(_lastSequenceIndex >= 0 && _lastSequenceIndex < GetSize())
    {
      getValue = GetValue(_lastSequenceIndex);
      _lastSequenceIndex--;
      return (TABLE_GET_TYPE_GET);
    }
  ResetSequenceCount();
  return (TABLE_GET_TYPE_END);
}

/**
 * Remove e define o novo elemento
 */
template<typename T>
bool CTable::SetValue(int index, T value)
{
  if(!Replace(index, value))
    {
      return (Add(value));
    }
  return (true);
}

/**
 * Reescreve um elemento por outro
 */
template<typename T>
bool CTable::Replace(int index, T value)
{
  if(IsValidRange(index))
    {
      _selectIndex  = index;
      _lastAddIndex = _selectIndex;
      _value[index] = value;
      SetTableModified(true);
      return (true);
    }
  return (false);
}

/**
 * Define o novo tamanho do array
 */
template<typename T>
bool CTable::SetSize(int v)
{
  if(ArrayResize(_value, v) > 0)
    {
      _count = (int)_value.Size();
      SetTableModified(true);
      return (true);
    }
  return (true);
}

/**
 * Métodos diversos
 */
template<typename T>
bool CTable::Remove(int index)
{
  if(IsValidRange(index))
    {
      ArrayRemove(_value, index, 1);
      _count--;
      SetTableModified(true);
      return (true);
    }
  return (false);
}
template<typename T>
void CTable::Reset()
{
  int size = GetSize();
  for(int i = size - 1; i >= 0; i--)
    {
      Remove(i);
    }
  ArrayFree(_value);
  ResetSequenceCount();
  SetTableModified(true);
}

#endif /* TABLE_INCLUDED */
