#SingleInstance,Force
#NoTrayIcon
ProgramName = XPSnap V1.1

Gui 1: -caption +ToolWindow 
Gui 1: Font, S10 bold, Verdana
Gui 1: Add, Text, x12 y5 h5      ,______________________________
Gui 1: Add, Text, x42 y30 h150, %ProgramName% is now running
Gui 1: Add, Text, x12 y44        ,______________________________
Gui 1: Add, Text, x32 y64, Press ctrl-alt-e to exit XPSnap
Gui 1: Add, Text, x58 y82 cBlue  ,Author: Robert Jackson
Gui 1: Add, Text, x12 y100 cBlue  ,Email: RobertJackson1@hotmail.com
ButtonXPos := (292/2)-30
Gui 1: Add, Button, x%ButtonXPos% y120,Close
XPos := ((A_ScreenWidth)/2)-146
Gui 1: Show, x%XPos% w292 h155, %ProgramName%
WinSet,AlwaysOnTop,On,
WinSet,region, 0-0  w292 h155 R30-30 , %ProgramName%
return
ButtonClose:
GuiEscape:
Gui 1: destroy


CoordMode, Mouse, Screen
SetFormat,float,6.0
*~LButton::
SysGet, MonitorWorkArea, MonitorWorkArea   
CoordMode, Mouse, Relative
MouseGetPos,,YPosInWindow,hwnd 
CoordMode, Mouse, Screen
Return
*~Lbutton up::
CoordMode, Mouse, Screen
MouseGetPos, XstopPos, YstopPos,
sleep 100 

If ((XstopPos-MonitorWorkAreaLeft)<3)and(YstopPos>MonitorWorkAreaTop+3)and(YstopPos<(MonitorWorkAreaBottom-3))and(YPosInWindow < 29)
 WinMove,ahk_id %hwnd%,,%MonitorWorkAreaLeft%,%MonitorWorkAreaTop%,((MonitorWorkAreaRight-MonitorWorkAreaLeft)/2),(MonitorWorkAreaBottom-MonitorWorkAreaTop)
;Mouse on Right edge // determined by "If (XstopPos>(MonitorWorkAreaRight-3))"
If (XstopPos>(MonitorWorkAreaRight-3))and(YstopPos>MonitorWorkAreaTop+3)and(YstopPos<(MonitorWorkAreaBottom-3))and(YPosInWindow < 29)
 WinMove,ahk_id %hwnd%,,((MonitorWorkAreaRight+MonitorWorkAreaLeft)/2),MonitorWorkAreaTop,((MonitorWorkAreaRight-MonitorWorkAreaLeft)/2),(MonitorWorkAreaBottom-MonitorWorkAreaTop)
;Mouse is on the bottom edge // determined by "If (YstopPos>(MonitorWorkAreaBottom-3))"
If (YstopPos>(MonitorWorkAreaBottom-3))and(YstopPos<(MonitorWorkAreaBottom+1))and(XstopPos>(MonitorWorkAreaLeft+3))and(XstopPos<(MonitorWorkAreaRight-3))and(YPosInWindow < 29)
 WinMove,ahk_id %hwnd%,,MonitorWorkAreaLeft,(((MonitorWorkAreaBottom-MonitorWorkAreaTop)/2)+MonitorWorkAreaTop) ,MonitorWorkAreaRight-MonitorWorkAreaLeft,((MonitorWorkAreaBottom-MonitorWorkAreaTop)/2)
;Mouse is on the top edge // determined by "If (YstopPos<(MonitorWorkAreaTop+3))"
If (YstopPos<(MonitorWorkAreaTop+3)) and (YstopPos>(MonitorWorkAreaTop-1))and(XstopPos>(MonitorWorkAreaLeft+3))and(XstopPos<(MonitorWorkAreaRight-3))and(YPosInWindow < 29)
 WinMove,ahk_id %hwnd%,,MonitorWorkAreaLeft,MonitorWorkAreaTop,MonitorWorkAreaRight-MonitorWorkAreaLeft,((MonitorWorkAreaBottom-MonitorWorkAreaTop)/2)
 Return
 ^!e::
 Gui 2: -caption +ToolWindow 
Gui 2: Font, S10 bold, Verdana
Gui 2: Add, Text, x12 y5 h5      ,______________________________
Gui 2: Add, Text, x42 y30 h150, %ProgramName% is now exiting
Gui 2: Add, Text, x12 y44        ,______________________________

Gui 2: Add, Text, x58 y82 cBlue  ,Author: Robert Jackson
Gui 2: Add, Text, x12 y100 cBlue  ,Email: RobertJackson1@hotmail.com
ButtonXPos := (292/2)-30
Gui 2: Add, Button, x%ButtonXPos% y120,Close
XPos := ((A_ScreenWidth)/2)-146
Gui 2: Show, x%XPos% w292 h155, %ProgramName%
WinSet,AlwaysOnTop,On,
WinSet,region, 0-0  w292 h155 R30-30 , %ProgramName%
sleep 3000
2ButtonClose:
 ExitApp
 
 



