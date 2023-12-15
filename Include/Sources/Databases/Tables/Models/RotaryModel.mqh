//+------------------------------------------------------------------+
//|                                                  RotaryModel.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+

#ifndef ROTARYMODEL_INCLUDED
#define ROTARYMODEL_INCLUDED

template<typename C, typename V>
class CRotaryModel : public C
{
  protected:
    uint _startIndex;
    uint _maxSize;
    //.
    int _currentIndex;
    int _fistIndex;

  public:
    CRotaryModel(uint maxSize);
    ~CRotaryModel();

    // Parameters
    //- SET
    void SetMaxSize(uint maxSize);
    //- GET
    int GetMaxSize() { return ((int)_maxSize); };

    // Methods
    //- GET
    uint GetStartIndex() { return (_startIndex); };
    int GetRotaryIndex(int normalIndex);
    V GetValueByRotary(int normalIndex) { return (GetValue(GetRotaryIndex(normalIndex))); };

    //- SET
    bool Add(V setClass) override;
    bool SetValue(int index, V setClass) override;
    bool Remove(int index) override;
    void Reset() override;
    void ResetSequenceCount() override
    {
      C::ResetSequenceCount();
      _currentIndex = -1;
      _fistIndex    = -2;
    };

  protected:
    void IndexIncrease();
    void IndexDecrease();
    bool IndexIncrease(uint& value);
    bool IndexDecrease(uint& value);
    bool IndexFixer(int index);
    bool IndexFixerBigger();
    bool IndexFixerSmaller(int index);
};

/**
 * Contrutores e Destrutores
 */
template<typename C, typename V>
CRotaryModel::CRotaryModel(uint maxSize)
{
  _startIndex = 0;
  _maxSize   = maxSize;
}
template<typename C, typename V>
CRotaryModel::~CRotaryModel()
{
}

/**
 * Define o tamanho da tabela e deleta o excesso
 */
template<typename C, typename V>
void CRotaryModel::SetMaxSize(uint maxSize)
{
  if(maxSize < _maxSize)
    {
      int deleteIndex = -1;
      while(GetSize() > (int)maxSize)
        {
          deleteIndex = GetSize() - 1;
          Remove(deleteIndex);
        }
    }
  _maxSize = maxSize;
}

/**
 * Adiciona um novo elemento
 */
template<typename C, typename V>
bool CRotaryModel::Add(V setClass)
{
  if(_maxSize > 0)
    {
      int index = (uint)GetSize() >= _maxSize ? (int)_startIndex : -1;
      if(index == -1)
        {
          return (C::Add(setClass));
        }
      else
        {
          if(SetValue(index, setClass))
            {
              IndexIncrease();
              return (true);
            }
        }
    }
  return (false);
}

/**
 * Seta um valor apartir de uma index
 */
template<typename C, typename V>
bool CRotaryModel::SetValue(int index, V setClass)
{
  if(_maxSize > 0)
    {
      if(index >= 0 && index < GetSize())
        {
          return (C::SetValue(index, setClass));
        }
      else
        {
          return (Add(setClass));
        }
    }
  return (false);
}

/**
 * Retorna o index rotativo usando o index normal
 */
template<typename C, typename V>
int CRotaryModel::GetRotaryIndex(int normalIndex)
{
  if(normalIndex >= 0 && normalIndex < GetSize())
    {
      int intStartIndex = int(_startIndex);
      int normalPos     = normalIndex + 1;
      int size          = GetSize();
      int space         = size - intStartIndex;
      int goBack        = normalPos - space;
      if(goBack <= 0)
        {
          return (intStartIndex + normalIndex);
        }
      else
        {
          return ((normalPos - space) - 1);
        }
    }
  return (-1);
}

/**
 * Remove um elemento
 */
template<typename C, typename V>
bool CRotaryModel::Remove(int index)
{
  if(index >= 0 && index < GetSize())
    {
      int lastIndex = GetSize() - 1;
      if(C::Remove(index))
        {
          IndexFixer(index);
          return (true);
        }
    }
  return (false);
}
template<typename C, typename V>
void CRotaryModel::Reset()
{
  _startIndex = 0;
  C::Reset();
}

/**
 * Aumenta ou diminui o valor do primeiro elemento da tabela
 */
template<typename C, typename V>
void CRotaryModel::IndexIncrease()
{
  IndexIncrease(_startIndex);
}
template<typename C, typename V>
void CRotaryModel::IndexDecrease()
{
  IndexDecrease(_startIndex);
}
template<typename C, typename V>
bool CRotaryModel::IndexIncrease(uint& value)
{
  value++;
  if(value >= (uint)GetSize())
    {
      value = 0;
      return (true);
    }
  return (false);
}
template<typename C, typename V>
bool CRotaryModel::IndexDecrease(uint& value)
{
  int lastIndex = GetSize() - 1;
  int fixIndex  = lastIndex >= 0 ? lastIndex : 0;
  value         = value == 0 ? fixIndex : value - 1;
  return (value == fixIndex);
}

/**
 * Corrige o index
 */
template<typename C, typename V>
bool CRotaryModel::IndexFixer(int index)
{
  return (IndexFixerSmaller(index) || IndexFixerBigger());
}
template<typename C, typename V>
bool CRotaryModel::IndexFixerBigger()
{
  int lastIndex = GetSize() - 1;
  if(_startIndex > (uint)lastIndex)
    {
      _startIndex = 0;
      return (true);
    }
  return (false);
}
template<typename C, typename V>
bool CRotaryModel::IndexFixerSmaller(int index)
{
  if((uint)index < _startIndex)
    {
      IndexDecrease();
      return (true);
    }
  return (false);
}


#endif /* ROTARYMODEL_INCLUDED */
