;
; AutoHotkey Version: 1.x
; Language.........: English
; Platform.........: Win9x/NT/XP/Vista
; Author...........: Veil <veilure@gmail.com>
; Full guide.......: http://brrp.mine.nu/fnkey/
;
; Script Function..: Use the Fn key to access the multimedia keys (F7-F12) 
;                    on the Apple Wireless Keyboard. 
; Usage............: Copy and paste the contents of this file into FnMapper.ahk
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Fn modifier: Audio hotkeys, specified for Winamp
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
; Winamp: Previous
;
$F7::hotkeyF7()

hotkeyF7() {
	global fnPressed
	if(fnPressed = 1) {
		IfWinNotExist ahk_class Winamp v1.x
  	Return
		ControlSend, ahk_parent, z  ; Previous
	} else {
		Send {F7}
	}
}
Return

;
; Winamp: Pause/Unpause
;
$F8::hotkeyF8()

hotkeyF8() {
	global fnPressed
	if (fnPressed = 1) {
		IfWinNotExist ahk_class Winamp v1.x
  	Return
		ControlSend, ahk_parent, c ; Pause/Unpause
	} else {
		Send {F8}
	}
}
Return

;
; Winamp: Next
;
$F9::hotkeyF9()

hotkeyF9()
{
	global fnPressed
	if (fnPressed = 1) {
		IfWinNotExist ahk_class Winamp v1.x
  	Return
		ControlSend, ahk_parent, b ; Next
	} else {
		Send {F9}
	}
}
Return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Fn modifier: Audio hotkeys, system volume
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
; System volume: Mute/Unmute
;
$F10::hotkeyF10()

hotkeyF10() {
	global fnPressed
	if (fnPressed = 1) {
		Send {Volume_Mute} ; Mute/unmute the master volume.
	} else {
		Send {F10}
	}
}
Return

;
; System volume: Volume Down
;
$F11::hotkeyF11()

hotkeyF11() {
	global fnPressed
	if (fnPressed = 1) {
		Send {Volume_Down} ; Lower the master volume by 1 interval (typically 5%)
	} else {
		Send {F11}
	}
}
Return

;
; System volume: Volume Down
;
$F12::hotkeyF12()

hotkeyF12() {
	global fnPressed
	if (fnPressed = 1) {
		Send {Volume_Up}  ; Raise the master volume by 1 interval (typically 5%).
	} else {
		Send {F12}
	}
}
Return