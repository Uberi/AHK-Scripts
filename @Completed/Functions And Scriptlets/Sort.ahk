#NoEnv

TestObject := ["D","B","A","E","C"]
SortArray(TestObject)
MsgBox % ShowObject(TestObject)
;MsgBox % ShowObject(SortArray(TestObject))
Return

;in-place merge sort with selection sort
SortArray(InputArray)
{
    MaxIndex := ObjMaxIndex(InputArray), (MaxIndex = "") ? (MaxIndex := 0) : ""
    If MaxIndex <= 8
    {
        If MaxIndex < 2
            Return, InputArray
        Loop, % MaxIndex - 1
        {
            Index := A_Index
            While, Index > 0 && InputArray[Index] > InputArray[Index + 1]
                Value := InputArray[Index + 1], InputArray[Index + 1] := InputArray[Index], InputArray[Index] := Value, Index --
        }
    }
    Else
    {
        Middle := MaxIndex >> 1
        SortLeft := ObjClone(InputArray), ObjRemove(SortLeft,Middle + 1,MaxIndex)
        SortRight := ObjClone(InputArray), ObjRemove(SortRight,1,Middle)
        SortArray(SortLeft), SortArray(SortRight)
        MaxRight := MaxIndex - Middle, LeftIndex := 1, RightIndex := 1
        Loop, %MaxIndex%
            InputArray[A_Index] := (LeftIndex <= Middle && (RightIndex > MaxRight || SortLeft[LeftIndex] < SortRight[RightIndex])) ? SortLeft[LeftIndex ++] : SortRight[RightIndex ++]
    }
}

/*
;in-place iterative merge sort
SortArray(InputArray)
{
    Length := 1
    MaxIndex := ObjMaxIndex(InputArray)
    Loop
    {
        Index := 1
        While, Index <= MaxIndex
        {
            Left := Index, Right := Index + Length
            Index += Length << 1
            If (Index >= MaxIndex)
                Index := MaxIndex + 1
            While, Left < Right && Right < Index
            {
                If InputArray[Right] < InputArray[Left]
                    ObjInsert(InputArray,Left,ObjRemove(InputArray,Right)), Right ++
                Left ++
            }
        }
        Length <<= 1
        If (Length > MaxIndex)
            Break
    }
    Return, InputArray
}
*/

/*
;merge sort with selection sort
SortArray(InputArray)
{
    MaxIndex := ObjMaxIndex(InputArray), (MaxIndex = "") ? (MaxIndex := 0) : ""
    If MaxIndex <= 8
    {
        ;use an insertion sort for the relatively small amount of remaining elements
        Result := ObjClone(InputArray)
        Loop, % MaxIndex - 1
        {
            Index := A_Index
            While, Index > 0 && Result[Index] > Result[Index + 1]
                Value := Result[Index + 1], Result[Index + 1] := Result[Index], Result[Index] := Value, Index --
        }
        Return, Result
    }

    ;use a merge sort for the relatively large amount of remaining elements
    Middle := MaxIndex >> 1, SortLeft := [], SortRight := []
    Loop, %Middle% ;divide the array into two arrays
        ObjInsert(SortLeft,InputArray[A_Index]), ObjInsert(SortRight,InputArray[Middle + A_Index])
    If MaxIndex & 1 ;odd number of elements
        ObjInsert(SortRight,InputArray[MaxIndex]) ;insert the extra element into the right side
    SortLeft := SortArray(SortLeft), SortRight := SortArray(SortRight) ;recursively sort the divided arrays
    MaxRight := MaxIndex - Middle, LeftIndex := 1, RightIndex := 1
    Result := [], ObjSetCapacity(Result,MaxIndex)
    Loop, %MaxIndex% ;merge the two sorted arrays together into one array
    {
        If (LeftIndex <= Middle && (RightIndex > MaxRight || SortLeft[LeftIndex] < SortRight[RightIndex])) ;left side of the array is lesser
            ObjInsert(Result,SortLeft[LeftIndex]), LeftIndex ++
        Else ;right side of the array is lesser
            ObjInsert(Result,SortRight[RightIndex]), RightIndex ++
    }
    Return, Result
}
*/