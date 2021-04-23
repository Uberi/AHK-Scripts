; "Fitatrak.ahk"
; Author: Jud Hardcastle
; Written: Jan 2006
; Updated: see *Version* on Menu stmt below

/* 
Script Function: 
Popsup the Fitaly on-screen keyboard whenever mouse hovers over TIP icon.
Hides the Fitaly keyboard when the TIP icon leaves.OR if the user brings
up the full TIP keyboard. Moves the Fitaly keyboard as close to the TIP 
icon as possible, either above or below as needed. Once up, Fitaly will
stay stationary horizontally until the TIP icon leaves the screen--user 
can force the Fitaly window to shift closer to caret by re-hovering mouse
over TIP icon.  If the TIP icon moves up or down, such as when the caret 
moves to a new line in an edited document, then move Fitaly vertically.
*/

CoordMode, Caret, Screen
#SingleInstance Force
OnExit, ExitSub
Menu, Tray, Icon, %A_WinDir%\system32\Shell32.dll, 134
Menu, Tray, Tip, FitaTrak V200905A ;*Version*

FitMWC := ""
New_CaretX := -1
GoSub RunFitaly
WinHide, ahk_class %FitMWC%
X_FitUp := 0

Save_CaretX := A_CaretX

Loop
{
	; Check if a TIP icon or window is being displayed, ie text input
	; field selected and stylus is near screen
	If WinExist("ahk_class IPTip_Main_Window")
	{
		WinGetPos, TipX, TipY, TipW, TipH, ahk_class IPTip_Main_Window
		
		; Main TIP keyboard is up, dont put up Fitaly
		IfGreater, TipH, 50
		{
			WinHide, ahk_class %FitMWC%
			X_FitUp := 0
			Sleep,500
			Continue
		}
		
		; If Mouse is over TIP then user either wants Fitaly to come up
		;   Or wants Fitaly to shift closer to caret
		; If Mouse isnt over TIP icon user doesnt want Fitaly
		;   Or Fitaly is already up
		MouseGetPos, ,,MouseWID
		WinGetClass, MouseWCL, ahk_id %MouseWID%
		IfEqual,MouseWCL,IPTip_Main_Window	
			X_FitUp := 0  ;need new horizontal position
		Else
		{
			IfEqual,X_FitUp,0
			{
				Sleep, 100
				Continue
			}
			Else
			{
				; Fitaly up, only if Tip moved up or down then move Fitaly
				;IfEqual,TipY,%Save_TipY%
				TDiff := TipY - Save_TipY
				TMax := TipH * 3
					;msgbox,%tdiff%
				IfLess,TDiff,%TMax%
				{
					; Location ok, faster loop to force on top of dropdowns
					WinSet, AlwaysOnTop, ON, ahk_class %FitMWC%
					Sleep, 30
					Continue
				}
			}	
		}
		
		; Fitaly not up (or mouse over tip), calculate new horizontal position
		; If Fitaly is up, use current horizontal position
		IfEqual,X_FitUp,0
		{
		
			; Start Fitaly a bit left of current caret
			Save_CaretX := A_CaretX - 100
			;Save_CaretX := TipX + TipW + 2
		
			; If caret is off screen left force it to zero  				
	  		IfLess,Save_CaretX,0
				Save_CaretX := 0
			
			; If off right side of screen shift left as needed
			SysGet, Mon1, MonitorWorkArea 
	  		NewRight := Save_CaretX + FitW
	  		IfGreater,NewRight,%Mon1Right%
  				Save_CaretX := Mon1Right - FitW - 5
  			New_CaretX := Save_CaretX		
  		}
  		Else
  		{
  			WinGetPos, FitX, FitY, FitW, FitH, ahk_class %FitMWC%
  			New_CaretX := FitX
  		}
		
		; Fitaly up or down, base vertical position on TIP icon
		; Put Fitaly just below Tip if Tip below Cursor else just above Tip
		Save_TipY := TipY
		New_CaretY := (A_CaretY - FitH - 5)	
		IfLess,TipY,%A_CaretY%
		{
		  New_CaretX := (TipX + TipW + 5)
			New_CaretY := (TipY - FitH - 5)
		}
		
		IfLess,New_CaretY,0
		{
			New_CaretY := (TipY + FitH - 5)
			New_CaretY := (TipY + TipH + 5)
    }	

		; Display Fitaly and move to new position
		GoSub RunFitaly
		WinSet, AlwaysOnTop, ON, ahk_class %FitMWC%
	}
	Else
	{
		; Tip not up, hide Fitaly until needed
		IfEqual,X_FitUp,1
		{
			; Short delay b4 hiding F in case user continues
			Sleep, 1200
			IfWinNotExist,ahk_class IPTip_Main_Window
			{
				WinHide, ahk_class %FitMWC%
				X_FitUp := 0
			}
		}
	}
	; Wait for change
	sleep, 500
}
Exit

ExitSub:
; unhide Fitaly before leaving, wont be usable otherwise
WinShow, ahk_class %FitMWC% 
ExitApp 

RunFitaly:
; Display Fitaly keyboard, Start Fitaly if not running
DetectHiddenWindows, On

; Was Fitaly running outside script, if so get Class
If FitMWC = 
{
	WinGet, id, list, Fitaly
	Loop, %id%
	{
    temp_id := id%A_Index%
    WinGetClass, temp_class, ahk_id %temp_id%
    IfInString, temp_class, FitalyMainWindow
		{
    	FitMWC = %temp_class%
    	break
		}
	}
}

; If Fitaly not running, start it
IfWinNotExist, ahk_class %FitMWC%
{
	RegRead, FitDir, HKEY_CURRENT_USER, SOFTWARE\Textware Solutions\Fitaly, Installation directory
	if ErrorLevel   
	{
		MsgBox, Error locating Fitaly Installation directory, Terminating script.
		ExitApp
	}
	IfExist, %FitDir%\Fitaly.exe
	  FitExe := "Fitaly.exe"
  Else
  {
  	IfExist, %FitDir%\Fitaly2005.exe
  	  FitExe := "Fitaly2005.exe"
  	Else
		{
  		Msgbox, Error locating Fitaly EXE file, Terminating script.
  		ExitApp
		}
	}
	Run, %FitExe%, %FitDir%
	Loop
	{
		Sleep, 1000
		WinGet, id, list, Fitaly
		Loop, %id%
		{
    	temp_id := id%A_Index%
    	WinGetClass, temp_class, ahk_id %temp_id%
    	IfInString, temp_class, FitalyMainWindow
			{
    		FitMWC = %temp_class%
    		break
			}
		}
		IfWinExist, ahk_class %FitMWC%
			Break
		IfGreater, A_Index, 60
		{
			MsgBox, Error starting Fitaly, Terminating script
			ExitApp
		}
	}
}
IfGreater,New_CaretX,-1 
	WinMove, ahk_class %FitMWC%, ,New_CaretX, New_CaretY
DetectHiddenWindows, Off
WinRestore, ahk_class %FitMWC%
WinShow, ahk_class %FitMWC%
WinGetPos, FitX, FitY, FitW, FitH, ahk_class %FitMWC%
X_FitUp := 1
Return
