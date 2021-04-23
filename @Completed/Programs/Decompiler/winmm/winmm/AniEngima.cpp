
#include "AntiEnigma.h"
#include "Utils.h"

#include <windows.h>

LPWSTR ExtractEnigmaString(int id){

	HMODULE enigma_ide;
	LPCSTR lpProcName;
	LPWSTR extractedStr;

	enigma_ide = GetModuleHandle(L"enigma_ide.dll");
	if(enigma_ide != NULL)
	{
		ENIGMA_ProtectedStringByID pProtectedStringByID = (ENIGMA_ProtectedStringByID) GetProcAddress(enigma_ide,  "EP_ProtectedStringByID");
		if(pProtectedStringByID != NULL)
		{
			extractedStr = WR_EP_ProtectedStringByID(1, pProtectedStringByID);
		}else{
			MessageBox(NULL, L"Can't find the method EP_ProtectedStringByID in module!", L"enigma cracker", MB_ICONINFORMATION);
		}
	}else{
		MessageBox(NULL, L"Can't find enigma_ide.dll module!", L"enigma cracker", MB_ICONINFORMATION);
	}
	return extractedStr;
}


LPWSTR WR_EP_ProtectedStringByID(int id, ENIGMA_ProtectedStringByID pProtectedStringByID)
{
   WCHAR* wbuffer;

   int strlen = pProtectedStringByID(id, NULL, 0);

   if(strlen > 0)
   {   
	   wbuffer = new WCHAR[strlen];
	   pProtectedStringByID(id, wbuffer, strlen);
   }else{
	    MessageBox(NULL, L"Cant find a string with the given id.", L"Uff.", MB_ICONINFORMATION);
   }

   return wbuffer;
}