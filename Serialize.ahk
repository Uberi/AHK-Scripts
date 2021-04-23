#NoEnv

;wip: support objects as keys

/*
[
uint *Key
uint *Value
]
uint 0
[
char KeyType
str Key
]
[
uint ValueLength
blob Value
]
*/

;creates a binary representation of an object
SaveObject(InputObject,ByRef SerializedObject,SizeOnly = 0)
{
 IsANSI := !A_IsUnicode

 ;calculate the size of the serialized object, including its keys and values
 ObjectSize := 0, TableSize := 0, KeySize := 0
 For Key In InputObject
 {
  TableSize += 8, KeySize += 1 + ((StrLen(Key) + 1) << IsANSI) ;sum the sizes of the table entry, sum the sizes of the keys
  If IsObject(InputObject[Key])
  {
   
  }
  Else ;value is a string or a number
  {
   CurrentSize := ObjGetCapacity(InputObject,Key)
   If (CurrentSize = "")
    InputObject[Key] .= "", CurrentSize := ObjGetCapacity(InputObject,Key)
  }
  ObjectSize += 4 + 
 }
 ObjectSize += TableSize + 4 + KeySize

 VarSetCapacity(SerializedObject,ObjectSize) ;set the capacity of the storage structure
 MsgBox % ObjectSize

 NumPut(0,SerializedObject,TableSize,"UInt") ;insert the table end indicator

 TableOffset := 0, KeyOffset := 4 + TableSize, ValueOffset := KeyOffset + KeySize
 For Key In InputObject
 {
  ;store the table entry in the structure
  NumPut(KeyOffset,SerializedObject,TableOffset,"UInt"), TableOffset += 4
  NumPut(ValueOffset,SerializedObject,TableOffset,"UInt"), TableOffset += 4

  ;store the key in the structure
  CurrentSize := StrLen(Key) + 1 ;length of the string and its null terminator
  NumPut(0,SerializedObject,KeyOffset,"UChar"), KeyOffset ++ ;0 means the key is a string, 1 means that the key is a number ;wip: need to be able to tell if the key is an integer or not
  StrPut(Key,&SerializedObject + KeyOffset,"","UTF-16"), KeyOffset += CurrentSize << IsANSI

  ;store the value in the structure
  If IsObject(InputObject[Key])
  {
   CurrentSize := SaveObject(Value,SerializedNestedObject)
   NumPut(CurrentSize,SerializedObject,ValueOffset,"UInt"), ValueOffset += 4
   DllCall("RtlMoveMemory","UPtr",&SerializedObject + ValueOffset,"UPtr",&SerializedNestedObject,"UInt",CurrentSize), ValueOffset += CurrentSize ;wip: not sure if UInt should be used for length
  }
  Else ;value is a string or a number
  {
   CurrentSize := ObjGetCapacity(InputObject,Key)
   If (CurrentSize = "") ;value is a number
    InputObject[Key] .= "", CurrentSize := ObjGetCapacity(InputObject,Key) ;convert it to a string and retrieve the size again
   NumPut(CurrentSize,SerializedObject,ValueOffset,"UInt"), ValueOffset += 4
   DllCall("RtlMoveMemory","UPtr",&SerializedObject + ValueOffset,"UPtr",ObjGetAddress(InputObject,Key),"UInt",CurrentSize)
   ValueOffset += CurrentSize ;wip: not sure if UInt should be used for length
  }
 }
 Return, ObjectSize
}

LoadObject(ByRef SerializedObject,ObjectSize)
{
 OutputObject := Object(), TableOffset := 0
 Loop
 {
  KeyOffset := NumGet(SerializedObject,TableOffset,"UInt"), TableOffset += 4
  If (KeyOffset = 0)
   Break
  ValueOffset := NumGet(SerializedObject,TableOffset,"UInt"), TableOffset += 4

  ;retrieve the key from the structure
  KeyType := NumGet(SerializedObject,KeyOffset,"UChar"), KeyOffset ++
  Key := StrGet(&SerializedObject + KeyOffset,"","UTF-16")
  ;wip: handle the key being a number type
  ObjInsert(OutputObject,Key,"")

  ValueLength := NumGet(SerializedObject,ValueOffset,"UInt"), ValueOffset += 4
  MsgBox % ValueOffset
  ObjSetCapacity(OutputObject,Key,ValueLength)
  DllCall("RtlMoveMemory","UPtr",ObjGetAddress(OutputObject,Key),"UPtr",&SerializedObject + ValueOffset,"UInt",ValueLength) ;wip: not sure if UInt should be used for length
 }
 Return, OutputObject
}