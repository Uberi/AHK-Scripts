;AHK v1
#NoEnv

;/*
MsgBox % RegExReplaceCallback("Bl123aBla456B789l054a","\d+",Func("ReplaceCallback"),Count,3,5) . "`n" . Count
RegExMatchCallback("Bl123aBla456B789l054a","\d+",Func("MatchCallback"),4)

ReplaceCallback(String,Match)
{
    Return, "(" . Match.Pos(0) . ":" . Match.Value(0) . ")"
}

MatchCallback(String,Match)
{
    MsgBox % Match.Value(0)
}
*/

/*
;example: obtaining each regular expression match
FoundPos := 1
While, FoundPos := RegExMatch(String,RegularExpression,Match,FoundPos)
{
    MsgBox %Match%
    FoundPos += StrLen(Match)
}
*/

/*
;example: replacing each regular expression match with a value
FoundPos := 1
FoundPos1 := 1
String1 := SubStr(String,1,StartingPosition - 1)
While, FoundPos := RegExMatch(String,RegularExpression,Match,FoundPos)
{
    MsgBox %Match%
    NewString .= SubStr(String,FoundPos1,FoundPos - FoundPos1) . "test123"
    FoundPos += StrLen(Match)
    FoundPos1 := FoundPos
}
NewString .= SubStr(String,FoundPos1)
*/

RegExReplaceCallback(String,RegularExpression,Callback,ByRef Count = "",Limit = -1,StartingPosition = 1)
{
    ;add the object match option to the regular expression if not already present
    If RegExMatch(RegularExpression,"S)^[a-zA-Z``]+\)",Options)
    {
        If !InStr(Options,"O",True)
            RegularExpression := "O" . RegularExpression
    }
    Else
        RegularExpression := "O)" . RegularExpression

    ;replace each match with the callback result
    FoundPos := StartingPosition
    FoundPos1 := StartingPosition
    NewString := SubStr(String,1,StartingPosition - 1)
    Count := 0
    While, (A_Index <= Limit || Limit = -1) && (FoundPos := RegExMatch(String,RegularExpression,Match,FoundPos))
    {
        NewString .= SubStr(String,FoundPos1,FoundPos - FoundPos1) . Callback.(String,Match)
        FoundPos += Match.Len(0)
        FoundPos1 := FoundPos
        Count ++
    }
    Return, NewString . SubStr(String,FoundPos1)
}

RegExMatchCallback(String,RegularExpression,Callback,Limit = -1,StartingPosition = 1)
{
    ;add the object match option to the regular expression if not already present
    If RegExMatch(RegularExpression,"S)^[a-zA-Z``]+\)",Options)
    {
        If !InStr(Options,"O",True)
            RegularExpression := "O" . RegularExpression
    }
    Else
        RegularExpression := "O)" . RegularExpression

    ;replace each match with the callback result
    FoundPos := StartingPosition
    Count := 0
    While, (A_Index <= Limit || Limit = -1) && (FoundPos := RegExMatch(String,RegularExpression,Match,FoundPos))
    {
        Callback.(String,Match)
        FoundPos += Match.Len(0)
        Count ++
    }

    Return, Count
}