;AHK v1.1
#NoEnv

/*
;Note: Unicode strings will cause hashes to be different from ANSI strings
Key := ")PO:L?>ajf35438&&^924376*()2455{"":?FDGHJKM<"
Data := "This is a test of the SHA512 hash, which is a member of the SHA2 algorithms. It outputs 512 bits representing the data, which is 64 bytes."
MsgBox % SHA512(Data,Key)

Data := "This is a test of the SHA1 hash, which is the second version of the SHA family. It outputs 160 bits representing the data, which is 20 bytes."
MsgBox, % SHA1(Data) ;EFCE74507B9D623C541DBC63DAC6E351C03984F9

Data := "This is a test of the MD5 hash, which is now considered insecure for cryptographic applications. It outputs 128 bits representing the data, which is 16 bytes."
MsgBox % MD5(Data) ;30C0F2E3D4D0EA4BDEF20B91EF63CB6C

MsgBox % FileMD5(A_ScriptFullPath)
ExitApp
*/

SHA512(ByRef Data,ByRef Key = "",DataSize = "",KeySize = "")
{
    IsUnicode := !!A_IsUnicode
    If (DataSize = "")
        DataSize := StrLen(Data) << IsUnicode
    If (KeySize = "")
        KeySize := StrLen(Key) << IsUnicode

    ;set up BLOBHEADER structure and data
    BlobSize := KeySize + 8
    VarSetCapacity(KeyStruct,BlobSize)
    NumPut(8,KeyStruct,0,"Char") ;key type (PLAINTEXTKEYBLOB)
    NumPut(2,KeyStruct,1,"Char") ;version (CUR_BLOB_VERSION)
    NumPut(0,KeyStruct,2,"Short") ;reserved
    NumPut(0x6602,KeyStruct,4,"UInt") ;key algorithm (CALG_RC2)
    DllCall("RtlCopyMemory","UPtr",&KeyStruct + 8,"UPtr",&Key,"UPtr",KeySize)

    ;set up HMAC_INFO structure
    VarSetCapacity(InfoStruct,12 + (A_PtrSize << 1))
    NumPut(0x800E,InfoStruct,0,"UInt") ;hash algorithm (CALG_SHA_512)
    NumPut(0,InfoStruct,4) ;pointer to inner string
    NumPut(0,InfoStruct,4 + A_PtrSize) ;bytes in inner string
    NumPut(0,InfoStruct,8 + A_PtrSize) ;pointer to outer string
    NumPut(0,InfoStruct,8 + (A_PtrSize << 1)) ;bytes in outer string

    hModule := DllCall("LoadLibrary","Str","advapi32.dll")
    If !hModule
        throw Exception("Could not load advapi32 library.")
    If !DllCall("advapi32\CryptAcquireContext","UPtr*",hProvider,"UPtr",0,"UPtr",0,"UInt",1,"UInt",0xF0000040) ;PROV_RSA_FULL, CRYPT_VERIFYCONTEXT | CRYPT_SILENT
    {
        DllCall("FreeLibrary","UPtr",hModule)
        throw Exception("Could not acquire cryptographic context.")
    }
    If !DllCall("advapi32\CryptImportKey","UPtr",hProvider,"UPtr",&KeyStruct,"UInt",BlobSize,"UPtr",0,"UInt",0x100,"UInt*",hKey) ;CRYPT_SF
    {
        DllCall("advapi32\CryptReleaseContext","UPtr",hProvider,"UInt",0)
        DllCall("FreeLibrary","UPtr",hModule)
        throw Exception("Could not import key.")
    }
    If !DllCall("advapi32\CryptCreateHash","UPtr",hProvider,"UInt",0x8009,"UInt",hKey,"UInt",0,"UInt*",hHash) ;CALG_HMAC
    {
        DllCall("advapi32\CryptDestroyKey","UInt",hKey)
        DllCall("advapi32\CryptReleaseContext","UPtr",hProvider,"UInt",0)
        DllCall("FreeLibrary","UPtr",hModule)
        throw Exception("Could not create hash.")
    }
    If !DllCall("advapi32\CryptSetHashParam","UInt",hHash,"UInt",5,"UPtr",&InfoStruct,"UInt",0) ;HP_HMAC_INFO
    {
        DllCall("advapi32\CryptDestroyHash","UInt",hHash)
        DllCall("advapi32\CryptDestroyKey","UInt",hKey)
        DllCall("advapi32\CryptReleaseContext","UPtr",hProvider,"UInt",0)
        DllCall("FreeLibrary","UPtr",hModule)
        throw Exception("Could not specify hash parameters.")
    }
    If !DllCall("advapi32\CryptHashData","UInt",hHash,"UPtr",&Data,"UInt",DataSize,"UInt",0)
    {
        DllCall("advapi32\CryptDestroyHash","UInt",hHash)
        DllCall("advapi32\CryptDestroyKey","UInt",hKey)
        DllCall("advapi32\CryptReleaseContext","UPtr",hProvider,"UInt",0)
        DllCall("FreeLibrary","UPtr",hModule)
        throw Exception("Could not hash data.")
    }
    HashSize := 64
    VarSetCapacity(HashValue,HashSize,0)
    If !DllCall("advapi32\CryptGetHashParam","UInt",hHash,"UInt",2,"UPtr",&HashValue,"UInt*",HashSize,"UInt",0) ;HP_HASHVAL
    {
        DllCall("advapi32\CryptDestroyHash","UInt",hHash)
        DllCall("advapi32\CryptDestroyKey","UInt",hKey)
        DllCall("advapi32\CryptReleaseContext","UPtr",hProvider,"UInt",0)
        DllCall("FreeLibrary","UPtr",hModule)
        throw Exception("Could not obtain hash value.")
    }
    If !DllCall("advapi32\CryptDestroyHash","UInt",hHash)
    {
        DllCall("advapi32\CryptDestroyKey","UInt",hKey)
        DllCall("advapi32\CryptReleaseContext","UPtr",hProvider,"UInt",0)
        DllCall("FreeLibrary","UPtr",hModule)
        throw Exception("Could not destroy hash.")
    }
    If !DllCall("advapi32\CryptDestroyKey","UInt",hKey)
    {
        DllCall("advapi32\CryptReleaseContext","UPtr",hProvider,"UInt",0)
        DllCall("FreeLibrary","UPtr",hModule)
        throw Exception("Could not destroy key.")
    }
    If !DllCall("advapi32\CryptReleaseContext","UPtr",hProvider,"UInt",0)
    {
        DllCall("FreeLibrary","UPtr",hModule)
        throw Exception("Could not release cryptographic context.")
    }
    If !DllCall("FreeLibrary","UPtr",hModule)
        throw Exception("Could not free advapi32 library.")

    FormatInteger := A_FormatInteger
    SetFormat, IntegerFast, Hex
    Hash := ""
    Loop, %HashSize%
        Hash .= SubStr("0" . SubStr(NumGet(HashValue,A_Index - 1,"UChar"),3),-1)
    SetFormat, IntegerFast, %FormatInteger%

    Return, Hash
}

