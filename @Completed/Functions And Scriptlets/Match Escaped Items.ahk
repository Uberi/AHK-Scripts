;AHK v1
#NoEnv

/*
SomeString := "bla""bl\\a1\""1\\\\""23456"
MsgBox % MatchEscaped(SomeString)
*/

MatchEscaped(String,ListDelimiter = "`n",EscapeChar = "\",ItemDelimiter = """")
{
 Chr1 := Chr(1), Chr2 := Chr(2)
 StringReplace, TempString, String, %EscapeChar%%EscapeChar%, %Chr1%%Chr1%, All
 StringReplace, TempString, TempString, %EscapeChar%%ItemDelimiter%, %Chr2%%Chr2%, All
 Position1 := 0
 Loop
 {
  Position := InStr(TempString,ItemDelimiter,0,Position1 + 1) + 1, Position1 := InStr(TempString,ItemDelimiter,0,Position + 1)
  If (Position = 1 || !Position1)
   Break
  QuotedList .= SubStr(TempString,Position,Position1 - Position) . ListDelimiter
 }
 StringReplace, QuotedList, QuotedList, %Chr1%%Chr1%, %EscapeChar%%EscapeChar%, All
 StringReplace, QuotedList, QuotedList, %Chr2%%Chr2%, %EscapeChar%%ItemDelimiter%, All
 QuotedList := SubStr(QuotedList,1,0 - StrLen(ListDelimiter))
 Return, QuotedList
}