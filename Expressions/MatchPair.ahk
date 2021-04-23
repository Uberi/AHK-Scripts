#NoEnv

MatchPair(ByRef String,Position,ByRef Output = "",OpenCharacter = "(",CloseCharacter = ")")
{
 Temp1 := SubStr(String,Position), BracketCount := 0, VarSetCapacity(Output,StrLen(Temp1))
 If (SubStr(Temp1,1,1) <> OpenCharacter)
  Return, 0
 Loop, Parse, Temp1
 {
  If A_LoopField = %OpenCharacter%
   BracketCount ++
  Else If A_LoopField = %CloseCharacter%
  {
   BracketCount --
   If BracketCount = 0
    Return, Position + (A_Index - 1)
  }
  Else If BracketCount = 1
   Output .= A_LoopField
 }
 Return, 0
}