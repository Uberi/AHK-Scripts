;AHK v1
#NoEnv

/*
MatchWord := "tteeoxsm"
WordList := "something`nwordword`nsometext`nanother`ntextsome`nanagram"
MsgBox % FindAnagrams(WordList,MatchWord)
*/

FindAnagrams(ByRef WordList,MatchWord)
{
 Temp1 := RegExReplace(MatchWord,"S).","$0`n")
 Sort, Temp1
 Loop, Parse, WordList, `n
 {
  Temp2 := RegExReplace(A_LoopField,"S).","$0`n")
  Sort, Temp2
  If (Temp1 = Temp2)
   MatchList .= A_LoopField . "`n"
 }
 Return, SubStr(MatchList,1,-1)
}