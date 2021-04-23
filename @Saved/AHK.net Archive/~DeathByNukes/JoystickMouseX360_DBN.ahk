#NoEnv
Menu, Tray, Icon, %A_WinDir%\system32\joy.cpl
Menu, Tray, Tip, Xbox 360 Controller

; Using a Joystick as a Mouse
; http://www.autohotkey.com
; This script converts a joystick into a three-button mouse.  It allows each
; button to drag just like a mouse button and it uses virtually no CPU time.
; Also, it will move the cursor faster depending on how far you push the joystick
; from center. You can personalize various settings at the top of the script.

; Increase the following value to make the mouse cursor move faster:
JoyMultiplier = 0.10
Joy2Multiplier = 0.40

; Decrease the following value to require less joystick displacement-from-center
; to start moving the mouse.  However, you may need to calibrate your joystick
; -- ensuring it's properly centered -- to avoid cursor drift. A perfectly tight
; and centered joystick could use a value of 1:
JoyThreshold = 7
Joy2Threshold = 7

; Change the following to true to invert the Y-axis, which causes the mouse to
; move vertically in the direction opposite the stick:
InvertYAxis := false

;
VolMultiplier = 0.05
VolThreshold = 0
VolInvert := true

; Change these values to use joystick button numbers other than 1, 2, and 3 for
; the left, right, and middle mouse buttons.  Available numbers are 1 through 32.
; Use the Joystick Test Script to find out your joystick's numbers more easily.
ButtonLeft = 6
ButtonRight = 10
ButtonMiddle = 7

; Custom Buttons

Button1 = Media_Play_Pause
Button2 = Media_Next
Button3 = Media_Prev
Button4 = Media_Stop
Button5 = Tab
Button6 = ;mouse
Button7 = ;mouse
Button8 = Launch_Media
Button9 = Enter
Button10 = ;mouse

; If your joystick has a POV control, you can use it as a mouse wheel.  The
; following value is the number of milliseconds between turns of the wheel.
; Decrease it to have the wheel turn faster:
WheelDelay = Off ;250

; If your system has more than one joystick, increase this value to use a joystick
; other than the first:
JoystickNumber = 1

; END OF CONFIG SECTION -- Don't change anything below this point unless you want
; to alter the basic nature of the script.

#SingleInstance

JoystickPrefix = %JoystickNumber%Joy
Hotkey, %JoystickPrefix%%ButtonLeft%, ButtonLeft
Hotkey, %JoystickPrefix%%ButtonRight%, ButtonRight
Hotkey, %JoystickPrefix%%ButtonMiddle%, ButtonMiddle

Loop, 32
{
	if ( Button%A_Index% != "" )
		Hotkey, %JoystickPrefix%%A_Index%, JoyButton
}

SetTimer, WatchPOV, 5

SetTimer, CheckFreeze, 750

; Calculate the axis displacements that are needed to start moving the cursor:
JoyThresholdUpper := 50 + JoyThreshold
JoyThresholdLower := 50 - JoyThreshold
Joy2ThresholdUpper := 50 + Joy2Threshold
Joy2ThresholdLower := 50 - Joy2Threshold
VolThresholdUpper := 50 + VolThreshold
VolThresholdLower := 50 - VolThreshold
if InvertYAxis
	YAxisMultiplier = -1
else
	YAxisMultiplier = 1

if VolInvert
	VolAxisMultiplier = -1
else
	VolAxisMultiplier = 1

SetTimer, WatchJoystick, 10  ; Monitor the movement of the joystick.

GetKeyState, JoyInfo, %JoystickNumber%JoyInfo
IfInString, JoyInfo, P  ; Joystick has POV control, so use it as a mouse wheel.
	SetTimer, MouseWheel, %WheelDelay%

return  ; End of auto-execute section.


CheckFreeze:
IfExist, C:\A_DBN_FREEZEALLINPUT
	Frozen := true
else
	Frozen := false
return


; Thanks to Freighter for this code
JoyButton:
If Frozen
	return

StringTrimLeft, BN, A_ThisHotKey, 4
KeyToSend := Button%BN%
Send {%KeyToSend% Down}
KeyWait %A_ThisHotKey%
Send {%KeyToSend% up}
Return


