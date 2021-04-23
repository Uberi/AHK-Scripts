/* TheGood
MouseMote

ONLY ENABLED WHILE IN FULLSCREEN

Raise/Lower volume              Mouse wheel Up/Down
Seek forward/backward           Hold RButton + Mouse wheel Up/Down
Play/Pause                      LButton click
Stop                            Middle click

To turn off hotkeys while in fullscreen, simply place the mouse in the upper-left corner of the
monitor. This is useful especially to access the context-menu (right-click menu) and to leave
fullscreen mode (most players require a double click). Also, clicking off the screen (in a multi-
monitor setup) will disable the hotkeys.

MouseMote automatically exits when no players are running. For this reason, it must be started
after the player is opened.

To add support for your own player:
    1. Add the class name to the window group (both when fullscreen and not)
    2. Make a wrapper for your player (look at the other wrappers for template)
    3. Add an Else If in DoActions() to call your wrapper

*/

;Comment out to hide icon
;#NoTrayIcon

;Action constants
C_PLAYPAUSE		:= 0
C_STOP			:= 1
C_LOWER_VOL		:= 2
C_RAISE_VOL		:= 3
C_SEEK_FORWARD	:= 4
C_SEEK_BACKWARD	:= 5

;Get monitor info
SysGet, iMonitorCount, 80	;SM_CMONITORS
Loop %iMonitorCount% {  ;Loop through each monitor
	SysGet, Mon%A_Index%, Monitor, %A_Index%
    Mon%A_Index%Width := Mon%A_Index%Right - Mon%A_Index%Left
    Mon%A_Index%Height := Mon%A_Index%Bottom - Mon%A_Index%Top
}

;Prep windows groups
GroupAdd, grpPlayers, ahk_class Winamp v1.x				;Winamp player
GroupAdd, grpPlayers, ahk_class Winamp Video			;Winamp video
GroupAdd, grpPlayers, ahk_class QWidget					;VLC Media Player player
GroupAdd, grpPlayers, ahk_class VLC DirectX				;VLC Media Player video
GroupAdd, grpPlayers, ahk_class MediaPlayerClassicW		;MPC

/****************************************************
	EXIT LOOP
*/

Loop
	If Not WinExist("ahk_group grpPlayers")
		ExitApp

/****************************************************
	HOTKEYS
*/

#IfWinActive ahk_group grpPlayers

$LButton Up::
	If Not HotkeysEnabled()
		SendInput, {LButton Up}
Return

$LButton::
	If HotkeysEnabled()
		DoAction(C_PLAYPAUSE)
	Else SendInput, {LButton Down}
Return

$RButton Up::
	If Not HotkeysEnabled()
		SendInput, {RButton Up}
Return

$RButton::
	If Not HotkeysEnabled()
		SendInput, {RButton Down}
Return

$MButton Up::
	If Not HotkeysEnabled()
		SendInput, {MButton Up}
Return

$MButton::
	If HotkeysEnabled()
		DoAction(C_STOP)
	Else SendInput, {MButton Down}
Return

$WheelUp::
	If HotkeysEnabled()
		DoAction(GetKeyState("RButton", "P") ? C_SEEK_FORWARD : C_RAISE_VOL)
	Else SendInput, {WheelUp}
Return

$WheelDown::
	If HotkeysEnabled()
		DoAction(GetKeyState("RButton", "P") ? C_SEEK_BACKWARD : C_LOWER_VOL)
	Else SendInput, {WheelDown}
Return

/****************************************************
    FUNCTIONS
*/

HotkeysEnabled() {
    Local wX, wY, wW, wH, mX, mY, i
    
    ;Check if there's an open menu
    IfWinExist, ahk_class #32768
        Return False    ;Disable hotkey
    
    mH := WinActive()                       ;Get the active window handle
    WinGetPos, wX, wY, wW, wH, ahk_id %mH% 	;Get window pos
    MouseGetPos, mX, mY                     ;Get mouse pos
	
	;Get the monitor number the window is on
    i := GetMonitorFromPos(wX + (wW / 2), wY + (wH / 2))    ;Window screen
    j := GetMonitorFromPos(mX, mY)                          ;Mouse screen
    
    ;Check if the mouse is on the same monitor
    If (i <> j)
        Return False
    
    ;Check if we're in fullscreen
    If (wX <> Mon%i%Left) Or (wY <> Mon%i%Top)
    Or (wW <> Mon%i%Width) Or (wH <> Mon%i%Height)
        Return False
	
	;Check if it's in corner
	If (mX = Mon%i%Left) And (mY = Mon%i%Top)
		Return False
	
    ;All the conditions have been met. Enable hotkey (and disable native function).
	Return True
}

;Returns the number of the monitor the coordinates are in
GetMonitorFromPos(mX, mY) {
	Global
	Loop %iMonitorCount%
		If (Mon%A_Index%Left <= mX AND Mon%A_Index%Right > mX)
        AND (Mon%A_Index%Top <= mY AND Mon%A_Index%Bottom > mY)
			Return %A_Index%
}

/****************************************************
	PLAYERS WRAPPERS
*/

DoAction(iAction) {
	
	;Check which player it is
	WinGetClass, sClass, A
	
	If (sClass = "Winamp Video")
		Winamp(iAction)
	Else If (sClass = "VLC DirectX")
		VLC(iAction)
	Else If (sClass = "MediaPlayerClassicW")
		MPC(iAction)
}

;Winamp wrapper
Winamp(iAction) {
	Global
	
	If (iAction = C_PLAYPAUSE)
		iAction := 40046
	Else If (iAction = C_STOP)
		iAction := 40047
	Else If (iAction = C_LOWER_VOL)
		iAction := 40059
	Else If (iAction = C_RAISE_VOL)
		iAction := 40058
	Else If (iAction = C_SEEK_FORWARD)
		iAction := 40148
	Else If (iAction = C_SEEK_BACKWARD)
		iAction := 40144
	
	;Send WM_COMMAND message to Winamp
	SendMessage, 0x111, iAction, 0,, ahk_class Winamp v1.x
	
}

;VLC Media Player wrapper
;MUST BE CONFIGURED TO MATCH REGISTERED VLC HOTKEYS
VLC(iAction) {
	Global
	
	If (iAction = C_PLAYPAUSE)
		SendInput, {Space}
	Else If (iAction = C_STOP)
		SendInput, s
	Else If (iAction = C_LOWER_VOL)
		SendInput, ^{Down}
	Else If (iAction = C_RAISE_VOL)
		SendInput, ^{Up}
	Else If (iAction = C_SEEK_FORWARD)
		SendInput, !{Right}
	Else If (iAction = C_SEEK_BACKWARD)
		SendInput, !{Left}
	
}

;MPC wrapper (also works for MPC-HC)
;MUST BE CONFIGURED TO MATCH REGISTERED MPC HOTKEYS
MPC(iAction) {
	Global
	
	If (iAction = C_PLAYPAUSE)
		SendInput, {Space}
	Else If (iAction = C_STOP)
		SendInput, .
	Else If (iAction = C_LOWER_VOL)
		SendInput, {Down}
	Else If (iAction = C_RAISE_VOL)
		SendInput, {Up}
	Else If (iAction = C_SEEK_FORWARD)
		SendInput, ^{Right}
	Else If (iAction = C_SEEK_BACKWARD)
		SendInput, ^{Left}	
}
