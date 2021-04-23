/*  Automatically clicks Timers as they appear.
 *  
 *  License:
 *  	Timers v0.2 by Xander
 *  	GNU General Public License 3.0 or higher: http://www.gnu.org/licenses/gpl-3.0.txt
 */

; ( [] )..( [] )   Auto-Execute   ( [] )..( [] ) 

#NoEnv
#SingleInstance Force
#Include Includes/Functions.ahk
#Include Includes/Display.ahk
#Persistent
#NoTrayIcon

SetTitleMatchMode, 2
SysGet, Caption, 4
SysGet, Border, 45
SysGet, ResizeBorder, 32

FullTilt()
PokerStars()
SetTimer, CheckTimers, 5000

PartyPoker()
SetTimer, CheckPartyTimers, 1000

return ; End Auto-Execute

FullTilt() {
	global
	FullTilt_Time = FTCSkinButton19
	FullTilt_GameWindow = ahk_class FTC_TableViewFull
}

PartyPoker() {
	global
	PartyPoker_Time = AfxWnd42u37
	PartyPoker_GameWindow = Good Luck ahk_class #32770
}

PokerStars() {
	local theme
	IniRead, theme, PokerPad.ini, PokerStars, Theme, %A_Space%
	if !theme
		return
	PokerStars_GameWindow = ahk_class PokerStarsTableFrameClass
	IniRead, PokerStars_Time, PokerPad.ini, %theme%, Time, %A_Space%
	local w, h
	IniRead, w, PokerPad.ini, %theme%, Width, %A_Space%
	IniRead, h, PokerPad.ini, %theme%, Height, %A_Space%
	PokerStars_Time := CreateArea(PokerStars_Time, w, h)
	IniRead, PokerStars_ButtonColor, PokerPad.ini, %theme%, ButtonColor, %A_Space%
	IniRead, PokerStars_ButtonColorVariation, PokerPad.ini, %theme%, ButtonColorVariation, %A_Space%
}

CheckPartyTimers:
	Critical, On
	if PartyPoker_GameWindow {
		WinGet, Tables, List, %PartyPoker_GameWindow%
		Loop, %Tables% {
			ID := Tables%A_Index%
			if IsControlVisible(PartyPoker_Time, ID)
				ClickControl(PartyPoker_Time, ID)
		}
	}
	return
	
CheckTimers:
	Critical, On
	if FullTilt_GameWindow {
		WinGet, Tables, List, %FullTilt_GameWindow%
		Loop, %Tables% {
			ID := Tables%A_Index%
			if IsControlVisible(FullTilt_Time, ID)
				ClickControl(FullTilt_Time, ID)
		}
	}
	if PokerStars_GameWindow {
		WinGet, Tables, List, %PokerStars_GameWindow%
		Loop, %Tables% {
			ID := Tables%A_Index%
			Display_CreateWindowCapture(ID, Device, Context, Pixels)
			GetWindowArea(X, Y, W, H, PokerStars_Time, true, ID)
			X += Floor(W/2)
			RGB := Display_GetPixel(Context, X, Y)
			if Display_CompareColors(RGB, PokerStars_ButtonColor, PokerStars_ButtonColorVariation)
				ClickWindowArea(PokerStars_Time, true, ID)
			Display_DeleteWindowCapture(Device, Context, Pixels)
		}
	}
	return

