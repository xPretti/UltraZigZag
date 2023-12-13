//+------------------------------------------------------------------+
//|                                                     MainRefs.mqh |
//|                                        Copyright 2023, UpCoding. |
//|                                         https://www.upcoding.net |
//+------------------------------------------------------------------+


#ifndef MAINREFS_INCLUDED
#define MAINREFS_INCLUDED

#include "MainEvents.mqh"

/**
 * Declarations 
 */
//class CTest;


// clang-format off
class CMainRefs : public CMainEvents
{
  public:
    CMainRefs();
    ~CMainRefs();
    
    // References
    //- GET
    //virtual CTest* GetTestRef() { return (NULL); };
    
};
// clang-format on

/**
 * Global reference
 */
CMainRefs* mainRef;
CMainRefs* GetMain() { return (mainRef); };
void SetMain(CMainRefs* ref) { mainRef = ref; };
bool ExistMain() { return (CheckPointer(mainRef) != POINTER_INVALID); };

/**
 * Contrutores e Destrutores
 */
CMainRefs::CMainRefs()
{
  if(!ExistMain())
    {
      SetMain(GetPointer(this));
    }
  else
    {
      Print("\nFATAL ERROR: Class CMainRefs is being initialized in more than one instance.\n ");
    }
}
CMainRefs::~CMainRefs()
{  
}


#endif /* MAINREFS_INCLUDED */