SHA1(ByRef Data,DataSize = "")
{
    If (DataSize = "")
        DataSize := StrLen(Data) << !!A_IsUnicode

    hModule := DllCall("LoadLibrary","Str","advapi32.dll")
    If !hModule
        throw Exception("Could not load advapi32 library.")
    If !DllCall("advapi32\CryptAcquireContext","UPtr*",hProvider,"UPtr",0,"UPtr",0,"UInt",1,"UInt",0xF0000040) ;PROV_RSA_FULL, CRYPT_VERIFYCONTEXT | CRYPT_SILENT
    {
        DllCall("FreeLibrary","UPtr",hModule)
        throw Exception("Could not acquire cryptographic context.")
    }
    If !DllCall("advapi32\CryptCreateHash","UInt",hProvider,"UInt",0x8004,"UInt",0,"UInt",0,"UInt*",hHash) ;CALG_SHA1
    {
        DllCall("advapi32\CryptReleaseContext","UPtr",hProvider,"UInt",0)
        DllCall("FreeLibrary","UPtr",hModule)
        throw Exception("Could not create hash.")
    }
    If !DllCall("advapi32\CryptHashData","UInt",hHash,"UPtr",&Data,"UInt",DataSize,"UInt",0)
    {
        DllCall("advapi32\CryptDestroyHash","UInt",hHash)
        DllCall("advapi32\CryptReleaseContext","UPtr",hProvider,"UInt",0)
        DllCall("FreeLibrary","UPtr",hModule)
        throw Exception("Could not hash data.")
    }
    HashSize := 20
    VarSetCapacity(HashValue,HashSize,0)
    If !DllCall("advapi32\CryptGetHashParam","UInt",hHash,"UInt",2,"UPtr",&HashValue,"UInt*",HashSize,"UInt",0) ;HP_HASHVAL
    {
        DllCall("advapi32\CryptDestroyHash","UInt",hHash)
        DllCall("advapi32\CryptReleaseContext","UPtr",hProvider,"UInt",0)
        DllCall("FreeLibrary","UPtr",hModule)
        throw Exception("Could not obtain hash value.")
    }
    If !DllCall("advapi32\CryptDestroyHash","UInt",hHash)
    {
        DllCall("advapi32\CryptReleaseContext","UPtr",hProvider,"UInt",0)
        DllCall("FreeLibrary","UPtr",hModule)
        throw Exception("Could not destroy hash.")
    }
    If !DllCall("advapi32\CryptReleaseContext","UPtr",hProvider,"UInt",0)
    {
        DllCall("FreeLibrary","UPtr",hModule)
        throw Exception("Could not release cryptographic context.")
    }
    If !DllCall("FreeLibrary","UPtr",hModule)
        throw Exception("Could not free advapi32 library.")

    FormatInteger := A_FormatInteger
    SetFormat, IntegerFast, Hex
    Hash := ""
    Loop, %HashSize%
        Hash .= SubStr("0" . SubStr(NumGet(HashValue,A_Index - 1,"UChar"),3),-1)
    SetFormat, IntegerFast, %FormatInteger%

    Return, Hash
}

