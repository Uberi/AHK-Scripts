;AHK v1
#NoEnv

/*
;another method that operates in O(n*log(n)) time is to sort both the opening and closing numbers of the entry, and then only loop through the lists once per window
String := "20-31,50-70,32-78,87-99"
MsgBox % """" . RangeOverlap1(String) . """"
*/

RangeOverlap(NumberWindows,EntryDelimiter = ",",ItemDelimiter = "-")
{
 Loop, Parse, NumberWindows, %EntryDelimiter%
 {
  StringSplit, Window, A_LoopField, %ItemDelimiter%
  Index := A_Index, LoopField := A_LoopField
  Loop, Parse, NumberWindows, %EntryDelimiter%
  {
   If (A_Index = Index)
    Continue
   StringSplit, Temp, A_LoopField, %ItemDelimiter%
   If (Temp1 > Window1 && Temp1 < Window2 && Temp2 > Window1 && Temp2 < Window2)
    Conflicts .= A_LoopField . EntryDelimiter . LoopField . EntryDelimiter
  }
 }
 Return, SubStr(Conflicts,1,-1)
}