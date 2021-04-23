#NoEnv

;MsgBox % PerfectSquare(123456 ** 2)

PerfectSquare(Number)
{
    If ((Number & 7) = 1 || (Number & 31) = 4 || (Number & 127) = 16 || (Number & 191) = 0) ;number is possibly a perfect square
    {
        ;find the highest power of 4 less than or equal to the number
        HighBit := 4
        While, HighBit < Number
            HighBit <<= 2
        If (HighBit > Number)
            HighBit >>= 2

        ;compute exact integer square root
        Value := Number
        Result := 0
        While, HighBit != 0
        {
            Temp1 := Result + HighBit
            If (Value >= Temp1)
            {
                Value -= Temp1
                Result := (Result >> 1) + HighBit
            }
            Else
                Result >>= 1
            HighBit >>= 2
        }

        ;test for perfect square
        Return, (Result * Result) = Number
    }
    Return, False ;number is definitely not a perfect square
}