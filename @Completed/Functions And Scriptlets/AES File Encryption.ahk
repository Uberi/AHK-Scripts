#NoEnv

/*
Password := "AutoHotkey"
FileOriginal = %A_AhkPath%
FileEncrypted = %A_ScriptDir%\Encrypted.bin
FileDecrypted = %A_ScriptDir%\Decrypted.exe

If !FileAES(FileOriginal, FileEncrypted, Password, True) ;Encryption
 MsgBox, Error Encrypting File
If !FileAES(FileEncrypted, FileDecrypted, Password, False) ;Decryption
 MsgBox, Error Decrypting File
Return
*/

FileAES(SourceFile,DestFile,Password,Encrypt = 1)
{
 If ((hFileFr := DllCall("CreateFile","UInt",&SourceFile,"UInt",0x80000000,"UInt",1,"UInt",0,"UInt",3,"UInt",0,"UInt",0)) = -1)
  Return
 DllCall("GetFileSizeEx","UInt",hFileFr,"Int64*",nSize)
 VarSetCapacity(sData,nSize + (Encrypt ? 16 : 0))
 pData := &sData
 DllCall("ReadFile","UInt",hFileFr,"UInt",pData,"UInt",nSize,"UInt*",nSize,"UInt",0)
 DllCall("CloseHandle","UInt",hFileFr)
 If (hFileTo := DllCall("CreateFile","UInt",&DestFile,"UInt",0x40000000,"UInt",1,"UInt",0,"UInt",2,"UInt",0,"UInt",0) = -1)
  Return
 hModule := DllCall("LoadLibrary","Str","advapi32.dll")
 DllCall("advapi32\CryptAcquireContextA","UInt*",hProv,"UInt",0,"UInt",0,"UInt",24,"UInt",0xF0000000)
 DllCall("advapi32\CryptCreateHash","UInt",hProv,"UInt",0x8004,"UInt",0,"UInt",0,"UInt*",hHash)
 DllCall("advapi32\CryptHashData","UInt",hHash,"UInt",&Password,"UInt",StrLen(Password),"UInt",0)
 DllCall("advapi32\CryptDeriveKey","UInt",hProv,"UInt",0x6610,"UInt",hHash,"UInt",0x1000000,"UInt*",hKey)
 DllCall("advapi32\CryptDestroyHash","UInt",hHash)
 If Encrypt
  DllCall("advapi32\CryptEncrypt","UInt",hKey,"UInt",0,"UInt",True,"UInt",0,"UInt",pData,"UInt*",nSize,"UInt",nSize + 16)
 Else
  DllCall("advapi32\CryptDecrypt","UInt",hKey,"UInt",0,"UInt",True,"UInt",0,"UInt",pData,"UInt*",nSize)
 DllCall("advapi32\CryptDestroyKey","UInt",hKey)
 DllCall("advapi32\CryptReleaseContext","UInt",hProv,"UInt",0)
 DllCall("FreeLibrary","UInt",hModule)
 DllCall("WriteFile","UInt",hFileTo,"UInt",pData,"UInt",nSize,"UInt*",nSize,"UInt",0)
 DllCall("CloseHandle","UInt",hFileTo)
 Return, nSize
}