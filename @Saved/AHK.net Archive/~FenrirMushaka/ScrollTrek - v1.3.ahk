/*
Limited Support, Documentation and Changelog: http://www.autohotkey.com/forum/viewtopic.php?t=83794

File structure

Settings
	-ahk script setting
	-save setings
	-reverse scroll settings
	-defaults method settings
	-app method settings
	-method counters
	-static system variables

External app settings retrieval

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
*/

#SingleInstance force
#NoEnv
#InstallMouseHook
#UseHook
Critical
SendMode Input
CoordMode, Mouse, Screen
SetScrollLockState, off
SetWorkingDir %A_ScriptDir%

useExternalAppSettings := 0
extSAVEfilename := "ScrollTrekAppSettings.ini"
SAVEdelay := -2000

vReverse := 0
hReverse := 0
sReverse := 0		;use reverse settings above when using setting hotkeys too

vDefaultMethod := 1
hDefaultMethod := 1
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

vMethodCount := 7
hMethodCount := 7
fMethodCount := 2

WM_MOUSEWHEEL := 0x20A
WM_MOUSEHWHEEL := 0x20E
WM_HSCROLL := 0x114
WM_VSCROLL := 0x115
EM_LINESCROLL := 0xB6
WM_LBUTTONDOWN := 0x201
WM_LBUTTONUP := 0x202
WM_KEYDOWN := 0x0100
WM_KEYUP := 0x0101
VK_LEFT := 0x25
VK_UP := 0x26
VK_RIGHT := 0x27
VK_DOWN := 0x28

if useExternalAppSettings
	{
	iniRead, AppSettings_vMethod, %extSAVEfilename%, AppMethodSettings, AppSettings_vMethod, %AppSettings_vMethod%
	iniRead, AppSettings_hMethod, %extSAVEfilename%, AppMethodSettings, AppSettings_hMethod, %AppSettings_hMethod%
	iniRead, AppSettings_fMethod, %extSAVEfilename%, AppMethodSettings, AppSettings_fMethod, %AppSettings_fMethod%
	StringReplace, AppSettings_vMethod, AppSettings_vMethod, ERROR,, All
	StringReplace, AppSettings_hMethod, AppSettings_hMethod, ERROR,, All
	StringReplace, AppSettings_fMethod, AppSettings_fMethod, ERROR,, All
	gosub, SAVEtoFILE
	}

~ScrollLock::Suspend

#^+WheelUp::
axis := "v"
if (sReverse = 0) or (%axis%Reverse = 0)
	direction := 1
else
	direction := -1
SettingDeph := 2
gosub, TApp_Method_Settings
return

#^+WheelDown::
axis := "v"
if (sReverse = 0) or (%axis%Reverse = 0)
	direction := -1
else
	direction := 1
SettingDeph := 2
gosub, TApp_Method_Settings
return

#^+WheelRight::
axis := "h"
if (sReverse = 0) or (%axis%Reverse = 0)
	direction := 1
else
	direction := -1
SettingDeph := 2
gosub, TApp_Method_Settings
return

#^+WheelLeft::
axis := "h"
if (sReverse = 0) or (%axis%Reverse = 0)
	direction := -1
else
	direction := 1
SettingDeph := 2
gosub, TApp_Method_Settings
return

#^WheelUp::
axis := "v"
if (sReverse = 0) or (%axis%Reverse = 0)
	direction := 1
else
	direction := -1
SettingDeph := 1
gosub, TApp_Method_Settings
return

#^WheelDown::
axis := "v"
if (sReverse = 0) or (%axis%Reverse = 0)
	direction := -1
else
	direction := 1
SettingDeph := 1
gosub, TApp_Method_Settings
return

#^WheelRight::
axis := "h"
if (sReverse = 0) or (%axis%Reverse = 0)
	direction := 1
else
	direction := -1
SettingDeph := 1
gosub, TApp_Method_Settings
return

#^WheelLeft::
axis := "h"
if (sReverse = 0) or (%axis%Reverse = 0)
	direction := -1
else
	direction := 1
SettingDeph := 1
gosub, TApp_Method_Settings
return

#WheelUp::
axis := "v"
if (sReverse = 0) or (%axis%Reverse = 0)
	direction := 1
else
	direction := -1
SettingDeph := 0
gosub, TApp_Method_Settings
return