MD5(ByRef Data,Length = "")
{
    If (Length = "")
        Length := StrLen(Data) << !!A_IsUnicode

    VarSetCapacity(Context,104,0)
    hModule := DllCall("LoadLibrary","Str","advapi32.dll")
    If !hModule
        throw Exception("Could not load advapi32 library.")
    DllCall("advapi32\MD5Init","UPtr",&Context)
    DllCall("advapi32\MD5Update","UPtr",&Context,"UPtr",&Data,"UInt",Length)
    DllCall("advapi32\MD5Final","UPtr",&Context)
    If !DllCall("FreeLibrary","UPtr",hModule)
        throw Exception("Could not free advapi32 library.")

    FormatInteger := A_FormatInteger
    SetFormat, IntegerFast, Hex
    Hash := ""
    Loop, 16
        Hash .= SubStr("0" . SubStr(NumGet(Context,87 + A_Index,"UChar"),3),-1)
    SetFormat, IntegerFast, %FormatInteger%
    Return, Hash
}

FileMD5(FileName)
{
    hModule := DllCall("LoadLibrary","Str","advapi32.dll")
    If !hModule
        throw Exception("Could not load advapi32 library.")
    VarSetCapacity(Context,104,0)
    DllCall("advapi32\MD5Init","UPtr",&Context)

    hFile := DllCall("CreateFile","Str",FileName,"UInt",0x80000000,"UInt",1,"UPtr",0,"UInt",3,"UInt",0,"UPtr",0,"UPtr") ;GENERIC_READ, FILE_SHARE_READ, OPEN_EXISTING
    If hFile = -1 ;INVALID_HANDLE_VALUE
        throw Exception("Could not open file.")
    If !DllCall("GetFileSizeEx","UPtr",hFile,"Int64*",FileSize)
        throw Exception("Could not obtain file size.")
    BufferSize := 0x400000
    VarSetCapacity(Buffer,BufferSize)
    Loop, % Ceil(FileSize / BufferSize)
    {
        If !DllCall("ReadFile","UPtr",hFile,"UPtr",&Buffer,"UInt",BufferSize,"UInt*",AmountRead,"UPtr",0)
            throw Exception("Could not read file.")
        DllCall("advapi32\MD5Update","UPtr",&Context,"UPtr",&Buffer,"UInt",AmountRead)
    }
    DllCall("CloseHandle","UPtr",hFile)

    DllCall("advapi32\MD5Final","UPtr",&Context)
    If !DllCall("FreeLibrary","UPtr",hModule)
        throw Exception("Could not free advapi32 library.")

    FormatInteger := A_FormatInteger
    SetFormat, IntegerFast, Hex
    Hash := ""
    Loop, 16
        Hash .= SubStr("0" . SubStr(NumGet(Context,87 + A_Index,"UChar"),3),-1)
    SetFormat, IntegerFast, %FormatInteger%

    Return, Hash
}