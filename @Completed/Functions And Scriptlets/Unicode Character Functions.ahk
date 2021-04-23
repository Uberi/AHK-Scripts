;AHK v1
#NoEnv

;MsgBox % Chr(97) . "`n" . Asc("a")

Chr(UnicodeCode)
{
 VarSetCapacity(TempVar,2), NumPut(UnicodeCode,TempVar,0,"UShort")
 Return, TempVar
}

Asc(UnicodeChar)
{
 Return, NumGet(UnicodeChar,0,"UShort")
}