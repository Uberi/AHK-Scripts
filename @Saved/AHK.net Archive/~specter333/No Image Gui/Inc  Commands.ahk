;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;              Command Section             ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;    Add new G-Labels to bottom of page.   ;;;;;;;;;;;;;;;;;;;;;

IfWinNotExist, %GuiName% ahk_class AutoHotkeyGUI ;;  Keeps this page from running
	{                                            ;;  on it's own. 
	Gui, Destroy
	ExitApp
	}

WM_LBUTTONDOWN()
	{
	GuiControl, 85:, Text85, %A_Gui%
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Do Not Trans List - These Guis are not "WinSet, Transparent" when clicked ;;;;;
	DoNotTrans = 23, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 53, 78, 79, 80, 81, 82, 83, 84, 85, 90, 91, 92, 93, 97, 98
;;;;; Guis listed here activate their associated G-Label on "Left Button Down". ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	IfInString, DoNotTrans, %A_Gui% 
		{
		Label = Area%A_Gui%
		If IsLabel(Label)
			Gosub, %Label%
		Return
		}
	WinSet, Transparent, 200, Area%A_Gui%
	GuiControl, 1:, ControlNumber, Area%A_Gui%
	;GuiControl, 85:, Text85, %A_Gui%
	}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Guis not in the Do Not Trans list activate their G-Label on "Left Button Up". ;;;
WM_LBUTTONUP()
	{
	ControlGetText, OverArea, Edit1, Non Image - Image Gui, 
	If OverArea = %DoNotTrans%
		Return
	If OverArea != Area%A_Gui%
		{
		WinSet, Transparent, 255, %OverArea%
		Return
		}
	If IsLabel(OverArea)
		Gosub, %OverArea%
	Else WinSet, Transparent, 255, %OverArea%
	}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;            G-Labels are the term "Area" plus the Gui Number.            ;;;;;
;;;  All guis whether in the "Do Not Trans" list or not may be given a G-Label  ;;;
;;;           however a G-Label is not required for every gui/control.          ;;;
Area21:
Reload
Return
Area33:
WinSet, Transparent, 255, Area33
SoundSet, +1, MASTER , Mute
GoSub GetMutes
Return
Area34:
WinSet, Transparent, 255, Area34
SoundSet, +1, WAVE , Mute
GoSub GetMutes
Return
Area35:
WinSet, Transparent, 255, Area35
SoundSet, +1, LINE , Mute
GoSub GetMutes
Return
Area36:
WinSet, Transparent, 255, Area36
SoundSet, +1, MICROPHONE , Mute
GoSub GetMutes
Return
Area37:
WinSet, Transparent, 255, Area37
SoundSet, +1, CD , Mute
GoSub GetMutes
Return
Area51:
Gui, 51:Color, c45b58
Sleep, 250
WinActivate, %GuiName%
PostMessage, 0xA1, 2,,, A 
Loop, 
	{
	KeyIsDown := GetKeyState("LButton")
	If KeyIsDown = 1
		Sleep, 50
	If KeyIsDown = 0
		Break
	}
Gui, 51:Color, fe9d00
Return
Area22:
WinSet, Transparent, 255, Area22
Run, C:\Program Files\AutoHotkey\AutoHotkey.chm 
Return
Area23:
GoSub GetNum
If rand = %OldNum%
	GoSub GetNum
If rand = 1
	Change = ffcc66
If rand = 2 
	Change = c45b58
If rand = 3 
	Change = fe9d00
If rand = 4 
	Change = cd9bd0
If rand = 5 
	Change = 9d9dff
Gui, 23:Color, %Change%
GuiControl, 23:, Text23, %Change%
OldNum = %rand%
Return

GetNum:
Random, rand, 1, 5
Return

Area52:
Gui, 52:Color, c45b58
Sleep, 250
Gui, 1:Destroy
ExitApp
Return

Area57:
WinSet, Transparent, 255, Area57
Return

Return
Area70:
WinSet, Transparent, 255, Area70
IfWinExist, Area73
	GoSub P2ButtonsOut
IfWinExist, Area21
	Return
IfWinExist, Area33
	GoSub AudioRemove
GoSub P1ButtonsIn
Return

Area71:
WinSet, Transparent, 255, Area71
IfWinExist, Area73
	Return
IfWinExist, Area21
	GoSub P1ButtonsOut
IfWinExist, Area33
	GoSub AudioRemove
GoSub P2ButtonsShow
Return

Area72:
WinSet, Transparent, 255, Area72
IfWinExist, Area73
	GoSub P2ButtonsOut
IfWinExist, Area33
	Return
IfWinExist, Area21
	GoSub P1ButtonsOut

GoSub ShowAudioControls
Return

Area97:
Area98:
Area99:
WinSet, Transparent, 255, Area99
Return

Area54:
WinSet, Transparent, 255, Area54
SoundPlay, C:\WINDOWS\Media\notify.wav
Return
Area55:
WinSet, Transparent, 255, Area55
SoundPlay, C:\WINDOWS\Media\tada.wav
Return
Area56:
WinSet, Transparent, 255, Area56
SoundPlay, C:\WINDOWS\Media\Windows XP Logoff Sound.wav
Return
Area69:
WinSet, Transparent, 255, Area69
SoundPlay, C:\WINDOWS\Media\Windows XP Logon Sound.wav
Return
Area24:
WinSet, Transparent, 255, Area24
Run, C:\Program Files\Mozilla Firefox\firefox.exe
Return
Area25:
WinSet, Transparent, 255, Area25
Run, http://www.autohotkey.com/forum/
Return