#WheelDown::
axis := "v"
if (sReverse = 0) or (%axis%Reverse = 0)
	direction := -1
else
	direction := 1
SettingDeph := 0
gosub, TApp_Method_Settings
return

#WheelRight::
axis := "h"
if (sReverse = 0) or (%axis%Reverse = 0)
	direction := 1
else
	direction := -1
SettingDeph := 0
gosub, TApp_Method_Settings
return

#WheelLeft::
axis := "h"
if (sReverse = 0) or (%axis%Reverse = 0)
	direction := -1
else
	direction := 1
SettingDeph := 0
gosub, TApp_Method_Settings
return

#+WheelUp::
axis := "f"
if (sReverse = 0) or (vReverse = 0)
	direction := 1
else
	direction := -1
SettingDeph := 0
gosub, TApp_Method_Settings
return

#+WheelDown::
axis := "f"
if (sReverse = 0) or (vReverse = 0)
	direction := -1
else
	direction := 1
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
if %axis%Reverse
	goto, ScrollDown
ScrollUp:
if (vMethod = "Off")
	Click, WheelUp
else if (vMethod = 1)
	PostMessage, WM_MOUSEWHEEL, 120 << 16, (mY << 16) | (mX & 0xFFFF), %TCon%, ahk_id%TWinID%
else if (vMethod = 2)
	ControlClick, %TCon%, ahk_id%TWinID%,, WheelUp, 1, NA
else if (vMethod = 3)
	PostMessage, WM_VSCROLL, 0, 0, %TCon%, ahk_id%TWinID%
else if (vMethod = 4)
	PostMessage, EM_LINESCROLL, 0, -1, %TCon%, ahk_id%TWinID%
else if (vMethod = 5) or (vMethod = 6)
	{
	if (mX <> exMx) or (mY <> exMy)
		{
		axis := "v"
		gosub, Get_SBar_Info
		}
	PostMessage, WM_LBUTTONDOWN,, (5 << 16) | 5, %VBarC%, ahk_id%TWinID%
	PostMessage, WM_LBUTTONUP,, (5 << 16) | 5, %VBarC%, ahk_id%TWinID%
	}
else if (vMethod = 7)
	{
	PostMessage, WM_KEYDOWN, VK_UP,, %TCon%, ahk_id%TWinID%
	PostMessage, WM_KEYUP, VK_UP,, %TCon%, ahk_id%TWinID%
	}
return

WheelDown::
MouseGetPos, mX, mY, TWinID, TCon
if (TWinID <> exWin4v) or (TCon <> exCon4v)
	{
	axis := "v"
	gosub, Set_Method
	}
if %axis%Reverse
	goto, ScrollUp
ScrollDown:
if (vMethod = "Off")
	Click, WheelDown
else if (vMethod = 1)
	PostMessage, WM_MOUSEWHEEL, -120 << 16, (mY << 16) | (mX & 0xFFFF), %TCon%, ahk_id%TWinID%
else if (vMethod = 2)
	ControlClick, %TCon%, ahk_id%TWinID%,, WheelDown, 1, NA
else if (vMethod = 3)
	PostMessage, WM_VSCROLL, 1, 0, %TCon%, ahk_id%TWinID%
else if (vMethod = 4)
	PostMessage, EM_LINESCROLL, 0, 1, %TCon%, ahk_id%TWinID%
else if (vMethod = 5) or (vMethod = 6)
	{
	if (mX <> exMx) or (mY <> exMy)
		{
		axis := "v"
		gosub, Get_SBar_Info
		}
	PostMessage, WM_LBUTTONDOWN,, ((VBarH - 5) << 16) | 5, %VBarC%, ahk_id%TWinID%
	PostMessage, WM_LBUTTONUP,, ((VBarH - 5) << 16) | 5, %VBarC%, ahk_id%TWinID%
	}
else if (vMethod = 7)
	{
	PostMessage, WM_KEYDOWN, VK_DOWN,, %TCon%, ahk_id%TWinID%
	PostMessage, WM_KEYUP, VK_DOWN,, %TCon%, ahk_id%TWinID%
	}
return

WheelLeft::
MouseGetPos, mX, mY, TWinID, TCon
if (TWinID <> exWin4h) or (TCon <> exCon4h)
	{
	axis := "h"
	gosub, Set_Method
	}
if %axis%Reverse
	goto, ScrollRight
