;AHK v1
#NoEnv

/*
SetBatchLines, -1
Loop, 30
 Var .= "Line " . A_Index . "`n"
StringTrimRight, Var, Var, 1
ReverseLines(Var)
MsgBox "%Var%"
*/

ReverseLines(ByRef LineList)
{
 CharShift := !!A_IsUnicode, UPtr := A_PtrSize ? "UPtr" : "UInt", Offset := &LineList + ((StrLen(LineList) + 1) << CharShift)
 Loop, Parse, LineList, `n
  CurrentLine := A_LoopField . "`n", Length := StrLen(CurrentLine) << CharShift, Offset -= Length, DllCall("RtlMoveMemory",UPtr,Offset,UPtr,&CurrentLine,"UInt",Length)
}