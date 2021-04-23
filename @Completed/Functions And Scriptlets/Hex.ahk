;AHK v1
#NoEnv

/*
Gui, Add, Edit, x10 y10 h100 w400 vEdit1 gUpdate1
Gui, Add, Edit, x10 y120 h100 w400 vEdit2 gUpdate2
Gui, Show, w420 h230
Return

Update1:
GuiControlGet, Edit1,, Edit1
Edit1 := TextToHex(Edit1)
GuiControl,, Edit2, %Edit1%
Return

Update2:
GuiControlGet, Edit2,, Edit2
Edit2 := HexToText(Edit2)
GuiControl,, Edit1, %Edit2%
Return

GuiEscape:
GuiClose:
ExitApp
*/

TextToHex(ByRef Text)
{
 FormatInteger := A_FormatInteger, Result
 SetFormat, IntegerFast, Hex
 Loop, Parse, Text
  Result .= SubStr("0" . SubStr(Asc(A_LoopField),3),-1)
 SetFormat, IntegerFast, %FormatInteger%
 Return, Result
}

HexToText(ByRef Hex)
{
 Index := 1, Result := ""
 Loop, % StrLen(Hex) >> 1
  Result .= Chr("0x" . SubStr(Hex,Index,2)), Index += 2
 Return, Result
}

DumpMemory(ByRef MemDump,pData,DataLength)
{
 A_FormatInteger1 := A_FormatInteger, pData --
 VarSetCapacity(MemDump,DataLength << 1)
 SetFormat, IntegerFast, Hex
 Loop, %DataLength%
  MemDump .= SubStr("0" . SubStr(NumGet(pData + A_Index,0,"UChar"),3),-1)
 SetFormat, IntegerFast, %A_FormatInteger1%
}