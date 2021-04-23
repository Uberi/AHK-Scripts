/*
File structure

Documentation
	-features
	-intro
	-use instructions

Settings
	-ahk script setting
	-save delay
	-method counters and defaults
	-app method settings

Suspend Hotkey
	-ScrollLock

Setup HotKeys
	-WinKey + [Ctrl + Shift +]WheelUp
	-WinKey + [Ctrl + Shift +]WheelDown
	-WinKey + [Ctrl + Shift +]WheelRight
	-WinKey + [Ctrl + Shift +]WheelLeft

Main HotKeys
	-WheelUp
	-WheelDown
	-WheelRight
	-WheelLeft

Subs for the main hotkeys
	-Set_Method
	-Get_SBar_Info

Subs for the setup hotkeys
	-TApp_Method_Settings
	-SAVEtoFILE

Documetation

Features
-scroll inactive windows and controls
-both vertical and horizontal wheels suported
-7 scrolling methods combined with 2 focus methods
-enables scrolling in some controls that don't normaly scroll
-switching methods on the fly
-saving of setup methods for programs and controls

Intro
This script is supposed to allow the user to use the scroll wheels
in the window and control under the mouse, rather than the one
holding keyboard focus, that being the default Windows behaviour.
It also atempts to enable wheelscroling in controls where it doesn't work by default.

It supports both the vertical and the horizontal scrollwheel,
unlike other programs of this type that I have tried.

Curently gives an option of 7 scrolling methods that can be changed on the fly.
Method changes are saved inside the script file separatly for programs and controls,
so once you configure a program the way you like, it stays that way.

Use instructions:
Must have Autohotkey instaled - it is possible I will work on a standalone version in the future.
Just run the script and scroll away :)
The default method should scroll most windows properly from the start, but, should you
encounter a window or control that doesn't scroll, consider changing the method used.
Methods are changed separately for horizontal and vertical because horizontal scrolling
works a lot less with the default method.

To dissable the script, press ScrollLock. I choosed it because it's rarely used and seems intuitive.
Note that ScrollLock state is reset to off when the script is run.

	Changing methods:
To change the scroll method used for a particular program hold down the WIN key and 
turn the wheel coresponding to the direction you want to change the method for.

If the method used generaly works in the program, but you find some controls for which it doesn't,
you can change the method used with a particular control class under that program by holding
WIN + CTRL and turning a wheel as before.

You can also change the setting for a particular control, individualized by it's classNN, by
holding WIN + CTRL + SHIFT and turning a wheel, but it's less likely to be needed.

Note that there are also a few global control settings, that are embeded in the script
and can't curently be changed without editing the file by hand. Theese take precedence over program
settings, but are overwriten by control settings. Globaly set up control classes are:
SysTreeView, SysListView and DirectUIHWND. With the exception of horizontal scrolling under DirectUIHWND,
they are set up to use the default method regardless of the program they are used under.

Method details:
Off - sends the wheel scroll to the active window using the Click command
1 - the default method - sends WM_MOUSEWHEEL messages to the control under the mouse using PostMessage
	- should imitate default behaviour
	-I will probably change this to be in effect for the active window rather than the window under the mouse
2 - similar to the above, but uses ControlClick - not sure if it's actually different from the first
3 - sends WM_SCROLL messages with PostMessage
4 - sends EM_SCROLL messages with PostMessage - probably only works on Edit and RichEdit controls
5 - finds a control named "ScrollBar" that seems to be apropiate and sends clicks to it's end arrows
	-mosty works, but I supose it could get mixed up in some window configurations
	-will attempt to see I can replace this by sending messages directly to the scrollbars
6 - similar to the above, but looks for "NetUIHWND" instead of "ScrollBar"
	-developed for use with horizontal scrolling in Office 2007 - not sure it works on anything
7 - sends direction keystrokes to the control under the mouse via PostMessage
	-I consider moving the carret to the top/bottom of the page beforehand to simulate scrolling better

Focus methods:
On some windows with more controls, scroll messages are sent to the last focused control in that window rather than
the one under the mouse, so changing the focused control is necessary before proper scrolling.
Curently I have two methods for doing that, the first being set up as default.
The second method sends an additional leftclick message to the tageted control, that sometimes has the side-effect
of activating the window as well, so test before you use it. I only used to try scrolling RichEdit comboboxes
under Office 2007 and with mixed results.
To change the focus method used for a program, hold WIN + SHIFT and turn the vertical mousewheel.
The focus method can also be set to "Off".

To change the default methods used by the script, you have to edit the Settings section of the file by hand.

Changes done on the fly are saved inside the file separately for each program.
Saving occurs about 2 seconds after the last change

Plans of development
	- a GUI to facilitate changing all the settings
	- improve and change some of the methods
	- add new methods if I find any
	- enable more actions on innactive windows

Alternative or similar software and ahk scripts
	-Wheeler
	-WheelHere
	-MouseHunter
	-WizMouse
	-KatMouse
	-Send mouse scrolls to window under mouse - http://www.autohotkey.com/forum/topic6772.html
	-Mouse Wheel Emulator - http://www.autohotkey.com/forum/topic50093.html
	-DragToScroll - Universal Drag & Fling/Flick Scrolling - http://www.autohotkey.com/forum/topic59726.html

Limited Support: http://www.autohotkey.com/forum/viewtopic.php?t=83794
*/

