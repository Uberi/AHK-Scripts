#include <vector>
#include "FindResource.h"
#include "ResCommon.h"
#include "Utils.h"

using  namespace std;
	/*
	// The resource tree has 4 levels. Each node on the first 3 levels consist
	// of an IMAGE_RESOURCE_DIRECTORY that is followed by variable number
	// of IMAGE_RESOURCE_DIRECTORY_ENTRY structures. Only the 
	// IMAGE_RESOURCE_DIRECTORY_ENTRY structures contain important info
	// for us. They always point (OffsetToData) to one of the
	// IMAGE_RESOURCE_DIRECTORY structures of the next level and the meaning
	// of their other field (Name) is dependent on the current level (1-3).
	//
	// Meaning of the IMAGE_RESOURCE_DIRECTORY_ENTRY.Name field on each level:
	// Level 1: Resource type. It is usally one of the predefined constants
	//          (RT_CURSOR, RT_BITMAP, RT_ICON....) but if the MSB is set then
	//          the lower 31 bits contain offset to an IMAGE_RESOURCE_DIR_STRING_U
	//          struct that contains the type name of the resource.
	// Level 2: Collection of resources of the same type.
	//          If the most significant bit of the Name field is set then the
	//          lower 31 bits contain an OffsetToData that points to an
	//          IMAGE_RESOURCE_DIR_STRING_U that holds the resource name in
	//          unicode format.
	//          If the most significant bit of the Name field is cleared than
	//          the lower 16 bits contain the resource ID.
	// Level 3: This level can contain more than one entry for the same
	//          resource that is identified by its Name or ID allowing
	//          you to have for example the same dialog in multiple languages.
	//          The Name field here contains a LANGID value.
	//
	// You search for a specific resource by: - TYPE        (level 1)
	//                                        - NAME/ID     (level 2)
	//                                        - LANGUAGE    (level 3)
	//
	// When you ended the search and found the suitable IMAGE_RESOURCE_DIRECTORY_ENTRY
	// on level 3 then its OffsetToData field is a pointer to an
	// IMAGE_RESOURCE_DATA_ENTRY that has no more branches, it is only a bridge
	// between the level 3 IMAGE_RESOURCE_DIRECTORY_ENTRY you found, and the
	// actual resource data whose structure is dependant on the resource type.
	//
	// Important:
	// - On each level the number of actual IMAGE_RESOURCE_DIRECTORY_ENTRY
	//   structures is dependent on two fields of the IMAGE_RESOURCE_DIRECTORY
	//   structure. These fields are NumberOfNamedEntries, and NumberOfIdEntries.
	//   The sum of these fields give the number of entry structures.
	//   NumberOfNamedEntries is always zero and NumberOfIdEntries stores the
	//   number of entries except on the first and second levels. At these levels there
	//   can be either resource Name or ID in the Name field of the entry struct.
	//   NumberOfNameEntries contains the number of named entries and
	//   guess what is in the NumberOfIdEntries field... :)
	//   The IMAGE_RESOURCE_DIRECTORY_ENTRY struct is followed by the Named
	//   entry structs that are in ascending order by Name, and after it
	//   you find the ID entry structs in ascending order by IDs.
	//   Exploiting this you can speed up your search for resource Names and IDs.
	//   You can also make difference between a Named and ID entry structure
	//   by checking the MSB of the Name fields cause it is set for Named entries.
	// - All strings are stored in unicode format in the resource data.
	//   WideCharToMultiByte() and MultiByteToWideChar() should be used for conversion.
	// - The OffsetToData field is always an offset relative to the address
	//   of the first (root) IMAGE_RESOURCE_DIRECTORY whose RVA is also in the
	//   DataDirectory[] of the IMAGE_NT_OPTIONAL header of the PE file.
	//   The only exception is the IMAGE_RESOURCE_DATA_ENTRY structure whose
	//   OffsetToData field contains RVA.
	// - On the 1st and 2nd levels of the tree the most significant bit of
	//   OffsetToData member in the IMAGE_RESOURCE_DIRECTORY_ENTRY structures
	//   is set to 1. This indicates that they point to an IMAGE_RESOURCE_DIRECTORY
	//   struct (a new tree node that has branches) instead of a normal
	//   entry structure. On level 3 and 4 the OffsetToData members always
	//   have their MSB cleared.
	// - Functions that work with resource data always use the
	//   FindResource(), LoadResource(), and LockResource()
	//   functions of KERNEL32.
	//   FindResource() searches a resource for you and retrieves a
	//   pointer (VA) to the IMAGE_RESOURCE_DATA_ENTRY of the specified
	//   resource. LoadResource() does nothing more than calculates a
	//   pointer (VA) to the actual resource data by taking the OffsetToData
	//   member of the IMAGE_RESOURCE_DATA_ENTRY that was found by the
	//   previous call to FindResource(), and converts it to a pointer (VA)
	//   using the ImageBase (HMOUDLE) parameter. SizeOfResource() only
	//   one of the fields of the PIMAGE_RESOURCE_DATA_ENTRY you pass in.
	//   LockResource() is a legacy function from Win16, it does nothing,
	//   returns the pointer you give to it as a parameter.
	// - You can not rely on FindResource() when you pass the address of
	//   a "manually loaded" module. This affects all functions that use
	//   resource data. For example FindResource() does not work on Win9x
	//   because it tries to look up the given HMODULE in the internal
	//   module table, but it works on WinNT. Lot of User32 functions that
	//   use resource (for example CreateDialog()) can be emulated easily.
	//   You must use a "hand made" FindResource() and LoadResource()
	//   function and then call a variant of the wanted function that
	//   operates on raw resource data. For example CreateDialogIndirect()
	//   instead of CreateDialog().
	*/

   

	/*
	// MyLoadResource, MySizeOfResource:
	*/


