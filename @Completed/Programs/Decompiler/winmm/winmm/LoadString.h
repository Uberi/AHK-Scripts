#ifndef LoadString_h
#define LoadString_h

#include "ResCommon.h"
#include "FindResource.h"

    /*
    // LoadString functions:
    // Each function have 2 variants: One that requires not only a
    // HMODULE but another parameter dwResDirVA, does not require
    // the DOS/NT headers to be loaded.
    */

    /*
    // MyLoadString:
    // The fake of the original windows LoadString if you don't use
    // the default parameters except that lengths are DWORD instead
    // of int.
    // - If nBufferMax is zero then the return value is the length of
    //   the string not including the terminating zero.
    // - If nBufferMax is nozero but lpBuffer is NULL then the return
    //   value is a const pointer to an IMAGE_RESOURCE_DIR_STRING_U
    //   structure.
    // - The return value is zero on error.
    */


DWORD MyLoadString (
    HMODULE ImageBase,  // dwImageBase
    DWORD dwResDirVA,   // Pointer (VA) to the root of resource tree.
    UINT uID,           // string resource identifier
    LPTSTR lpBuffer,    // pointer to buffer to receive the string with terminating zero.
    DWORD nBufferMax,   // size of buffer
    WORD wLanguage = MAKELANGID (LANG_NEUTRAL, SUBLANG_NEUTRAL),    // LANGID forged with MAKELANGID().
    WORD *lpwErrorCode = NULL,  // Pointer to a variable that recives error code on failure or zero on success.
    WORD *lpwLanguageFound = NULL   // Language of the resource found. It may differ from wLanguage if that language is absent.
    );


DWORD MyLoadString (
    HMODULE ImageBase,  // dwImageBase
    UINT uID,           // string resource identifier
    LPTSTR lpBuffer,    // pointer to buffer to receive the string with terminating zero.
    DWORD nBufferMax,   // size of buffer
    WORD wLanguage = MAKELANGID (LANG_NEUTRAL, SUBLANG_NEUTRAL),    // LANGID forged with MAKELANGID().
    WORD *lpwErrorCode = NULL,  // Pointer to a variable that recives error code on failure or zero on success.
    WORD *lpwLanguageFound = NULL   // Language of the resource found. It may differ from wLanguage if that language is absent.
    );


    /*
    // InternalLoadString:
    // Retrieve a pointer to the resource string identified by uID or
    // if an error occurs. The preferred language wLanguage will be
    // searched. This can be MAKELANGID (LANG_NEUTRAL, SUBLANG_NEUTRAL)
    // to search for the trhead default language. If it is not found
    // then the first language found in the language directory will be
    // used.
    */


IMAGE_RESOURCE_DIR_STRING_U *InternalLoadString (
    HMODULE ImageBase,  // dwImageBase
    DWORD dwResDirVA,   // Pointer (VA) to the root of resource tree.
    UINT uID,           // string resource identifier
    WORD wLanguage = MAKELANGID (LANG_NEUTRAL, SUBLANG_NEUTRAL),    // LANGID forged with MAKELANGID().
    WORD *lpwErrorCode = NULL,  // Pointer to a variable that recives error code on failure or zero on success.
    WORD *lpwLanguageFound = NULL   // Language of the resource found. It may differ from wLanguage if that language is absent.
    );

IMAGE_RESOURCE_DIR_STRING_U *InternalLoadString (
    HMODULE ImageBase,  // dwImageBase
    UINT uID,           // string resource identifier
    WORD wLanguage = MAKELANGID (LANG_NEUTRAL, SUBLANG_NEUTRAL),    // LANGID forged with MAKELANGID().
    WORD *lpwErrorCode = NULL,  // Pointer to a variable that recives error code on failure or zero on success.
    WORD *lpwLanguageFound = NULL   // Language of the resource found. It may differ from wLanguage if that language is absent.
    );


#endif /* LoadString_h */