#SingleInstance force
#NoEnv
#InstallMouseHook
#UseHook
Critical
SendMode Input
CoordMode, Mouse, Screen
SetScrollLockState, off

SAVEdelay := -2000

vMethodCount := 7
vDefaultMethod := 1

hMethodCount := 7
hDefaultMethod := 1

fMethodCount := 2
fDefaultMethod := 1

/*
[AppMethodSettings]
*/
AppSettings_vMethod ={<SysTreeView>}{<SysListView>}{<DirectUIHWND>}
AppSettings_hMethod ={<SysTreeView>}{<SysListView>}{<DirectUIHWND(5)>}
AppSettings_fMethod =
/*
[Rest of Script]
*/

~ScrollLock::Suspend

#^+WheelUp::
axis := "v"
direction := 1
SettingDeph := 2
gosub, TApp_Method_Settings
return

#^+WheelDown::
axis := "v"
direction := -1
SettingDeph := 2
gosub, TApp_Method_Settings
return

#^+WheelRight::
axis := "h"
direction := 1
SettingDeph := 2
gosub, TApp_Method_Settings
return

#^+WheelLeft::
axis := "h"
direction := -1
SettingDeph := 2
gosub, TApp_Method_Settings
return

#^WheelUp::
axis := "v"
direction := 1
SettingDeph := 1
gosub, TApp_Method_Settings
return

#^WheelDown::
axis := "v"
direction := -1
SettingDeph := 1
gosub, TApp_Method_Settings
return

#^WheelRight::
axis := "h"
direction := 1
SettingDeph := 1
gosub, TApp_Method_Settings
return

#^WheelLeft::
axis := "h"
direction := -1
SettingDeph := 1
gosub, TApp_Method_Settings
return

#WheelUp::
axis := "v"
direction := 1
SettingDeph := 0
gosub, TApp_Method_Settings
return

#WheelDown::
axis := "v"
direction := -1
SettingDeph := 0
gosub, TApp_Method_Settings
return

#WheelRight::
axis := "h"
direction := 1
SettingDeph := 0
gosub, TApp_Method_Settings
return

#WheelLeft::
axis := "h"
direction := -1
SettingDeph := 0
gosub, TApp_Method_Settings
return

#+WheelUp::
axis := "f"
direction := 1
SettingDeph := 0
gosub, TApp_Method_Settings
return

#+WheelDown::
axis := "f"
direction := -1
SettingDeph := 0
gosub, TApp_Method_Settings
return

WheelUp::
MouseGetPos, mX, mY, TWinID, TCon
if (TWinID <> exWin4v) or (TCon <> exCon4v)
	{
	axis := "v"
	gosub, Set_Method
	}
