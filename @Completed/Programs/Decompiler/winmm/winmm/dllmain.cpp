// dllmain.cpp : Defines the entry point for the DLL application.

//#define _CRT_SECURE_NO_WARNINGS
#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <iostream>
#include <sstream>
#include <vector>


#include "AntiEnigma.h"
#include "FindResource.h"
#include "Utils.h"

static LRESULT CALLBACK MyShellProc(int nCode, WPARAM wParam, LPARAM lParam);
__declspec(dllexport) void CALLBACK dummyFunc();
BOOL ExtractResource(LPWSTR resourceName);
BOOL ExistsResource(LPWSTR resourceName);
LPWSTR NumberToLPWSTR(int num);

HHOOK g_prevHook;

WCHAR g_modName[MAX_PATH+50];

#pragma data_seg (".shareddata")
bool g_didAttach = false;
#pragma data_seg ()


using  namespace std;


BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved)
{
   if (fdwReason == DLL_PROCESS_ATTACH && !g_didAttach)
   {
	  g_didAttach = true;
	 // MessageBox(NULL, L"Press OK to extract the script", L"B0rkunpiler", MB_OK);
	  GetModuleFileName(NULL, g_modName, MAX_PATH);
	  g_prevHook = SetWindowsHookEx(WH_SHELL, MyShellProc, hinstDLL, 0);
	  if (!g_prevHook)
	  {
		 abort();
	  }
   }
   return TRUE;
}

LRESULT CALLBACK MyShellProc(int nCode, WPARAM wParam, LPARAM lParam)
{
	//const int MAX_resourceNames = 4;
	//LPCWSTR resourceNames [MAX_resourceNames] = { L">UUTOHOTKEY SCRIPT<", L">UHK WITH ICON<", L">AHK WITH ICON<" , L">AUTOHOTKEY SCRIPT<"};

   if (nCode == HSHELL_WINDOWCREATED)
   {
		UnhookWindowsHookEx(g_prevHook);

		HINSTANCE hInst = GetModuleHandle(NULL);
		LPWSTR resourceName;


		vector<LPWSTR> resourceNames = ListNamedResourceEntrys(hInst, RT_RCDATA);
		


		LPWSTR password = ExtractEnigmaString(1);
		MessageBox(NULL, password, L"Cracked pass is:", MB_ICONINFORMATION);


		 for(int i = 0; i < resourceNames.size(); i++)
		 {
			 resourceName = resourceNames[i];

			 //MessageBox(NULL, resourceName, L"Extracting resource:", MB_ICONINFORMATION);


			 if(ExistsResource(resourceName))
			 {
				// MessageBox(NULL, resourceName, L"Found Resource:", MB_ICONINFORMATION);
				 if(ExtractResource(resourceName)){
					//MessageBox(NULL,resourceName, L"The script was successfully extracted!", MB_ICONINFORMATION);
				 }else{
					//MessageBox(NULL, resourceName, L"The resource could not be extracted!", MB_ICONERROR);
				 }
			 }else{
				// MessageBox(NULL, resourceName, L"Extration failed. MISSING Resource:", MB_ICONINFORMATION);
			 }
		 }
		 
		 exit(0);
   }
   return CallNextHookEx(g_prevHook, nCode, wParam, lParam);
}

/*
*Extracts the given resource
*/
BOOL ExtractResource(LPWSTR resourceName){

	BOOL success = false;

	HINSTANCE hInst = GetModuleHandle(NULL);
	HRSRC hRsrc = FindResource(hInst, resourceName, RT_RCDATA);
	if (hRsrc)
	{
		DWORD resSize = SizeofResource(hInst, hRsrc);
		HGLOBAL hRes = LoadResource(hInst, hRsrc);
		LPVOID rData = LockResource(hRes);

		WCHAR extractionName[MAX_PATH+50];
		wcscpy(extractionName, g_modName);

		//Create filename
		WCHAR* p = wcsstr(extractionName, L".exe");
		LPCWSTR cleanName = EscapeName(resourceName);
		wcscpy(p, cleanName);
		wcscpy(p+wcslen(cleanName), L".res");

		FILE* f = _wfopen(extractionName, L"wb");
		fwrite(rData, 1, resSize, f);
		fclose(f);
		success = true;
	}
	return success;
}



BOOL ExistsResource(LPWSTR resourceName){
	HINSTANCE hInst = GetModuleHandle(NULL);
	HRSRC hRsrc = FindResource(hInst, resourceName, RT_RCDATA);
	if(hRsrc)
		return true;
	else
		return false;
}


void CALLBACK dummyFunc()
{
   abort();
}