; Thanks to Chris for this code
WatchPOV:
If Frozen
	return

GetKeyState, POV, JoyPOV  ; Get position of the POV control.
KeyToHoldDownPrev = %KeyToHoldDown%  ; Prev now holds the key that was down before (if any).

; Some joysticks might have a smooth/continous POV rather than one in fixed increments.
; To support them all, use a range:
if POV < 0   ; No angle to report
   KeyToHoldDown =
else if POV > 31500                 ; 315 to 360 degrees: Forward
   KeyToHoldDown = Up
else if POV between 0 and 4500      ; 0 to 45 degrees: Forward
   KeyToHoldDown = Up
else if POV between 4501 and 13500  ; 45 to 135 degrees: Right
   KeyToHoldDown = Right
else if POV between 13501 and 22500 ; 135 to 225 degrees: Down
   KeyToHoldDown = Down
else                                ; 225 to 315 degrees: Left
   KeyToHoldDown = Left

if KeyToHoldDown = %KeyToHoldDownPrev%  ; The correct key is already down
   return  ; Do nothing.

; Otherwise, release the previous key and press down the new key:
SetKeyDelay -1  ; Avoid delays between keystrokes.
if KeyToHoldDownPrev <>   ; There is a previous key to release.
   Send, {%KeyToHoldDownPrev% up}  ; Release it.
if KeyToHoldDown <>   ; There is a key to press down.
   Send, {%KeyToHoldDown% down}  ; Press it down.
return


; The subroutines below do not use KeyWait because that would sometimes trap the
; WatchJoystick quasi-thread beneath the wait-for-button-up thread, which would
; effectively prevent mouse-dragging with the joystick.

ButtonLeft:
If Frozen
	return

SetMouseDelay, -1  ; Makes movement smoother.
MouseClick, left,,, 1, 0, D  ; Hold down the left mouse button.
SetTimer, WaitForLeftButtonUp, 10
return

ButtonRight:
If Frozen
	return

SetMouseDelay, -1  ; Makes movement smoother.
MouseClick, right,,, 1, 0, D  ; Hold down the right mouse button.
SetTimer, WaitForRightButtonUp, 10
return

ButtonMiddle:
If Frozen
	return

SetMouseDelay, -1  ; Makes movement smoother.
MouseClick, middle,,, 1, 0, D  ; Hold down the right mouse button.
SetTimer, WaitForMiddleButtonUp, 10
return

WaitForLeftButtonUp:
if GetKeyState(JoystickPrefix . ButtonLeft)
	return  ; The button is still, down, so keep waiting.
; Otherwise, the button has been released.
SetTimer, WaitForLeftButtonUp, off
SetMouseDelay, -1  ; Makes movement smoother.
MouseClick, left,,, 1, 0, U  ; Release the mouse button.
return

WaitForRightButtonUp:
if GetKeyState(JoystickPrefix . ButtonRight)
	return  ; The button is still, down, so keep waiting.
; Otherwise, the button has been released.
SetTimer, WaitForRightButtonUp, off
MouseClick, right,,, 1, 0, U  ; Release the mouse button.
return

WaitForMiddleButtonUp:
if GetKeyState(JoystickPrefix . ButtonMiddle)
	return  ; The button is still, down, so keep waiting.
; Otherwise, the button has been released.
SetTimer, WaitForMiddleButtonUp, off
MouseClick, middle,,, 1, 0, U  ; Release the mouse button.
return

WatchJoystick:
If Frozen
	return

MouseNeedsToBeMoved := false  ; Set default.
SetFormat, float, 03
GetKeyState, joyx, %JoystickNumber%JoyX
GetKeyState, joyy, %JoystickNumber%JoyY
if joyx > %JoyThresholdUpper%
{
	MouseNeedsToBeMoved := true
	DeltaX := joyx - JoyThresholdUpper
}
else if joyx < %JoyThresholdLower%
{
	MouseNeedsToBeMoved := true
	DeltaX := joyx - JoyThresholdLower
}
else
	DeltaX = 0
