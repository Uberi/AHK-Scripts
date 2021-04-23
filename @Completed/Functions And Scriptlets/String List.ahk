;AHK v1
#NoEnv

/*
;StringList := "`nRed`nOrange`nYellow`nGreen`nBlue`nIndigo`nViolet`nBlue`nStringTest`n", ElementDelimiter := "`n"
StringList := "`r`nRed`r`nOrange`r`nYellow`r`nGreen`r`nBlue`r`nIndigo`r`nViolet`r`nBlue`r`nStringTest`r`n", ElementDelimiter := "`r`n"

MsgBox % """" . StringElementList(StringList,ElementDelimiter) . """" ;Red`nOrange`nYellow`nGreen`nBlue`nIndigo`nViolet`nBlue`nStringTest
MsgBox % """" . StringElementCount(StringList,"",ElementDelimiter) . """" ;9
MsgBox % """" . StringElementCount(StringList,"Blue",ElementDelimiter) . """" ;2
MsgBox % """" . StringElementFind(StringList,"Blue",6,0,ElementDelimiter) . """" ;8
MsgBox % """" . StringElementGet(StringList,-3,1,ElementDelimiter) . """" ;`nViolet`n
MsgBox % """" . StringElementGet(StringList,3,4,ElementDelimiter) . """" ;`nYellow`nGreen`nBlue`nIndigo`n
MsgBox % """" . StringElementInsert(StringList,"TestString","",0,ElementDelimiter) . """" ;`nRed`nOrange`nYellow`nGreen`nBlue`nIndigo`nViolet`nBlue`nStringTest`nTestString`n
MsgBox % """" . StringElementInsert(StringList,"SomeString",3,0,ElementDelimiter) . """" ;`nRed`nOrange`nSomeString`nYellow`nGreen`nBlue`nIndigo`nViolet`nBlue`nStringTest`n
MsgBox % """" . StringElementInsert(StringList,"SomeTest",-5,1,ElementDelimiter) . """" ;`nRed`nOrange`nYellow`nGreen`nSomeTest`nIndigo`nViolet`nBlue`nStringTest`n
MsgBox % """" . StringElementRemove(StringList,-3,1,ElementDelimiter) . """" ;`nRed`nOrange`nYellow`nGreen`nBlue`nIndigo`nBlue`nStringTest`n
MsgBox % """" . StringElementRemove(StringList,2,2,ElementDelimiter) . """" ;`nRed`nGreen`nBlue`nIndigo`nViolet`nBlue`nStringTest`n
MsgBox % """" . StringElementReplace(StringList,"Yellow","TestString",0,ElementDelimiter) ;`nRed`nOrange`nTestString`nGreen`nBlue`nIndigo`nViolet`nBlue`nStringTest`n
AnotherStringList := ElementDelimiter . "Another Item" . ElementDelimiter . "Something" . ElementDelimiter
MsgBox % """" . StringElementJoin(StringList,AnotherStringList,ElementDelimiter) . """" ;`nRed`nOrange`nYellow`nGreen`nBlue`nIndigo`nViolet`nBlue`nStringTest`nAnother Item`nSomething`n
MsgBox % """" . StringElementUnique(StringList,0,ElementDelimiter) . """" ;`nRed`nOrange`nYellow`nGreen`nBlue`nIndigo`nViolet`nStringTest`n
StringElementParse(StringList,"TestFunc","BlaBlaBla",ElementDelimiter)
Return

TestFunc(Field,Index,PassBack)
{
 MsgBox "%Field%"`n"%PassBack%"`n%Index%
}
*/

StringElementList(ByRef String,ElementDelimiter = "`n")
{
 Temp1 := StrLen(ElementDelimiter)
 Return, SubStr(String,Temp1 + 1,0 - Temp1)
}

StringElementCount(ByRef String,Item = "",ElementDelimiter = "`n")
{
 If (Item = "")
 {
  StringReplace, String, String, %ElementDelimiter%, %ElementDelimiter%, UseErrorLevel
  Return, ErrorLevel - 1
 }
 Else
 {
  StringReplace, String, String, %ElementDelimiter%%Item%%ElementDelimiter%, %ElementDelimiter%%Item%%ElementDelimiter%, UseErrorLevel
  Return, ErrorLevel
 }
}

