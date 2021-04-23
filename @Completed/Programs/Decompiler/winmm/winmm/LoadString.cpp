#include "FindResource.h"
#include "LoadString.h"

    /*
    // The strings are stored using IMAGE_RESOURCE_DIR_STRING_U
    // structures. Strings can be identified only by ID.
    // The whole string table is broken up to blocks and each block
    // contains 16 IMAGE_RESOURCE_DIR_STRING_U structures. These blocks
    // always contain all 16 strings, the non existent strings'
    // length is set to zero.
    // Strings with ID number
    // 0x00-0x0f are stored in block #1
    // 0x10-0x1f are stored in block #2
    // 0x20-0x2f are in block #3
    // ...and so on.
    //
    // If you do not use the string ID 17, then the second string in
    // block #2 will have a length of zero. If you don't need any string
    // IDs in the range 0x10-0x1f then the whole second block will be
    // absent, but #1 and #3 can be present.
    // Calculating the block number and the index inside the
    // block using the ID of string:
    // block_number = (ID >> 4) + 1
    // index_inside_block = ID & 0xf
    //
    // How do these blocks reside in the resource information?
    // At the FindResource tutorial we learned that you search for
    // a particular resource by RESOURCE_TYPE, NAME/ID, and LANGUAGE
    // on the first 3 levels of the resource tree.
    // When you search for a string then RESOURCE_TYPE is RT_STRING,
    // NAME/ID is the block number, and the LANGUAGE is your choice.
    // When you use the Win32 LoadString then the thread default
    // language is used.
    // After searching the block with FindResource/LoadResource you
    // have the pointer to an array of IMAGE_RESOURCE_DIR_STRING_U
    // whose elements are variable length, but its element count
    // is always 16.
    //
    // Info:
    // - String ID 0 is usually not used.
    // - If you use only the string IDs 0x11, 0x55 then these
    //   strings will occupy 2 full blocks (#2 and #6) each containing
    //   16 strings, and 15 of them have zero length. It is recommended
    //   to use a continuous range of string IDs.
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
    // - If neither of lpBuffer/nBufferMax is zero then the return
    //   value is the number of characters copied to the buffer not
    //   including the terminating zero.
    // - The return value is zero on error.
    */


DWORD MyLoadString (
    HMODULE ImageBase,  // dwImageBase
    DWORD dwResDirVA,   // Pointer (VA) to the root of resource tree.
    UINT uID,           // string resource identifier
    LPTSTR lpBuffer,    // pointer to buffer to receive the string with terminating zero.
    DWORD nBufferMax,   // size of buffer
    WORD wLanguage,     // LANGID forged with MAKELANGID().
    WORD *lpwErrorCode, // Pointer to a variable that recives error code on failure or zero on success.
    WORD *lpwLanguageFound  // Language of the resource found. It may differ from wLanguage if that language is absent.
    )
{
    IMAGE_RESOURCE_DIR_STRING_U *str;
    DWORD len;
    WORD error_code;

    __try
    {
        str = InternalLoadString (
            ImageBase,
            dwResDirVA,
            uID,
            wLanguage,
            &error_code,
            lpwLanguageFound
            );

        if (!str) RAISE_EXCEPTION_RESULT (RES_NOT_FOUND);
        error_code = RES_UNKNOWN_ERR;

        len = str->Length;

        if (nBufferMax && lpBuffer)
        {
            /*
            // return the string
            */

            /* number of characters to copy not including the zero */
            len = min (nBufferMax - 1, len);

#ifdef UNICODE

            /*
            // UNICODE: Simply copy one buffer to another.
            */

            memcpy (
                (void*)lpBuffer, 
                (void*)&str->NameString, 
                len * sizeof (WCHAR)
                );

#else /* UNICODE */

            /*
            // ANSI: UNICODE->ANSI conversion instead of memcpy
            */

            len = WideCharToMultiByte (
                CP_ACP,
                0,
                (LPCWSTR)&str->NameString,
                len,
                lpBuffer,
                len,
                NULL,
                NULL
                );


#endif /* UNICODE */

            lpBuffer[len] = 0;  /* terminating zero */

        }
        else if (nBufferMax && !lpBuffer)
        {
            /*
            // return a pointer to the IMAGE_RESOURCE_DIR_STRING_U.
            */

            len = (DWORD)str;
        } 
        /* else, nBufferMax==0 so return only the length without terminating zero */

        error_code = RES_OK;
    }
    __except ( EXCEPT_EVAL ) 
    {
        len = 0;
    }

    __try
    {
        if (lpwErrorCode) *lpwErrorCode = error_code;
    }
    __except (EXCEPTION_EXECUTE_HANDLER) {}

    return len;
}



