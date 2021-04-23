;AHK v1
#NoEnv

;MsgBox % Clipboard := FindFactors(9999999999)

FindFactors(Num)
{
 Loop, % Floor(Sqrt(Abs(Num)))
  `(!Mod(Num,A_Index)) ? (Temp1 := Num // A_Index, FactorList .= A_Index . "," . Temp1 . "`n" . (0 - A_Index) . "," . (0 - Temp1) . "`n")
 Return, SubStr(FactorList,1,-1)
}