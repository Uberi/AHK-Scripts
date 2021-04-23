#NoEnv

#Include OperatorTable.ahk
#Include MatchPair.ahk

;rewrite this to use a parser

;MsgBox % Tokenise("ToolTip(3 * True)")
;MsgBox % """" . (ClipBoard := Tokenise("""abc""""test""=%Bla% . Bla . !!TestFunc(1**3-#(23,2),""'Hello', World!"",Bla)")) . """"
;MsgBox % """" . (ClipBoard := Tokenise("SubStr(Peek(Not -Stack-0.005+Abc()),&Stack,*Stack,-0x20)=""f""")) . """"
;MsgBox % """" . (ClipBoard := Tokenise("SubStr(Var--++Var)")) . """"
;MsgBox % """" . (ClipBoard := Tokenise("Var . ""Hello"" . x.y")) . """"
;MsgBox % """" . (ClipBoard := Tokenise("Var ""H````el``nlo"" . World -x y")) . """"
;MsgBox % """" . (ClipBoard := Tokenise("2**(4*-1+10)/Floor(-1.3) /* This is a multiline comment */,SomeText:=(2<<1)*-3/Sin(4),1+5*3 `;A single line comment`r`nSomeText+5`n6^2-7")) . """"
;MsgBox % """" . (ClipBoard := Tokenise("4 SomeVar 1.5")) . """"

Timer()
{
 static TimerBefore
 TimerBefore <> "" ? (DllCall("QueryPerformanceCounter","Int64*",TimerAfter), DllCall("QueryPerformanceFrequency","Int64*",TickFrequency), Result := (TimerAfter - TimerBefore) / (TickFrequency / 1000), TimerBefore := "") : DllCall("QueryPerformanceCounter","Int64*",TimerBefore)
 Return, Result
}

Tokenise(Expression)
{
 Chr1 := Chr(1), Chr2 := Chr(2)
 Expression := TokeniseStrings(Expression)
 StringReplace, Expression, Expression, `r, `n, All ;normalise end of line characters
 Expression := RegExReplace(Expression,"S)[ \t\n]`;.*?(?=\r|\n|$)|/\*.*?\*/") ;remove comments
 While, InStr(Expression,"`n`n") ;collapse newlines
  StringReplace, Expression, Expression, `n`n, `n, All
 StringReplace, Expression, Expression, `n, %Chr1%`;%Chr2%, All ;tokenise newlines

 Expression := TokeniseWhitespaceSensitiveOperators(Expression)
 Expression := TokeniseNumbers(Expression)

 Expression := RegExReplace(Expression,"S)(%[\w#@\$]{1,253})%","$1") ;convert dynamic variable reference to a unary operator

 Expression := TokeniseVariables(Expression)

 ;substitute the variables True and False for their real values
 Expression := RegExReplace(Expression,"iS)(?:^|" . Chr1 . ")vTrue(?:" . Chr2 . "|$)",Chr1 . "n1" . Chr2)
 Expression := RegExReplace(Expression,"iS)(?:^|" . Chr1 . ")vFalse(?:" . Chr2 . "|$)",Chr1 . "n0" . Chr2)

 Expression := TokeniseFunctions(Expression)

 Expression := RegExReplace(Expression,"S)(^|[^" . Chr2 . "\)-])-" . Chr1 . "n","$1" . Chr1 . "n'2D") ;group unary minuses with literal numbers

 StringReplace, Expression, Expression, %Chr1%n, %Chr1%l, All ;convert literal numbers into generic literals

 Expression := TokeniseContextSensitiveOperators(Expression)
 Expression := TokeniseSyntaxElements(Expression)

 StringReplace, Expression, Expression, %Chr2%%Chr1%, %Chr1%, All ;collapse duplicate delimiters

 If RegExMatch(Expression,"S)" . Chr1 . "[^lvfo\(\),`;]") ;check for invalid tokens
  Return

 Expression := SubStr(Expression,2,-1), FoundPos := 0
 While, (FoundPos := InStr(Expression,"'",False,FoundPos + 1)) ;unescape strings, as everything has been tokenised by this point
 {
  If ((Temp1 := SubStr(Expression,FoundPos + 1,2)) <> 27)
   StringReplace, Expression, Expression, '%Temp1%, % Chr("0x" . Temp1), All
 }
 StringReplace, Expression, Expression, '27, ', All
 Return, Expression
}

TokeniseStrings(Expression)
{
 Chr1 := Chr(1), Chr2 := Chr(2), FoundPos := 1, FoundPos1 := 1
 While, (FoundPos := RegExMatch(Expression,"S)""(?:[^""]|"""")*""",Match,FoundPos))
 {
  Temp1 := SubStr(Match,2,-1) ;remove surrounding quotes
  StringReplace, Temp1, Temp1, "", ", All ;unescape quotes
  StringReplace, Temp1, Temp1, ', '27, All ;escape single quotes
  Temp1 := ProcessEscapeSequences(Temp1)
  SetFormat, IntegerFast, Hex
  While, RegExMatch(Temp1,"iS)[^\w']",Char) ;escape non-word characters
   StringReplace, Temp1, Temp1, %Char%, % "'" . SubStr("0" . SubStr(Asc(Char),3),-1), All
  SetFormat, IntegerFast, D
  Expression1 .= SubStr(Expression,FoundPos1,FoundPos - FoundPos1) . Chr1 . "l" . Temp1 . Chr2, FoundPos += StrLen(Match), FoundPos1 := FoundPos
 }
 Expression1 .= SubStr(Expression,FoundPos1)
 Return, InStr(Expression1,"""") ? "" : Expression1 ;check for unmatched quotes
}

TokeniseWhitespaceSensitiveOperators(Expression)
{
 StringReplace, Expression, Expression, %A_Tab%, %A_Space%, All ;convert tabs to spaces
 Expression := RegExReplace(Expression,"S)([\w#@\$] +|\) *)(?=[" . Chr(1) . Chr(2) . "]*[\w#@\$\(])","$1 . ") ;convert implicit concatenation to explicit
 StringReplace, Expression, Expression, %A_Space%.%A_Space%, \., All ;differentiate concatenation from object access
 StringReplace, Expression, Expression, %A_Space%,, All ;remove all spaces (spaces inside strings are unaffected)
 Return, Expression
}

TokeniseNumbers(Expression)
{
 Chr1 := Chr(1), Chr2 := Chr(2), FoundPos := 1, FoundPos1 := 1
 While, (FoundPos := RegExMatch(Expression,"S)(^|[^\w#@\$'])(0x\d+|\d+(?:\.\d+)?|\.\d+)(?=[^\d\.]|$)",Match,FoundPos))
 {
  Match2 += 0 ;convert numbers to current number format
  StringReplace, Match2, Match2, ., '2E ;escape decimal point
  Expression1 .= SubStr(Expression,FoundPos1,FoundPos - FoundPos1) . Match1 . Chr1 . "n" . Match2 . Chr2, FoundPos += StrLen(Match), FoundPos1 := FoundPos
 }
 Return, Expression1 . SubStr(Expression,FoundPos1)
}

TokeniseVariables(Expression)
{
 Chr1 := Chr(1)
 Return, RegExReplace(Expression,"S)(?:^|[^\w#@\$'" . Chr1 . "])\K[\w#@\$]{1,253}(?=[^\(\w#@\$]|$)",Chr1 . "v$0" . Chr(2))
}

TokeniseFunctions(Expression)
{
 Chr1 := Chr(1), Chr2 := Chr(2), FoundPos := 1, FoundPos1 := 1 ;Tokenise functions
 While, (FoundPos := RegExMatch(Expression,"S)(^|[^\w#@\$'])([\w#@\$]{1,253})(?=\()",Match,FoundPos))
 {
  Temp1 := FoundPos + StrLen(Match) ;position of function's opening parenthesis
  If (SubStr(Expression,Temp1 + 1,1) = ")") ;if the function has no arguments
   ArgumentCount = 0
  Else ;function has arguments
  {
   If Not MatchPair(Expression,Temp1,FunctionArguments) ;matching brace not found
    Return
   StringReplace, FunctionArguments, FunctionArguments, `,, `,, UseErrorLevel
   ArgumentCount := ErrorLevel + 1 ;count the number of arguments passed to the function
  }
  Expression1 .= SubStr(Expression,FoundPos1,FoundPos - FoundPos1) . Match1 . Chr1 . "f" . ArgumentCount . "'20" . Match2 . Chr2, FoundPos += StrLen(Match), FoundPos1 := FoundPos
 }
 Return, Expression1 . SubStr(Expression,FoundPos1)
}

TokeniseContextSensitiveOperators(Expression)
{
 Chr1 := Chr(1), Chr2 := Chr(2)
 StringReplace, Expression, Expression, %Chr1%vNot%Chr2%, \!, All ;differentiate low-precendence logical NOT operator from variable references
 StringReplace, Expression, Expression, %Chr1%vAnd%Chr2%, &&, All ;differentiate logical AND (word form) operator from variable references
 StringReplace, Expression, Expression, %Chr1%vOr%Chr2%, ||, All ;differentiate logical OR (word form) operator from variable references

 Expression := RegExReplace(Expression,"S)(^|[^" . Chr2 . "\)-])-" . Chr1 . "(?=[lvf])","$1\-" . Chr1) ;differentiate unary minus operator from binary minus operator, without matching "--"
 Expression := RegExReplace(Expression,"S)(^|[^" . Chr2 . "\)&])&" . Chr1 . "(?=[lvf])","$1\&" . Chr1) ;differentiate address operator from bitwise AND operator, without matching "&&"
 Expression := RegExReplace(Expression,"S)(^|[^" . Chr2 . "\)\*])\*" . Chr1 . "(?=[lvf])","$1\*" . Chr1) ;differentiate dereference operator from multiplication operator, without matching "**"
 Expression := RegExReplace(Expression,"S)(^|[^" . Chr2 . "\)])(\+\+|--)" . Chr1 . "(?=[lvf])","$1\$2" . Chr1) ;differentiate prefix increment or decrement operator from postfix increment or decrement operator 
 Return, Expression
}

TokeniseSyntaxElements(Expression)
{
 global OperatorList
 Chr1 := Chr(1), Chr2 := Chr(2)
 Temp1 := RegExReplace(OperatorList,"S)[\\\.\*\?\+\[\{\|\(\)\^\$]","\$0") ;escape special characters
 StringReplace, Temp1, Temp1, `n, |, All ;prepare list for regular expression
 Expression := RegExReplace(Expression,"S)" . Temp1,Chr1 . "o$0" . Chr2) ;tokenise operators

 StringReplace, Expression, Expression, `,, %Chr1%`,%Chr2%, All ;Tokenise function argument or multi-statement separator

 StringReplace, Expression, Expression, (, %Chr1%(%Chr2%, All ;Tokenise parentheses
 StringReplace, Expression, Expression, ), %Chr1%)%Chr2%, All
 Return, Expression
}

ProcessEscapeSequences(String)
{
 Chr1 := Chr(1)
 StringReplace, String, String, ````, %Chr1%, All ;temporarily replace escaped backtick with an unused character
 StringReplace, String, String, ``n, `n, All ;newline
 StringReplace, String, String, ``r, `r, All ;carriage return
 StringReplace, String, String, ``b, `b, All ;backspace
 StringReplace, String, String, ``t, `t, All ;horizontal tab
 StringReplace, String, String, ``v, `v, All ;vertical tab
 StringReplace, String, String, ``a, `a, All ;bell
 StringReplace, String, String, ``f, `f, All ;formfeed
 StringReplace, String, String, %Chr1%, ``, All ;restore backticks
 Return, String
}