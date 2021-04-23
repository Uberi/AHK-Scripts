#NoEnv

;#NoTrayIcon
ListLines, Off
Target = %1%
If Target = 
 ExitApp
OnMessage(0x4a,"ReceiveData")
Gosub, CheckServer
SetTimer, CheckServer, 5000
Temp1 = StartUp
If IsFunc(Temp1)
{
 ListLines, On
 %Temp1%()
 ListLines, Off
}
Return

SendData:
SetTimer, SendData, Off
WebPage := "", Header := "", PageLen := ""
Gosub, Start
ListLines, Off
If PageLen = 
 PageLen := StrLen(WebPage) + StrLen(Header) + 1
Echo(WebPage,Header,PageLen)
Return

CheckServer:
ListLines, Off
DetectHiddenWindows, On
SetTitleMatchMode, 2
If Target
{
 IfWinNotExist, ahk_class AutoHotkey ahk_id %Target%
  ExitApp
}
Return

ReceiveData(wParam, lParam)
{
 Critical
 global ReceivedData
 global Values
 global IPAddress
 StringAddress := NumGet(lParam + 8)
 StringLength := DllCall("lstrlen","UInt",StringAddress)
 VarSetCapacity(ReceivedData,StringLength)
 DllCall("lstrcpy","Str",ReceivedData,"UInt",StringAddress)
 Temp1 := InStr(ReceivedData,"`n")
 StringLeft, IPAddress, ReceivedData, Temp1 - 1
 StringTrimLeft, ReceivedData, ReceivedData, %Temp1%
 Temp1 := InStr(ReceivedData,"`n")
 StringLeft, Values, ReceivedData, Temp1 - 1
 StringTrimLeft, ReceivedData, ReceivedData, %Temp1%
 SetTimer, SendData, 0
 Return, 1
}

Echo(ByRef Data,ByRef Header,ByRef DataLen)
{
 global Target
 ListLines, Off
 Critical
 Data = %Header%|%Data%
 VarSetCapacity(CopyDataStruct,12,0)
 NumPut(DataLen + 2,CopyDataStruct,4)
 NumPut(&Data,CopyDataStruct,8)
 DetectHiddenWindows, On
 SetTitleMatchMode, 2
 SendMessage, 0x4a, 0, &CopyDataStruct,, ahk_class AutoHotkey ahk_id %Target%
 ListLines, On
}

GetVars(VarList)
{
 local VarName
 local Temp1
 ListLines, Off
 Critical
 Loop, Parse, Values, &
 {
  Temp1 := InStr(A_LoopField,"=")
  If Not Temp1
   Continue
  StringLeft, VarName, A_LoopField, Temp1 - 1
  StringTrimLeft, Temp1, A_LoopField, %Temp1%
  Temp1 := URLDecode(Temp1)
  If VarName In %VarList%
   %VarName% = %Temp1%
 }
 ListLines, On
}

URLDecode(ByRef Encoded)
{
 StringReplace, Encoded, Encoded, +, %A_Space%, All
 Loop, Parse, Encoded, `%
  % (A_Index = 1) ? Decoded := A_LoopField : Decoded .= Chr("0x" . SubStr(A_LoopField,1,2)) . SubStr(A_LoopField,3)
 Return, RegExReplace(Decoded,"S)[^\w\s[::punct::]]")
}

GetPostData(ByRef PostData)
{
 global ReceivedData
 ListLines, Off
 ParseList = `n`r`n`r,`n`n,`r`n`r`n,`r`r
 PostData = 
 Loop, Parse, ParseList, CSV
 {
  Temp1 := InStr(ReceivedData,A_LoopField)
  If Temp1
  {
   PostData := SubStr(ReceivedData,Temp1 + StrLen(A_LoopField))
   Break
  }
 }
 ListLines, On
}

PostVars(VarList)
{
 local VarName
 local Temp1
 local PostData
 ListLines, Off
 GetPostData(PostData)
 Loop, Parse, PostData, &
 {
  IfNotInString, A_LoopField, =
   Continue
  Temp1 := InStr(A_LoopField,"=")
  StringLeft, VarName, A_LoopField, Temp1 - 1
  StringTrimLeft, Temp1, A_LoopField, %Temp1%
  If VarName In %VarList%
   %VarName% = %Temp1%
 }
 ListLines, On
}

Start:
ListLines, On