DWORD MyLoadString (
    HMODULE ImageBase,  // dwImageBase
    UINT uID,           // string resource identifier
    LPTSTR lpBuffer,    // pointer to buffer to receive the string with terminating zero.
    DWORD nBufferMax,   // size of buffer
    WORD wLanguage,     // LANGID forged with MAKELANGID().
    WORD *lpwErrorCode, // Pointer to a variable that recives error code on failure or zero on success.
    WORD *lpwLanguageFound  // Language of the resource found. It may differ from wLanguage if that language is absent.
    )
{
    DWORD dwResDirVA = ResDirVAFromHMODULE (ImageBase, lpwErrorCode);
    if (!dwResDirVA) return 0;

    return MyLoadString (
        ImageBase,
        dwResDirVA,
        uID,
        lpBuffer,
        nBufferMax,
        wLanguage,
        lpwErrorCode,
        lpwLanguageFound
        );
}


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
    WORD wLanguage,     // LANGID forged with MAKELANGID().
    WORD *lpwErrorCode, // Pointer to a variable that recives error code on failure or zero on success.
    WORD *lpwLanguageFound  // Language of the resource found. It may differ from wLanguage if that language is absent.
    )
{
    IMAGE_RESOURCE_DIR_STRING_U *result;
    IMAGE_RESOURCE_DATA_ENTRY   *data;
    WORD                        error_code = RES_UNKNOWN_ERR;

    __try
    {
        /*
        // Find the block of strings we need.
        */

        data = InternalFindResourceEx (
            dwResDirVA,
            (LPCTSTR)((uID >> 4) + 1),
            RT_STRING,
            wLanguage,
            &error_code,
            lpwLanguageFound
            );

        if (!data) RAISE_EXCEPTION ();

        error_code = RES_UNKNOWN_ERR;

        uID &= 0xf; // String index in the block.
        result = (IMAGE_RESOURCE_DIR_STRING_U*)MyLoadResource (ImageBase, data);

        /*
        // MyLoadResource should not fail.
        */

        for (; uID; uID--)
            result = (IMAGE_RESOURCE_DIR_STRING_U*)((DWORD)result
                + (result->Length + 1) * sizeof (WCHAR));

        if (!result->Length) RAISE_EXCEPTION_RESULT (RES_NOT_FOUND);
        error_code = RES_OK;
    }
    __except (EXCEPT_EVAL) 
    {
        result = NULL;
    }

    __try
    {
        if (lpwErrorCode) *lpwErrorCode = error_code;
    }
    __except (EXCEPTION_EXECUTE_HANDLER) {}

    return result;
}



IMAGE_RESOURCE_DIR_STRING_U *InternalLoadString (
    HMODULE ImageBase,  // dwImageBase
    UINT uID,           // string resource identifier
    WORD wLanguage,     // LANGID forged with MAKELANGID().
    WORD *lpwErrorCode, // Pointer to a variable that recives error code on failure or zero on success.
    WORD *lpwLanguageFound  // Language of the resource found. It may differ from wLanguage if that language is absent.
    )
{
    DWORD dwResDirVA = ResDirVAFromHMODULE (ImageBase, lpwErrorCode);
    if (!dwResDirVA) return NULL;

    return InternalLoadString (
        ImageBase,
        dwResDirVA,
        uID,
        wLanguage,
        lpwErrorCode,
        lpwLanguageFound
        );
}