void *MyLoadResource (
	HMODULE ImageBase,  // dwImageBase
	IMAGE_RESOURCE_DATA_ENTRY *lpDataEntry  // pointer returned by FindResource()
	)
{
	__try
	{
		if (!ImageBase || !lpDataEntry) return NULL;
		return (void*)((DWORD)ImageBase + (lpDataEntry->OffsetToData & 0x7FFFFFFF));
	}
	__except (EXCEPTION_EXECUTE_HANDLER)
	{
		return NULL;
	}
}

DWORD MySizeOfResource (
	IMAGE_RESOURCE_DATA_ENTRY *lpDataEntry  // pointer returned by FindResource()
	)
{
	__try
	{
		return lpDataEntry->Size;
	}
	__except (EXCEPTION_EXECUTE_HANDLER)
	{
		return 0;
	}
}



	/*
	// MyFindResource:
	// The fake of the original Win32 FindResource.
	// Calls InternalFindResourceEx with MAKELANGID (LANG_NEUTRAL, SUBLANG_NEUTRAL).
	// Returns a resource with the language of the current thread, or
	// with the first language in the language directory for the specified
	// resource if the language of the current thread was not found.
	*/

IMAGE_RESOURCE_DATA_ENTRY *MyFindResource (
	DWORD dwResDirVA,   // Pointer (VA) to the root of resource tree.
	LPCTSTR lpName,     // Name or ID of the resource.
	LPCTSTR lpType,     // One of the RT_XXX constants (a MAKEINTRESOURCE() value).
	WORD *lpwErrorCode, // Pointer to a variable that recives error code on failure or zero on success.
	WORD *lpwLanguageFound  // Language of the resource found. It may differ from wLanguage if that language is absent.
	)
{
	return InternalFindResourceEx (
		dwResDirVA,
		lpName,
		lpType,
		MAKELANGID (LANG_NEUTRAL, SUBLANG_NEUTRAL),
		lpwErrorCode,
		lpwLanguageFound
		);
}


