;AHK v1
#NoEnv
#Warn All

/*
Data := "14`n44`n31`n41`n54`n27`n46`n43`n29`n34`n15`n45`n31"
MsgBox % MeanAverage(Data)
MsgBox % MedianAverage(Data)
MsgBox % ModeAverage(Data)
MsgBox % RangeAverage(Data)
Loop, Parse, Data, `n
    MsgBox % SimpleMovingAverage(A_LoopField)
*/

SimpleMovingAverage(NumberToAppend,Method = "Mean",MaxListLen = 10)
{
    static NumList := ""
    NumList .= NumberToAppend . "`n"
    StringReplace, NumList, NumList, `n, `n, UseErrorLevel
    If (ErrorLevel > MaxListLen)
    {
        StringGetPos, Temp1, NumList, `n, % "R" . MaxListLen + 1
        StringTrimLeft, NumList, NumList, Temp1 + 1
    }
    Return, %Method%Average(SubStr(NumList,1,-1))
}

MeanAverage(NumList)
{
    Mean := 0
    Loop, Parse, NumList, `n
        Mean += A_LoopField, Index := A_Index
    Return, Mean / Index
}

MedianAverage(NumList)
{
    IfNotInString, NumList, `n
        Return, NumList
    Sort, NumList, N
    StringReplace, NumList, NumList, `n, `n, UseErrorLevel
    Temp1 := ErrorLevel, NumList .= "`n"
    StringGetPos, Temp2, NumList, `n, % "L" . (Temp1 >> 1)
    Temp2 += 2
    If (Temp1 & 1)
    {
        Temp3 := InStr(NumList,"`n",0,Temp2), Temp1 := SubStr(NumList,Temp2,Temp3 - Temp2), Temp3 ++, Temp2 := SubStr(NumList,Temp3,InStr(NumList,"`n",0,Temp3) - Temp3)
        Return, (Temp1 + Temp2) / 2
    }
    Return, SubStr(NumList,Temp2,InStr(NumList,"`n",0,Temp2) - Temp2)
}

ModeAverage(NumList)
{
    IfNotInString, NumList, `n
        Return, NumList
    MostCommon := 0, TempList := "`n" . NumList . "`n"
    Loop, Parse, NumList, `n
    {
        StringReplace, TempList, TempList, `n%A_LoopField%`n, `n, UseErrorLevel
        `(ErrorLevel > MostCommon) ? (MostCommon := ErrorLevel, Mode := A_LoopField)
    }
    Return, (MostCommon > 0) ? Mode : ""
}

RangeAverage(NumList)
{
    IfNotInString, NumList, `n
        Return, NumList
    Sort, NumList, N
    Return, (SubStr(NumList,1,InStr(NumList,"`n") - 1) + SubStr(NumList,InStr(NumList,"`n",0,0) + 1)) / 2
}