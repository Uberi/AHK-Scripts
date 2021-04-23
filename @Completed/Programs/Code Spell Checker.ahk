#NoEnv

/*
FileName = %1%
If (FileName = "" || !FileExist(FileName))
{
 FileSelectFile, FileName, M3,, Select a source file to spell check:, *.ahk
 If ErrorLevel
  ExitApp
}

FileRead, WordList, %A_ScriptDir%\..\..\WordList.txt

SetBatchLines, -1
PrepareWordList(WordList)

Gui, Font, s16 Bold, Arial
Gui, Add, Text, x0 y0 w550 h30 Center, Spell Check Results
Gui, Font, s10 Norm
Gui, Add, Button, x10 y440 w410 h30 Default, Copy
Gui, Add, Button, x440 y440 w100 h30 vNext, Next
Gui, Add, Edit, x10 y480 w530 h20 vCurrentFile ReadOnly
Gui, Font, s8 Norm, Courier New
Gui, Add, Edit, x10 y30 w530 h400 vResult ReadOnly -Wrap

SetWorkingDir, % NextFile(FileName)
Gosub, ButtonNext

GuiControl, Focus, Copy
Gui, Show, w550 h510, Code Spell Checker
Return

GuiClose:
ExitApp

ButtonCopy:
Gui, +OwnDialogs
MsgBox, 64, Clipboard, Spell check results copied to the clipboard.
Return

ButtonNext:
CurrentFile := NextFile(FileName)
FileRead, Code, %CurrentFile%
If (FileName = "")
 GuiControl, Disable, Next
Errors := CodeSpellCheck(Code,WordList)
Result := ShowResults(Code,Errors)
If (Result = "")
 Result := "No errors found."
GuiControl,, Result, %Result%
GuiControl,, CurrentFile, %CurrentFile%
Return

NextFile(ByRef FileName)
{
 Temp1 := InStr(FileName . "`n","`n")
 File := SubStr(FileName,1,Temp1 - 1)
 FileName := SubStr(FileName,Temp1 + 1)
 Return, File
}
*/

;prepares a wordlist for usage by the spell checker
PrepareWordList(ByRef WordList)
{
 StringReplace, WordList, WordList, `r,, All ;normalize end of line characters to a solitary "`n"
 If (SubStr(WordList,1,1) != "`n") ;prepend a newline if the wordlist does not already begin with one
  WordList := "`n" . WordList
 If (SubStr(WordList,0) != "`n") ;append a newline if the wordlist does not already end with one
  WordList .= "`n"
}

