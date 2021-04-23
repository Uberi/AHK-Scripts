#NoEnv

Loop,1{
}Var=1

Var := 1
++ Var
Var := 2
 - 3 + 1

Var = 

/*
bla
 ;blasdjsdjkjk
   ;test
 Bla
;hello
*/

(LTrim0 Join`n
 ;test
;another comment
Bla
;A continuation section.
  Hello, World!
)

FileRead, Code, %A_ScriptFullPath%
MsgBox % Clipboard := Minify(Code)

Minify(Code,MinifyNames = -1)
{
 StringReplace, Code, Code, `r,, All ;remove carriage returns for easier processing
 Code := MinifyContinuationSections(Code) ;collapse continuation sections
 Code := RegExReplace(Code,"`nmS)(?:^| |\t)`;.*$") ;remove single line comments
 Code := RegExReplace(Code,"`nmsS)^[ \t]*/\*.*?\n[ \t]*\*/") ;remove multiline comments
 StringReplace, Code, Code, `n{, `n{`n, All ;normalize opening braces
 StringReplace, Code, Code, `n}, `n}`n, All ;normalize closing braces
 Code := RegExReplace(Code,"`nmS)^[ \t]+|[ \t]+$") ;remove beginning and ending whitespace
 While, InStr(Code,"`n`n") ;collapse empty lines
  StringReplace, Code, Code, `n`n, `n, All
 StringReplace, Code, Code, `n'Continuation:,, All ;combine continuation sections with the lines they belong to
 If (SubStr(Code,1,1) = "`n")
  Code := SubStr(Code,2)
 If (SubStr(Code,0) = "`n")
  Code := SubStr(Code,1,-1)
 ;Code := RemoveLiterals(Code,LiteralsList) ;wip
 Code := RegExReplace(Code,"`nmS)\n(?=[^\w#@\$\{}%\+-]|\+[^\+]|-[^-])(?!.*::)"," ") ;collapse multiline expressions to a single line (excluding lines beginning with ++ and --, or hotstrings)
 Code := MinifyCommands(Code)
 If MinifyNames = -1 ;detect whether or not names can be minified safely
 {
  If RegExMatch(Code,"S)%[\w#@\$]+%") ;dynamic variable reference or function call
   MinifyNames := 1
  Else If Code Contains IsFunc(,IsLabel( ;dynamic function or label checking
   MinifyNames := 1
  Else
   MinifyNames := 0
 }
 If MinifyNames ;allow the changing of symbol names, which may break some dynamic features
 {
  Code := MinifyVariables(Code)
  Code := MinifyFunctions(Code)
  Code := MinifyLabels(Code)
 }
 Code := MinifyExpressions(Code)
 Code := RegExReplace(Code,"`nmiS)^(?:While[, \(]|If ?\(|Else[ ,]?|[\w#@\$]+\().*?\K(?:\n|[ \t]+){","{") ;use OTB where possible
 Code := RegExReplace(Code,"`nmS)\n\{\n(?!.*::|[^, \t``]+:$)","`n{") ;minify opening braces, unless there is a label immediately after
 Code := RegExReplace(Code,"S)\n}\n(?![\w#@\$\{}]+\(.*\)(?:\n|[ \t]*)\{)","`n}") ;minify closing braces, unless there is a function definition immediately after
 ;Code := RestoreLiterals(Code,LiteralsList) ;wip
 StringReplace, Code, Code, `n, `r`n, All ;restore carriage returns
 Return, Code
}

MinifyCommands(Code)
{
 ;wip: remove spaces from the commas delimiting command parameters (commas can be cleaned globally, after quoted strings and classic assignments are escaped)
 ;Code := RegExReplace(Code,"`nmS)^(\w+)[ \t]*(?:,[ \t]*| [ \t]*(?!\W=))","$1,") ;remove whitespace after command name
 Return, Code
}

MinifyVariables(Code) ;wip: change variable names to shorter ones
{
 
 Return, Code
}

MinifyFunctions(Code) ;wip: change all function names to shorter ones
{
 Code := RegExReplace(Code,"`nmS)^([\w#@\$\{}]+)(\(.*\))(?:\n|[ \t]*)\{","$U{1}$2`n{") ;find function definitions
 Return, Code
}

MinifyLabels(Code) ;wip: change label names to shorter ones
{
 
 Return, Code
}

MinifyExpressions(Code) ;wip: remove all whitespace from expressions, except where needed, like concatenation or ternary expressions
{
 
 Return, Code
}

MinifyContinuationSections(Code)
{
 FoundPos := 1, FoundPos1 := 1
 While, (FoundPos := RegExMatch(Code,"sS)\n[ \t]*\((.*?)\n[ \t]*\)",Match,FoundPos)) ;loop through each continuation section
 {
  Temp2 := InStr(Match1 . "`n","`n"), Temp1 := SubStr(Match1,1,Temp2 - 1), Match1 := SubStr(Match1,Temp2 + 1) ;extract continuation section options and actual text
  StringReplace, Temp1, Temp1, %A_Tab%, %A_Space%, All ;convert tabs to spaces
  While, InStr(Temp1,"  ") ;collapse spaces
   StringReplace, Temp1, Temp1, %A_Space%%A_Space%, %A_Space%, All
  JoinString := "`n", TrimRight := 1, AllowComments := 0, LiteralCommas := 1
  Loop, Parse, Temp1, %A_Space% ;process options
  {
   If (SubStr(A_LoopField,1,4) = "Join")
    JoinString := SubStr(A_LoopField,5)
   Else If (SubStr(A_LoopField,1,5) = "LTrim")
    % (SubStr(A_LoopField,6) <> 0) ? (Match1 := RegExReplace(Match1,"`nmS)^[ \t]+")) ;remove leading whitespace
   Else If (SubStr(A_LoopField,1,5) = "RTrim")
    TrimRight := SubStr(A_LoopField,6), (TrimRight = "") ? (TrimRight := 1)
   Else If (SubStr(A_LoopField,1,1) = "C")
    AllowComments := SubStr(A_LoopField,0), (AllowComments = "") ? (AllowComments := 1)
   Else If (A_LoopField = "%")
    LiteralPercentSigns := 1
   Else If (A_LoopField = ",")
    LiteralCommas := 0
   Else If (A_LoopField = "``")
    LiteralBackTicks := 1
  }
  If TrimRight
   Match1 := RegExReplace(Match1,"`nmS)[ \t]+$") ;remove ending whitespace
  If AllowComments
   Match1 := RegExReplace(Match1,"`nmS)(?:^| |\t)`;.*?(?:\n|$)") ;remove single line comments
  Else
   Match1 := RegExReplace(Match1,"`nmS)(^| |\t)`;","$1```;") ;escape single line comments
  If LiteralPercentSigns
   StringReplace, Match1, Match1, `%, ```%, All ;escape percent signs
  If LiteralCommas
   StringReplace, Match1, Match1, `,, ```,, All ;escape commas
  If LiteralBackTicks
   StringReplace, Match1, Match1, ``, ````, All ;escape backticks
  JoinString := EscapeSpecialChars(JoinString)
  StringReplace, Match1, Match1, `n, %JoinString%, All ;join the string
  Code1 .= SubStr(Code,FoundPos1,FoundPos - FoundPos1) . "`n'Continuation:" . Match1, FoundPos += StrLen(Match), FoundPos1 := FoundPos
 }
 Return, Code1 . SubStr(Code,FoundPos1)
}

EscapeSpecialChars(String)
{
 Chr1 := Chr(1)
 StringReplace, String, String, ````, %Chr1%, All ;temporarily replace escaped backtick with an unused character
 StringReplace, String, String, `n, ``n, All ;newline
 StringReplace, String, String, `r, ``r, All ;carriage return
 StringReplace, String, String, `b, ``b, All ;backspace
 StringReplace, String, String, %A_Tab%, ``t, All ;horizontal tab
 StringReplace, String, String, `v, ``v, All ;vertical tab
 StringReplace, String, String, `a, ``a, All ;bell
 StringReplace, String, String, `f, ``f, All ;formfeed
 StringReplace, String, String, %Chr1%, ````, All ;restore backticks
 Return, String
}