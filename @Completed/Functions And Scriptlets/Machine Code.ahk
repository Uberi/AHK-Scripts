;AHK v1 32bit
#NoEnv

/*
Bin := "AaBbCc"

Length := StrLen(Bin)
PrepareMachineCode(BinToHex,"8B54240C85D2568B7424087E3A53578B7C24148A07478AC8C0E90480F9090F97C3F6DB80E30702D980C330240F881E463C090F97C1F6D980E10702C880C130880E464A75CE5F5BC606005EC3")
VarSetCapacity(Hex,Length << 1), DllCall(&BinToHex,"UInt",&Hex,"UInt",&Bin,"UInt",Length,"Cdecl"), VarSetCapacity(Hex,-1)
MsgBox, %Hex%
ExitApp
*/

PrepareMachineCode(ByRef Code,Hex)
{
 Temp1 := StrLen(Hex) >> 1, VarSetCapacity(Code,Temp1)
 Loop, %Temp1%
  NumPut("0x" . SubStr(Hex,(2 * A_Index) - 1,2),Code,A_Index - 1,"Char")
 DllCall("VirtualProtect","UInt",&Code,"UInt",Temp1,"UInt",0x40,"UInt*",0)
}