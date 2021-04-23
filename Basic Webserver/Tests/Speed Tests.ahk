#NoEnv

#Include %A_ScriptDir%\HTTPQuery.ahk

TestAmount = 100

DetectHiddenWindows, On
SetTitleMatchMode, 2
IfWinNotExist, Simple Server ahk_class AutoHotkey
{
 Run, "%A_ScriptDir%\..\Simple Server.ahk"
 WinWait, Simple Server ahk_class AutoHotkey
 Sleep, 500
}
Clipboard = 
Request()
Sleep, 1000
StartTimer()
Temp1 = %TimerBefore%
Loop, %TestAmount%
 Clipboard .= Request() . "`n"
TimerBefore = %Temp1%
Temp1 := StopTimer()
Send, !{Esc}
WinWait, Confirm Exit ahk_class #32770,, 2
ControlSend, Button1, {Enter}
MsgBox, 64, Complete, Speed benchmarks copied to clipboard.`n`nTotal milliseconds elapsed: %Temp1%
ExitApp

Request()
{
 StartTimer()
 httpQuery(Result,"http://127.0.0.1/scripts/script.ahk")
 Return, StopTimer()
}

StartTimer()
{
 global TimerBefore
 DllCall("QueryPerformanceCounter","Int64*",TimerBefore)
}

StopTimer()
{
 global TimerBefore
 DllCall("QueryPerformanceCounter","Int64*",TimerAfter)
 DllCall("QueryPerformanceFrequency","Int64*",TicksPerMillisecond)
 TicksPerMillisecond /= 1000
 Return, (TimerAfter - TimerBefore) / TicksPerMillisecond
}