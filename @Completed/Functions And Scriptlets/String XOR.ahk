#NoEnv

/*
String1 := "abcdef ghijkl"
String2 := "abcdef mnopqr"
ToHex(Hex1,String1), ToHex(Hex2,String2)
HexXOR(Result,Hex1,Hex2)
MsgBox "%Result%"
HexXOR(Temp1,Result,Hex2), HexXOR(Hex2,Result,Hex1), Hex1 := Temp1
ToString(String1,Hex1), ToString(String2,Hex2)
MsgBox "%String1%" "%String2%" ;(x ^ y) ^ y = x
*/

ToHex(ByRef Hex,ByRef String)
{
 VarSetCapacity(Hex,StrLen(String) << 1)
 SetFormat, IntegerFast, Hex
 Loop, Parse, String
  Hex .= SubStr("0" . SubStr(Asc(A_LoopField),3),-1)
 SetFormat, IntegerFast, D
}

ToString(ByRef String,ByRef Hex)
{
 Temp1 := StrLen(Hex) >> 1, VarSetCapacity(String,Temp1)
 SetFormat, IntegerFast, Hex
 Loop, %Temp1%
  String .= Chr("0x" . SubStr(Hex,(A_Index << 1) - 1,2))
 SetFormat, IntegerFast, D
}

HexXOR(ByRef Result,ByRef Hex1,ByRef Hex2)
{
 SetFormat, IntegerFast, Hex
 Hex1Length := StrLen(Hex1), Hex2Length := StrLen(Hex2), VarSetCapacity(Temp1,Abs(Hex1Length - Hex2Length),Asc("0")), (Hex1Length < Hex2Length) ? (Hex1 .= Temp1) : (Hex2 .= Temp1)
 VarSetCapacity(Temp1,64), Result := ""
 Loop, % StrLen(Hex1) >> 1
  Temp1 := (A_Index << 1) - 1, Temp2 := "0x" . SubStr(Hex2,Temp1,2), Temp1 := "0x" . SubStr(Hex1,Temp1,2), Result .= SubStr("0" . SubStr(Temp1 ^ Temp2,3),-1)
 SetFormat, IntegerFast, D
}