if (vMethod = "Off")
	Click, WheelUp
else if (vMethod = 1)
	PostMessage, 0x20A, 120 << 16, (mY << 16) | mX, %TCon%, ahk_id%TWinID%
else if (vMethod = 2)
	ControlClick, %TCon%, ahk_id%TWinID%,, WheelUp, 1, NA
else if (vMethod = 3)
	PostMessage, 0x115, 0, 0, %TCon%, ahk_id%TWinID%
else if (vMethod = 4)
	PostMessage, 0xB6, 0, -1, %TCon%, ahk_id%TWinID%
else if (vMethod = 5) or (vMethod = 6)
	{
	if (mX <> exMx) or (mY <> exMy)
		{
		axis := "v"
		gosub, Get_SBar_Info
		}
	PostMessage, 0x201,, (5 << 16) | 5, %VBarC%, ahk_id%TWinID%
	PostMessage, 0x202,, (5 << 16) | 5, %VBarC%, ahk_id%TWinID%
	}
else if (vMethod = 7)
	{
	PostMessage, 0x0100, 0x26,, %TCon%, ahk_id%TWinID%
	PostMessage, 0x0101, 0x26,, %TCon%, ahk_id%TWinID%
	}
return

WheelDown::
MouseGetPos, mX, mY, TWinID, TCon
if (TWinID <> exWin4v) or (TCon <> exCon4v)
	{
	axis := "v"
	gosub, Set_Method
	}
if (vMethod = "Off")
	Click, WheelDown
else if (vMethod = 1)
	PostMessage, 0x20A, -120 << 16, (mY << 16) | mX, %TCon%, ahk_id%TWinID%
else if (vMethod = 2)
	ControlClick, %TCon%, ahk_id%TWinID%,, WheelDown, 1, NA
else if (vMethod = 3)
	PostMessage, 0x115, 1, 0, %TCon%, ahk_id%TWinID%
else if (vMethod = 4)
	PostMessage, 0xB6, 0, 1, %TCon%, ahk_id%TWinID%
else if (vMethod = 5) or (vMethod = 6)
	{
	if (mX <> exMx) or (mY <> exMy)
		{
		axis := "v"
		gosub, Get_SBar_Info
		}
	PostMessage, 0x201,, ((VBarH - 5) << 16) | 5, %VBarC%, ahk_id%TWinID%
	PostMessage, 0x202,, ((VBarH - 5) << 16) | 5, %VBarC%, ahk_id%TWinID%
	}
else if (vMethod = 7)
	{
	PostMessage, 0x0100, 0x28,, %TCon%, ahk_id%TWinID%
	PostMessage, 0x0101, 0x28,, %TCon%, ahk_id%TWinID%
	}
return

WheelLeft::
MouseGetPos, mX, mY, TWinID, TCon
if (TWinID <> exWin4h) or (TCon <> exCon4h)
	{
	axis := "h"
	gosub, Set_Method
	}
if (hMethod = "Off")
	Click, WheelLeft
else if (hMethod = 1)
	PostMessage, 0x20E, -120 << 16, (mY << 16) | mX, %TCon%, ahk_id%TWinID%
else if (hMethod = 2)
	ControlClick, %TCon%, ahk_id%TWinID%,, WheelLeft, 1, NA
else if (hMethod = 3)
	PostMessage, 0x114, 0, 0, %TCon%, ahk_id%TWinID%
else if (hMethod = 4)
	PostMessage, 0xB6, -1, 0, %TCon%, ahk_id%TWinID%
else if (hMethod = 5) or (hMethod = 6)
	{
	if (mX <> exMx) or (mY <> exMy)
		{
		axis := "h"
		gosub, Get_SBar_Info
		}
	PostMessage, 0x201,, (5 << 16) | 5, %HBarC%, ahk_id%TWinID%
	PostMessage, 0x202,, (5 << 16) | 5, %HBarC%, ahk_id%TWinID%
	}
else if (hMethod = 7)
	{
	PostMessage, 0x0100, 0x25,, %TCon%, ahk_id%TWinID%
	PostMessage, 0x0101, 0x25,, %TCon%, ahk_id%TWinID%
	}