ScrollLeft:
if (hMethod = "Off")
	Click, WheelLeft
else if (hMethod = 1)
	PostMessage, WM_MOUSEHWHEEL, -120 << 16, (mY << 16) | (mX & 0xFFFF), %TCon%, ahk_id%TWinID%
else if (hMethod = 2)
	ControlClick, %TCon%, ahk_id%TWinID%,, WheelLeft, 1, NA
else if (hMethod = 3)
	PostMessage, WM_HSCROLL, 0, 0, %TCon%, ahk_id%TWinID%
else if (hMethod = 4)
	PostMessage, EM_LINESCROLL, -1, 0, %TCon%, ahk_id%TWinID%
else if (hMethod = 5) or (hMethod = 6)
	{
	if (mX <> exMx) or (mY <> exMy)
		{
		axis := "h"
		gosub, Get_SBar_Info
		}
	PostMessage, WM_LBUTTONDOWN,, (5 << 16) | 5, %HBarC%, ahk_id%TWinID%
	PostMessage, WM_LBUTTONUP,, (5 << 16) | 5, %HBarC%, ahk_id%TWinID%
	}
else if (hMethod = 7)
	{
	PostMessage, WM_KEYDOWN, VK_LEFT,, %TCon%, ahk_id%TWinID%
	PostMessage, WM_KEYUP, VK_LEFT,, %TCon%, ahk_id%TWinID%
	}
return

WheelRight::
MouseGetPos, mX, mY, TWinID, TCon
if (TWinID <> exWin4h) or (TCon <> exCon4h)
	{
	axis := "h"
	gosub, Set_Method
	}
if %axis%Reverse
	goto, ScrollLeft
ScrollRight:
if (hMethod = "Off")
	Click, WheelRight
else if (hMethod = 1)
	PostMessage, WM_MOUSEHWHEEL, 120 << 16, (mY << 16) | (mX & 0xFFFF), %TCon%, ahk_id%TWinID%
else if (hMethod = 2)
	ControlClick, %TCon%, ahk_id%TWinID%,, WheelRight, 1, NA
else if (hMethod = 3)
	PostMessage, WM_HSCROLL, 1, 0, %TCon%, ahk_id%TWinID%
else if (hMethod = 4)
	PostMessage, EM_LINESCROLL, 1, 0, %TCon%, ahk_id%TWinID%
else if (hMethod = 5) or (hMethod = 6)
	{
	if (mX <> exMx) or (mY <> exMy)
		{
		axis := "h"
		gosub, Get_SBar_Info
		}
	PostMessage, WM_LBUTTONDOWN,, (5 << 16) | (HBarW - 5), %HBarC%, ahk_id%TWinID%
	PostMessage, WM_LBUTTONUP,, (5 << 16) | (HBarW - 5), %HBarC%, ahk_id%TWinID%
	}
else if (hMethod = 7)
	{
	PostMessage, WM_KEYDOWN, VK_RIGHT,, %TCon%, ahk_id%TWinID%
	PostMessage, WM_KEYUP, VK_RIGHT,, %TCon%, ahk_id%TWinID%
	}
return



Set_Method:

%axis%Method := %axis%DefaultMethod, fMethod := fDefaultMethod
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
	PostMessage, WM_LBUTTONDOWN,,, %TCon%, ahk_id%TWinID%
	PostMessage, WM_LBUTTONUP,,, %TCon%, ahk_id%TWinID%
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

setTimer, SAVEtoFILE, %SAVEdelay%

return

SAVEtoFILE:
iniWrite, %AppSettings_vMethod%, %A_ScriptName%, AppMethodSettings, AppSettings_vMethod
iniWrite, %AppSettings_hMethod%, %A_ScriptName%, AppMethodSettings, AppSettings_hMethod
iniWrite, %AppSettings_fMethod%, %A_ScriptName%, AppMethodSettings, AppSettings_fMethod
if useExternalAppSettings
	{
	iniWrite, %AppSettings_vMethod%, %extSAVEfilename%, AppMethodSettings, AppSettings_vMethod
	iniWrite, %AppSettings_hMethod%, %extSAVEfilename%, AppMethodSettings, AppSettings_hMethod
	iniWrite, %AppSettings_fMethod%, %extSAVEfilename%, AppMethodSettings, AppSettings_fMethod
	}
ToolTip
return
