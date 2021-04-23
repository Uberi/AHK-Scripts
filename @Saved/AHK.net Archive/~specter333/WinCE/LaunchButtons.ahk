; Launcher is a simple panel of buttons used to open files.
; It has only been tested on Windows Mobile 2003 Second Edition with a screen size of 240x320.
; 
; Must have None's "GetFile" function in your library.
; http://www.autohotkey.com/forum/viewtopic.php?p=375102#375102

#NoEnv 
SendMode Input 
#SingleInstance, Force

Loop, 12
	{
	IniRead, B%A_Index%, %A_ScriptDir%\Launch.ini, Functions, B%A_Index% 
	IniRead, NB%A_Index%, %A_ScriptDir%\Launch.ini, Names, NB%A_Index% 
	}
Gui, Font, s10, LCARS

Gui, Add, Tab2,x0 y5 w240 h262 vChangeTabs gChangeTabs, Controls|Options|
Gui, Tab, 
Gui, Add, Button, x170 y5 w60 h20 Center gExit, Exit

Gui, Tab, 1
Gui, Add, Button, x0 y45 w80 h52 Center vB1 gRunApp, %NB1%
Gui, Add, Button, x+0 w80 h52 Center vB2 gRunApp, %NB2%
Gui, Add, Button, x+0 w80 h52 Center vB3 gRunApp, %NB3%

Gui, Add, Button, x0 y+0 w80 h52 Center vB4 gRunApp, %NB4%
Gui, Add, Button, x+0 w80 h52 Center vB5 gRunApp, %NB5%
Gui, Add, Button, x+0 w80 h52 Center vB6 gRunApp, %NB6%

Gui, Add, Button, x0 y+0 w80 h52 Center vB7 gRunApp, %NB7%
Gui, Add, Button, x+0 w80 h52 Center vB8 gRunApp, %NB8%
Gui, Add, Button, x+0 w80 h52 Center vB9 gRunApp, %NB9%

Gui, Add, Button, x0 y+0 w80 h52 Center vB10 gRunApp, %NB10%
Gui, Add, Button, x+0 w80 h52 Center vB11 gRunApp, %NB11%
Gui, Add, Button, x+0 w80 h52 Center vB12 gRunApp, %NB12%

Gui, Tab, 2
Gui, Add, Edit, x5 y35 w50 r1 Right ReadOnly vButtonNum,
Gui, Add, UpDown, Range1-12, 1
Gui, Add, Text, x+10 w100, Button Number

Gui, Add, Edit, x10 y75 w200 r1 vRunApp, 
Gui, Add, Button, x+1 w20 h25 gGo, ...
Gui, Add, Groupbox, x5 y60 w230 h45, Select an App
Gui, Add, Edit, x10 y120 w220 r1 vButtonName,
Gui, Add, Groupbox, x5 y105 w230 h45, Add A Button Name
Gui, Add, Button, x5 y152 w230 gUseApp, Assign to Button

Gui, -Caption
Gui, Show, y25 w240 h270, Launcher
Return

RunApp:
DoRun := %A_GuiControl%
If DoRun = ERROR
	{
	MsgBox, An action has not been assigned to this button.
	Return
	}
Run, %DoRun%
Return

Go:
DllCall("SipShowIM", "UInt", 0) ;Hide
Fpath:=GetFile("\Program Files\AutoHotkeyCE\","*.ahk") 
Guicontrol, , RunApp, %Fpath%
DllCall("SipShowIM", "UInt", 1) ;Show
Return

UseApp:
Gui, Submit, NoHide
If RunApp = 
	{
	MsgBox, Please select an application to run before saving button.
	Return
	}
If RunApp = Canceled
	{
	MsgBox, Please select an application to run before saving button.
	Return
	}
IniWrite, %ButtonName%, %A_ScriptDir%\Launch.ini, Names, NB%ButtonNum% 
IniWrite, %RunApp%, %A_ScriptDir%\Launch.ini, Functions, B%ButtonNum% 
Sleep, 250
Reload
Return

ChangeTabs:
Gui, Submit, NoHide
If ChangeTabs = Options
	DllCall("SipShowIM", "UInt", 1) ;Show
If ChangeTabs = Controls
	DllCall("SipShowIM", "UInt", 0) ;Hide
Return

Exit:
GuiClose:
Gui, Destroy
ExitApp
