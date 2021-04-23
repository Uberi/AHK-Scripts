#NoEnv

Temp1 := "a b c d e fghijklmnopqrstuvw x", NumPut(1,Temp1,5)
DumpMemory(MemDump,&Temp1,StrLen(Temp1))
StringUpper, MemDump, MemDump
FormatDump(Formatted,MemDump)
DumpToString(String,MemDump)
Formatted .= "`n`n" . String
MsgBox %Formatted%
Clipboard = %Formatted%

DumpMemory(ByRef MemDump,pData,DataLength)
{
 A_FormatInteger1 := A_FormatInteger, pData --
 VarSetCapacity(MemDump,DataLength << 1)
 SetFormat, IntegerFast, Hex
 Loop, %DataLength%
  MemDump .= SubStr("0" . SubStr(NumGet(pData + A_Index,0,"UChar"),3),-1)
 SetFormat, IntegerFast, %A_FormatInteger1%
}

DumpToString(ByRef String,ByRef MemDump)
{
 Length := StrLen(MemDump) // 2, VarSetCapacity(String,Length)
 Loop, %Length%
  Temp1 := "0x" . SubStr(MemDump,(A_Index * 2) - 1,2), String .= (Temp1 < 32 || Temp1 > 126) ? "?" : Chr(Temp1)
}

FormatDump(ByRef Formatted,ByRef MemDump,PadWidth = 13)
{
 DumpLength := StrLen(MemDump), VarSetCapacity(Formatted,(Ceil((DumpLength + Mod(DumpLength,4)) / 8) * 43) + 46), Formatted := "Offset    Integer       Hex Char       String`n", Offset := 1
 Loop, % DumpLength // 8
  Char1 := SubStr(MemDump,Offset,2), Offset += 2, Char2 := SubStr(MemDump,Offset,2), Offset += 2, Char3 := SubStr(MemDump,Offset,2), Offset += 2, Char4 := SubStr(MemDump,Offset,2), Offset += 2, Temp1 := "0x" . Char4 . Char3 . Char2 . Char1, Temp1 += 0, Temp2 := (A_Index - 1) * 4, Temp3 := Char1 . "," . Char2 . "," . Char3 . "," . Char4, Formatted .= Temp2, VarSetCapacity(Temp4,64), VarSetCapacity(Temp4,0), VarSetCapacity(Temp4,10 - Strlen(Temp2),32), Formatted .= Temp4 . Temp1, VarSetCapacity(Temp4,64), VarSetCapacity(Temp4,0), VarSetCapacity(Temp4,14 - Strlen(Temp1),32), Formatted .= Temp4 . Temp3, VarSetCapacity(Temp4,64), VarSetCapacity(Temp4,0), VarSetCapacity(Temp4,15 - Strlen(Temp3),32), Char1 := "0x" . Char1, Char2 := "0x" . Char2, Char3 := "0x" . Char3, Char4 := "0x" . Char4, Formatted .= Temp4 . ((Char1 < 32 || Char1 > 126) ? "?" : Chr(Char1)) . ((Char2 < 32 || Char2 > 126) ? "?" : Chr(Char2)) . ((Char3 < 32 || Char3 > 126) ? "?" : Chr(Char3)) . ((Char4 < 32 || Char4 > 126) ? "?" : Chr(Char4)) . "`n"
 If Mod(DumpLength,8)
  Char1 := SubStr(MemDump,Offset,2), Char2 := SubStr(MemDump,Offset + 2,2), Char3 := SubStr(MemDump,Offset + 4,2), Char4 := SubStr(MemDump,Offset + 6,2), Temp1 := "0x" . Char4 . Char3 . Char2 . Char1, Temp1 += 0, Temp3 := Char1 . ((Char4 <> "") ? ("," . Char2 . "," . Char3 . "," . Char4) : ((Char3 <> "") ? (("," . Char2 . "," . Char3)) : ((Char2 <> "") ? ("," . Char2) : ""))), Formatted .= Temp2 + 4, VarSetCapacity(Temp4,64), VarSetCapacity(Temp4,0), VarSetCapacity(Temp4,10 - Strlen(Temp2),32), Formatted .= Temp4 . Temp1, VarSetCapacity(Temp4,64), VarSetCapacity(Temp4,0), VarSetCapacity(Temp4,14 - Strlen(Temp1),32), Formatted .= Temp4 . Temp3, VarSetCapacity(Temp4,64), VarSetCapacity(Temp4,0), VarSetCapacity(Temp4,15 - Strlen(Temp3),32), Char1 := "0x" . Char1, Char2 := "0x" . Char2, Char3 := "0x" . Char3, Char4 := "0x" . Char4, Formatted .= Temp4 . ((Char1 < 32 || Char1 > 126) ? ((Char1 = "0x") ? "" : "?") : Chr(Char1)) . ((Char2 < 32 || Char2 > 126) ? ((Char2 = "0x") ? "" : "?") : Chr(Char2)) . ((Char3 < 32 || Char3 > 126) ? ((Char3 = "0x") ? "" : "?") : Chr(Char3)) . ((Char4 < 32 || Char4 > 126) ? ((Char4 = "0x") ? "" : "?") : Chr(Char4)) . "`n"
 StringTrimRight, Formatted, Formatted, 1
}