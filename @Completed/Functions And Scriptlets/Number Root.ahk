;AHK v1
#NoEnv

;MsgBox % NumberRoot(8,3)

NumberRoot(Num,Root,DecimalPlaces = 6)
{
 ;alternatively: Return, Num ** (1 / Root)
 Precision := 10 ** (-1 - DecimalPlaces), Guess1 := 0, Guess := Num / Root
 While, (Abs(Guess1 - Guess) > Precision)
  Guess1 := Guess, Guess := (((Root - 1) * Guess) + (Num / (Guess ** (Root - 1)))) / Root
 Return, Round(Guess,DecimalPlaces)
}