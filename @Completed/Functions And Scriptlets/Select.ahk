;AHK AHK_L
#NoEnv

/*
TestArray := []
Loop, 1000
{
 Random, Value, 1, 1000
 TestArray.Insert(Value)
}
MsgBox % Select(TestArray,7)
*/

;retrieves the index of the Position'th lowest element in an unsorted array
Select(InputArray,Index)
{
 MaxIndex := ObjMaxIndex(InputArray)
 Loop
 {
  If MaxIndex <= 10
  {
   Subset := ObjClone(InputArray)
   Loop, % MaxIndex - 1
   {
    ArrayIndex := A_Index
    While, ArrayIndex > 0 && Subset[ArrayIndex] > Subset[ArrayIndex + 1]
     Value := Subset[ArrayIndex + 1], Subset[ArrayIndex + 1] := Subset[ArrayIndex], Subset[ArrayIndex] := Value, ArrayIndex --
   }
   Return, Subset[Index]
  }

  ArrayIndex := 0, Medians := [], MedianIndex := 0
  Loop, % MaxIndex // 5
  {
   ;partition the array into a subset with 5 elements
   ArrayIndex ++, Subset1 := InputArray[ArrayIndex]
   ArrayIndex ++, Subset2 := InputArray[ArrayIndex]
   ArrayIndex ++, Subset3 := InputArray[ArrayIndex]
   ArrayIndex ++, Subset4 := InputArray[ArrayIndex]
   ArrayIndex ++, Subset5 := InputArray[ArrayIndex]

   ;find the median of the subset using a partial insertion sort specialized for five elements
   If (Subset2 < Subset1)
    Temp1 := Subset1, Subset1 := Subset2, Subset2 := Temp1
   If (Subset3 < Subset1)
    Temp1 := Subset1, Subset1 := Subset3, Subset3 := Temp1
   If (Subset4 < Subset1)
    Temp1 := Subset1, Subset1 := Subset4, Subset4 := Temp1
   If (Subset5 < Subset1)
    Temp1 := Subset1, Subset1 := Subset5, Subset5 := Temp1
   If (Subset3 < Subset2)
    Temp1 := Subset2, Subset2 := Subset3, Subset3 := Temp1
   If (Subset4 < Subset2)
    Temp1 := Subset2, Subset2 := Subset4, Subset4 := Temp1
   If (Subset5 < Subset2)
    Temp1 := Subset2, Subset2 := Subset5, Subset5 := Temp1
   If (Subset4 < Subset3)
    Temp1 := Subset3, Subset3 := Subset4, Subset4 := Temp1
   If (Subset5 < Subset3)
    Temp1 := Subset3, Subset3 := Subset5, Subset5 := Temp1
   MedianIndex ++, Medians[MedianIndex] := Subset3
  }

  ;handle the remaining elements
  If (ArrayIndex != MaxIndex)
  {
   Subset := []
   Temp1 := MaxIndex - ArrayIndex
   Loop, %Temp1%
    ArrayIndex ++, ObjInsert(Subset,InputArray[ArrayIndex])
   Loop, % Temp1 - 1
   {
    ArrayIndex := A_Index
    While, ArrayIndex > 0 && InputArray[ArrayIndex] > InputArray[ArrayIndex + 1]
     Value := InputArray[ArrayIndex + 1], InputArray[ArrayIndex + 1] := InputArray[ArrayIndex], InputArray[ArrayIndex] := Value, ArrayIndex --
   }
   Medians[MedianIndex + 1] := Subset[(Temp1 >> 1) + (Temp1 & 1)]
 }

  ;find the median of the medians
  Middle := Select(Medians,MaxIndex // 10)

  ;partition the array into three subsets, one with elements less than the middle, one with elements equal to the middle, and one with elements greater than the middle
  ArrayLess := [], ArrayEqual := 0, ArrayGreater := []
  Loop, %MaxIndex%
  {
   If (InputArray[A_Index] < Middle)
    ObjInsert(ArrayLess,InputArray[A_Index])
   Else If (InputArray[A_Index] = Middle)
    ArrayEqual ++
   Else ;If (InputArray[A_Index] > Middle)
    ObjInsert(ArrayGreater,InputArray[A_Index])
  }
  Length := ObjMaxIndex(ArrayLess)
  If (Index <= Length)
  {
   InputArray := ArrayLess, MaxIndex := Length
   Continue
  }
  Length += ArrayEqual
  If (Index > Length)
   InputArray := ArrayGreater, MaxIndex := ObjMaxIndex(ArrayGreater), Index -= Length
  Else
   Return, Middle
 }
}