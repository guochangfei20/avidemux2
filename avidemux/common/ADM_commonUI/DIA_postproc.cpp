//
// C++ Implementation: ADM_vidForcedPP
//
// Description: 
//
//	Force postprocessing assuming constant quant & image type
//	Uselefull on some badly authored DVD for example
//
// Author: mean <fixounet@free.fr>, (C) 2004
//
// Copyright: See COPYING file that comes with this distribution
//
//

//#include "xonfig.h"
#include "ADM_default.h"


#include "DIA_factory.h"

int DIA_getMPParams( uint32_t *pplevel, uint32_t *ppstrength,bool *swap)
{
        

#define PX(x) x
        
    diaElemUInteger   postProcStrength(PX(ppstrength),QT_TRANSLATE_NOOP("adm","_Filter strength:"),0,5);
    diaElemToggle     swapuv(PX(swap),QT_TRANSLATE_NOOP("adm","_Swap U and V"));
    
    bool hzd,vzd,dring;
    
#define DOME(x,y) if(*pplevel & x) y=1;else y=0;
    
    DOME(1,hzd);
    DOME(2,vzd);
    DOME(4,dring);
    
     diaElemToggle     fhzd(&hzd,QT_TRANSLATE_NOOP("adm","_Horizontal deblocking"));
     diaElemToggle     fvzd(&vzd,QT_TRANSLATE_NOOP("adm","_Vertical deblocking"));
     diaElemToggle     fdring(&dring,QT_TRANSLATE_NOOP("adm","_Deringing"));
    
    
    
      diaElem *elems[5]={&postProcStrength,&swapuv,&fhzd
                        ,&fvzd,&fdring};

   if(diaFactoryRun("Postprocessing",5,elems))
  {
#undef DOME
#define DOME(x,y) if(y) *pplevel |=x;
    *pplevel=0;
    DOME(1,hzd);
    DOME(2,vzd);
    DOME(4,dring);
    return 1;
  }
  return 0;	
}
