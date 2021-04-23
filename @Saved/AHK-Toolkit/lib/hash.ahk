Hash(ByRef sData, SID=4) { ; SID = 3: MD5, 4: SHA1
    ; Lazlo: http://www.autohotkey.com/forum/viewtopic.php?p=113252#113252
    
    DllCall("advapi32\CryptAcquireContextW", UIntP,hProv, UInt,0, UInt,0, UInt,1, UInt,0xF0000000)
    DllCall("advapi32\CryptCreateHash", UInt,hProv, UInt,0x8000|0|SID, UInt,0, UInt,0, UIntP, hHash)
    DllCall("advapi32\CryptHashData", UInt,hHash, UInt,&sData, UInt,nLen := strlen(sData), UInt,0)
    DllCall("advapi32\CryptGetHashParam", UInt,hHash, UInt,2, UInt,0, UIntP,nSize, UInt,0)
    VarSetCapacity(HashVal, nSize, 0)
    DllCall("advapi32\CryptGetHashParam", UInt,hHash, UInt,2, UInt,&HashVal, UIntP,nSize, UInt,0)
    DllCall("advapi32\CryptDestroyHash", UInt,hHash)
    DllCall("advapi32\CryptReleaseContext", UInt,hProv, UInt,0)

    IFormat := A_FormatInteger
    SetFormat Integer, H
    Loop %nSize%
      sHash .= SubStr(*(&HashVal+A_Index-1)+0x100,-1)
    SetFormat Integer, %IFormat%
    Return sHash
}