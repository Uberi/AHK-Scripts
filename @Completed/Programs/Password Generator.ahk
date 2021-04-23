#NoEnv

#NoTrayIcon

CharList = 1234567890``!@#$`%^&*_+:<>?abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-=\`;'`,./

Gui, Font, S12 CDefault Bold, Arial
Gui, Add, Text, x2 y0 w250 h30 Center, Password Generator
Gui, Font, S10 CDefault Norm, Arial
Gui, Add, Text, x2 y30 w90 h20, Site Name:
Gui, Add, Edit, x82 y30 w170 h20 vSite, example.com
Gui, Add, Text, x2 y60 w90 h20, Username:
Gui, Add, Edit, x82 y60 w170 h20 vUsername, Username
Gui, Add, Text, x2 y90 w90 h20, Master Key:
Gui, Add, Edit, x82 y90 w170 h20 Password vMasterKey, Master Key
Gui, Add, Button, x2 y120 w250 h30 Default, Copy To Clipboard
Gui, +ToolWindow +AlwaysOnTop
Gui, Show, w255 h155, Password Generator
Return

GuiEscape:
GuiClose:
ExitApp

ButtonCopyToClipboard:
Gui, Submit, NoHide
Temp1 := MasterKey . "~" . Site . "~" . Username, Temp1 := SHA512(Temp1,MasterKey), Temp2 := ""
Loop, 64
 Temp2 .= SubStr(CharList,Mod("0x" . SubStr(Temp1,A_Index << 1,2),85),1)
Clipboard := Temp2
Return

SHA512(ByRef Data,ByRef Key = "",DataSize = "")
{
 % (DataSize = "") ? DataSize := StrLen(Data)
 KeySize := StrLen(Key), VarSetCapacity(Temp1,20,0), NumPut(0x800E,Temp1,0,"UInt"), Temp2 := 12 + KeySize
 VarSetCapacity(Temp3,Temp2,0), NumPut(8,Temp3,0,"Char"), NumPut(2,Temp3,1,"Char"), NumPut(0x6602,Temp3,4,"UInt"), NumPut(KeySize,Temp3,8,"Char"), DllCall("RtlMoveMemory","UInt",&Temp3 + 12,"UInt",&Key,"Int",KeySize)
 hModule := DllCall("LoadLibrary","Str","advapi32.dll")
 DllCall("advapi32\CryptAcquireContextA","UInt*",Temp4,"UInt",0,"UInt",0,"UInt",1,"UInt",0xF0000000)
 DllCall("advapi32\CryptImportKey","UInt",Temp4,"UInt",&Temp3,"UInt",Temp2,"UInt",0,"UInt",0x100,"UInt*",hKey)
 DllCall("advapi32\CryptCreateHash","UInt",Temp4,"UInt",0x8009,"UInt",hKey,"UInt",0,"UInt*",hHash)
 DllCall("advapi32\CryptSetHashParam","UInt",hHash,"UInt",5,"UInt",&Temp1,"UInt",0)
 DllCall("advapi32\CryptHashData","UInt",hHash,"UInt",&Data,"UInt",DataSize,"UInt",0)
 Temp1 := 64, VarSetCapacity(Temp2,Temp1,0), DllCall("advapi32\CryptGetHashParam","UInt",hHash,"UInt",2,"UInt",&Temp2,"UInt*",Temp1,"UInt",0)
 DllCall("advapi32\CryptDestroyHash","UInt",hHash), DllCall("advapi32\CryptDestroyKey","UInt",hKey), DllCall("advapi32\CryptDestroyHash","UInt",hHash), DllCall("advapi32\CryptReleaseContext","UInt",Temp4,"UInt",0)
 DllCall("FreeLibrary","UInt",hModule)
 A_FormatInteger1 = %A_FormatInteger%
 SetFormat, IntegerFast, Hex
 Loop, %Temp1%
  Hash .= SubStr("0" . SubStr(NumGet(&Temp2 + (A_Index - 1),0,"UChar"),3),-1)
 SetFormat, IntegerFast, %A_FormatInteger1%
 StringUpper, Hash, Hash
 Return, Hash
}