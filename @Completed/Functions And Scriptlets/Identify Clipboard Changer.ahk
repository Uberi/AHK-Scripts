;AHK v1
#NoEnv

/*
Result := IdentifyClipboardChanger()
WinGet, CBName, ProcessName, ahk_pid %Result%
MsgBox % CBName
*/

IdentifyClipboardChanger()
{ ;Returns the PID of the program that last modified the clipboard.
 HiddenWindows := A_DetectHiddenWindows
 DetectHiddenWindows, On
 WinGet, ClipboardPID, PID, % "ahk_id " . DllCall("GetClipboardOwner")
 DetectHiddenWindows, %HiddenWindows%
 Return, ClipboardPID
}