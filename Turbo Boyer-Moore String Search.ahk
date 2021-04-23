#NoEnv

;http://www-igm.univ-mlv.fr/~lecroq/string/node15.html
;http://www-igm.univ-mlv.fr/~lecroq/string/node14.html#SECTION00140
;http://en.wikipedia.org/wiki/Boyer-Moore

String := "GCAGAGAG", StringLength := StrLen(String)
Suffixes(String,StringLength,Suffixes)
Loop, %StringLength%
    Result .= NumGet(Suffixes,(A_Index - 1) * 4,"UInt") . ","
Result := SubStr(Result,1,-1)
MsgBox % Result
ExitApp

PrepareGoodSuffixes(String,StringLength,GoodSuffixes)
Loop, %StringLength%
    Result .= NumGet(GoodSuffixes,(A_Index - 1) * 4,"UInt") . ","
Result := SubStr(Result,1,-1)
MsgBox % Result

StringSearch(String,m,Search,n)
{
    
}

PrepareBadCharacters(ByRef String,StringLength,ByRef BadCharacters)
{
    CharSize := A_IsUnicode ? 2 : 1, Char := A_IsUnicode ? "UShort" : "UChar"
    AlphabetSize := 26
    VarSetCapacity(BadCharacters,AlphabetSize * 4)
    /*
    for (i = 0; i < ASIZE; ++i)
        bmBc[i] = m;
    for (i = 0; i < m - 1; ++i)
        bmBc[x[i]] = m - i - 1;
    */
    Loop, %AlphabetSize%
        NumPut(StringLength,BadCharacters,(A_Index - 1) * 4,"UInt")
    Loop, % StringLength - 1
        NumPut(StringLength - A_Index,BadCharacters,NumGet(String,(A_Index - 1) * 4,"UInt"),"UInt")
}

PrepareGoodSuffixes(ByRef String,StringLength,ByRef GoodSuffixes)
{
    Suffixes(String,StringLength,Suffixes)
    VarSetCapacity(GoodSuffixes,StringLength * 4)
    Loop, %StringLength%
        NumPut(StringLength,GoodSuffixes,(A_Index - 1) * 4,"UInt") ;Temp1 := A_Index - 1, GoodSuffixes%Temp1% := StringLength
    j := 0
    Loop, %StringLength%
    {
        i := StringLength - A_Index
        If (NumGet(Suffixes,i * 4,"UInt") = (i + 1))
        {
            Temp1 := StringLength - (i + 1)
            While, (j < Temp1)
            {
                ;If (GoodSuffixes%j% = StringLength)
                    ;GoodSuffixes%j% := Temp1
                If (NumGet(GoodSuffixes,j * 4,"UInt") = StringLength)
                    NumPut(Temp1,GoodSuffixes,j * 4,"UInt") := Temp1
                j ++
            }
        }
    }
    Loop, % StringLength - 1
    {
        i := A_Index - 1, Temp1 := (StringLength - 1) - NumGet(Suffixes,i * 4,"UInt")
        ;GoodSuffixes%Temp1% := StringLength - (i + 1)
        NumPut(StringLength - (i + 1),GoodSuffixes,Temp1 * 4,"UInt")
    }
}

Suffixes(ByRef String,StringLength,ByRef Suffixes)
{
    CharSize := A_IsUnicode ? 2 : 1, Char := A_IsUnicode ? "UShort" : "UChar"
    VarSetCapacity(Suffixes,StringLength * 4), ShiftAmount := StringLength - 1, NumPut(StringLength,Suffixes,ShiftAmount * 4,"UInt")
    Loop, % StringLength - 1
    {
        Index := StringLength - (A_Index + 1), Temp1 := NumGet(Suffixes,((Index + StringLength) - (Index + 1)) * 4,"UInt")
        If (Index > ShiftAmount && Temp1 < (Index - ShiftAmount))
            NumPut(Temp1,Suffixes,Index * 4,"UInt")
        Else
        {
            % (Index < ShiftAmount) ? ShiftAmount := Index
            While, (ShiftAmount >= 0 && (NumGet(String,ShiftAmount * CharSize,Char) = NumGet(String,((ShiftAmount + StringLength) - (Index + 1)) * CharSize,Char)))
                ShiftAmount --
            NumPut(Index - ShiftAmount,Suffixes,Index * 4,"UInt")
        }
    }
}