;AHK v1
#NoEnv

/*
InputNumber := 56
MsgBox % Factorize(InputNumber) . " = " . InputNumber
*/

Factorize(InputNumber)
{
    If InputNumber < 2
        Return, InputNumber
    Result := "", Divisor := 2
    While, Divisor <= InputNumber
    {
        If Mod(InputNumber,Divisor) = 0
            Result .= Divisor . "*", InputNumber /= Divisor
        Else
            Divisor ++
    }
    Return, SubStr(Result,1,-1)
}