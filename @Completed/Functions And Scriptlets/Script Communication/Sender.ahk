#NoEnv

SetTitleMatchMode, 2
DetectHiddenWindows, On

String = TestBla123
Return

Tab::
VarSetCapacity(Temp1,12,0), NumPut(StrLen(String) + 1,Temp1,4), NumPut(&String,Temp1,8)
SendMessage, 0x4A, 0, &Temp1,, Receiver ahk_class AutoHotkey
Return