#NoEnv

;MsgBox % 2 ** Log(540000000)

Log(Number,Tolerance = 0.000000000000001)
{
    If Number <= 0
        throw Exception("Invalid value: " . Number)
 
    Result := 0.0
 
    While, Number < 1
    {
        Result --
        Number *= 2
    }

    While, Number >= 2
    {
        Result ++
        Number /= 2.0
    }

    FractionalPart := 1.0
    While, FractionalPart >= Tolerance
    {
        FractionalPart /= 2
        Number *= Number
        If Number >= 2
        {
            Number /= 2.0
            Result += FractionalPart
        }
    }
    Return, Result
}