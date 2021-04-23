// hyde.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"
#include "hyde.h"

// Callback procedure for WH_CBT hook. Will work with any SetWindowsHookEx type
extern HYDE_API LRESULT WINAPI CBProc( int nCode, WPARAM wParam, LPARAM lParam )
{
	return CallNextHookEx( 0,nCode,wParam,lParam );
}
