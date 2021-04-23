
#include "Utils.h"
#include "ResCommon.h"



DWORD ResDirVAFromHMODULE (HMODULE ImageBase, WORD *lpwErrorCode)
{
	DWORD resourceVA = 0;

	_IMAGE_DOS_HEADER *dosHeader = (_IMAGE_DOS_HEADER*)ImageBase;



	if(dosHeader->e_magic == IMAGE_DOS_SIGNATURE)
	{ // seems to be the correct module address pointing to the dos header

		// now we go our way down to the resource directory
		PIMAGE_NT_HEADERS  ntheader =  (PIMAGE_NT_HEADERS) ((DWORD)ImageBase + dosHeader->e_lfanew);
		if(ntheader->Signature == IMAGE_NT_SIGNATURE)
		{ // found IMAGE_NT_SIGNATURE (PE-Header)
			DWORD resourceRVA  = ntheader->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_RESOURCE].VirtualAddress;
			resourceVA = (DWORD)ImageBase + resourceRVA; // get the virtual address
		}
	}

	//MessageBox(NULL, NumberToLPWSTR(resourceVA) , L"resource VA:", MB_ICONINFORMATION);

	return resourceVA;
}