IMAGE_RESOURCE_DATA_ENTRY *MyFindResource (
	HMODULE ImageBase,  // dwImageBase
	LPCTSTR lpName,     // Name of the resource or resource ID.
	LPCTSTR lpType,     // One of the RT_XXX constants (a MAKEINTRESOURCE() value).
	WORD *lpwErrorCode, // Pointer to a variable that recives error code on failure or zero on success.
	WORD *lpwLanguageFound  // Language of the resource found. It may differ from wLanguage if that language is absent.
	)
{
	return InternalFindResourceEx (
		ImageBase,
		lpName,
		lpType,
		MAKELANGID (LANG_NEUTRAL, SUBLANG_NEUTRAL),
		lpwErrorCode,
		lpwLanguageFound
		);
}


	/*
	// MyFindResourceEx:
	// Works the same way as the original Win32 FindResourceEx.
	// Its similar to InternalFindResourceEx except that
	// this function will fail if the resource with the specified
	// language was not found. You can use InternalFindResourceEx
	// as well despite its name.
	*/


IMAGE_RESOURCE_DATA_ENTRY *MyFindResourceEx (
	DWORD dwResDirVA,   // Pointer (VA) to the root of resource tree.
	LPCTSTR lpName,     // Name or ID of the resource.
	LPCTSTR lpType,     // One of the RT_XXX constants (a MAKEINTRESOURCE() value).
	WORD wLanguage,     // LANGID forged with MAKELANGID().
	WORD *lpwErrorCode  // Pointer to a variable that recives error code on failure or zero on success.
	)
{
	IMAGE_RESOURCE_DATA_ENTRY   *result;
	WORD                        wLanguageFound;

	result = InternalFindResourceEx (
		dwResDirVA,
		lpName,
		lpType,
		wLanguage,
		lpwErrorCode,
		&wLanguageFound
		);

	if (result && wLanguage != wLanguageFound) 
	{
		result = NULL;

		__try
		{
			if (lpwErrorCode) *lpwErrorCode = RES_LANG_NOT_FOUND;
		}
		__except (EXCEPTION_EXECUTE_HANDLER) {}

	}

	return result;
}




IMAGE_RESOURCE_DATA_ENTRY *MyFindResourceEx (
	HMODULE ImageBase,  // dwImageBase
	LPCTSTR lpName,     // Name or ID of the resource.
	LPCTSTR lpType,     // One of the RT_XXX constants (a MAKEINTRESOURCE() value).
	WORD wLanguage,     // LANGID forged with MAKELANGID().
	WORD *lpwErrorCode  // Pointer to a variable that recives error code on failure or zero on success.
	)
{
	IMAGE_RESOURCE_DATA_ENTRY   *result;
	WORD                        wLanguageFound;

	result = InternalFindResourceEx (
		ImageBase,
		lpName,
		lpType,
		wLanguage,
		lpwErrorCode,
		&wLanguageFound
		);

	if (result && wLanguage != wLanguageFound) 
	{
		result = NULL;

		__try
		{
			if (lpwErrorCode) *lpwErrorCode = RES_LANG_NOT_FOUND;
		}
		__except (EXCEPTION_EXECUTE_HANDLER) {}

	}

	return result;
}





	/*
	// CmpLPCTSTRStringU:
	// Performs comparsion of the lpStr ANSI/UNICODE string and the lpStrU
	// unicode string that is stored in the resource data of a PE file.
	// In the ANSI version the comparsion will be done in ANSI format.
	// It may raise an exception on fatal errors.
	// Comparsion result:
	// * negative: lpStr < lpStrU
	// * zero:     lpStr == lpStrU
	// * positive: lpStr > lpStrU
	*/