return

WheelRight::
MouseGetPos, mX, mY, TWinID, TCon
if (TWinID <> exWin4h) or (TCon <> exCon4h)
	{
	axis := "h"
	gosub, Set_Method
	}
if (hMethod = "Off")
	Click, WheelRight
else if (hMethod = 1)
	PostMessage, 0x20E, 120 << 16, (mY << 16) | mX, %TCon%, ahk_id%TWinID%
else if (hMethod = 2)
	ControlClick, %TCon%, ahk_id%TWinID%,, WheelRight, 1, NA
else if (hMethod = 3)
	PostMessage, 0x114, 1, 0, %TCon%, ahk_id%TWinID%
else if (hMethod = 4)
	PostMessage, 0xB6, 1, 0, %TCon%, ahk_id%TWinID%
else if (hMethod = 5) or (hMethod = 6)
	{
	if (mX <> exMx) or (mY <> exMy)
		{
		axis := "h"
		gosub, Get_SBar_Info
		}
	PostMessage, 0x201,, (5 << 16) | (HBarW - 5), %HBarC%, ahk_id%TWinID%
	PostMessage, 0x202,, (5 << 16) | (HBarW - 5), %HBarC%, ahk_id%TWinID%
	}
else if (hMethod = 7)
	{
	PostMessage, 0x0100, 0x27,, %TCon%, ahk_id%TWinID%
	PostMessage, 0x0101, 0x27,, %TCon%, ahk_id%TWinID%
	}
return



Set_Method:

%axis%Method := %axis%DefaultMethod
fMethod := fDefaultMethod
, TConC := "", TConN := ""
, AppString := "", AppString_method := "", AppString_exceptions := ""
, ConCString := "", ConCString_method := "", ConCString_exceptions := ""
, ConNString := "", ConNString_method := ""

if (TCon <> "")
	RegExMatch(TCon, "(?P<C>.*\D)(?P<N>\d+)$", TCon)

WinGet, TApp, ProcessName, ahk_id%TWinID%

if (TApp <> "") and inStr(AppSettings_%axis%Method, "{" . TApp)
	{
	RegExMatch(AppSettings_%axis%Method, "i)\{" . TApp . "(\((?P<_method>[^\)]*)\))?(?P<_exceptions>[^\}]*)\}", AppString)

	if (AppString_method <> "")
		%axis%Method := AppString_method

	if inStr(AppSettings_%axis%Method, "{<" . TConC)
		{
		RegExMatch(AppSettings_%axis%Method, "i)\{\<" . TConC . "(\((?P<_method>[^\)]*)\))?\>\}", ConCString)

		if (ConCString_method <> "")
			%axis%Method := ConCString_method
		else %axis%Method := %axis%DefaultMethod
		}

	if inStr(AppString_Exceptions, "<" . TConC)
		{
		RegExMatch(AppString_Exceptions, "i)\<" . TConC . "(\((?P<_method>[^\)]*)\))?(?P<_exceptions>[^\>]*)\>", ConCString)

		if (ConCString_method <> "")
			%axis%Method := ConCString_method

		if inStr(ConCString_Exceptions, "[" . TConN)
			{
			RegExMatch(ConCString_Exceptions, "i)\[" . TConN . "\((?P<_method>[^\)]*)\)\]", ConNString)

			if (ConNString_method <> "")
				%axis%Method := ConNString_method
			}
		}
	}
else if (TCon <> "") and inStr(AppSettings_%axis%Method, "{<" . TConC)
	{
	RegExMatch(AppSettings_%axis%Method, "i)\{\<" . TConC . "(\((?P<_method>[^\)]*)\))?\>\}", ConCString)

	if (ConCString_method <> "")
		%axis%Method := ConCString_method
	}

if (%axis%Method = 5)
	{
	look4 := "ScrollBar"
	gosub, Get_SBar_Info
	}
else if (%axis%Method = 6)
	{
	look4 := "NetUIHWND"
	gosub, Get_SBar_Info
	}

