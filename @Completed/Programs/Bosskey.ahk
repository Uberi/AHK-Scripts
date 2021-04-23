#NoEnv

;#NoTrayIcon

SafeWin = NotePad.exe
HideKey = RControl
ShowKey = Esc

Run, %SafeWin%,, Hide UseErrorLevel, SafeWinPID
Hotkey, %HideKey%, HideWin
Hotkey, %ShowKey%, ShowWin, Off
Return

HideWin:
WinGet, WinList, List
Loop, %WinList%
{
 Temp1 := WinList%A_Index%
 WinHide, ahk_id %Temp1%
}
WinShow ahk_class Shell_TrayWnd
WinShow, ahk_class Progman
WinShow, ahk_pid %SafeWinPID%
WinActivate, ahk_pid %SafeWinPID%
Hotkey, Esc, On
Return

ShowWin:
Loop, %WinList%
{
 Temp1 := WinList%A_Index%
 WinList%A_Index% = 
 WinShow, ahk_id %Temp1%
}
WinList = 
WinMinimize, ahk_pid %SafeWinPID%
Hotkey, Esc, Off
Return