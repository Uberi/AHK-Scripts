#NoEnv

;MsgBox % LinearWeightRandomNumber(1,10)

LinearWeightRandomNumber(Minimum,Maximum)
{
    If Minimum Is Not Number
        Return
    If Maximum Is Not Number
        Return
    Minimum ++, Maximum ++
    TriangularMinimum := (Minimum * (Minimum + 1)) / 2 ;calculate the minimum as a triangular number
    TriangularMaximum := (Maximum * (Maximum + 1)) / 2 ;calculate the maximum as a triangular number
    Random, Result, TriangularMinimum, TriangularMaximum ;generate the random number
    If (Result >= TriangularMaximum)
        Result := TriangularMinimum
    Result := Sqrt((Result * 2) + 0.25) - 0.5 ;simplified quadratic formula for triangular numbers
    If Minimum Is Integer
    {
        If Maximum Is Integer
            Result := Floor(Result) ;convert the value into an integer if both range parameters are integers
    }
    Return, Result
}