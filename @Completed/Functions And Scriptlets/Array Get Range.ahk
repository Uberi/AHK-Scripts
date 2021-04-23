#NoEnv

/*
Alphabet := "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
InputArray := Array()
Loop, Parse, Alphabet
 InputArray[A_Index - 1] := A_LoopField
MsgBox % ShowObject(ArrayGetRange(InputArray,5,8)) . "`n`n" . ShowObject(InputArray)
Return

ShowObject(ShowObject,Padding = "")
{
 ListLines, Off
 If !IsObject(ShowObject)
 {
  ListLines, On
  Return, ShowObject
 }
 ObjectContents := ""
 For Key, Value In ShowObject
 {
  If IsObject(Value)
   Value := "`n" . ShowObject(Value,Padding . A_Tab)
  ObjectContents .= Padding . Key . ": " . Value . "`n"
 }
 ObjectContents := SubStr(ObjectContents,1,-1)
 If (Padding = "")
  ListLines, On
 Return, ObjectContents
}
*/

ArrayGetRange(InputArray,StartKey,EndKey)
{
 Result := ObjClone(InputArray), MinIndex := ObjMinIndex(Result)
 StartKey --, ObjRemove(Result,MinIndex,StartKey), EndKey -= StartKey
 ObjRemove(Result,EndKey + 1,ObjMaxIndex(Result))
 Return, Result
}