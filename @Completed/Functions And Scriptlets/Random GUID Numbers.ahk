;AHK v1
#NoEnv

MsgBox % RandomNumber()

RandomNumber(Min = 1,Max = 100)
{
 If Min Is Not Number
  Return
 If Max Is Not Number
  Return
 VarSetCapacity(Temp1,16), DllCall("rpcrt4\UuidCreate",A_PtrSize ? "UPtr" : "UInt",&Temp1)
 Result := (NumGet(Temp1,0,"UChar") ^ NumGet(Temp1,8,"UChar"))
         + (NumGet(Temp1,1,"UChar") ^ NumGet(Temp1,9,"UChar"))
         + (NumGet(Temp1,2,"UChar") ^ NumGet(Temp1,10,"UChar"))
         + (NumGet(Temp1,3,"UChar") ^ NumGet(Temp1,11,"UChar"))
         + (NumGet(Temp1,4,"UChar") ^ NumGet(Temp1,12,"UChar"))
         + (NumGet(Temp1,5,"UChar") ^ NumGet(Temp1,13,"UChar"))
         + (NumGet(Temp1,6,"UChar") ^ NumGet(Temp1,14,"UChar"))
         + (NumGet(Temp1,7,"UChar") ^ NumGet(Temp1,15,"UChar")) ;calculate the value of the GUID
 Result := Mod(Result,255) / 255
 Result := Min + (Result * ((Max - Min) + 1)) ;calculate a random number in the desired range using the GUID value
 If Min Is Integer
 {
  If Max Is Integer
   Result := Floor(Result) ;convert the value into an integer if both range parameters are integers
 }
 Return, Result
}