int CmpLPCTSTRStringU (LPCTSTR lpStr, IMAGE_RESOURCE_DIR_STRING_U *lpStrU)
{
	int     result;
	DWORD   StrLen = (DWORD)lstrlen (lpStr);

	if (StrLen < lpStrU->Length) return -1;
	else if (StrLen > lpStrU->Length) return 1;
	if (!StrLen) return 0;  // zero lengths

	LPTSTR  UniStr;

	/*
	// In ANSI version we convert the unicode resource string to ANSI.
	*/

#ifdef UNICODE

	UniStr = (LPWSTR)&lpStrU->NameString;

#else /* UNICODE */

	UniStr = (LPSTR)malloc (lpStrU->Length);
	if (!UniStr) RAISE_EXCEPTION_RESULT (RES_MEMORY_ERR);

	__try
	{
		if (WideCharToMultiByte (CP_ACP, 0, (LPCWSTR)&lpStrU->NameString,
			lpStrU->Length, UniStr, lpStrU->Length, NULL, NULL) != lpStrU->Length)
			RAISE_EXCEPTION_RESULT (RES_UNKNOWN_ERR);

#endif /* UNICODE */

		result = CompareString (
			LOCALE_USER_DEFAULT, 
			0,
			lpStr,
			StrLen,
			UniStr,
			lpStrU->Length
			) - CSTR_EQUAL;  /* subtract 2 to be consistent with normal strcmp() */

#ifndef UNICODE

	}
	__finally
	{
		free (UniStr);
	}

#endif /* !UNICODE */

	return result;
}


	/*
	// CmpLPCTSTRName:
	// Compares lpStr to Name that is the field of an
	// IMAGE_RESOURCE_DIRECTORY_ENTRY.
	// If lpStr is an ID (high-word is zero) than it will be compared
	// to the low-word of Name. If lpStr is not an ID than it points
	// to a null terminated string and the lower 31 bits of Name
	// should be an offset to a IMAGE_RESOURCE_DIR_STRING_U structure.
	// This offset is relative to dwResDirVA.
	// Comparsion result:
	// * negative: lpStr < Name
	// * zero:     lpStr == Name
	// * positive: lpStr > Name
	*/

int CmpLPCTSTRName (DWORD dwResDirVA, LPCTSTR lpStr, DWORD Name)
{
	if (IS_RES_ID (lpStr))
	{
		if ((WORD)lpStr < (WORD)Name) return -1;
		else if ((WORD)lpStr > (WORD)Name) return 1;
		else return 0;
	}
	else
	{
		return CmpLPCTSTRStringU (
			lpStr, 
			(IMAGE_RESOURCE_DIR_STRING_U*)(dwResDirVA + (Name & 0x7FFFFFFF))
			);
	}
}


	/*
	// ConvertResName:
	// If the high-word of lpStr is not zero and the string it points to
	// begins with a '#' character than the following characters will be
	// interpreted as decimal digits. The number will be converted to
	// its binary representation and stored in lpStr.
	// The function fails only when the string begins with '#' so
	// conversion is needed but the following characters do not represent
	// a valid decimal number, or the number is so big that it can not be
	// stored using 16bits. In this case the function raises an exception
	// but other type of exception may occur (access violation).
	*/

void ConvertResName (LPCTSTR *lplpStr)
{
	if (!IS_RES_ID (*lplpStr))
		if ((*lplpStr)[0] == '#')
	{
		errno = 0;
		LPTSTR endptr;
		long num = _tcstol (*lplpStr + 1, &endptr, 10); // strtol() or wcstol()

		if (errno != 0 ||                   // conversion error
			(*lplpStr + 1) == endptr ||     // there were no decimal digits
			(DWORD)num > 0xFFFF)            // too big ID
			RAISE_EXCEPTION_RESULT (RES_INVALID_RESNAME);

		*lplpStr = (LPCTSTR)num;
	}
}


	/*
	// FindResDirEntry:
	// Search for the specified resource directory entry by its Name
	// or ID in a resource directory. The name can be a string that
	// represents the ID in decimal format eg.: "#238".
	// The return value is NULL if the specified Name or ID does not
	// exist in the directory.
	// Unhandled exception may occur.
	*/

