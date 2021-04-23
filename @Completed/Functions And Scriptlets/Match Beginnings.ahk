;AHK v1
#NoEnv

/*
Word := "d"
Text1 := "abc`ndef`nghi`njkl`ndgh"
MatchedAmount := MatchAllBeginnings(Matched,Text1,Word)
MsgBox % """" . Matched . """`n`n" . MatchedAmount . " Matches"
*/

MatchAllBeginnings(ByRef Output,ByRef WordList,ByRef SearchWord,ListDelimiter = "`n",MaxMatches = 20)
{
 Temp2 := 1, Output := "", OutputCount := 0
 While, ((Temp1 := InStr(ListDelimiter . WordList,ListDelimiter . SearchWord,0,Temp2)) && A_Index <= MaxMatches)
  Temp2 := InStr(WordList . ListDelimiter,ListDelimiter,0,Temp1), Output .= SubStr(WordList,Temp1,Temp2 - Temp1) . ListDelimiter, OutputCount ++
 Output := SubStr(Output,1,-1)
 Return, OutputCount
}