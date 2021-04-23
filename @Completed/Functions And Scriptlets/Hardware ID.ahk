;AHK v1
#NoEnv

;MsgBox % HardwareID("rf7yh8frhrq89f3phy")

HardwareID(Salt = "")
{
 SplitPath, A_WinDir,,,,, Data
 DriveGet, Data, Serial, %Data%
 Data .= "`n" . Salt . "`n" . A_OSVersion . "`n" . A_Language . "`n" . A_UserName . "`n" . A_ComputerName

 UPtr := A_PtrSize ? "UPtr" : "UInt", VarSetCapacity(Temp1,104,0)
 hModule := DllCall("LoadLibrary","Str","advapi32.dll")
 DllCall("advapi32\MD5Init",UPtr,&Temp1)
 DllCall("advapi32\MD5Update",UPtr,&Temp1,UPtr,&Data,"UInt",StrLen(Data) << !!A_IsUnicode)
 DllCall("advapi32\MD5Final",UPtr,&Temp1)
 DllCall("FreeLibrary",UPtr,hModule)
 FormatInteger := A_FormatInteger, MD5 := ""
 SetFormat, IntegerFast, Hex
 Loop, 16
  MD5 .= SubStr("0" . SubStr(NumGet(Temp1,87 + A_Index,"UChar"),3),-1)
 SetFormat, IntegerFast, %FormatInteger%
 Return, MD5
}