#ifndef ResCommon_h
#define ResCommon_h

    /*
    // Ensure that both UNICODE and _UNICODE symbols are
    // defined or none of them.
    // You must define only UNICODE. _UNICODE will be
    // automatically defined or undefined.
    */

#if defined(UNICODE) && !defined(_UNICODE)
#  define _UNICODE
#endif

#if !defined(UNICODE) && defined(_UNICODE)
#  undef _UNICODE
#endif


#include <windows.h>
#include <winnt.h>
#include <tchar.h>



#define IS_RES_ID(lpName) (!((DWORD)(lpName) & 0xFFFF0000))

#define RAISE_EXCEPTION_RESULT(result) (RaiseException (0xEDCB0000 | ((result) & 0xFFFF), 0, 0, NULL))
#define RAISE_EXCEPTION() (RaiseException (0xE0000000, 0, 0, NULL))

#define EXCEPT_EVAL ( error_code = ((GetExceptionCode () & 0xFFFF0000) == 0xEDCB0000) \
                      ? (WORD)(GetExceptionCode () & 0xFFFF) : error_code, EXCEPTION_EXECUTE_HANDLER)


// ResDirVAFromHMODULE:
// Speaks for itself... :)
// The function returns zero on error.

DWORD ResDirVAFromHMODULE (HMODULE ImageBase, WORD *lpwErrorCode = NULL);

    /*
    // Resource function return codes:
    // All codes can be at most 16 bits wide.
    //
    // * RES_OK:
    // Success.
    // * RES_MEMORY_ERR:
    // Out of memory.
    // * RES_INVALID_RESNAME:
    // The lpName or lpType parameter of FindResourceEx() is a string
    // and begins with a '#' character but the following numbers
    // do not contain valid decimal digits or the number can not be
    // stored using 16 bits.
    // * RES_TYPE_NOT_FOUND:
    // The specified resource type does not exist in this module.
    // * RES_NOT_FOUND:
    // The module does not contain the specified type of resource
    // with the given name or id.
    // * RES_LANG_NOT_FOUND:
    // The resource specified by type and name or id does not have
    // a copy with the specified language id.
    // * RES_NO_RESOURCE:
    // The specified module does not contain resources. It will return
    // only by functions that require a HMODULE.
    //
    // * RES_INVALID_IMAGEBASE:
    // The dwImageBase parameter is invalid.
    // * RES_UNKNOWN_ERR:
    // Unknown error. Most likely an unwanted exception. (GPF)
    */

#define RES_OK                      0x0000
#define RES_MEMORY_ERR              0x0001
#define RES_INVALID_RESNAME         0x0002
#define RES_TYPE_NOT_FOUND          0x0003
#define RES_NOT_FOUND               0x0004
#define RES_LANG_NOT_FOUND          0x0005
#define RES_NO_RESOURCE             0x0006
#define RES_INVALID_IMAGEBASE       0xFFFE
#define RES_UNKNOWN_ERR             0xFFFF


#endif /* ResCommon_h */