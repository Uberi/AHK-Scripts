/*
AnimatedSplashScreens.ahk

Fancy animations to make the user to patient
(kind of infinite progress bar, replacement for AVI animations).

// by Philippe Lhoste <PhiLho(a)GMX.net> http://Phi.Lho.free.fr
// File/Project history:
 1.02.000 -- 2006/06/13 (PL) -- Added other effects: HorizontalMarquee, VerticalMarquee, Zoom, RandomZoom.
 1.01.000 -- 2006/06/12 (PL) -- Refactoring to make an ASS_effect framework.
 1.00.000 -- 2006/06/09 (PL) -- Falldown effect. http://www.autohotkey.com/forum/viewtopic.php?t=10366
*/
/* Copyright notice: See the PhiLhoSoftLicence.txt file for details.
This file is distributed under the zlib/libpng license.
Copyright (c) 2006 Philippe Lhoste / PhiLhoSoft
*/
#NoEnv	; Recommended for performance and compatibility with future AutoHotkey releases.

; User defined parameters
; Leave them as is, or set them after #Including this file
#ASSP_message = RUNNING, WAIT PLEASE!
#ASSP_backColor = 0x200050
#ASSP_backTrans = 128
#ASSP_fontColor = Lime
#ASSP_fontSize = 48
#ASSP_guiNb = 66
#ASSP_speed = 700

; List of effects
ASS_effect?1 = HorizontalMarquee
ASS_effect?2 = VerticalMarquee
ASS_effect?3 = FallDown
ASS_effect?4 = Zoom
ASS_effect?5 = RandomZoom

; Some test script, run only if the file is ran standalone
If (A_ScriptName != "AnimatedSplashScreens.ahk")
	Goto ASS=>ContinueAutoExec

ASS_scriptName = Animated Splash Screens

; Demo GUI
Gui Add, Radio, vrbEffect Checked x120 y20, Horizontal Marquee
Gui Add, Radio, , Vertical Marquee
Gui Add, Radio, , Falldown
Gui Add, Radio, , Zoom
Gui Add, Radio, , RandomZoom

Gui Add, Button, gASSShow w150 x20 y+20, Run long process
Gui Add, Button, gASSEnd x+20 w150, End of demo

Gui Show, , %ASS_scriptName%
Return

Escape::
	IfWinActive %ASS_scriptName%
		ExitApp

	Gui %#ASSP_guiNb%:Destroy
	SetTimer %#ASSP_effect%//Animate, Off
	Gui Show
Return

ASSEnd:
;~ GuiClose:
	ExitApp

ASSShow:
	Gui Submit
	#ASSP_effect := ASS_effect?%rbEffect%


Run_ASS:
;~	SetBatchLines -1

	#ASSP_messageLength := StrLen(#ASSP_message)

	Gosub SetUpGUI
	Gosub %#ASSP_effect%//DisplayMessage
	Gosub DisplayGUI
	SetTimer %#ASSP_effect%//Animate, 700 ; %#ASSP_speed%
Return

SetUpGUI:
	Gui %#ASSP_guiNb%:+ToolWindow +AlwaysOnTop +Disable -SysMenu -Caption
	Gui %#ASSP_guiNb%:Color, %#ASSP_backColor%
	; Proportional fonts aren't nice with most effects
	Gui %#ASSP_guiNb%:Font, s%#ASSP_fontSize%, Courier New
	Gui %#ASSP_guiNb%:Font, , Andale Mono
;~	Gui %#ASSP_guiNb%:Add, Text, vDebug x10 y800, ?                             ?
Return

DisplayGUI:
	Gui %#ASSP_guiNb%:+LastFound
	WinSet, Transparent, %#ASSP_backTrans%
	Gui %#ASSP_guiNb%:Show, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight%, Splash
Return

;===== Horizontal Marquee =====

