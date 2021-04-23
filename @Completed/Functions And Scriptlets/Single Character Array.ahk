;AHK v1
#NoEnv

/*
NegativeCells := "mlkjihgfedcba"
PositiveCells := "nopq"
Loop, Parse, NegativeCells
 CellPut(A_Index + 10,A_LoopField)
CellPut(-30,"!")
CellPut(30,"@")
MsgBox % CellGet(-30) . "`n" . CellGet(30)
MsgBox "%NegativeCells%" "%PositiveCells%"
*/

CellGet(Index,DefaultCell = "_")
{
 global NegativeCells, PositiveCells
 Temp1 := (Index < 0) ? SubStr(NegativeCells,0 - Index,1) : SubStr(PositiveCells,Index + 1,1)
 Return, (Temp1 = "") ? DefaultCell : Temp1
}

CellPut(Index,Char,DefaultCell = "_")
{
 global NegativeCells, PositiveCells
 static StrGetFunc := "StrGet"
 CharType := A_IsUnicode ? "UShort" : "UChar"
 If (Index < 0)
 {
  Index := 0 - Index, Temp1 := Index - StrLen(NegativeCells)
  If (Temp1 > 0)
   VarSetCapacity(Pad,64), VarSetCapacity(Pad,0), VarSetCapacity(Pad,Temp1,Asc(DefaultCell)), NegativeCells .= A_IsUnicode ? %StrGetFunc%(&Pad,Temp1,"CP0") : Pad
  NumPut(Asc(Char),NegativeCells,(Index - 1) << !!A_IsUnicode,CharType)
 }
 Else
 {
  Temp1 := (Index - StrLen(PositiveCells)) + 1
  If (Temp1 > 0)
   VarSetCapacity(Pad,64), VarSetCapacity(Pad,0), VarSetCapacity(Pad,Temp1,Asc(DefaultCell)), PositiveCells .= A_IsUnicode ? %StrGetFunc%(&Pad,Temp1,"CP0") : Pad
  NumPut(Asc(Char),PositiveCells,Index << !!A_IsUnicode,CharType)
 }
}