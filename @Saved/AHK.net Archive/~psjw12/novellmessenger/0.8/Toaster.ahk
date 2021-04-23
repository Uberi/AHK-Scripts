#NoEnv
#SingleInstance,Off
#NoTrayIcon

Process,Priority,,L

If 0 = 0
Text = Sample Text
Else
Text = %1%

Restart:
Count = 0
Loop
{
	IfWinExist,Toaster%Count%
		Count++
	;If Count > 6
	;{}
	Else
		Break	
}
SysGet,TStartH,MonitorWorkArea,
;Msgbox, Right: %TStartHRight% -- Bottom %TStartHBottom%.
Gui,Add,Text, w160,%Text%
Gui,Add,Button,y5 x180 h18,X
Gui, -0x400000 -MinimizeBox -SysMenu +ToolWindow +AlwaysOnTop
;SetTimer,HoverMon,-100,
;DetectHiddenWindows,On
;WinGetPos,,,,WinHeight,Toaster%Count%
;Msgbox,%WinHeight%
;Msgbox,%A_GuiHeight%
xPos := TStartHRight - 202
yPos := TStartHBottom -27
ypos := yPos-(26*Count)
If ypos < 0
{
	Sleep,1000
	Goto,Restart
}
Gui,Show,x%xPos% y%yPos% w200 h25,Toaster%Count%
WinSet,Trans,170,Toaster%Count%,
++TStartHBottom
TStartHBottom := TStartHBottom-(26*count)
;Return
Loop,28
{
	--TStartHBottom
	Gui,Show,x%xPos% y%TStartHBottom% NoActivate,
	Gosub,HoverMon
	Sleep,5
}
;Msgbox,Pause
Loop,100
{
	Gosub,HoverMon
	Sleep,50
}
;Sleep,5000
Loop,203
{
	Gui,Show,x%xPos% y%TStartHBottom% NoActivate,
	++xPos
	Gosub,HoverMon
	Sleep,5
} 
ExitApp

ButtonX:
GuiClose:
ExitApp


HoverMon:
MouseGetPos, , , Window,
WinGetTitle,Window,ahk_id %Window%
If Window = Toaster%Count%
WinSet,Trans,off,Toaster%Count%,
Else
WinSet,Trans,170,Toaster%Count%,
Return