if joyy > %JoyThresholdUpper%
{
	MouseNeedsToBeMoved := true
	DeltaY := joyy - JoyThresholdUpper
}
else if joyy < %JoyThresholdLower%
{
	MouseNeedsToBeMoved := true
	DeltaY := joyy - JoyThresholdLower
}
else
	DeltaY = 0
if MouseNeedsToBeMoved
{
	SetMouseDelay, -1  ; Makes movement smoother.
	MouseMove, DeltaX * JoyMultiplier, DeltaY * JoyMultiplier * YAxisMultiplier, 0, R
}

; Edit - 2nd stick
MouseNeedsToBeMoved := false  ; Set default.
GetKeyState, joyx, %JoystickNumber%JoyU
GetKeyState, joyy, %JoystickNumber%JoyR
if joyx > %Joy2ThresholdUpper%
{
	MouseNeedsToBeMoved := true
	DeltaX := joyx - Joy2ThresholdUpper
}
else if joyx < %JoyThresholdLower%
{
	MouseNeedsToBeMoved := true
	DeltaX := joyx - Joy2ThresholdLower
}
else
	DeltaX = 0
if joyy > %Joy2ThresholdUpper%
{
	MouseNeedsToBeMoved := true
	DeltaY := joyy - Joy2ThresholdUpper
}
else if joyy < %JoyThresholdLower%
{
	MouseNeedsToBeMoved := true
	DeltaY := joyy - Joy2ThresholdLower
}
else
	DeltaY = 0
if MouseNeedsToBeMoved
{
	SetMouseDelay, -1  ; Makes movement smoother.
	MouseMove, DeltaX * Joy2Multiplier, DeltaY * Joy2Multiplier * YAxisMultiplier, 0, R
}

; Edit - volume
MouseNeedsToBeMoved := false  ; Set default.
GetKeyState, joyx, %JoystickNumber%JoyZ
if joyx > %VolThresholdUpper%
{
	MouseNeedsToBeMoved := true
	DeltaX := joyx - VolThresholdUpper
}
else if joyx < %VolThresholdLower%
{
	MouseNeedsToBeMoved := true
	DeltaX := joyx - VolThresholdLower
}
else
	DeltaX = 0

if MouseNeedsToBeMoved && DeltaX
{
	SoundGet, Volume
	SoundSet, Volume + DeltaX * VolMultiplier * VolAxisMultiplier
}
return

MouseWheel:
If Frozen
	return

GetKeyState, JoyPOV, %JoystickNumber%JoyPOV
if ( JoyPOV = -1 || JoyPOV = "" )  ; No angle.
	return
if (JoyPOV > 31500 or JoyPOV < 4500)  ; Forward
	Send {WheelUp}
else if JoyPOV between 13500 and 22500  ; Back
	Send {WheelDown}
return


;Media button runs WMP and toggles minimization if it is already open.
Launch_Media::


Process, Exist, wmplayer.exe
WMP_Exist = %ErrorLevel%  ; Save the value immediately since ErrorLevel is often changed.
if WMP_Exist = 0 ;if the process is not running
	Run, "%ProgramFiles%\Windows Media Player\wmplayer.exe"
else
{
	IfWinExist, Windows Media Player ;If the process is running but the window is not, it is in toolbar mode.
	{
		WinGet, wmp_state, MinMax, Windows Media Player

		if (wmp_state = -1)
			WinRestore, Windows Media Player
		else
		{
			WinMinimize, Windows Media Player
			If ErrorLevel
				Msgbox, %errorlevel%
		}
	}
	else
	{
		Send, !+P ; Built in shortcut to restore WMP!
	}
}

return


!Launch_Media::
DetectHiddenWindows, On
WinClose, Windows Media Player
Process, WaitClose, wmplayer.exe, 30
if ( errorlevel != 0 )
{
	MsgBox, 19, Hotkey Script, Windows Media Player failed to close! If it appeared to close normally, it is invisible and can be retrieved by pressing cancel. Do you wish to force Media Player to close? (Media Player will disable 3rd party plugins upon restart.), 20  ; Options: 3 + 16

	IfMsgBox, No
		return

	IfMsgBox, Cancel
	{
		Send, !+P
		return
	}

	; Yes or TIMEOUT
	Process, Close, wmplayer.exe
}
return
