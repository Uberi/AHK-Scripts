#NoEnv 

/*
Temp1 = abc123test123abc
BinaryStringCopy(Temp2,Temp1,StrLen(Temp1))
MsgBox "%Temp2%"

Temp1 = abc123test123abc
BinarySubStr(Temp1,Temp1,7,4)
MsgBox "%Temp1%"

Temp1 = abc123test123abc
Temp2 = SomeText

BinaryConcatenate(Temp1,StrLen(Temp1),Temp2,StrLen(Temp2))
MsgBox "%Temp1%"

Temp2 = 123a
MsgBox % BinaryInStr(Temp1,StrLen(Temp1),Temp2,StrLen(Temp2))
Temp1 = abc123test123abc
BinaryToHex(Temp2,Temp1,StrLen(Temp1))
MsgBox "%Temp2%"

Temp1 = 61626331323374657374313233616263
BinaryFromHex(Temp2,Temp1)
MsgBox "%Temp2%"

Temp1 = abc123test123abc
Temp2 = abc123test123abc
MsgBox % BinaryStringsAreEqual(Temp1,StrLen(Temp1),Temp2,StrLen(Temp2))
*/

BinaryStringCopy(ByRef OutputVar,ByRef InputVar,Length)
{
 % (&OutputVar <> &InputVar) ? (VarSetCapacity(OutputVar,Length,10), DllCall("RtlMoveMemory","UInt",&OutputVar,"UInt",&InputVar,"UInt",Length))
}

BinaryStringsAreEqual(ByRef String1,String1Length,ByRef String2,String2Length)
{
 If String1Length <> %String2Length%
  Return, 0
 Loop, %String1Length%
 {
  Temp1 := A_Index - 1
  If (NumGet(String1,Temp1,"Char") <> NumGet(String2,Temp1,"Char"))
   Return, 0
 }
 Return, 1
}

BinaryConcatenate(ByRef OriginalString,OriginalStringLength,ByRef StringToAppend,StringToAppendLength)
{
 Temp1 := OriginalStringLength + StringToAppendLength, VarSetCapacity(Temp2,Temp1,10), DllCall("RtlMoveMemory","UInt",&Temp2,"UInt",&OriginalString,"UInt",OriginalStringLength), DllCall("RtlMoveMemory","UInt",&Temp2 + OriginalStringLength,"UInt",&StringToAppend,"UInt",StringToAppendLength), VarSetCapacity(OriginalString,64,10), VarSetCapacity(OriginalString,0,10), VarSetCapacity(OriginalString,Temp1,10), DllCall("RtlMoveMemory","UInt",&OriginalString,"UInt",&Temp2,"UInt",Temp1)
}

BinarySubStr(ByRef OutputVar,ByRef InputVar,StartingPos,Length = "")
{
 % (&OutputVar <> &InputVar) ? (VarSetCapacity(OutputVar,Length,10), DllCall("RtlMoveMemory","UInt",&OutputVar,"UInt",&InputVar + (StartingPos - 1),"UInt",Length)) : (VarSetCapacity(Temp1,Length,10), DllCall("RtlMoveMemory","UInt",&Temp1,"UInt",&InputVar + (StartingPos - 1),"UInt",Length), VarSetCapacity(OutputVar,64), VarSetCapacity(OutputVar,0), VarSetCapacity(OutputVar,Length,10), DllCall("RtlMoveMemory","UInt",&OutputVar,"UInt",&Temp1,"UInt",Length))
}

BinaryInStr(ByRef InputVar,InputVarLength,ByRef SearchString,SearchStringLength,StartingPos = 1)
{
 If ((StartingPos + SearchStringLength) > InputVarLength || StartingPos < 1)
  Return, 0
 StartingPos -= 2, MatchCount := 0
 Loop, %InputVarLength%
 {
  If (NumGet(InputVar,A_Index + StartingPos,"Char") = NumGet(SearchString,MatchCount,"Char"))
  {
   MatchCount ++
   If MatchCount = %SearchStringLength%
    Return, (A_Index - SearchStringLength) + StartingPos + 2
  }
  Else
   MatchCount = 0
 }
 Return, 0
}

BinaryToHex(ByRef OutputVar,ByRef InputBinary,InputLength)
{
 OutputVar := "", VarSetCapacity(OutputVar,InputLength << 1), FormatOld := A_FormatInteger
 SetFormat, Integer, Hex
 Loop, %InputLength%
  OutputVar .= SubStr("0" . SubStr(NumGet(InputBinary,A_Index - 1,"Char"),3),-1)
 SetFormat, Integer, %FormatOld%
}

BinaryFromHex(ByRef OutputVar,ByRef Hex)
{
 Temp1 := StrLen(Hex) >> 1, VarSetCapacity(OutputVar,Temp1,10)
 Loop, %Temp1%
  NumPut("0x" . SubStr(Hex,(A_Index * 2) - 1,2),OutputVar,A_Index - 1,"Char")
}