if (TApp <> "") and inStr(AppSettings_fMethod, "{" . TApp)
	{
	RegExMatch(AppSettings_fMethod, "i)\{" . TApp . "(\((?P<_method>[^\)]*)\))?(?P<_exceptions>[^\}]*)\}", AppFocus)

	if (AppFocus_method <> "")
		fMethod := AppFocus_method
	}

if (fMethod = 1)
	PostMessage, 0x0006, 2,, %TCon%, ahk_id%TWinID%
else if (fMethod = 2)
	{
	PostMessage, 0x0006, 2,, %TCon%, ahk_id%TWinID%
	PostMessage, 0x201,,, %TCon%, ahk_id%TWinID%
	PostMessage, 0x202,,, %TCon%, ahk_id%TWinID%
	}

exWin4%axis% := exTWinID := TWinID, exCon4%axis% := exTCon := TCon
return


Get_SBar_Info:
%axis%BarC := "", exMx := mX, exMy := mY
if (look4 = "ScrollBar") and inStr(TCon, look4)
	{
	ControlGetPos, SBarX, SBarY, SBarW, SBarH, %TCon%, ahk_id%TWinID%
	if (axis = "v")
		and (SBarW < 20)
		and (SBarH > SBarW)
		{
		VBarC := TCon, VBarX := SBarX, VBarY := SBarY, VBarW := SBarW, VBarH := SBarH
		return
		}
	else if (axis = "h")
		and (SBarH < 20)
		and (SBarW > SBarH)
		{
		HBarC := TCon, HBarX := SBarX, HBarY := SBarY, HBarW := SBarW, HBarH := SBarH
		return
		}
	else TSBarH := SBarH, TSBarW := SBarW
	}
