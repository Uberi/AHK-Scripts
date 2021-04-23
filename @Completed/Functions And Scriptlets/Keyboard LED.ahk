#NoEnv

;/*
1::
KeyLED(1,0,0)
KeyWait, %A_ThisHotkey%
KeyLED(0,0,0)
Return

2::
KeyLED(0,1,0)
KeyWait, %A_ThisHotkey%
KeyLED(0,0,0)
Return

3::
KeyLED(0,0,1)
KeyWait, %A_ThisHotkey%
KeyLED(0,0,0)
Return
*/

KeyLED(NumLock = 1,CapsLock = 1,ScrollLock = 1)
{
 static hDevice
 device := "\Device\KeyBoardClass0"
 If !hDevice
 {
  VarSetCapacity(st1,8,0), NumPut(0x530025,st1)
  VarSetCapacity(fn,(StrLen(device) + 1) << 1,0)
  DllCall("wsprintfW","Str",fn,"Str",st1,"Str",device,"Cdecl UInt")
  VarSetCapacity(fh,4,0), VarSetCapacity(objattrib,24,0), VarSetCapacity(io,8,0), VarSetCapacity(pus,8)
  uslen := DllCall("lstrlenW","Str",fn) << 1
  NumPut(uslen,pus,0,2), NumPut(uslen,pus,2,2), NumPut(&fn,pus,4), NumPut(24,objattrib,0), NumPut(&pus,objattrib,8)
  status := DllCall("ntdll\ZwCreateFile","Str",fh,"UInt",0x100 | 0x80 | 0x100000,"Str",objattrib,"Str",io,"UInt",0,"UInt",0,"UInt",1,"UInt",1,"UInt",0x40 | 0x20,"UInt",0,"UInt",0,"UInt")
  hDevice := NumGet(fh)
 }
 VarSetCapacity(output_actual,4,0)
 Input_size := 4, VarSetCapacity(Input,Input_size,0)
 LEDvalue := (ScrollLock ? 1 : 0) | (NumLock ? 2 : 0) | (CapsLock ? 4 : 0)
 KeyLED := LEDvalue | GetKeyState("ScrollLock", "T") | (GetKeyState("NumLock", "T") << 1) | (GetKeyState("CapsLock", "T") << 2)
 Input := Chr(1) . Chr(1) . Chr(KeyLED), Input := Chr(1), Input := ""
 Return, DllCall("DeviceIoControl","UInt",hDevice,"UInt",720896 | 8,"UInt",&Input,"UInt",Input_size,"UInt",0,"UInt",0,"UInt",&output_actual,"UInt",0)
}