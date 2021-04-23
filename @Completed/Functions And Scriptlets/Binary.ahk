;AHK v1
#NoEnv

/*
MsgBox % BinaryToText(Temp1 := TextToBinary("Test")) . "`n" . Temp1
MsgBox % BinaryToNumber(Temp1 := NumberToBinary(1234)) . "`n" . Temp1
*/

TextToBinary(ByRef InputText)
{
 Result := ""
 Loop, Parse, InputText
 {
  Temp1 := Asc(A_LoopField)
  While, Temp1
   Temp2 := (Temp1 & 1) . Temp2, Temp1 >>= 1
  Result .= SubStr("0000000" . Temp2,-7), Temp2 := ""
 }
 Return, Result
}

BinaryToText(ByRef InputBinary)
{
 Index := 1, Length := StrLen(InputBinary) >> 3, Result := ""
 Loop, %Length%
  Result .= Chr((SubStr(InputBinary,Index ++,1) << 7) + (SubStr(InputBinary,Index ++,1) << 6) + (SubStr(InputBinary,Index ++,1) << 5) + (SubStr(InputBinary,Index ++,1) << 4) + (SubStr(InputBinary,Index ++,1) << 3) + (SubStr(InputBinary,Index ++,1) << 2) + (SubStr(InputBinary,Index ++,1) << 1) + (SubStr(InputBinary,Index ++,1)))
 Return, Result
}

NumberToBinary(InputNumber)
{
 While, InputNumber
  Result := (InputNumber & 1) . Result, InputNumber >>= 1
 Return, Result
}

BinaryToNumber(InputBinary)
{
 Length := StrLen(InputBinary), Result := 0
 Loop, Parse, InputBinary
  Result += A_LoopField << (Length - A_Index)
 Return, Result
}