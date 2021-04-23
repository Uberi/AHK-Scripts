#NoEnv

;MsgBox % Show(Pairs(["A", "B", "C", "D"]))
MsgBox % Show(Triplets(["A", "B", "C", "D"]))
;Display(Permutation(["A", "B", "C", "D"],4))
For Index, Value In Combinations(["A", "B", "C", "D"],2)
;For Index, Value In Combinations([1, 2, 3, 4],3)
    Display(Value)
;MsgBox % Show(Combinations(["A", "B", "C", "D"],3))

;wip: see http://www.mathsisfun.com/combinatorics/combinations-permutations.html and implement these funcs with/without repetition and with/without ordering
;wip: implement combinations and permutations; permutations are ordered while combinations are not, combinations are unique(set(permutation) for permutation in permutations(list))
;wip: also implement http://stackoverflow.com/questions/11140505/computing-the-factoradic-rank-of-a-permutation-n-choose-k?rq=1 to find the index of a permutation given a list
;wip: http://stackoverflow.com/questions/7918806/finding-n-th-permutation-without-computing-others
;wip: http://stackoverflow.com/questions/14175128/getting-ith-prefix-without-computing-others

Display(List)
{
    Result := ""
    For Index, Value In List
        Result .= Value
    FileAppend, %Result%`n, *
}

Pairs(List)
{
    Length := List.MaxIndex()
    Result := []
    Index1 := 1, Index2 := 2
    Loop, %Length%
    {
        Outer := A_Index
        Index := Outer
        Loop, % Length - A_Index
        {
            Index ++
            Result.Insert([List[Outer], List[Index]])
        }
    }
    Return, Result
}

Triplets(List)
{
    Length := List.MaxIndex()
    Result := []
    Index1 := 1, Index2 := 2, Index3 = 3

    Loop
    {
        ;generate current combination
        Combination := [List[Index1], List[Index2], List[Index3]]
        Result.Insert(Combination)

        If Index3 != Length
        {
            Index3 ++
        }
        Else If Index2 != Length - 1
        {
            Index2 ++
            Index3 := Index2 + 1
        }
        Else If Index1 != Length - 2
        {
            Index1 ++
            Index2 := Index1 + 1
            Index3 := Index2 + 1
        }
        Else
            Break
    }
    Return, Result
}

Permutation(List, Number, Count = "") ;wip: from http://www.mathblog.dk/project-euler-24-millionth-lexicographic-permutation/ but doesn't support count
{
    Length := List.MaxIndex()

    If !Count
        Count := Length

    Factorials := [], Index := 1
    Factorials[0] := 1
    Loop, % Length - 1
        Factorials[Index] := Factorials[Index - 1] * Index, Index ++

    Permutation := []
    Index := 1
    Number --
    Loop, %Length%
    {
        Permutation[Index] := (Number // Factorials[Length - Index]) + 1
        Number := Mod(Number,Factorials[Length - Index])
        Index ++
    }

    Index := Length
    While, Index > 1
    {
        Index1 := Index - 1
        While, Index1 >= 1
        {
            If Permutation[Index1] <= Permutation[Index]
                Permutation[Index] ++
            Index1 --
        }
        Index --
    }

    Return, Permutation
}

Combination(List, Number, Count = "")
{
    ;wip: http://stackoverflow.com/questions/15058903/n-th-or-arbitrary-combination-of-a-large-set
    
}

Combinations(List, Count)
{
    Length := List.MaxIndex()
    Result := []
    If (Count > Length) ;invalid element count
        Return, Result

    ;set up initial indices
    Indices := []
    Loop, %Count%
        Indices[A_Index] := A_Index

    Loop
    {
        ;generate current combination
        Combination := []
        For Key, Index In Indices
            Combination.Insert(List[Index])
        Result.Insert(Combination)

        Index := Count
        Loop, %Count%
        {
            If Indices[Index] != Index + Length - Count
                Break
            Index --
        }
        If Index = 0
            Break
        Indices[Index] ++

        While, Index < Count
        {
            Index ++
            Indices[Index] := Indices[Index - 1] + 1
        }
    }
    Return, Result
}