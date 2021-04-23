#NoEnv

String := "Man is distinguished, not only by his reason, but by this singular passion from other animals, which is a lust of the mind, that by a perseverance of delight in the continued and indefatigable generation of knowledge, exceeds the short vehemence of any carnal pleasure."
Value := Ascii85Encode(String)
Ascii85Decode(Output,Value,True)
MsgBox %Value%`n`n%Output%

Ascii85Encode(ByRef Data,Length = "")
{
    If (Length = "")
        Length := StrLen(Data) << !!A_IsUnicode
    VarSetCapacity(Output,Ceil((Length * 5) / 4)), Output := "<~", Index := 0
    Loop, % Length >> 2 ;process 4 bytes per iteration
    {
        ;convert the 4 bytes into a single 32 bit big endian number
        Value := (NumGet(Data,Index,"UChar") << 24)
               | (NumGet(Data,Index + 1,"UChar") << 16)
               | (NumGet(Data,Index + 2,"UChar") << 8)
               | NumGet(Data,Index + 3,"UChar")
        Index += 4

        If Value = 0 ;four bytes with a value of 0 (null)
            Output .= "z" ;null group
        Else
        {
            ;obtain the five values in base 85
            Remainder1 := Value, Value //= 85, Remainder1 -= Value * 85
            Remainder2 := Value, Value //= 85, Remainder2 -= Value * 85
            Remainder3 := Value, Value //= 85, Remainder3 -= Value * 85
            Remainder4 := Value, Value //= 85, Remainder4 -= Value * 85

            ;obtain the Ascii85 representation of the values
            Output .= Chr(Value + 33)
                . Chr(Remainder4 + 33)
                . Chr(Remainder3 + 33)
                . Chr(Remainder2 + 33)
                . Chr(Remainder1 + 33)
        }
    }
    Length &= 3 ;determine the number of characters remaining
    If Length = 0 ;no characters remaining
        Return, Output . "~>"

    Value := NumGet(Data,Index,"UChar") << 24 ;insert the first byte
    If Length = 1 ;one byte remaining
    {
        ;obtain two of the five values in base 85
        Value //= 85 ** 3
        Remainder4 := Value, Value //= 85, Remainder4 -= Value * 85

        ;obtain the Ascii85 representation of the values
        Output .= Chr(Value + 33) . Chr(Remainder4 + 33)
    }
    Else If Length = 2 ;two bytes remaining
    {
        Value |= NumGet(Data,Index + 1,"UChar") << 16 ;insert the second byte

        ;obtain the five values in base 85
        Value //= 85 ** 2
        Remainder3 := Value, Value //= 85, Remainder3 -= Value * 85
        Remainder4 := Value, Value //= 85, Remainder4 -= Value * 85

        ;obtain the Ascii85 representation of the values
        Output .= Chr(Value + 33)
            . Chr(Remainder4 + 33)
            . Chr(Remainder3 + 33)
    }
    Else ;three bytes remaining
    {
        Value |= (NumGet(Data,Index + 1,"UChar") << 16)
            | (NumGet(Data,Index + 2,"UChar") << 8) ;insert the second and third byte

        ;obtain four of the five values in base 85
        Value //= 85
        Remainder2 := Value, Value //= 85, Remainder2 -= Value * 85
        Remainder3 := Value, Value //= 85, Remainder3 -= Value * 85
        Remainder4 := Value, Value //= 85, Remainder4 -= Value * 85

        ;obtain the Ascii85 representation of the values
        Output .= Chr(Value + 33)
            . Chr(Remainder4 + 33)
            . Chr(Remainder3 + 33)
            . Chr(Remainder2 + 33)
    }

    Return, Output . "~>"
}

Ascii85Decode(ByRef Data,Code,IsString = False)
{
    Index := 1
    Length := StrLen(Code)

    ;remove delimiters if present
    If SubStr(Code,1,2) = "<~"
        Index += 2, Length -= 2
    If SubStr(Code,-1) = "~>"
        Length -= 2

    BufferSize := (Length << 2) // 5, VarSetCapacity(Data,BufferSize) ;calculate the correct buffer size
    BinPos := 0
    Value := 0, Exponent := 85 ** 4
    Loop, %Length%
    {
        CurrentChar := SubStr(Code,Index,1), Index ++

        If CurrentChar = "z" ;null group
        {
            NumPut(0,Data,BinPos,"UInt") ;four zero bytes
            Value := 0, Exponent := 85 ** 4
            Continue
        }

        Temp1 := Asc(CurrentChar) - 33
        If (Temp1 < 0 || Temp1 >= 85) ;unknown character
            Continue

        Value += Temp1 * Exponent
        Exponent //= 85

        If Exponent = 0
        {
            If Value <= 0xFFFFFFFF ;valid sequence
            {
                NumPut(Value >> 24,Data,BinPos,"UChar")
                NumPut((Value >> 16) & 255,Data,BinPos + 1,"UChar")
                NumPut((Value >> 8) & 255,Data,BinPos + 2,"UChar")
                NumPut(Value & 255,Data,BinPos + 3,"UChar")
                BinPos += 4
            }
            Value := 0, Exponent := 85 ** 4
        }
    }
    Length := Mod(Length,5)
    If Length > 1 ;characters remain
    {
        ;pad the last few characters
        While, Exponent > 0
            Value += 84 * Exponent, Exponent //= 85

        NumPut(Value >> 24,Data,BinPos,"UChar")
        If Length = 3
            NumPut((Value >> 16) & 255,Data,BinPos + 1,"UChar")
        Else If Length = 4
        {
            NumPut((Value >> 16) & 255,Data,BinPos + 1,"UChar")
            NumPut((Value >> 8) & 255,Data,BinPos + 2,"UChar")
        }
    }

    If IsString ;resize the buffer if the output is a string
        VarSetCapacity(Data,-1)
    Return, BufferSize
}