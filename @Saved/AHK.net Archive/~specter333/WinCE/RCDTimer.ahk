; Richard's Countdown Timer.  Add a timer on your desktop.
; Developed out of necessity.  I was always burning my dinner while wearing headphones
; at my computer.  Couldn't hear the oven timer.

#SingleInstance, Ignore
#Persistent
SetTitleMatchMode, 2
DetectHiddenWindows,On

SetBatchLines, -1
settitlematchmode 2

k_MenuItemHide = Hide Timer
k_MenuItemShow = Show Timer

Menu, Tray, Add, %k_MenuItemHide%, k_ShowHide
Gui, Color, Black
Gui, Font, cA3A300 s30 Bold, Arial
Gui, Add, Text, x15 y5 w150 Center vtime, 00:00:00

Gui, Font, cBlack s10, Arial
Gui, Add, Edit, x15 y76 h20 w50 Center Number Limit3 Hidden vgettimeh, 00
Gui, Add,  UpDown, r0-100,

Gui, Add, Edit, x+15 h20 w50 Center Number Limit3 Hidden vgettimem, 00
Gui, Add,  UpDown, r0-100,

Gui, Add, Edit, x+15 y76 h20 w50 Center Number Limit3 Hidden vgettimes, 00
Gui, Add,  UpDown, xr0-100,

Gui, Font, cWhite s10, Arial
Gui, Add, Groupbox,x10 y60 h39 w60 Center, HR
Gui, Add, Groupbox,x+5 h39 w60 Center, MIN
Gui, Add, Groupbox,x+5 h39 w60 Center, SEC

Gui, Add, Button, x55 y110 h20 w100 vgo, Go
Gui, Add, Button, x55 y110 h20 w100 Hidden vreset, Reset
Gui, Add, Button, x55 y140 h20 w100 Disabled vhide, Hide

Gui, Margin, 2, 2
Gui, +AlwaysOnTop +LastFound

Gui, Show, w210, Countdown Timer

GuiControl, Show, gettimeh
GuiControl, Show, gettimem
GuiControl, Show, gettimes
GuiControl, Focus, time

k_IsVisible = y
stoploop = 
Return

exit:
GuiClose:
ButtonExit:
Sleep, 250
Gui, Destroy
ExitApp

ButtonHide:
k_ShowHide:
if k_IsVisible = y
{
    Gui, Cancel
    Menu, Tray, Rename, %k_MenuItemHide%, %k_MenuItemShow%
    k_IsVisible = n
}
else
{
    Gui, Show
    Menu, Tray, Rename, %k_MenuItemShow%, %k_MenuItemHide%
    k_IsVisible = y
}
return

ButtonGo:
Gui, Submit, NoHide
xtime:=MCI_ToMilliseconds(gettimeh,gettimem,gettimes)
If xtime = 0
	{
	Gui, Font, s30 cYellow Bold, Arial
	GuiControl, Font, time
	GuiControl, , time, Time?
	Sleep, 1000
	GoTo resettimer
	}
ztime:=MCI_ToHHMMSS(xtime)
Gui, Font, s30 cYellow Bold, Arial
GuiControl, Font, time
GuiControl, , time,%ztime%
GuiControl, Enable, hide
GuiControl, Hide, go
GuiControl, Show, reset
Loop,
	{
	Sleep, 1000
	countdown:=xtime-(A_index*1000)
	cdpos:=MCI_ToHHMMSS(countdown)
	GuiControl, , time,%cdpos%
	If countdown = 0
		Break
	If countdown = 5000
		If k_IsVisible = n
			GoSub, k_ShowHide
	If stoploop = stopcount
		Break
	}
If stoploop = stopcount
		Goto Resettimer
GoTo TimeUp
Return

TimeUp:
GuiControl, Disable, hide
Gui, Show ;In case it's hidden in the last 5 seconds.
Loop,
	{
	SoundPlay, \WINDOWS\Alarm1.wav
	GuiControl, Show, time
	Sleep, 1000
	GuiControl, Show0, time
	Sleep, 1000
	If stoploop = stopcount
		Break
	}
GoTo resettimer
Return

ButtonReset:
stoploop = stopcount
Return

resettimer:
stoploop = 
GuiControl, Hide, reset
GuiControl, Disable, hide
GuiControl, Show, go
GuiControl, ,gettimeh, 00
GuiControl, ,gettimem, 00
GuiControl, ,gettimes, 00
Gui, Font, s30 cA3A300 Bold, Arial
GuiControl, Font, time
Guicontrol, Show, time
GuiControl, ,time, 00:00:00
GuiControl, Focus, time
Return