IMAGE_RESOURCE_DIRECTORY_ENTRY *FindResDirEntry (
	DWORD dwResDirVA,                   // Pointer (VA) to the root of the resource directory.
	IMAGE_RESOURCE_DIRECTORY *lpDir,    // The directory to search in.
	LPCTSTR lpName                      // The name or id to search for.
	)
{
	DWORD   low, high, mid;

	IMAGE_RESOURCE_DIRECTORY_ENTRY *entries = (IMAGE_RESOURCE_DIRECTORY_ENTRY*)(lpDir + 1);

	/*
	// Since the IMAGE_RESOURCE_DIRECTORY_ENTRY structures of a node
	// are always in ascending order by their Name fields we can use
	// binary halving to reduce search time to log2 (n) + 1 steps at
	// worst case.
	*/

	ConvertResName (&lpName);

	if (IS_RES_ID (lpName))
	{
		low = lpDir->NumberOfNamedEntries;
		high = low + lpDir->NumberOfIdEntries;
	}
	else
	{
		low = 0;
		high = lpDir->NumberOfNamedEntries;
	}

	/*
	// low: index of the first directory entry we must search in.
	// high: index of the last directory entry we want to search in + 1.
	*/

	while (high > low)
	{
		mid = (high + low) >> 1;
		int cmpres = CmpLPCTSTRName (dwResDirVA, lpName, entries[mid].Name);
		if (!cmpres) return &entries[mid];

		if (cmpres < 0)
			high = mid;
		else
			low = mid + 1;
	}

	return NULL;
}

	/*
	// InternalFindResourceEx:
	// Search for a specified type of resource with a given name
	// or ID in the specified Resource Directory. We will look
	// for resource with the specified language but if the
	// resource does not have an instance with that language then
	// we return the first language occurance of that resource.
	// The language of the returned data entry will be stored at
	// *lpwLanguageFound.
	*/


IMAGE_RESOURCE_DATA_ENTRY *InternalFindResourceEx (
	DWORD dwResDirVA,   // Pointer (VA) to the root of resource tree.
	LPCTSTR lpName,     // Name of the resource or resource ID.
	LPCTSTR lpType,     // One of the RT_XXX constants (a MAKEINTRESOURCE() value).
	WORD wLanguage,     // LANGID forged with MAKELANGID().
	WORD *lpwErrorCode,     // Pointer to a variable that recives error code on failure or zero on success.
	WORD *lpwLanguageFound  // Language of the resource found. It may differ from wLanguage if that language is absent.
	)
{
	IMAGE_RESOURCE_DATA_ENTRY       *result = NULL;
	IMAGE_RESOURCE_DIRECTORY_ENTRY  *entry;
	IMAGE_RESOURCE_DIRECTORY        *lang_dir;

	WORD    error_code = RES_UNKNOWN_ERR;

	__try
	{
		/*
		// level 1: search by type
		*/

		entry = FindResDirEntry (
					dwResDirVA,
					(IMAGE_RESOURCE_DIRECTORY*)dwResDirVA,
					lpType
					);

		if (!entry) RAISE_EXCEPTION_RESULT (RES_TYPE_NOT_FOUND);

		/*
		// level 2: search by Name or ID
		*/

		entry = FindResDirEntry (
					dwResDirVA,
					(IMAGE_RESOURCE_DIRECTORY*)(dwResDirVA + (entry->OffsetToData & 0x7FFFFFFF)),
					lpName
					);

		if (!entry) RAISE_EXCEPTION_RESULT (RES_NOT_FOUND);

		/*
		// level 3: search by LANGID
		*/

		lang_dir = (IMAGE_RESOURCE_DIRECTORY*)(dwResDirVA + (entry->OffsetToData & 0x7FFFFFFF));

		if (wLanguage == MAKELANGID (LANG_NEUTRAL, SUBLANG_NEUTRAL))
			wLanguage = LANGIDFROMLCID (GetThreadLocale ());

		entry = FindResDirEntry (dwResDirVA, lang_dir, (LPCTSTR)wLanguage);

		if (!entry)
		{
			/*
			// Number of language entries is zero. (???)
			// This should never happen.
			*/

			if (!lang_dir->NumberOfIdEntries) RAISE_EXCEPTION_RESULT (RES_LANG_NOT_FOUND);

			/*
			// If the specified LANGID was not found then we return the
			// resource with the first language of the directory.
			*/

			entry = (IMAGE_RESOURCE_DIRECTORY_ENTRY*)(lang_dir + 1);
		}

		result = (IMAGE_RESOURCE_DATA_ENTRY*)(dwResDirVA + (entry->OffsetToData & 0x7FFFFFFF));
		error_code = RES_OK;
	}
	__except (EXCEPT_EVAL) {}

	__try
	{
		if (lpwErrorCode) *lpwErrorCode = error_code;
	}
	__except (EXCEPTION_EXECUTE_HANDLER) {}

	__try
	{
		if (lpwLanguageFound) *lpwLanguageFound = (WORD)entry->Name;
	}
	__except (EXCEPTION_EXECUTE_HANDLER) {}

	return result;
}



	/*
	// InternalFindResourceEx that recives dwImageBase (HMODULE) instead of
	// dwResDirVA. This function will calculate the dwResDirVA value
	// from the NT headers.
	*/

