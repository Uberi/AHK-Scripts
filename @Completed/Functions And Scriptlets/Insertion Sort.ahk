;AHK AHK_L
#NoEnv

;in place insertion sort, most efficient for arrays with between 1 to 10 elements
InsertionSort(ByRef InputArray)
{
 Loop, % ObjMaxIndex(InputArray) - 1
 {
  Index := A_Index
  While, Index > 0 && InputArray[Index] > InputArray[Index + 1]
   Value := InputArray[Index + 1], InputArray[Index + 1] := InputArray[Index], InputArray[Index] := Value, Index --
 }
}