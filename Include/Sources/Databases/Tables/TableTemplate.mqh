//+------------------------------------------------------------------+
//|                                                TableTemplate.mqh |
//|                                       Copyright 2022, UltraCode. |
//|                                       https://docs.ultracode.org |
//+------------------------------------------------------------------+

#ifndef TABLETEMPLATE_INCLUDED
#define TABLETEMPLATE_INCLUDED

#include "Table.mqh"

template<typename T>
class CTableTemplate : public CTable<T*>
{
  public:
    bool IsValid(T* checkClass) { return (CheckPointer(checkClass) != POINTER_INVALID); };
    bool IsEqual(T* v1, T* v2);

  public:
    CTableTemplate();
    ~CTableTemplate();

    // GET
    virtual bool GetValidValue(int index, T*& getValue) override;
    virtual ENUM_TABLE_GET_TYPE GetValue(int index, T*& getValue);
    virtual T* GetValue(int index) override { return (CTable<T*>::GetValue(index)); };
    virtual ENUM_TABLE_GET_TYPE GetNextValue(T*& getValue) override;
    virtual ENUM_TABLE_GET_TYPE GetPreviousValue(T*& getValue) override;

    // SET
    virtual bool Add(T* value) override;
    virtual bool SetValue(int index, T* value) override;
    virtual bool Replace(int index, T* value) override;
    virtual bool Remove(int index) override;
    virtual bool RemovePointer(int index);
    virtual bool RemovePointerByNotEqual(int index, T* compareValue);
    virtual bool RemoveNoDestroy(int index);
    virtual bool RemoveRange(int startIndex, int removeAmount);
    virtual bool SetSize(int v) override;
    virtual bool SetSizeNoDestroy(int v);
    virtual void Reset() override;
    virtual void ResetNoDestroy();
    void RamFree();
};

/**
 * Construtores e Destrutores
 */
template<typename T>
CTableTemplate::CTableTemplate()
{
}
template<typename T>
CTableTemplate::~CTableTemplate()
{
  Reset();
}

/**
 * Adiciona um novo elemento
 */
template<typename T>
bool CTableTemplate::Add(T* value)
{
  if(IsValid(value))
    {
      return (CTable<T*>::Add(value));
    }
  return (false);
}

/**
 * Retorna o valor armazenado neste elemento
 */
template<typename T>
bool CTableTemplate::GetValidValue(int index, T*& getValue)
{
  return (GetValue(index, getValue)==TABLE_GET_TYPE_GET);
}
template<typename T>
ENUM_TABLE_GET_TYPE CTableTemplate::GetValue(int index, T*& getValue)
{
  if(IsValidRange(index))
    {
      getValue = GetValue(index);
      if(IsValid(getValue))
        {
          return (TABLE_GET_TYPE_GET);
        }
      return (TABLE_GET_TYPE_NO_GET_NO_END);
    }
  return (TABLE_GET_TYPE_END);
}

template<typename T>
ENUM_TABLE_GET_TYPE CTableTemplate::GetNextValue(T*& getValue)
{
  if(CTable<T*>::GetNextValue(getValue) != TABLE_GET_TYPE_END)
    {
      if(IsValid(getValue))
        {
          return (TABLE_GET_TYPE_GET);
        }
      return (TABLE_GET_TYPE_NO_GET_NO_END);
    }
  return (TABLE_GET_TYPE_END);
}
template<typename T>
ENUM_TABLE_GET_TYPE CTableTemplate::GetPreviousValue(T*& getValue)
{
  if(CTable<T*>::GetPreviousValue(getValue) != TABLE_GET_TYPE_END)
    {
      if(IsValid(getValue))
        {
          return (TABLE_GET_TYPE_GET);
        }
      return (TABLE_GET_TYPE_NO_GET_NO_END);
    }
  return (TABLE_GET_TYPE_END);
}

/**
 * Remove e define o novo elemento
 */
template<typename T>
bool CTableTemplate::SetValue(int index, T* value)
{
  if(IsValid(value))
    {
      if(RemovePointerByNotEqual(index, value))
        {
          return (CTable<T*>::SetValue(index, value));
        }
    }
  return (false);
}
template<typename T>
bool CTableTemplate::Replace(int index, T* value)
{
  if(IsValid(value))
    {
      if(RemovePointerByNotEqual(index, value))
        {
          return (CTable<T*>::Replace(index, value));
        }
    }
  return (false);
}

/**
 * Define o novo tamanho do array
 */
template<typename T>
bool CTableTemplate::SetSize(int v)
{
  if(v < GetSize())
    {
      int removeAmount = GetSize() - v;
      int startIndex   = v;
      return (CTableTemplate::RemoveRange(startIndex, removeAmount));
    }
  return (SetSizeNoDestroy(v));
}
template<typename T>
bool CTableTemplate::SetSizeNoDestroy(int v)
{
  return (CTable<T*>::SetSize(v));
}

/**
 * Métodos diversos
 */
template<typename T>
bool CTableTemplate::Remove(int index)
{
  RemovePointer(index);
  return (CTable<T*>::Remove(index));
}
template<typename T>
bool CTableTemplate::RemovePointer(int index)
{
  if(IsValidRange(index))
    {
      T* getRef = NULL;
      if(GetValue(index, getRef))
        {
          if(IsValid(getRef))
            {
              delete(getRef);
              return (true);
            }
          else
            {
              return (true);
            }
        }
    }
  return (false);
}
template<typename T>
bool CTableTemplate::RemovePointerByNotEqual(int index, T* compareValue)
{
  if(IsValidRange(index))
    {
      T* getRef = NULL;
      if(GetValue(index, getRef))
        {
          if(IsValid(getRef))
            {
              if(!IsEqual(getRef, compareValue))
                {
                  delete(getRef);
                  return (true);
                }
            }
          else
            {
              return (true);
            }
        }
    }
  return (false);
}
template<typename T>
bool CTableTemplate::RemoveNoDestroy(int index)
{
  return (CTable<T*>::Remove(index));
}
template<typename T>
bool CTableTemplate::RemoveRange(int startIndex, int removeAmount)
{
  if(removeAmount > 0)
    {
      int newIndex = startIndex <= 0 ? 0 : startIndex;
      if(newIndex < GetSize())
        {
          int size  = GetSize();
          int count = 0;
          for(int i = size - 1; i >= 0; i--)
            {
              if(count >= removeAmount)
                {
                  break;
                }
              CTableTemplate::Remove(i);
              count++;
            }
          return (count > 0);
        }
    }
  return (false);
}
template<typename T>
void CTableTemplate::Reset()
{
  int size = GetSize();
  for(int i = size - 1; i >= 0; i--)
    {
      CTableTemplate::Remove(i);
    }
  RamFree();
}
template<typename T>
void CTableTemplate::ResetNoDestroy()
{
  int size = GetSize();
  for(int i = size - 1; i >= 0; i--)
    {
      CTableTemplate::RemoveNoDestroy(i);
    }
  RamFree();
}
template<typename T>
void CTableTemplate::RamFree()
{
  ArrayFree(_value);
  ResetSequenceCount();
}


/**
 * Compara dois ponteiros
 */
template<typename T>
bool CTableTemplate::IsEqual(T* v1, T* v2)
{
  if(IsValid(v1) && IsValid(v2))
    {
      return (v1==v2);
    }
  return (false);
}

#endif /* TABLETEMPLATE_INCLUDED */
