#ifndef FindResource_h
#define FindResource_h

#include <vector>

#include "ResCommon.h"


    /*
    // MyLoadResource:
    // Fake LoadResource. Fake LockResource isn't required since
    // that function does nothing. The headers at ImageBase (if any)
    // aren't used.
    */


void *MyLoadResource (
    HMODULE ImageBase,  // dwImageBase
    IMAGE_RESOURCE_DATA_ENTRY *lpDataEntry  // pointer returned by FindResource()
    );

DWORD MySizeOfResource (
    IMAGE_RESOURCE_DATA_ENTRY *lpDataEntry  // pointer returned by FindResource()
    );


    /*
    // FindResource functions have two variants. One that works
    // with the address of the resource directory, and another that
    // takes a HMODULE and retrieves the address of resource directory
    // itself. You must use the functions that require ResDirVA if
    // you haven't loaded the headers of the PE file.
    */


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
    WORD *lpwErrorCode = NULL,  // Pointer to a variable that recives error code on failure or zero on success.
    WORD *lpwLanguageFound = NULL   // Language of the resource found. It may differ from wLanguage if that language is absent.
    );


IMAGE_RESOURCE_DATA_ENTRY *MyFindResource (
    HMODULE ImageBase,  // dwImageBase
    LPCTSTR lpName,     // Name of the resource or resource ID.
    LPCTSTR lpType,     // One of the RT_XXX constants (a MAKEINTRESOURCE() value).
    WORD *lpwErrorCode = NULL,  // Pointer to a variable that recives error code on failure or zero on success.
    WORD *lpwLanguageFound = NULL   // Language of the resource found. It may differ from wLanguage if that language is absent.
    );


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
    WORD wLanguage = MAKELANGID (LANG_NEUTRAL, SUBLANG_NEUTRAL),    // LANGID forged with MAKELANGID().
    WORD *lpwErrorCode = NULL   // Pointer to a variable that recives error code on failure or zero on success.
    );


IMAGE_RESOURCE_DATA_ENTRY *MyFindResourceEx (
    HMODULE ImageBase,  // dwImageBase
    LPCTSTR lpName,     // Name of the resource or resource ID.
    LPCTSTR lpType,     // One of the RT_XXX constants (a MAKEINTRESOURCE() value).
    WORD wLanguage = MAKELANGID (LANG_NEUTRAL, SUBLANG_NEUTRAL),    // LANGID forged with MAKELANGID().
    WORD *lpwErrorCode = NULL   // Pointer to a variable that recives error code on failure or zero on success.
    );



    /*
    // InternalFindResourceEx:
    // Search for a specified resource with the given language.
    // If this language not found then return the first resource
    // of the language directory. You can specify
    // MAKELANGID (LANG_NEUTRAL, SUBLANG_NEUTRAL) == 0
    // as wLanguage if you want to search for a resource with the
    // LANGID of the current thread.
    */


IMAGE_RESOURCE_DATA_ENTRY *InternalFindResourceEx (
    DWORD dwResDirVA,   // Pointer (VA) to the root of resource tree.
    LPCTSTR lpName,     // Name or ID of the resource.
    LPCTSTR lpType,     // One of the RT_XXX constants (a MAKEINTRESOURCE() value).
    WORD wLanguage = MAKELANGID (LANG_NEUTRAL, SUBLANG_NEUTRAL),    // LANGID forged with MAKELANGID().
    WORD *lpwErrorCode = NULL,      // Pointer to a variable that recives error code on failure or zero on success.
    WORD *lpwLanguageFound = NULL   // Language of the resource found. It may differ from wLanguage if that language is absent.
    );


IMAGE_RESOURCE_DATA_ENTRY *InternalFindResourceEx (
    HMODULE ImageBase,  // dwImageBase
    LPCTSTR lpName,     // Name of the resource or resource ID.
    LPCTSTR lpType,     // One of the RT_XXX constants (a MAKEINTRESOURCE() value).
    WORD wLanguage = MAKELANGID (LANG_NEUTRAL, SUBLANG_NEUTRAL),    // LANGID forged with MAKELANGID().
    WORD *lpwErrorCode = NULL,     // Pointer to a variable that recives error code on failure or zero on success.
    WORD *lpwLanguageFound = NULL  // Language of the resource found. It may differ from wLanguage if that language is absent.
    );


/*
* This method will search all named resource entries in the given RESOURCE_DIRECTORY
* 
* returns the number of found resources
*/
std::vector<LPWSTR> ListNamedResourceEntrysInternal(
	DWORD dwResDirVA,                   // Pointer (VA) to the root of the resource directory.
	IMAGE_RESOURCE_DIRECTORY *lpDir    // The directory to search in.
	);	

std::vector<LPWSTR> ListNamedResourceEntrys(
	HMODULE ImageBase, 
	LPCTSTR lpType     // One of the RT_XXX constants (a MAKEINTRESOURCE() value).)
	);



#endif /* FindResource_h */