;spell checks the comments and literal strings within AutoHotkey code given as input
CodeSpellCheck(ByRef Code,ByRef WordList,CheckCase = 1)
{ ;returns an array of objects containing error types, positions, and lengths
 StringReplace, Code, Code, `r,, All ;normalize end of line characters to a solitary "`n"
 StringReplace, Code, Code, `n, `r`n, All ;change end of line characters to the Windows "`r`n" format
 StringReplace, Code, Code, %A_Tab%, %A_Space%, All ;replace tabs with spaces for simpler handling of whitespace

 Errors := Array() ;initialize the array storing error records

 Identifiers := GetCodeIdentifiers(Code) ;get a list of all identifiers in the code, in order to check for matches against identifiers

 ;find and spell check each single line comment, and build up a version of the code without double quotes in single line comments
 FoundPos := 1, FoundPos1 := 1, LiteralCode := ""
 While, (FoundPos := RegExMatch(Code,"mS)((?:^| ); *)(.*?)( *)$",Match,FoundPos))
 {
  CheckPhrase(Code,Identifiers,Match2,CheckCase,FoundPos + StrLen(Match1),Errors,WordList)
  StringReplace, Match2, Match2, ", |, All
  LiteralCode .= SubStr(Code,FoundPos1,FoundPos - FoundPos1) . Match1 . Match2 . Match3, FoundPos += StrLen(Match), FoundPos1 := FoundPos
 }
 LiteralCode .= SubStr(Code,FoundPos1)

 ;find and spell check each multi line comment, and build up a version of the code with padding instead of multi line comments
 FoundPos := 1, FoundPos1 := 1, TempCode := ""
 While, (FoundPos := RegExMatch(LiteralCode,"msS)^( */\*[ \r\n]*)(.*?)[ \r\n]*\r\n *\*/",Match,FoundPos))
 {
  CheckPhrase(Code,Identifiers,Match2,CheckCase,FoundPos + StrLen(Match1),Errors,WordList), Length := StrLen(Match), Padding := ""
  Loop, %Length%
   Padding .= " "
  TempCode .= SubStr(LiteralCode,FoundPos1,FoundPos - FoundPos1) . Padding, FoundPos += Length, FoundPos1 := FoundPos
 }
 TempCode .= SubStr(LiteralCode,FoundPos1)

 ;build up a version of the code without double quotes in the literal parameters of commands and directives
 FoundPos := 1, FoundPos1 := 1, LiteralCode := ""
 While, (FoundPos := RegExMatch(TempCode,"mS)^( *[\w#]+(?: +(?!:=|=)| *,))(.*)$",Match,FoundPos))
 {
  StringReplace, Match2, Match2, ", |, All
  LiteralCode .= SubStr(TempCode,FoundPos1,FoundPos - FoundPos1) . Match1 . Match2, FoundPos += StrLen(Match), FoundPos1 := FoundPos
 }
 LiteralCode .= SubStr(TempCode,FoundPos1)

 ;build up a version of the code without double quotes in classic assignments
 FoundPos := 1, FoundPos1 := 1, LiteralCode1 := ""
 While, (FoundPos := RegExMatch(LiteralCode,"mS)^( *[\w#_@\$%]+ *= *)(.+)$",Match,FoundPos))
 {
  StringReplace, Match2, Match2, ", |, All
  LiteralCode1 .= SubStr(LiteralCode,FoundPos1,FoundPos - FoundPos1) . Match1 . Match2, FoundPos += StrLen(Match), FoundPos1 := FoundPos
 }
 LiteralCode1 .= SubStr(LiteralCode,FoundPos1)

 ;find and spell check each string literal in an expression
 FoundPos := 1
 While, (FoundPos := RegExMatch(LiteralCode1,"S)("" *)((?:[^""]|"""")*?) *""",Match,FoundPos))
  CheckPhrase(Code,Identifiers,Match2,CheckCase,FoundPos + StrLen(Match1),Errors,WordList), FoundPos += StrLen(Match)

 ;find and spell check each continuation section
 FoundPos := 1
 While, (FoundPos := RegExMatch(TempCode,"mS)^( *\(.*?\r\n *)(.*?) *\r\n *\)",Match,FoundPos))
  CheckPhrase(Code,Identifiers,Match2,CheckCase,FoundPos + StrLen(Match1),Errors,WordList), FoundPos += StrLen(Match)

 ;find and spell check each classic assignment
 FoundPos := 1
 While, (FoundPos := RegExMatch(LiteralCode,"mS)^( *[\w#_@\$%]+ *= *)(.+?) *$",Match,FoundPos))
  CheckPhrase(Code,Identifiers,Match2,CheckCase,FoundPos + StrLen(Match1),Errors,WordList), FoundPos += StrLen(Match)

 Return, Errors
}

;summarizes spell check results in an easily readable form
ShowResults(Code,Errors)
{ ;returns a textual summary of an array of error records
 ;iterate through the errors once first so the columns can be aligned later
 MaxLength := 0
 For Index, CurrentError In Errors
  Length := StrLen(CurrentError.Type), (Length > MaxLength) ? (MaxLength := Length)
 MaxLength += 3 ;pad the maximum column length with three extra characters

 ;iterate through the errors again to build up a summary
 Result := ""
 For Index, CurrentError In Errors
  Result .= ShowText(Code,CurrentError.Type,CurrentError.Position,CurrentError.Length,MaxLength) . "`n`n`n"

 Return, SubStr(Result,1,-3) ;trim the three trailing newlines
}

