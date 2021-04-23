;AHK v1
#NoEnv

/*
RC4Password := "123"
Message := "abc"
Temp1 := RC4Encrypt(Message,RC4Password)
MsgBox % Temp1 . "`n" . RC4Decrypt(Temp1,RC4Password)
*/

RC4Encrypt(Data,Pass)
{
 PassLength := StrLen(Pass), b := 0, j := 0, a := 0
 FormatInteger := A_FormatInteger
 SetFormat, IntegerFast, Hex
 Loop, 256
  Key%a% := Asc(SubStr(Pass,Mod(a,PassLength) + 1,1)), sBox%a% := a, a ++
 a := 0
 Loop, 256
  Temp1 := sBox%a%, b := (b + Temp1 + Key%a%) & 255, sBox%a% := sBox%b%, sBox%b% := Temp1, a ++
 VarSetCapacity(Result,StrLen(Data) << 1)
 Loop, Parse, Data
  i := A_Index & 255, Temp1 := sBox%i%, j := (j + Temp1) & 255, k := (Temp1 + sBox%j%) & 255, Result .= SubStr(Asc(A_LoopField) ^ sBox%k%,-1,2)
 SetFormat, IntegerFast, %FormatInteger%
 StringReplace, Result, Result, x, 0, All
 Return, Result
}

RC4Decrypt(Data,Pass)
{
 PassLength := StrLen(Pass), b := 0, j := 0, a := 0, VarSetCapacity(Result,StrLen(Data) >> 1)
 Loop, 256
  Key%a% := Asc(SubStr(Pass,Mod(a,PassLength) + 1,1)), sBox%a% := a, a ++
 a := 0
 Loop, 256
  Temp1 := sBox%a%, b := (b + Temp1 + Key%a%) & 255, sBox%a% := sBox%b%, sBox%b% := Temp1, a ++
 Position := 1
 Loop, % StrLen(Data) >> 1
  i := A_Index & 255, Temp1 := sBox%i%, j := (j + Temp1) & 255, k := (Temp1 + sBox%j%) & 255, r := "0x" . SubStr(Data,Position,2), NumPut(r ^ sBox%k%,Result,Position >> 1,"UChar"), Position += 2
 Return, Result
}