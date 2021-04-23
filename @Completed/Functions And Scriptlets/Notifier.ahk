;AHK v1
#NoEnv

/*
Notify("MoreInfo","Test Notification","Test information to show at the bottom. More information follows. Click here for more information.",500,4)
ExitApp
*/

Notify(NotifyLabel,Title,Contents = "",Width = 500,TimeOut = -1)
{
 Gui, Color, 777777
 Gui, Font, cWhite s34 Bold, Arial
 Gui, Font,, Calibri
 Temp1 := Width - 40
 Gui, Add, Text, x20 y10 w%Temp1% h60 Center, %Title%
 Gui, Font, s16
 Gui, Add, Text, x20 y70 w%Temp1% Center, %Contents%
 Gui, -Caption +ToolWindow +AlwaysOnTop +LastFound
 WinSet, Transparent, 0
 Gui, Show, y70 w%Width% Hide
 WinGetPos,,,, Temp1
 Gui, Add, Text, x0 y0 w%Width% h%Temp1% gNotifierAction BackgroundTrans
 WinSet, Region, 0-0 w%Width% h%Temp1% r40-40
 Gui, Show, NoActivate, Notification
 Loop, 20
 {
  WinSet, Transparent, % A_Index * 10
  Sleep, 40
 }
 While, (A_Index != 15 && !Notified)
  Sleep, 100
 If !Notified
  Input, Temp1, % "L1 V " . ((TimeOut = -1) ? "" : ("T" . TimeOut)), {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}
 Loop, 20
 {
  WinSet, Transparent, % (15 - A_Index) * 10
  Sleep, 30
 }
 Gui, Destroy
 If (Notified && IsLabel(NotifyLabel))
  SetTimer, %NotifyLabel%, -1
 Return

 NotifierAction:
 Input
 Notified = 1
 Return
}