;checks each word in a phrase against a wordlist and a list of identifiers in the code, and inserts an error record if a word is not correct
CheckPhrase(ByRef Code,ByRef Identifiers,ByRef PhraseText,CheckCase,TextPosition,ByRef Errors,ByRef WordList)
{
 LineCase := 0
 Loop, Parse, PhraseText, `r`n .`,;:?!"/- ;parse the string on every whitespace and common punctuation character
 {
  CurrentDelimiter := SubStr(Code,TextPosition - 1,1)
  If InStr("`r`n.-",CurrentDelimiter) ;found a new line or sentence
   LineCase := 0
  Length := StrLen(A_LoopField)
  If !RegExMatch(A_LoopField,"S)^[a-zA-Z']+$") ;check only nonblank fields containing alphanumeric and apostrophe characters
  {
   TextPosition += Length + 1 ;add the field and delimiter length to the position
   Continue
  }
  CaseFlag := CheckCase && LineCase ;check case if needed and the current word is not the first word on the line
  If !(InStr(Identifiers,"," . A_LoopField . ",",CaseFlag) || InStr(WordList,"`n" . A_LoopField . "`n",CaseFlag)) ;is not a correct identifier or word
  {
   If CaseFlag
   {
    If InStr(Identifiers,"," . A_LoopField . ",",0) ;is not in the wordlist, so is an incorrectly capitalized identifier within the code
     ObjInsert(Errors,Object("Type","Identifier case mismatch","Position",TextPosition,"Length",Length))
    Else If InStr(WordList,"`n" . A_LoopField . "`n",0) ;is an incorrectly capitalized word in the wordlist
     ObjInsert(Errors,Object("Type","Wordlist case mismatch","Position",TextPosition,"Length",Length))
    Else ;unknown word
     ObjInsert(Errors,Object("Type","Unknown word","Position",TextPosition,"Length",Length))
   }
   Else ;unknown word
    ObjInsert(Errors,Object("Type","Unknown word","Position",TextPosition,"Length",Length))
  }
  TextPosition += Length + 1, LineCase := 1 ;add the field and delimiter length to the position, clear the new line flag
 }
}

;generates a summary of a single error record
ShowText(ByRef Code,ErrorType,Position,Length,MaxLength)
{
 TextPadding := 15 ;number of characters to show on both sides of the error
 HighlightChar := "~" ;character to highlight with

 ErrorSection := "    ", ErrorDisplay := "    " ;set leading characters

 ;find the line and column of the error
 TempCode := "`n" . SubStr(Code,1,Position - 1)
 StringReplace, TempCode, TempCode, `r`n, `n, All
 StringReplace, TempCode, TempCode, `r, `n, All
 StringReplace, TempCode, TempCode, `n, `n, UseErrorLevel
 Line := ErrorLevel
 TempCode := TempCode, Column := StrLen(SubStr(TempCode,InStr(TempCode,"`n",1,0) + 1)) + 1

 Loop, % MaxLength - StrLen(ErrorType) ;pad the error display to the column length
  ErrorType .= " "

 ErrorType .= "(Line " . Line . ", Column " . Column . "):"

 ;get the beginning of the line containing the error
 Temp2 := (Position - 1) - StrLen(Code), Temp1 := InStr(Code,"`r",1,Temp2), Temp2 := InStr(Code,"`n",1,Temp2)
 Temp2 := ((Temp1 > Temp2) ? Temp1 : Temp2) + 1

 ;show the error message and the code before the error
 Temp1 := Position - TextPadding, Temp2 := (Temp1 < Temp2) ? Temp2 : Temp1 ;get start of the section to display
 While, (SubStr(Code,Temp2,1) = " ") ;trim off extra whitespace from the beginning of the line
  Temp2 ++
 Temp1 := Position - Temp2, ErrorSection .= SubStr(Code,Temp2,Temp1)

 ;pad the error display with the length of the code before the error
 Loop, %Temp1%
  ErrorDisplay .= " "

 ErrorSection .= SubStr(Code,Position,Length) ;show the code referenced by the error

 ;pad the error display with the highlight
 Loop, %Length%
  ErrorDisplay .= HighlightChar

 ;get the end of the line containing the error
 ErrorEnd := Position + Length, Temp1 := InStr(Code,"`r",1,ErrorEnd), Temp2 := InStr(Code,"`n",1,ErrorEnd)
 If (Temp2 = 0)
  Temp2 := Temp1
 Else If (Temp1 > 0)
  Temp2 := (Temp1 < Temp2) ? Temp1 : Temp2

 ;show the code after the error
 TextPadding += ErrorEnd
 If (TextPadding > Temp2)
  TextPadding := Temp2
 ErrorSection .= SubStr(Code,ErrorEnd,TextPadding - ErrorEnd)

 Return, ErrorType . "`n`n" . ErrorSection . "`n" . ErrorDisplay
}

;retrieves a list of identifiers within the code given as input
GetCodeIdentifiers(Code)
{
 Code := RegExReplace(Code,"mS)(?:^| );.*$") ;remove single line comments
 Code := RegExReplace(Code,"msS)^ */\*.*?\r\n *\*/") ;remove multiline comments
 Code := RegExReplace(Code,"mS)^ *(\w+)(?: *,| +(?![:=])).*$","$1") ;remove command parameters, as they are usually literal (commands are found by identifiers followed by either spaces or a comma surrounded by optional spaces, then anything that is not ":" or "=", as those characters denote an expression assignment, label, or classic assignment)
 Code := RegExReplace(Code,"S)""(?:[^""]|"""")*""","|") ;remove string literals
 Code := RegExReplace(Code,"mS)^ *([\w#_@\$%]+) *=.*?$","$1") ;remove classic assignment text
 Code := RegExReplace(Code,"S)[^\w#_@\$]+",",") ;get a list of identifiers
 If (SubStr(Code,1,1) != ",")
  Code := "," . Code
 If (SubStr(Code,0) != ",")
  Code .= ","
 Sort, Code, C U D`,
 Return, Code
}