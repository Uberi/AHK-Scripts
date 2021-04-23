#NoEnv

/*
Data := "Test data 123 abc !@#$%^&*()"
AESPassword  := "Test Password 123 abc"

Encrypted := AESEncrypt(AESPassword,Data)
Length := AESDecrypt(AESPassword,Encrypted,Decrypted)
VarSetCapacity(Decrypted,-1)
MsgBox "%Decrypted%"`n`n"%Encrypted%"
*/

;256 bit AES encryption
AESEncrypt(AESPassword,ByRef Data,Length = "")
{ ;returns the length of the encrypted data
 UPtr := A_PtrSize ? "UPtr" : "UInt"
 If (Length = "")
  Length := StrLen(Data) << !!A_IsUnicode
 BlockLength := Ceil(Length / 16) << 4 ;round up to the nearest block size, 16 bytes
 VarSetCapacity(Encrypted,BlockLength), DllCall("RtlMoveMemory",UPtr,&Encrypted,UPtr,&Data,UPtr,Length)
 hModule := DllCall("LoadLibrary","Str","advapi32.dll")
 hProvider := 0, DllCall("advapi32\CryptAcquireContext","UInt*",hProvider,UPtr,0,UPtr,0,"UInt",24,"UInt",0xF0000000)
 hHash := 0, DllCall("advapi32\CryptCreateHash","UInt",hProvider,"UInt",0x8004,"UInt",0,"UInt",0,"UInt*",hHash) ;CALG_SHA1
 DllCall("advapi32\CryptHashData","UInt",hHash,UPtr,&AESPassword,"UInt",StrLen(AESPassword),"UInt",0)
 hKey := 0, DllCall("advapi32\CryptDeriveKey","UInt",hProvider,"UInt",0x6610,"UInt",hHash,"UInt",0x1000000,"UInt*",hKey) ;CALG_AES_256, 256 << 16
 DllCall("advapi32\CryptDestroyHash","UInt",hHash)
 DllCall("advapi32\CryptEncrypt","UInt",hKey,"UInt",0,"UInt",1,"UInt",0,UPtr,&Encrypted,"UInt*",Length,"UInt",BlockLength)
 DllCall("advapi32\CryptDestroyKey","UInt",hKey)
 DllCall("advapi32\CryptReleaseContext","UInt",hProvider,"UInt",0)
 DllCall("FreeLibrary",UPtr,hModule)
 VarSetCapacity(EncryptedHex,Length << 1)
 FormatInteger := A_FormatInteger
 SetFormat, IntegerFast, Hex
 Loop, %Length%
  EncryptedHex .= SubStr("0" . SubStr(NumGet(Encrypted,A_Index - 1,"UChar"),3),-1)
 SetFormat, IntegerFast, %FormatInteger%
 Return, EncryptedHex
}

AESDecrypt(AESPassword,Encrypted,ByRef Decrypted)
{
 UPtr := A_PtrSize ? "UPtr" : "UInt"
 Length := StrLen(Encrypted) >> 1
 VarSetCapacity(Decrypted,Length), Position := 1
 Loop, %Length%
  NumPut("0x" . SubStr(Encrypted,Position,2),Decrypted,Position >> 1,"UChar"), Position += 2
 hModule := DllCall("LoadLibrary","Str","advapi32.dll")
 hProvider := 0, DllCall("advapi32\CryptAcquireContext","UInt*",hProvider,UPtr,0,UPtr,0,"UInt",24,"UInt",0xF0000000)
 hHash := 0, DllCall("advapi32\CryptCreateHash","UInt",hProvider,"UInt",0x8004,"UInt",0,"UInt",0,"UInt*",hHash) ;CALG_SHA1
 DllCall("advapi32\CryptHashData","UInt",hHash,UPtr,&AESPassword,"UInt",StrLen(AESPassword),"UInt",0)
 hKey := 0, DllCall("advapi32\CryptDeriveKey","UInt",hProvider,"UInt",0x6610,"UInt",hHash,"UInt",0x1000000,"UInt*",hKey) ;CALG_AES_256, 256 << 16
 DllCall("advapi32\CryptDestroyHash","UInt",hHash)
 DllCall("advapi32\CryptDecrypt","UInt",hKey,"UInt",0,"UInt",1,"UInt",0,UPtr,&Decrypted,"UInt*",Length)
 DllCall("advapi32\CryptDestroyKey","UInt",hKey)
 DllCall("advapi32\CryptReleaseContext","UInt",hProvider,"UInt",0)
 DllCall("FreeLibrary",UPtr,hModule)
 Return, Length ;wip: use the ByRef Decrypted parameter
}