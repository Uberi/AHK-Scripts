; Personalized iTunes Controls
; Current Configuration used with both
; Keyboard and MX1000 Logitech Mouse
;
; *The bottom half of the code is specific for my
; *system, and works well with a MX1000 Logitech
; *mouse mapped to certain keys with Logitech's
; SetPoint software.  Deleted it if you want.

#SingleInstance force
DetectHiddenWindows, on

;Starts iTunes if it is not currently running,
;or if it is, Restores or Minimizes it
#a:: ;Win+A
	IfWinNotExist, ahk_class iTunes
	{   
		Run %ProgramFiles%\iTunes\iTunes.exe  ;
		return ; End of Hotkey if iTunes was not already open
	}

	IfWinExist, ahk_class iTunes ;
	{
		IfWinNotActive ; Restores iTunes Windows
			WinActivate
		Else
			WinMinimize ; Minimizes iTunes Window
		return ;End of Hotkey if iTunes was already open
	}

#c:: ;Win+C
	IfWinExist, ahk_class iTunes
		ControlSend, ahk_parent, ^{RIGHT}  ; Skips to Next Track in iTunes
	return

#z:: ;Win+Z
	IfWinExist, ahk_class iTunes
		ControlSend, ahk_parent, ^{LEFT}  ; Returns to Start of Track or Previous Track
	return

#x:: ;Win+X
	IfWinExist, ahk_class iTunes
		ControlSend, ahk_parent, {SPACE}  ; Plays and Pauses iTunes
	return

#w:: ;Win+X
	IfWinExist, ahk_class iTunes
		ControlSend, ahk_parent, ^{UP}  ; Turns the Volume up in iTunes only
	return
   
#s:: ;Win+S
	IfWinExist, ahk_class iTunes
		ControlSend, ahk_parent, ^{DOWN}  ; Turns the Volume down in iTunes only
	return
	
	
;The following are shortcuts I made for my MX1000 mouse
;I used Logitech's SetPoint to mape some of the mouse buttons
;to keystrokes for me.
;Here is the mapping I have for my mouse
;Cruise Up sends Ctrl+W  ((Closes Tab in Firefox))
;Cruise Down sends Middle Click ((To keep from wearing down my wheel))
;Tilt Wheel Left sends Ctrl+PgUp ((Previous Tab in Firefox))
;Tilt Wheel Right sends Ctrl+PgDn ((Next Tab in Firefox))
;Document Flip Button (Middle thumb button) Sends Alt  (I use as a modifier to expand mouse buttons)
;Forward Thumb button sends Alt+Right ((Goes forward in History in Firefox))
;Back Thumb Button sends Alt+Left ((Goes back in History in Firefox))
;The Above are the keymappings from Logitech's SetPoint software


;So when you see Alt on a hotkey, I usually send that Alt using my mouse button
;I refered to in the above comments
;So if a hotkey buttons don't seem to make sense, refer to mappings I listed

~Alt & LButton::AltTab ;Works like Alt+Tab, so I can use my middle thumb button and my left mouse button together to change between applications
;While Holding Alt, each click of the LButton moves through the Alt Tab Menu
	

~Alt & RButton:: ;Middle Thumb button + Right Mouse Button
	IfWinExist, ahk_class iTunes
		ControlSend, ahk_parent, {SPACE}  ; Plays and Pauses iTunes
	return
	
~Alt & WheelUp:: ;Middle Thumb Button + Wheel Up
	IfWinExist, ahk_class iTunes
		ControlSend, ahk_parent, ^{UP}  ; Turns the Volume up in iTunes only
	return
	
~Alt & WheelDown:: ;Middle Thumb Button + Wheel Down
	IfWinExist, ahk_class iTunes
		ControlSend, ahk_parent, ^{DOWN}  ; Turns the Volume down in iTunes only
	return
	
	
~Alt & ^PgDn:: ;Middle Thumb Button + Tilt Wheel Right
	IfWinExist, ahk_class iTunes
		ControlSend, ahk_parent, ^{RIGHT}  ; Skips to Next Track in iTunes
	return

~Alt & ^PgUp:: ;Middle Thumb Button + Tilt Wheel Left
	IfWinExist, ahk_class iTunes
		ControlSend, ahk_parent, ^{LEFT}  ; Returns to Start of Track or Previous Track
	return
	
~Alt & ^w::Send !{F4} ;Middle Thumb BUtton + Cruise Up Button closes current window using Alt+F4


~Alt & MButton:: ;Middle Thumb Button + Middle Mouse Button bring up iTunes, or minimizes, depending if it is active or not.  It will also start iTunes if it is not currently running
	IfWinNotExist, ahk_class iTunes
	{   
		Run %ProgramFiles%\iTunes\iTunes.exe  ;
		return ; End of Hotkey if iTunes was not already open
	}

	IfWinExist, ahk_class iTunes ;
	{
		IfWinNotActive ; Restores iTunes Windows
			WinActivate
		Else
			WinMinimize ; Minimizes iTunes Window
		return ;End of Hotkey if iTunes was already open
	}