HorizontalMarquee//DisplayMessage:

	ASS_initialXPos := A_ScreenWidth - #ASSP_fontSize * 1.27
	ASS_xPos := ASS_initialXPos
	ASS_yPos := (A_ScreenHeight - #ASSP_fontSize * 1.27) / 2
	ASS_speed := 100

	Gui %#ASSP_guiNb%:Add, Text
			, vASS_ctrl c%#ASSP_fontColor% x%ASS_xPos% y%ASS_yPos%
			, %#ASSP_message%
	GuiControlGet ASS_pos, %#ASSP_guiNb%:Pos, ASS_ctrl
Return

HorizontalMarquee//Animate:

	ASS_xPos -= ASS_speed
	If (ASS_xPos < -ASS_posW)
	{
		ASS_xPos := ASS_initialXPos
	}
	GuiControl %#ASSP_guiNb%:Move, ASS_ctrl, x%ASS_xPos% y%ASS_yPos%
Return

;===== Vertical Marquee =====

VerticalMarquee//DisplayMessage:

	ASS_xPos := 200
	ASS_initialYPos := 20
	ASS_yPos := ASS_initialYPos
	ASS_speed := 10

	Gui %#ASSP_guiNb%:Add, Text
			, vASS_ctrl c%#ASSP_fontColor% x%ASS_xPos% y%ASS_yPos%
			, %#ASSP_message%
Return

VerticalMarquee//Animate:

	ASS_yPos += ASS_speed
	If (ASS_yPos > A_ScreenHeight)
	{
		ASS_yPos := ASS_initialYPos
	}
	GuiControl %#ASSP_guiNb%:Move, ASS_ctrl, x%ASS_xPos% y%ASS_yPos%
Return


;===== Falldown =====

Falldown//DisplayMessage:

	ASS_xMargin := 50
	ASS_initialYPos := 20
	ASS_charW := (A_ScreenWidth - 3 * ASS_xMargin) / #ASSP_messageLength

	Loop Parse, #ASSP_message
	{
		ASS_xPos := ASS_xMargin + ASS_charW * A_Index
		ASS_xPos%A_Index% := ASS_xPos
		ASS_yPos%A_Index% := ASS_initialYPos
		Gui %#ASSP_guiNb%:Add, Text
				, vASS_ctrl%A_Index% c%#ASSP_fontColor% x%ASS_xPos% y%ASS_initialYPos%
				, %A_LoopField%
	}
Return

Falldown//Animate:

	ASS_yMin := 0
	Loop %#ASSP_messageLength%
	{
		Random ASS_rnd, 5, 20
	;~ 		Random ASS_rnd, 20, 100	; Much faster, for tests...
		ASS_yPos%A_Index% += ASS_rnd
		If (ASS_yPos%A_Index% > ASS_yMin)
			ASS_yMin := ASS_yPos
	}
	Gosub Falldown//MoveControls
	If (ASS_yMin > A_ScreenHeight)
	{
		Loop %#ASSP_messageLength%
		{
			ASS_yPos%A_Index% := ASS_initialYPos
		}
		ASS_yMin := 0
	}
	Gosub Falldown//MoveControls
Return

Falldown//MoveControls:

	Loop %#ASSP_messageLength%
	{
		ASS_xPos := ASS_xPos%A_Index%
		ASS_yPos := ASS_yPos%A_Index%
		GuiControl %#ASSP_guiNb%:Move, ASS_ctrl%A_Index%, x%ASS_xPos% y%ASS_yPos%
	}
Return


;===== Zoom =====

Zoom//DisplayMessage:

	ASS_xMargin := 50
	ASS_initialYPos := (A_ScreenHeight - #ASSP_fontSize * 1.27) / 2
	ASS_charW := (A_ScreenWidth - 3 * ASS_xMargin) / #ASSP_messageLength
	ASS_sizeDelta := -3
	ASS_size := #ASSP_fontSize

	Loop Parse, #ASSP_message
	{
		ASS_xPos := ASS_xMargin + ASS_charW * A_Index
		Gui %#ASSP_guiNb%:Add, Text
				, vp%A_Index% c%#ASSP_fontColor% x%ASS_xPos% y%ASS_initialYPos%
				, %A_LoopField%
	}
Return

Zoom//Animate:

	ASS_size += ASS_sizeDelta
	If (ASS_size >= #ASSP_fontSize || ASS_size <= 3 * Abs(ASS_sizeDelta))
		ASS_sizeDelta := -ASS_sizeDelta
	Loop %#ASSP_messageLength%
	{
		Gui %#ASSP_guiNb%:Font, s%ASS_size% c%#ASSP_fontColor%
		GuiControl %#ASSP_guiNb%:Font, p%A_Index%
	}
Return


;===== Random Zoom =====

RandomZoom//DisplayMessage:

	Gosub Zoom//DisplayMessage
	Loop %#ASSP_messageLength%
	{
		Random ASS_rnd, 3, 9
		ASS_sizeDelta%A_Index% := -ASS_rnd
		ASS_size%A_Index% := #ASSP_fontSize
	}
Return

RandomZoom//Animate:

	Loop %#ASSP_messageLength%
	{
		; Increment or decrement size of this letter
		ASS_size := ASS_size%A_Index% + ASS_sizeDelta%A_Index%
		; Too big or too small?
		If (ASS_size > #ASSP_fontSize || ASS_size < 8)
		{
			; Restore previous size
			ASS_size := ASS_size%A_Index% - ASS_sizeDelta%A_Index%
			; Choose another increment
			Random ASS_rnd, 3, 9
			; Revert the size change sense
			If (ASS_sizeDelta%A_Index% < 0)
				ASS_sizeDelta%A_Index% := ASS_rnd
			Else
				ASS_sizeDelta%A_Index% := -ASS_rnd
			; New size
			ASS_size := ASS_size%A_Index% + ASS_sizeDelta%A_Index%
		}
		; Update letter size
		ASS_size%A_Index% := ASS_size
		Gui %#ASSP_guiNb%:Font, s%ASS_size% c%#ASSP_fontColor%
		GuiControl %#ASSP_guiNb%:Font, p%A_Index%
	}
Return

ASS=>ContinueAutoExec: