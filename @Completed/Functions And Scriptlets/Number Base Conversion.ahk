;AHK v1
#NoEnv

;MsgBox % FromBase("-AF4",16) ;-2804
;MsgBox % ToBase(123,16) ;7B
;MsgBox % ConvertBase(-20,12,10) ;-24

ConvertBase(Num,InputBase,OutputBase)
{
    static CharSet := "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    Value := 1
    Num1 := 0
    Position := StrLen(Num)
    Output := ""
    If SubStr(Num,1,1) = "-" ;negative number
    {
        While, Position > 1
            Num1 := (InStr(CharSet,SubStr(Num,Position,1)) - 1) * Value, Value *= InputBase, Position --
        If Num1 = 0
            Return, "0"
        While, Num1 > 0
            Output := SubStr(CharSet,Mod(Num1,OutputBase) + 1,1) . Output, Num1 //= OutputBase
        Return, "-" . Output
    }
    While, Position > 0
        Num1 += (InStr(CharSet,SubStr(Num,Position,1)) - 1) * Value, Value *= InputBase, Position --
    If Num1 = 0
        Return, "0"
    While, Num1 > 0
        Output := SubStr(CharSet,Mod(Num1,OutputBase) + 1,1) . Output, Num1 //= OutputBase
    Return, Output
}

FromBase(Num,InputBase)
{
    static CharSet := "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    Position := StrLen(Num)
    Value := 1
    Num1 := 0
    If SubStr(Num,1,1) = "-" ;negative number
    {
        While, Position > 1
            Num1 -= (InStr(CharSet,SubStr(Num,Position,1)) - 1) * Value, Value *= InputBase, Position --
    }
    Else
    {
        While, Position > 0
            Num1 += (InStr(CharSet,SubStr(Num,Position,1)) - 1) * Value, Value *= InputBase, Position --
    }
    Return, Num1
}

ToBase(Num,OutputBase)
{
    static CharSet := "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    If Num < 0
    {
        Num := -Num
        Sign := "-"
    }
    Else
        Sign := ""
    Num1 := ""
    If Num = 0
        Return, "0"
    While, Num > 0
        Num1 := SubStr(CharSet,Mod(Num,OutputBase) + 1,1) . Num1, Num //= OutputBase
    Return, Sign . Num1
}