else  TSBarH := 0, TSBarW := 0
WinGetPos, TWinIDX, TWinIDY,,, ahk_id%TWinID%
WinGet, TWinIDConList, ControlList, ahk_id%TWinID%
loop, Parse, TWinIDConList, `n
	{
	if inStr(A_LoopField, look4)
		{
		ControlGet, vis, Visible,, %A_LoopField%, ahk_id%TWinID%
		if vis = 1
			{
			ControlGetPos, SBarX, SBarY, SBarW, SBarH,  %A_LoopField%, ahk_id%TWinID%
			if (axis = "v") 
				and (SBarW < 20)
				and (SBarH > SBarW)
				and (mX < (TWinIDX + SBarX + SBarW))
				and (mY < (TWinIDY + SBarY + SBarH + TSBarH))
				{
				if (VBarC = "")
					or (SBarX < VBarX)
					or ((TWinIDY + VBarY) > (TWinIDY + SBarY + SBarH))
					{
					VBarC := A_LoopField, VBarX := SBarX, VBarY := SBarY, VBarW := SBarW, VBarH := SBarH
					}
				}
			else if (axis = "h")
				and (SBarH < 20)
				and (SBarW > SBarH)
				and (mY < (TWinIDY + SBarY + SBarH))
				and (mX < (TWinIDX + SBarX + SBarW + TSBarW))
				{
				if (HBarC = "")
					or (SBarY < HBarY)
					or ((TWinIDX + HBarX) > (TWinIDX + SBarX + SBarW))
					{
					HBarC := A_LoopField, HBarX := SBarX, HBarY := SBarY, HBarW := SBarW, HBarH := SBarH
					}
				}
			}

		}
	}
return


TApp_Method_Settings:
MouseGetPos,,, TWinID, TCon
WinGet, TApp, ProcessName, ahk_id%TWinID%

if (TApp = "")
	return

if (TCon = "") and (SettingDeph > 0)
	return
else RegExMatch(TCon, "(?P<C>.*\D)(?P<N>\d+)$", TCon)

TApp_%axis%Method_ex := %axis%DefaultMethod, TApp_%axis%Method_new := ""
, AppString := "", AppString_method := "", AppString_exceptions := ""
, ConCString := "", ConCString_method := "", ConCString_exceptions := ""
, ConNString := "", ConNString_method := ""

if inStr(AppSettings_%axis%Method, "{" . TApp)
	{
	RegExMatch(AppSettings_%axis%Method, "i)\{" . TApp . "(\((?P<_method>[^\)]*)\))?(?P<_exceptions>[^\}]*)\}", AppString)
	StringReplace, AppSettings_%axis%Method, AppSettings_%axis%Method, %AppString%,, All

	if (AppString_method = "")
		AppString_method := %axis%DefaultMethod

	TApp_%axis%Method_ex := AppString_method

	if (SettingDeph > 0)
		and (AppString_exceptions <> "")
		and inStr(AppString_exceptions,  "<" . TConC)
		{
		RegExMatch(AppString_Exceptions, "i)\<" . TConC . "(\((?P<_method>[^\)]*)\))?(?P<_exceptions>[^\>]*)\>", ConCString)
		StringReplace, AppString_exceptions, AppString_exceptions, %ConCString%,, All

		if (ConCString_method = "")
			ConCString_method := AppString_method

		TApp_%axis%Method_ex := ConCString_method


		if (SettingDeph > 1)
			and (ConCString_exceptions <> "")
			and inStr(ConCString_exceptions, "[" . TConN)
			{
			RegExMatch(ConCString_Exceptions, "i)\[" . TConN . "\((?P<_method>[^\)]*)\)\]", ConNString)
			StringReplace, ConCString_exceptions, ConCString_exceptions, %ConNString%,, All

			if (ConNString_method = "")
				ConNString_method := ConCString_method

			TApp_%axis%Method_ex := ConNString_method
			}
		}
	}

ToolTip % TApp_%axis%Method_ex

if (TApp_%axis%Method_ex = 1) and (direction = -1)
	TApp_%axis%Method_new := "Off"
else if (TApp_%axis%Method_ex = %axis%MethodCount) and (direction = 1)
	TApp_%axis%Method_new := "Off"
else if (TApp_%axis%Method_ex = "Off")
	{
	if (direction = 1)
		TApp_%axis%Method_new := 1
	else if (direction = -1)
		TApp_%axis%Method_new := %axis%MethodCount
	}
else TApp_%axis%Method_new := TApp_%axis%Method_ex + direction

if (SettingDeph = 2)
	ConNString_method := TApp_%axis%Method_new
else if (SettingDeph = 1)
	ConCString_method := TApp_%axis%Method_new
else AppString_method := TApp_%axis%Method_new


if (SettingDeph > 1) and (ConNString_method <> ConCString_method)
	ConCString_exceptions := ConCString_exceptions . "[" . TConN . "(" . ConNString_method . ")]"

if (SettingDeph > 0)
	{
	if (ConCString_method <> AppString_method)
		AppString_exceptions := AppString_exceptions . "<" . TConC . "(" . ConCString_method . ")" . ConCString_exceptions . ">"
	else if (ConCString_exceptions <> "")
		AppString_exceptions := AppString_exceptions . "<" . TConC . ConCString_exceptions . ">"
	}

if (AppString_method <> %axis%DefaultMethod)
	AppSettings_%axis%Method := AppSettings_%axis%Method . "{" . TApp . "(" . AppString_method . ")" . AppString_exceptions . "}"
else if (AppString_exceptions <> "")
	AppSettings_%axis%Method := AppSettings_%axis%Method . "{" . TApp . AppString_exceptions . "}"

ToolTip, % TApp_%axis%Method_new

exWin4%axis% := "", exCon4%axis% := ""

SetTimer, SAVEtoFILE, %SAVEdelay%

return

SAVEtoFILE:
IniWrite, %AppSettings_vMethod%, %A_ScriptName%, AppMethodSettings, AppSettings_vMethod
IniWrite, %AppSettings_hMethod%, %A_ScriptName%, AppMethodSettings, AppSettings_hMethod
IniWrite, %AppSettings_fMethod%, %A_ScriptName%, AppMethodSettings, AppSettings_fMethod
ToolTip
return
