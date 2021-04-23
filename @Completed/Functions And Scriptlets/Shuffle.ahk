;AHK AHK_L
#NoEnv

;MsgBox % Unscramble(Scramble("abcdef",14),14)

;MsgBox % StringShuffle("abc")

/*
TestArray := [0,1,2,3,4,5,6,7,8,9]
ArrayShuffle(TestArray)
For Key, Value In TestArray
    Output .= Value . ","
MsgBox % SubStr(Output,1,-1)
*/

ArrayShuffle(ByRef InputArray)
{
    Index := Length := ObjMaxIndex(InputArray)
    Loop, % Length - 1
    {
        ;swap current value and random value
        Index --
        Random, RandomIndex, 1, Index
        TempValue := InputArray[RandomIndex]
        InputArray[RandomIndex] := InputArray[Index]
        InputArray[Index] := TempValue
    }
}

StringShuffle(String)
{
    Index := Length := StrLen(String)
    Loop, % Length - 1
    {
        ;swap current value and random value
        Index --
        Random, RandomIndex, 1, Index
        TempValue := SubStr(String,RandomIndex,1)
        String := SubStr(String,1,RandomIndex - 1) . SubStr(String,Index,1) . SubStr(String,RandomIndex + 1)
        String := SubStr(String,1,Index - 1) . TempValue . SubStr(String,Index + 1)
    }
    Return, String
}

Scramble(String,Seed = 0)
{
    Random,, Seed
    Index := Length := StrLen(String)
    Loop, % Length - 1
    {
        ;swap current value and random value
        Index --
        Random, RandomIndex, 1, Index
        TempValue := SubStr(String,RandomIndex,1)
        String := SubStr(String,1,RandomIndex - 1) . SubStr(String,Index,1) . SubStr(String,RandomIndex + 1)
        String := SubStr(String,1,Index - 1) . TempValue . SubStr(String,Index + 1)
    }
    Return, String
}

Unscramble(String,Seed = 0)
{
    Random,, Seed
    Positions := []
    Index := Length := StrLen(String)
    Loop, % Length - 1
    {
        ;obtain random index corresponding with the current index
        Index --
        Random, RandomIndex, 1, Index
        Positions[Index] := RandomIndex
    }
    Index := 0
    Loop, % Length - 1
    {
        ;swap current value and random value
        Index ++
        RandomIndex := Positions[Index]
        TempValue := SubStr(String,RandomIndex,1)
        String := SubStr(String,1,RandomIndex - 1) . SubStr(String,Index,1) . SubStr(String,RandomIndex + 1)
        String := SubStr(String,1,Index - 1) . TempValue . SubStr(String,Index + 1)
    }
    Return, String
}