IMAGE_RESOURCE_DATA_ENTRY *InternalFindResourceEx (
	HMODULE ImageBase,  // dwImageBase
	LPCTSTR lpName,     // Name of the resource or resource ID.
	LPCTSTR lpType,     // One of the RT_XXX constants (a MAKEINTRESOURCE() value).
	WORD wLanguage,     // LANGID forged with MAKELANGID().
	WORD *lpwErrorCode,     // Pointer to a variable that recives error code on failure or zero on success.
	WORD *lpwLanguageFound  // Language of the resource found. It may differ from wLanguage if that language is absent.
	)
{
	DWORD dwResDirVA = ResDirVAFromHMODULE (ImageBase, lpwErrorCode);
	if (!dwResDirVA) return NULL;

	return InternalFindResourceEx (
		dwResDirVA,
		lpName,
		lpType,
		wLanguage,
		lpwErrorCode,
		lpwLanguageFound
		);
}




vector<LPWSTR> ListNamedResourceEntrys(
	HMODULE ImageBase, 
	LPCTSTR lpType     // One of the RT_XXX constants (a MAKEINTRESOURCE() value).)
	)
{
	IMAGE_RESOURCE_DIRECTORY_ENTRY  *directory;
	
	DWORD dwResDirVA = ResDirVAFromHMODULE ( ImageBase, 0 );

	vector<LPWSTR> entryNames;

	if (dwResDirVA)
	{

		/*
		// search the resource dir of the given type
		*/

		directory = FindResDirEntry (
					dwResDirVA,
					(IMAGE_RESOURCE_DIRECTORY*)dwResDirVA,
					lpType
					);

		

		if (!directory) RAISE_EXCEPTION_RESULT (RES_TYPE_NOT_FOUND);
		
		
		entryNames = ListNamedResourceEntrysInternal(
						dwResDirVA,
						(IMAGE_RESOURCE_DIRECTORY*)(dwResDirVA + (directory->OffsetToData & 0x7FFFFFFF))
						);
	} 
	return entryNames;
}


/*
* This method will search all named resource entries in the given RESOURCE_DIRECTORY
* 
* returns the number of found resources
*/
vector<LPWSTR> ListNamedResourceEntrysInternal(
	DWORD dwResDirVA,                   // Pointer (VA) to the root of the resource directory.
	IMAGE_RESOURCE_DIRECTORY *lpDir    // The directory to search in.
	)	
{
	int entryCount = lpDir->NumberOfNamedEntries;
	IMAGE_RESOURCE_DIRECTORY_ENTRY *entries = (IMAGE_RESOURCE_DIRECTORY_ENTRY*)(lpDir + 1);
	LPWSTR resourceName = NULL;
	const IMAGE_RESOURCE_DIR_STRING_U *lpStr;   

	vector<LPWSTR> entryNames;


	for(int i=0; i < entryCount; i++){
		lpStr = (const IMAGE_RESOURCE_DIR_STRING_U *)((const BYTE *)dwResDirVA + entries[i].NameOffset);   

		resourceName = new WCHAR[MAX_PATH];
		wmemcpy_s(resourceName, lpStr->Length, lpStr->NameString, lpStr->Length);
		resourceName[lpStr->Length] = '\0'; // ensure last byte is NULL
		
		entryNames.push_back(resourceName);
	}
	return entryNames;
}