StringElementFind(ByRef String,Item,StartingPos = 1,CaseSense = 0,ElementDelimiter = "`n")
{
 StringGetPos, StartingPos, String, %ElementDelimiter%, % (StartingPos > 0) ? ("L" . StartingPos) : ("R" . (1 - StartingPos))
 Temp1 := InStr(String,ElementDelimiter . Item . ElementDelimiter,CaseSense,StartingPos + 1)
 If !Temp1
  Return, -1
 Temp1 := SubStr(String,1,Temp1 - 1)
 StringReplace, Temp1, Temp1, %ElementDelimiter%, %ElementDelimiter%, UseErrorLevel
 Return, ErrorLevel + 1
}

StringElementGet(ByRef String,Index = 1,Amount = 1,ElementDelimiter = "`n")
{
 StringGetPos, Temp1, String, %ElementDelimiter%, % (Index > 0) ? ("L" . Index) : ("R" . (1 - Index))
 Temp3 := StrLen(ElementDelimiter)
 StringGetPos, Temp2, String, %ElementDelimiter%, L%Amount%, Temp1 + Temp3
 Return, ErrorLevel ? -1 : SubStr(String,Temp1 + 1,Temp2 - (Temp1 - Temp3))
}

StringElementInsert(ByRef String,Item = "",Index = "",Replace = 0,ElementDelimiter = "`n")
{
 If (String = "")
  Return, ElementDelimiter . Item . ElementDelimiter
 If (Index = "")
  Return, String . Item . ElementDelimiter
 StringGetPos, Temp1, String, %ElementDelimiter%, % (Index > 0) ? ("L" . Index) : ("R" . (1 - Index))
 Temp2 := StrLen(ElementDelimiter)
 Return, SubStr(String,1,Temp1 + Temp2) . Item . SubStr(String,Replace ? InStr(String,ElementDelimiter,0,Temp1 + Temp2 + 1) : Temp1 + 1)
}

StringElementRemove(ByRef String,Index = 1,Amount = 1,ElementDelimiter = "`n")
{
 StringGetPos, Temp1, String, %ElementDelimiter%, % (Index > 0) ? ("L" . Index) : ("R" . (1 - Index))
 If ErrorLevel
  Return, -1
 Temp2 := StrLen(ElementDelimiter), Temp1 += Temp2
 StringGetPos, Temp3, String, %ElementDelimiter%, L%Amount%, Temp1
 If ErrorLevel
  Return, -1
 Temp1 := SubStr(String,1,Temp1) . SubStr(String,Temp3 + Temp2 + 1)
 Return, (Temp1 = ElementDelimiter) ? "" : Temp1
}

StringElementReplace(ByRef String,Item,Replacement = "",ReplaceAll = 0,ElementDelimiter = "`n")
{
 StringReplace, Temp1, String, %ElementDelimiter%%Item%%ElementDelimiter%, %ElementDelimiter%%Replacement%%ElementDelimiter%, ReplaceAll ? "All" : ""
 Return, Temp1
}

StringElementJoin(ByRef String,ByRef SecondString,ElementDelimiter = "`n")
{
 Return, String . SubStr(SecondString,StrLen(ElementDelimiter) + 1)
}

StringElementUnique(ByRef String,CaseSense = 0,ElementDelimiter = "`n")
{
 Unique := ElementDelimiter, Temp1 := StrLen(ElementDelimiter), FoundPos := 1
 While, (FoundPos := InStr(String,ElementDelimiter,0,FoundPos))
 {
  FoundPos += Temp1, Temp2 := InStr(String,ElementDelimiter,0,FoundPos)
  If !Temp2
   Break
  Temp2 := SubStr(String,FoundPos,Temp2 - FoundPos), !InStr(Unique,ElementDelimiter . Temp2 . ElementDelimiter,CaseSense) ? (Unique .= Temp2 . ElementDelimiter)
 }
 Return, Unique
}

StringElementParse(ByRef String,CallBack,PassBack = "",ElementDelimiter = "`n")
{
 If !IsFunc(CallBack)
  Return, -1
 Temp1 := StrLen(ElementDelimiter), FoundPos := 1
 While, (FoundPos := InStr(String,ElementDelimiter,0,FoundPos))
 {
  FoundPos += Temp1, Temp2 := InStr(String,ElementDelimiter,0,FoundPos)
  If !Temp2
   Break
  Temp2 := SubStr(String,FoundPos,Temp2 - FoundPos)
  %CallBack%(Temp2,A_Index,PassBack)
 }
}